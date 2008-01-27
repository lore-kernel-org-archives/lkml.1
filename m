Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYA0Rib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYA0Rib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYA0RiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:38:24 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:51563 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYA0RiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:38:23 -0500
Subject: Re: [PATCH][RFC] Kconfig: show git branch name in LOCALVERSION_AUTO
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080124212345.GA3944@uranus.ravnborg.org>
References: <1200916933.2906.17.camel@castor.localdomain>
	 <20080124212345.GA3944@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 17:38:20 +0000
Message-Id: <1201455500.9303.6.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-24 at 22:23 +0100, Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 12:02:13PM +0000, Richard Kennedy wrote:
> > config option to add the git branch name to the automatically generated
> > version string.
> > 
> > If the current git branch name is not "master" then add the name to the
> > LOCALVERSION_AUTO version string.
> > The format will then be -<name>-gxxxxxxxx
> 
> PAtch does no longer apply to kbuild.git.
> Please update either on top of kbuild.git or
> when kbuild.git is merged and then resubmit.
> 
> Thanks,
> 	Sam
config option to add the git branch name to the automatically generated
version string.

If the current git branch name is not "master" then add the name to the
LOCALVERSION_AUTO version string.
The format will then be -<name>-gxxxxxxxx

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
Sam,
here's a patch against the latest kbuild.git.
[ if I got the git remote thing right ;) ]

Richard


diff --git a/Makefile b/Makefile
index ae80713..84eddba 100644
--- a/Makefile
+++ b/Makefile
@@ -874,7 +874,8 @@ localver = $(subst $(space),, $(string) \
 # checks as needed.
 ifdef CONFIG_LOCALVERSION_AUTO
 	_localver-auto = $(shell $(CONFIG_SHELL) \
-	                  $(srctree)/scripts/setlocalversion $(srctree))
+	                  $(srctree)/scripts/setlocalversion $(srctree) \
+				$(CONFIG_LOCALVERSION_BRANCH))
 	localver-auto  = $(LOCALVERSION)$(_localver-auto)
 endif
 
diff --git a/init/Kconfig b/init/Kconfig
index e7f2f41..bfaadc7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -100,6 +100,16 @@ config LOCALVERSION_AUTO
 
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
index 52f032e..f38e3c4 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -2,7 +2,7 @@
 # Print additional version information for non-release trees.
 
 usage() {
-	echo "Usage: $0 [srctree]" >&2
+	echo "Usage: $0 [srctree] [show-branch]" >&2
 	exit 1
 }
 
@@ -10,6 +10,13 @@ cd "${1:-.}" || usage
 
 # Check for git and a git repo.
 if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+	# show the branch name?
+    	if [[ $2 == "y" ]]; then
+		name=`git branch | grep -E "^[*]" | cut -d " " -sf 2`
+		if [[ $name != "master" ]]; then
+			printf '%s' "-$name"
+		fi
+	fi
 	# Do we have an untagged version?
 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
 	        git describe | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
-- 
1.5.3.7



