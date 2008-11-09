Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYKIWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYKIWLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYKIWLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:11:31 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37424 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYKIWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:11:30 -0500
Date: Sun, 9 Nov 2008 23:08:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jonathan McDowell <noodles@earth.li>, Frans Pop <elendil@planet.nl>
Subject: [GIT] one kbuild fix
Message-ID: <20081109220854.GA23710@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull following fix the debian packager to properly support firmware

	Sam

Pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Jonathan McDowell (1):
      kbuild: Fixup deb-pkg target to generate separate firmware deb

 scripts/package/builddeb |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)


diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index ba6bf5d..1264b8e 100644
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
