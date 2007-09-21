Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbXIUWfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbXIUWfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763532AbXIUWcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763324AbXIUWcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:10 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: roland@redhat.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/50] x86_64: Install unstripped copy of 64bit vdso to disk
Message-Id: <20070921223209.9BA9213DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Roland McGrath <roland@redhat.com>

This keeps an unstripped copy of the 64bit vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.


Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Makefile      |    1 +
 arch/x86_64/vdso/Makefile |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -120,6 +120,7 @@ vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
Index: linux/arch/x86_64/vdso/Makefile
===================================================================
--- linux.orig/arch/x86_64/vdso/Makefile
+++ linux/arch/x86_64/vdso/Makefile
@@ -13,7 +13,7 @@ vobjs := $(foreach F,$(vobjs-y),$(obj)/$
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.lds $(vobjs-y) vdso-syms.o
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y) vdso-syms.o
 
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
@@ -25,14 +25,18 @@ export CPPFLAGS_vdso.lds += -P -C -U$(AR
 vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-SYSCFLAGS_vdso.so = $(vdso-flags)
+SYSCFLAGS_vdso.so.dbg = $(vdso-flags)
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
-$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+CFL := $(PROFILING) -mcmodel=small -fPIC $(if $(CONFIG_DEBUG_INFO),-g,-g0) -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: CFLAGS = $(CFL)
@@ -47,3 +51,11 @@ $(obj)/built-in.o: ld_flags += -R $(obj)
 SYSCFLAGS_vdso-syms.o = -r -d
 $(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+vdso.so:
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso.so
