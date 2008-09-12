Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYILLUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYILLUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYILLUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:20:44 -0400
Received: from the.earth.li ([217.147.81.2]:40094 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYILLUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:20:43 -0400
Date: Fri, 12 Sep 2008 12:20:42 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Message-ID: <20080912112042.GX30927@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below is a simplistic fix for "make deb-pkg"; it splits the firmware
out to a linux-firmware-image package and adds an (unversioned) Suggests
to the linux package for this firmware.

Frans, does this solve your problem in an acceptable manner?

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index ba6bf5d..d152b38 100644
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
+cat <<EOF >> debian/control
+
+Package: $fwpackagename
+Architecture: any
+Description: Linux kernel firmware, version $version
+ This package contains firmware from the Linux kernel, version $version
+EOF
+
+dpkg-gencontrol -isp -p$fwpackagename -P"$fwdir"
+dpkg --build "$fwdir" ..
+fi
+
 # Perform the final magic
-dpkg-gencontrol -isp
+dpkg-gencontrol -isp -p$packagename
 dpkg --build "$tmpdir" ..
 
 exit 0
-----

J.

-- 
If I save time, when do I get it back?
