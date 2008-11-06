Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYKFIcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYKFIcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYKFIbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:31:39 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38389 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYKFIbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:31:38 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: use KECHO convenience echo
Date: Thu,  6 Nov 2008 03:31:35 -0500
Message-Id: <1225960295-30366-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
References: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a few echos in the build system to new $(KECHO) so we get correct
output according to build verbosity.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile                    |    6 +++---
 arch/blackfin/boot/Makefile |    2 +-
 scripts/Kbuild.include      |   11 ++---------
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index 29abe62..3dd95c2 100644
--- a/Makefile
+++ b/Makefile
@@ -983,7 +983,7 @@ endef
 # directory for generated filesas used by some architectures.
 define create-symlink
 	if [ ! -L include/asm ]; then                                      \
-			echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';     \
+			$(KECHO) '  SYMLINK $@ -> include/asm-$(SRCARCH)'; \
 			if [ ! -d include/asm-$(SRCARCH) ]; then           \
 				mkdir -p include/asm-$(SRCARCH);           \
 			fi;                                                \
@@ -1096,7 +1096,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
-	@echo '  Building modules, stage 2.';
+	@$(KECHO) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
 
@@ -1360,7 +1360,7 @@ $(module-dirs): crmodverdir $(objtree)/Module.symvers
 	$(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
 
 modules: $(module-dirs)
-	@echo '  Building modules, stage 2.';
+	@$(KECHO) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_install
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index 522f3c1..25bb977 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -25,7 +25,7 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 
 $(obj)/vmImage: $(obj)/vmlinux.gz
 	$(call if_changed,uimage)
-	@echo 'Kernel: $@ is ready'
+	@$(KECHO) 'Kernel: $@ is ready'
 
 install:
 	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 9dc96cf..c992249 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -46,22 +46,15 @@ KECHO = $($(quiet)kecho)
 # - If they are equal no change, and no timestamp update
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
-       chk_filechk = :
- quiet_chk_filechk = echo '  CHK     $@'
-silent_chk_filechk = :
-       upd_filechk = :
- quiet_upd_filechk = echo '  UPD     $@'
-silent_upd_filechk = :
-
 define filechk
 	$(Q)set -e;				\
-	$($(quiet)chk_filechk);			\
+	$(KECHO) '  CHK     $@';		\
 	mkdir -p $(dir $@);			\
 	$(filechk_$(1)) < $< > $@.tmp;		\
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
 		rm -f $@.tmp;			\
 	else					\
-		$($(quiet)upd_filechk);		\
+		$(KECHO) '  UPD     $@';	\
 		mv -f $@.tmp $@;		\
 	fi
 endef
-- 
1.6.0.3

