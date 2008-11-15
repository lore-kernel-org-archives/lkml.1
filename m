Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYKOFad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYKOFad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYKOFZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:21 -0500
Received: from kroah.org ([198.145.64.141]:50632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753823AbYKOFZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:08 -0500
Date: Fri, 14 Nov 2008 21:23:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jonathan McDowell <noodles@earth.li>,
       Frans Pop <elendil@planet.nl>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 16/22] kbuild: Fixup deb-pkg target to generate separate
	firmware deb
Message-ID: <20081115052338.GQ3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kbuild-fixup-deb-pkg-target-to-generate-separate-firmware-deb.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan McDowell <noodles@earth.li>

commit bf1b36445dc868cbbde194aa1dd87e38fe24cf16 upstream.

The below is a simplistic fix for "make deb-pkg"; it splits the
firmware out to a linux-firmware-image package and adds an
(unversioned) Suggests to the linux package for this firmware.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>
Acked-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/package/builddeb |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -15,15 +15,18 @@ set -e
 version=$KERNELRELEASE
 revision=`cat .version`
 tmpdir="$objtree/debian/tmp"
+fwdir="$objtree/debian/fwtmp"
 packagename=linux-$version
+fwpackagename=linux-firmware-image
 
 if [ "$ARCH" == "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
 # Setup the directory structure
-rm -rf "$tmpdir"
+rm -rf "$tmpdir" "$fwdir"
 mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot"
+mkdir -p "$fwdir/DEBIAN" "$fwdir/lib"
 if [ "$ARCH" == "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/share/doc/$packagename" "$tmpdir/usr/bin"
 fi
@@ -107,6 +110,7 @@ Standards-Version: 3.6.1
 
 Package: $packagename
 Provides: kernel-image-$version, linux-image-$version
+Suggests: $fwpackagename
 Architecture: any
 Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
@@ -118,8 +122,24 @@ fi
 chown -R root:root "$tmpdir"
 chmod -R go-w "$tmpdir"
 
+# Do we have firmware? Move it out of the way and build it into a package.
+if [ -e "$tmpdir/lib/firmware" ]; then
+	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
+
+	cat <<EOF >> debian/control
+
+Package: $fwpackagename
+Architecture: all
+Description: Linux kernel firmware, version $version
+ This package contains firmware from the Linux kernel, version $version
+EOF
+
+	dpkg-gencontrol -isp -p$fwpackagename -P"$fwdir"
+	dpkg --build "$fwdir" ..
+fi
+
 # Perform the final magic
-dpkg-gencontrol -isp
+dpkg-gencontrol -isp -p$packagename
 dpkg --build "$tmpdir" ..
 
 exit 0

-- 
