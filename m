Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXGVDN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXGVDN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 23:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXGVDNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 23:13:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbXGVDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 23:13:18 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 vDSO: install unstripped copies on disk
X-Zippy-Says: HAIR TONICS, please!!
Message-Id: <20070722031312.681484D05C1@magilla.localdomain>
Date: Sat, 21 Jul 2007 20:13:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/Makefile      |    1 +
 arch/x86_64/vdso/Makefile |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 93fc1f2..c0905ae 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -107,6 +107,7 @@ fdimage fdimage144 fdimage288 isoimage: vmlinux
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
diff --git a/arch/x86_64/vdso/Makefile b/arch/x86_64/vdso/Makefile
index faaa72f..20ecf05 100644
--- a/arch/x86_64/vdso/Makefile
+++ b/arch/x86_64/vdso/Makefile
@@ -13,7 +13,7 @@ vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.lds $(vobjs-y) vdso-syms.o
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y) vdso-syms.o
 
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
@@ -25,14 +25,18 @@ export CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-SYSCFLAGS_vdso.so = $(vdso-flags)
+SYSCFLAGS_vdso.so.dbg = $(vdso-flags)
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
-$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
-CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+CF := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CF)
 $(obj)/vgetcpu.o: CFLAGS = $(CF)
@@ -47,3 +51,11 @@ $(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
 SYSCFLAGS_vdso-syms.o = -r -d
 $(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+vdso.so:
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: vdso.so
