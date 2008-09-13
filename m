Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYIMQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYIMQIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 12:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYIMQId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 12:08:33 -0400
Received: from the.earth.li ([217.147.81.2]:59084 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYIMQIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 12:08:32 -0400
Date: Sat, 13 Sep 2008 17:08:31 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Message-ID: <20080913160831.GE30927@earth.li>
References: <20080912112042.GX30927@earth.li> <200809131035.18477.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809131035.18477.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding linux-kbuild as that seems to be the closest to a maintainer for
scripts/package/]

On Sat, Sep 13, 2008 at 10:35:18AM +0200, Frans Pop wrote:
> On Friday 12 September 2008, Jonathan McDowell wrote:
> > The below is a simplistic fix for "make deb-pkg"; it splits the
> > firmware out to a linux-firmware-image package and adds an
> > (unversioned) Suggests to the linux package for this firmware.
> >
> > Frans, does this solve your problem in an acceptable manner?
> 
> Yes it does. Thanks for the patch Jonathan.
> Tested both with kernel configs that result in firmware and that do not 
> result in firmware.
> 
> A few minor nitpicks below.

Ta, I've fixed both the indents. I've also changed the firmware package
to be arch: all.

> > Signed-Off-By: Jonathan McDowell <noodles@earth.li>
> Acked-by: Frans Pop <elendil@planet.nl>
 
-----
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
-----

J.

-- 
"Just because I'll spend 4 hours automating a task that takes 4 minutes
by hand doesn't mean I'm not lazy." -- Mike Sphar, asr
