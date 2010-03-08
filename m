Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0CHLUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:20:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0CHLUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:20:52 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Do not unnecessarily regenerate modules.builtin
Date: Mon,  8 Mar 2010 12:20:22 +0100
Message-Id: <1268047222-13218-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only regenerate it if the configuration has changed. Also, do this after
the modules build to fix errors with some weird Makefiles that are
generated during build.

Reported-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 2e74a68..160cada 100644
--- a/Makefile
+++ b/Makefile
@@ -882,9 +882,6 @@ $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
 PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
-ifdef CONFIG_MODULES
-	$(Q)$(MAKE) $(modbuiltin)=$@
-endif
 
 # Build the kernel release string
 #
@@ -1089,7 +1086,7 @@ ifdef CONFIG_MODULES
 
 # By default, build modules as well
 
-all: modules
+all: modules modules.builtin
 
 #	Build modules
 #
@@ -1100,11 +1097,16 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
-	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.builtin) > $(objtree)/modules.builtin
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
 
+modules.builtin: $(vmlinux-dirs:%=%/modules.builtin)
+	$(Q)$(AWK) '!x[$$0]++' $^ > $(objtree)/modules.builtin
+
+%/modules.builtin: include/config/auto.conf | modules
+	$(Q)$(MAKE) $(modbuiltin)=$*
+
 
 # Target to prepare building external modules
 PHONY += modules_prepare
-- 
1.6.6.1

