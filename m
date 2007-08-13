Return-Path: <linux-kernel-owner+w=401wt.eu-S937991AbXHMCTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937991AbXHMCTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934687AbXHMCTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:19:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934795AbXHMCTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:19:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: akpm@linux-foundation.org
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: ak@suse.de
Subject: [PATCH 2/2] x86_64 vDSO: install unstripped copies on disk
In-Reply-To: akpm@linux-foundation.org's message of  Friday, 10 August 2007 14:59:50 -0700 <200708102159.l7ALxolY011805@imap1.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070813021931.1406A4D057D@magilla.localdomain>
Date: Sun, 12 Aug 2007 19:19:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces x86_64-vdso-install-unstripped-copies-on-disk.patch
and expects x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
was applied first.


Thanks,
Roland

---

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
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
@@ -112,6 +112,7 @@ vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)

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
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+CFL := $(PROFILING) -mcmodel=small -fPIC $(if $(CONFIG_DEBUG_INFO),-g,-g0) -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: CFLAGS = $(CFL)
@@ -47,3 +51,11 @@ $(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
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
