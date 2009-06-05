Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZFEXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZFEXmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZFEXlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36386 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZFEXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:08 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Frans Pop <elendil@planet.nl>, Andres Salomon <dilinger@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 07/39] kbuild, deb-pkg: allow alternative hook scripts directory in .deb packages
Date: Sat,  6 Jun 2009 01:42:25 +0200
Message-Id: <1244245377-17441-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Hook scripts in the default directory /etc/kernel are also executed by
official Debian kernel packages as well as kernel packages created using
make-kpkg. Allow to specify an alternative hook scripts directory by
exporting the environment variable KDEB_HOOKDIR.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5868c0f..c01f812 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -6,8 +6,9 @@
 # Simple script to generate a deb package for a Linux kernel. All the
 # complexity of what to do with a kernel after it is installed or removed
 # is left to other scripts and packages: they can install scripts in the
-# /etc/kernel/{pre,post}{inst,rm}.d/ directories that will be called on
-# package install and removal.
+# /etc/kernel/{pre,post}{inst,rm}.d/ directories (or an alternative location
+# specified in KDEB_HOOKDIR) that will be called on package install and
+# removal.
 
 set -e
 
@@ -73,8 +74,11 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 fi
 
 # Install the maintainer scripts
+# Note: hook scripts under /etc/kernel are also executed by official Debian
+# kernel packages, as well as kernel packages built using make-kpkg
+debhookdir=${KDEB_HOOKDIR:-/etc/kernel}
 for script in postinst postrm preinst prerm ; do
-	mkdir -p "$tmpdir/etc/kernel/$script.d"
+	mkdir -p "$tmpdir$debhookdir/$script.d"
 	cat <<EOF > "$tmpdir/DEBIAN/$script"
 #!/bin/sh
 
@@ -83,7 +87,7 @@ set -e
 # Pass maintainer script parameters to hook scripts
 export DEB_MAINT_PARAMS="\$@"
 
-test -d /etc/kernel/$script.d && run-parts --arg="$version" /etc/kernel/$script.d
+test -d $debhookdir/$script.d && run-parts --arg="$version" $debhookdir/$script.d
 exit 0
 EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"
-- 
1.6.3.rc3.40.g75b44

