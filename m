Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZFBLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZFBLpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbZFBLp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:45:28 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33922 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760816AbZFBLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:45:26 -0400
Message-Id: <20090602114403.642703631@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 02 Jun 2009 13:44:03 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
       Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: [PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64
References: <20090602114359.129247921@linux.vnet.ibm.com>
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

Index: linux-2.6.30-rc7/kernel/gcov/Kconfig
===================================================================
--- linux-2.6.30-rc7.orig/kernel/gcov/Kconfig	2009-06-02 10:35:26.000000000 +0200
+++ linux-2.6.30-rc7/kernel/gcov/Kconfig	2009-06-02 10:35:31.000000000 +0200
@@ -34,7 +34,7 @@
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on S390 || X86_32
+	depends on S390 || X86
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
Index: linux-2.6.30-rc7/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.30-rc7.orig/arch/x86/kernel/acpi/realmode/Makefile	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.30-rc7/arch/x86/kernel/acpi/realmode/Makefile	2009-06-02 10:35:31.000000000 +0200
@@ -42,6 +42,7 @@
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
Index: linux-2.6.30-rc7/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.30-rc7.orig/arch/x86/boot/Makefile	2009-06-02 10:33:04.000000000 +0200
+++ linux-2.6.30-rc7/arch/x86/boot/Makefile	2009-06-02 10:35:31.000000000 +0200
@@ -69,6 +69,7 @@
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
Index: linux-2.6.30-rc7/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.30-rc7.orig/arch/x86/boot/compressed/Makefile	2009-06-02 10:33:04.000000000 +0200
+++ linux-2.6.30-rc7/arch/x86/boot/compressed/Makefile	2009-06-02 10:35:31.000000000 +0200
@@ -15,6 +15,7 @@
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
Index: linux-2.6.30-rc7/arch/x86/vdso/Makefile
===================================================================
--- linux-2.6.30-rc7.orig/arch/x86/vdso/Makefile	2009-06-02 10:33:11.000000000 +0200
+++ linux-2.6.30-rc7/arch/x86/vdso/Makefile	2009-06-02 10:35:31.000000000 +0200
@@ -123,6 +123,7 @@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
 
 VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
 
 #
 # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
Index: linux-2.6.30-rc7/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.30-rc7.orig/arch/x86/kernel/Makefile	2009-06-02 10:33:07.000000000 +0200
+++ linux-2.6.30-rc7/arch/x86/kernel/Makefile	2009-06-02 10:35:31.000000000 +0200
@@ -24,6 +24,8 @@
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+GCOV_PROFILE_vsyscall_64.o	:= n
+GCOV_PROFILE_hpet.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o


