Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYAUMCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYAUMCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 07:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbYAUMCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 07:02:33 -0500
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:2173 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759089AbYAUMCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:02:32 -0500
Subject: [PATCH][RFC] Kconfig: show git branch name in LOCALVERSION_AUTO
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 12:02:13 +0000
Message-Id: <1200916933.2906.17.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config option to add the git branch name to the automatically generated
version string.

If the current git branch name is not "master" then add the name to the
LOCALVERSION_AUTO version string.
The format will then be -<name>-gxxxxxxxx

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 Makefile                |    3 ++-
 init/Kconfig            |   10 ++++++++++
 scripts/setlocalversion |    9 ++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

I added this to automatically track which git branch I was on, because I
kept forgetting to change the version string manually. Maybe it will be 
helpful to other people too.

Patch is against v2.6.24-rc8.

comments /suggestions ?

Thanks
Richard


diff --git a/Makefile b/Makefile
index 713f685..ea01118 100644
--- a/Makefile
+++ b/Makefile
@@ -867,7 +867,8 @@ localver = $(subst $(space),, $(string) \
 # checks as needed.
 ifdef CONFIG_LOCALVERSION_AUTO
 	_localver-auto = $(shell $(CONFIG_SHELL) \
-	                  $(srctree)/scripts/setlocalversion $(srctree))
+	                  $(srctree)/scripts/setlocalversion $(srctree) \
+			  $(CONFIG_LOCALVERSION_BRANCH) )
 	localver-auto  = $(LOCALVERSION)$(_localver-auto)
 endif
 
diff --git a/init/Kconfig b/init/Kconfig
index b9d11a8..fafb7e5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -92,6 +92,16 @@ config LOCALVERSION_AUTO
 
 	  which is done within the script "scripts/setlocalversion".)
 
+config LOCALVERSION_BRANCH
+	bool "Automatically add branch name to the version string"
+	default n
+	depends on LOCALVERSION_AUTO
+	help
+	  If the current git branch name is not "master" then add the name to
+	  the LOCALVERSION_AUTO version string.
+	  The format will then be -<name>-gxxxxxxxx
+	  see the help for LOCALVERSION_AUTO for more details
+
 config SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 82e4993..1fffa2d 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -2,7 +2,7 @@
 # Print additional version information for non-release trees.
 
 usage() {
-	echo "Usage: $0 [srctree]" >&2
+	echo "Usage: $0 [srctree] [show_branch]" >&2
 	exit 1
 }
 
@@ -10,6 +10,13 @@ cd "${1:-.}" || usage
 
 # Check for git and a git repo.
 if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+
+	if [[ $2 == "y" ]]; then
+		name=`git branch | grep -E "^[*]" | cut -d " " -sf 2`
+		if [[ $name != "master" ]]; then
+			printf '%s' "-$name"
+		fi
+	fi
 	# Do we have an untagged version?
 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
 		printf '%s%s' -g `echo "$head" | cut -c1-8`
-- 
1.5.3.7



