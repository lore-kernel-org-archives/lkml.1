Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbXJMHQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbXJMHQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXJMHQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:16:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbXJMHQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:16:16 -0400
Date: Sat, 13 Oct 2007 08:16:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@karaya.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] minimal build fixes for uml (fallout from x86 merge)
Message-ID: <20071013071604.GE8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	a) include/asm-um/arch can't just point to include/asm-$(SUBARCH) now
	b) arch/{i386,x86_64}/crypto are merged now
	c) subarch-obj needed changes
	d) cpufeature_64.h should pull "cpufeature_32.h", not
<asm/cpufeature_32.h> since it can be included from asm-um/cpufeature.h
	e) in case of uml-i386 we need CONFIG_X86_32 for make and gcc,
but not for Kconfig
	f) sysctl.c shouldn't do vdso_enabled for uml-i386 (actually, that
one should be registered from corresponding arch/*/kernel/*, with ifdef going
away; that's a separate patch, though).

With that and with Stephen's patch ([PATCH net-2.6] uml: hard_header fix)
we have uml allmodconfig building both on i386 and amd64.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 989224f..0666729 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -176,9 +176,9 @@ include/asm-um/arch:
 	@echo '  SYMLINK $@'
 ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
-	$(Q)ln -fsn $(srctree)/include/asm-$(SUBARCH) include/asm-um/arch
+	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(SUBARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
@@ -232,4 +232,4 @@ $(ARCH_DIR)/include/kern_constants.h: $(objtree)/$(ARCH_DIR)/include
 	@echo '  SYMLINK $@'
 	$(Q)ln -sf ../../../include/asm-um/asm-offsets.h $@
 
-export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS
+export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index c9f1c5b..60107ed 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -1,4 +1,4 @@
-core-y += arch/um/sys-i386/ arch/i386/crypto/
+core-y += arch/um/sys-i386/ arch/x86/crypto/
 
 TOP_ADDR := $(CONFIG_TOP_ADDR)
 
@@ -12,6 +12,7 @@ LDFLAGS			+= -m elf_i386
 ELF_ARCH		:= $(SUBARCH)
 ELF_FORMAT 		:= elf32-$(SUBARCH)
 OBJCOPYFLAGS  		:= -O binary -R .note -R .comment -S
+HEADER_ARCH		:= x86
 
 ifeq ("$(origin SUBARCH)", "command line")
 ifneq ("$(shell uname -m | sed -e s/i.86/i386/)", "$(SUBARCH)")
@@ -24,6 +25,11 @@ export LDFLAGS HOSTCFLAGS HOSTLDFLAGS UML_OBJCOPYFLAGS
 endif
 endif
 
+CFLAGS			+= -DCONFIG_X86_32
+AFLAGS			+= -DCONFIG_X86_32
+CONFIG_X86_32		:= y
+export CONFIG_X86_32
+
 ARCH_KERNEL_DEFINES += -U__$(SUBARCH)__ -U$(SUBARCH)
 
 # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
diff --git a/arch/um/Makefile-x86_64 b/arch/um/Makefile-x86_64
index 69ecea6..8a00e5f 100644
--- a/arch/um/Makefile-x86_64
+++ b/arch/um/Makefile-x86_64
@@ -1,7 +1,7 @@
 # Copyright 2003 - 2004 Pathscale, Inc
 # Released under the GPL
 
-core-y += arch/um/sys-x86_64/ arch/x86_64/crypto/
+core-y += arch/um/sys-x86_64/ arch/x86/crypto/
 START := 0x60000000
 
 _extra_flags_ = -fno-builtin -m64
@@ -18,6 +18,7 @@ CPPFLAGS += -m64
 
 ELF_ARCH := i386:x86-64
 ELF_FORMAT := elf64-x86-64
+HEADER_ARCH := x86
 
 # Not on all 64-bit distros /lib is a symlink to /lib64. PLD is an example.
 
diff --git a/arch/um/scripts/Makefile.rules b/arch/um/scripts/Makefile.rules
index a9a4b85..bf23dd3 100644
--- a/arch/um/scripts/Makefile.rules
+++ b/arch/um/scripts/Makefile.rules
@@ -28,5 +28,5 @@ endef
 
 ifdef subarch-obj-y
 obj-y += subarch.o
-subarch-y = $(addprefix ../../$(SUBARCH)/,$(subarch-obj-y))
+subarch-y = $(addprefix ../../$(HEADER_ARCH)/,$(subarch-obj-y))
 endif
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index d6b3ecd..a4618b6 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,9 +4,9 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 
 obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
 
-subarch-obj-y = lib/bitops.o lib/semaphore.o lib/string.o
-subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+subarch-obj-y = lib/bitops_32.o lib/semaphore_32.o lib/string_32.o
+subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
+subarch-obj-$(CONFIG_MODULES) += kernel/module_32.o
 
 USER_OBJS := bugs.o ptrace_user.o sigcontext.o fault.o
 
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index 4d9e5ef..ea8185d 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -11,8 +11,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
 obj-$(CONFIG_MODULES) += um_module.o
 
-subarch-obj-y = lib/bitops.o lib/csum-partial.o lib/memcpy.o lib/thunk.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+subarch-obj-y = lib/bitops_64.o lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-$(CONFIG_MODULES) += kernel/module_64.o
 
 ldt-y = ../sys-i386/ldt.o
 
diff --git a/include/asm-x86/cpufeature_64.h b/include/asm-x86/cpufeature_64.h
index 2983501..e18496b 100644
--- a/include/asm-x86/cpufeature_64.h
+++ b/include/asm-x86/cpufeature_64.h
@@ -7,7 +7,7 @@
 #ifndef __ASM_X8664_CPUFEATURE_H
 #define __ASM_X8664_CPUFEATURE_H
 
-#include <asm/cpufeature_32.h>
+#include "cpufeature_32.h"
 
 #undef  cpu_has_vme
 #define cpu_has_vme            0
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 53a456e..74afbc7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1053,7 +1053,7 @@ static ctl_table vm_table[] = {
 		.strategy	= &sysctl_string,
 	},
 #endif
-#if defined(CONFIG_X86_32) || \
+#if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
 		.ctl_name	= VM_VDSO_ENABLED,
