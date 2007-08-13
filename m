Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXHMCMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXHMCMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934170AbXHMCMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:12:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531AbXHMCM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:12:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, sam@ravnborg.org
Subject: [PATCH] powerpc vDSO: install unstripped copies on disk
In-Reply-To: akpm@linux-foundation.org's message of  Friday, 10 August 2007 13:49:45 -0700 <200708102049.l7AKnkr7008081@imap1.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070813021222.0C8554D057D@magilla.localdomain>
Date: Sun, 12 Aug 2007 19:12:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces powerpc-vdso-install-unstripped-copies-on-disk.patch


Thanks,
Roland

---

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/powerpc/Makefile               |    5 ++++-
 arch/powerpc/kernel/vdso32/Makefile |   20 +++++++++++++++++---
 arch/powerpc/kernel/vdso64/Makefile |   19 ++++++++++++++++---
 3 files changed, 37 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/Makefile
@@ -166,9 +166,15 @@ define archhelp
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
 endef
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
+vdso_install:
+ifeq ($(CONFIG_PPC64),y)
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
+endif
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)

diff -puN arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -9,11 +9,11 @@ ifeq ($(CONFIG_PPC32),y)
 CROSS32CC := $(CC)
 endif
 
-targets := $(obj-vdso32) vdso32.so
+targets := $(obj-vdso32) vdso32.so vdso32.so.dbg
 obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
 
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
@@ -26,9 +26,14 @@ CPPFLAGS_vdso32.lds += -P -C -Upowerpc
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32)
+$(obj)/vdso32.so.dbg: $(src)/vdso32.lds $(obj-vdso32)
 	$(call if_changed,vdso32ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso32): %.o: %.S
 	$(call if_changed_dep,vdso32as)
@@ -39,3 +44,12 @@ quiet_cmd_vdso32ld = VDSO32L $@
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso32.so: $(obj)/vdso32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso32.so
diff -puN arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -4,10 +4,10 @@ obj-vdso64 = sigtramp.o gettimeofday.o d
 
 # Build rules
 
-targets := $(obj-vdso64) vdso64.so
+targets := $(obj-vdso64) vdso64.so vdso64.so.dbg
 obj-vdso64 := $(addprefix $(obj)/, $(obj-vdso64))
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
@@ -20,9 +20,14 @@ CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64)
+$(obj)/vdso64.so.dbg: $(src)/vdso64.lds $(obj-vdso64)
 	$(call if_changed,vdso64ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso64): %.o: %.S
 	$(call if_changed_dep,vdso64as)
@@ -33,4 +38,12 @@ quiet_cmd_vdso64ld = VDSO64L $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso64.so: $(obj)/vdso64.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
 
+vdso_install: vdso64.so
