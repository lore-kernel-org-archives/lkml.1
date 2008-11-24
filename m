Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYKXUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYKXUyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYKXUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:53:34 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36269 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYKXUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:53:31 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>, kbuild <linux-kbuild@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/8] kbuild: use KECHO convenience echo
Date: Mon, 24 Nov 2008 21:54:51 +0100
Message-Id: <1227560095-32597-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <20081124205150.GA32497@uranus.ravnborg.org>
References: <20081124205150.GA32497@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Convert a few echos in the build system to new $(kecho) so we get correct
output according to build verbosity.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
[sam: added kecho in a few more places for O=... builds]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                    |    8 ++++----
 arch/blackfin/boot/Makefile |    2 +-
 scripts/Kbuild.include      |   11 ++---------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 54720a5..391b2da 100644
--- a/Makefile
+++ b/Makefile
@@ -926,7 +926,7 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 # 2) Create the include2 directory, used for the second asm symlink
 prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
-	@echo '  Using $(srctree) as source for kernel'
+	@$(kecho) '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
 		echo "  $(srctree) is not clean, please run 'make mrproper'";\
 		echo "  in the '$(srctree)' directory.";\
@@ -983,7 +983,7 @@ endef
 # directory for generated filesas used by some architectures.
 define create-symlink
 	if [ ! -L include/asm ]; then                                      \
-			echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';     \
+			$(kecho) '  SYMLINK $@ -> include/asm-$(SRCARCH)'; \
 			if [ ! -d include/asm-$(SRCARCH) ]; then           \
 				mkdir -p include/asm-$(SRCARCH);           \
 			fi;                                                \
@@ -1096,7 +1096,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
-	@echo '  Building modules, stage 2.';
+	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
 
@@ -1360,7 +1360,7 @@ $(module-dirs): crmodverdir $(objtree)/Module.symvers
 	$(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
 
 modules: $(module-dirs)
-	@echo '  Building modules, stage 2.';
+	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_install
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index 522f3c1..e028d13 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -25,7 +25,7 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 
 $(obj)/vmImage: $(obj)/vmlinux.gz
 	$(call if_changed,uimage)
-	@echo 'Kernel: $@ is ready'
+	@$(kecho) 'Kernel: $@ is ready'
 
 install:
 	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index e637e28..2cf1516 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -46,22 +46,15 @@ kecho := $($(quiet)kecho)
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
+	$(kecho) '  CHK     $@';		\
 	mkdir -p $(dir $@);			\
 	$(filechk_$(1)) < $< > $@.tmp;		\
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
 		rm -f $@.tmp;			\
 	else					\
-		$($(quiet)upd_filechk);		\
+		$(kecho) '  UPD     $@';	\
 		mv -f $@.tmp $@;		\
 	fi
 endef
-- 
1.5.6.GIT

