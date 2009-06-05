Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZFEXn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZFEXn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZFEXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45058 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbZFEXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: maximilian attems <max@stro.at>, Frans Pop <elendil@planet.nl>,
       Andres Salomon <dilinger@debian.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/39] kbuild, deb-pkg: improve maintainer identification
Date: Sat,  6 Jun 2009 01:42:28 +0200
Message-Id: <1244245377-17441-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: maximilian attems <max@stro.at>

Try harder to find email and maintainer name.
Debian's own devscripts all use DEBEMAIL or DEBFULLNAME prior to an
eventual EMAIL or NAME environment variable. Match their logic.

"Anonymous" sounds nicer then "Kernel Compiler" if no name is found.

Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 122becc..9d464fd 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -95,14 +95,30 @@ EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"
 done
 
-name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
+# Try to determine maintainer and email values
+if [ -n "$DEBEMAIL" ]; then
+       email=$DEBEMAIL
+elif [ -n "$EMAIL" ]; then
+       email=$EMAIL
+else
+       email=$(id -nu)@$(hostname -f)
+fi
+if [ -n "$DEBFULLNAME" ]; then
+       name=$DEBFULLNAME
+elif [ -n "$NAME" ]; then
+       name=$NAME
+else
+       name="Anonymous"
+fi
+maintainer="$name <$email>"
+
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
 linux ($packageversion) unstable; urgency=low
 
   * Custom built Linux kernel.
 
- -- $name  $(date -R)
+ -- $maintainer  $(date -R)
 EOF
 
 # Generate copyright file
@@ -130,7 +146,7 @@ cat <<EOF > debian/control
 Source: linux
 Section: base
 Priority: optional
-Maintainer: $name
+Maintainer: $maintainer
 Standards-Version: 3.6.1
 EOF
 
-- 
1.6.3.rc3.40.g75b44

