Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZFEXmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZFEXmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZFEXlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:14 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36375 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbZFEXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:08 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 03/39] kbuild, deb-pkg: refactor code to reduce duplication
Date: Sat,  6 Jun 2009 01:42:21 +0200
Message-Id: <1244245377-17441-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Factor out code to build package into separate function and
only write "source" section for the debian/control file once.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index eff7f9d..feebd69 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -11,6 +11,18 @@
 
 set -e
 
+create_package() {
+	local pname="$1" pdir="$2"
+
+	# Fix ownership and permissions
+	chown -R root:root "$pdir"
+	chmod -R go-w "$pdir"
+
+	# Create the package
+	dpkg-gencontrol -isp -p$pname -P"$pdir"
+	dpkg --build "$pdir" ..
+}
+
 # Some variables and settings used throughout the script
 version=$KERNELRELEASE
 revision=$(cat .version)
@@ -77,13 +89,16 @@ linux ($version-$revision) unstable; urgency=low
 EOF
 
 # Generate a control file
-if [ "$ARCH" = "um" ]; then
-	cat <<EOF > debian/control
+cat <<EOF > debian/control
 Source: linux
 Section: base
 Priority: optional
 Maintainer: $name
 Standards-Version: 3.6.1
+EOF
+
+if [ "$ARCH" = "um" ]; then
+	cat <<EOF >> debian/control
 
 Package: $packagename
 Provides: kernel-image-$version, linux-image-$version
@@ -100,12 +115,7 @@ Description: User Mode Linux kernel, version $version
 EOF
 
 else
-	cat <<EOF > debian/control
-Source: linux
-Section: base
-Priority: optional
-Maintainer: $name
-Standards-Version: 3.6.1
+	cat <<EOF >> debian/control
 
 Package: $packagename
 Provides: kernel-image-$version, linux-image-$version
@@ -118,10 +128,6 @@ EOF
 
 fi
 
-# Fix some ownership and permissions
-chown -R root:root "$tmpdir"
-chmod -R go-w "$tmpdir"
-
 # Do we have firmware? Move it out of the way and build it into a package.
 if [ -e "$tmpdir/lib/firmware" ]; then
 	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
@@ -134,12 +140,9 @@ Description: Linux kernel firmware, version $version
  This package contains firmware from the Linux kernel, version $version
 EOF
 
-	dpkg-gencontrol -isp -p$fwpackagename -P"$fwdir"
-	dpkg --build "$fwdir" ..
+	create_package "$fwpackagename" "$fwdir"
 fi
 
-# Perform the final magic
-dpkg-gencontrol -isp -p$packagename
-dpkg --build "$tmpdir" ..
+create_package "$packagename" "$tmpdir"
 
 exit 0
-- 
1.6.3.rc3.40.g75b44

