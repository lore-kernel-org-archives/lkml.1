Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZELPku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZELPku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZELPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:39:20 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:38352 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZELPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:39:16 -0400
Message-Id: <20090512153900.784747296@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 12 May 2009 17:38:55 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: [PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64
References: <20090512153851.939166562@linux.vnet.ibm.com>
Content-Disposition: inline; filename=gcov-profile-all-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Enable gcov profiling of the entire kernel on x86_64. Required changes
include disabling profiling for:

* arch/kernel/acpi/realmode and arch/kernel/boot/compressed:
  not linked to main kernel
* arch/vdso, arch/kernel/vsyscall_64 and arch/kernel/hpet:
  profiling causes segfaults during boot (incompatible context)

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/Makefile               |    2 ++
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 arch/x86/vdso/Makefile                 |    1 +
 kernel/gcov/Kconfig                    |    2 +-
 6 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc5/kernel/gcov/Kconfig
===================================================================
--- linux-2.6.30-rc5.orig/kernel/gcov/Kconfig
+++ linux-2.6.30-rc5/kernel/gcov/Kconfig
@@ -34,7 +34,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on S390 || X86_32
+	depends on S390 || X86
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
Index: linux-2.6.30-rc5/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.30-rc5.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6.30-rc5/arch/x86/kernel/acpi/realmode/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
Index: linux-2.6.30-rc5/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.30-rc5.orig/arch/x86/boot/Makefile
+++ linux-2.6.30-rc5/arch/x86/boot/Makefile
@@ -69,6 +69,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
Index: linux-2.6.30-rc5/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.30-rc5.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6.30-rc5/arch/x86/boot/compressed/Makefile
@@ -15,6 +15,7 @@ KBUILD_CFLAGS += $(call cc-option,-ffree
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
Index: linux-2.6.30-rc5/arch/x86/vdso/Makefile
===================================================================
--- linux-2.6.30-rc5.orig/arch/x86/vdso/Makefile
+++ linux-2.6.30-rc5/arch/x86/vdso/Makefile
@@ -123,6 +123,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
 
 VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
 
 #
 # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
Index: linux-2.6.30-rc5/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.30-rc5.orig/arch/x86/kernel/Makefile
+++ linux-2.6.30-rc5/arch/x86/kernel/Makefile
@@ -24,6 +24,8 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+GCOV_PROFILE_vsyscall_64.o	:= n
+GCOV_PROFILE_hpet.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o


