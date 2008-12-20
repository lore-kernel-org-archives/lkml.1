Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYLTOhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYLTOhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYLTOar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56397 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYLTOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:09 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "Paul Smith" <psmith@gnu.org>
Subject: [PATCH 18/26] kbuild: fix make incompatibility
Date: Sat, 20 Dec 2008 15:31:29 +0100
Message-Id: <1229783497-19550-18-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Smith" <psmith@gnu.org> reported that we would fail
to build with a new check that may be enabled in an
upcoming version of make.

The error was:

      Makefile:442: *** mixed implicit and normal rules.  Stop.

The problem is that we did stuff like this:

config %config: ...

The solution was simple - the above was split into two with identical
prerequisites and commands.
With only three lines it was not worth to try to avoid the duplication.

Cc: "Paul Smith" <psmith@gnu.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index be462cf..95160e5 100644
--- a/Makefile
+++ b/Makefile
@@ -439,7 +439,11 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config: scripts_basic outputmakefile FORCE
+	$(Q)mkdir -p include/linux include/config
+	$(Q)$(MAKE) $(build)=scripts/kconfig $@
+
+%config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -1493,7 +1497,11 @@ endif
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
 # Modules
-/ %/: prepare scripts FORCE
+/: prepare scripts FORCE
+	$(cmd_crmodverdir)
+	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
+	$(build)=$(build-dir)
+%/: prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
-- 
1.6.0.2.GIT

