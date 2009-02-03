Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZBCMvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZBCMvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZBCMv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:51:28 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43067 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZBCMv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:51:27 -0500
Message-ID: <49883CEA.7070403@linux.vnet.ibm.com>
Date: Tue, 03 Feb 2009 13:47:38 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Index: linux-2.6.29-rc3/kernel/gcov/Kconfig
===================================================================
--- linux-2.6.29-rc3.orig/kernel/gcov/Kconfig
+++ linux-2.6.29-rc3/kernel/gcov/Kconfig
@@ -34,7 +34,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on S390 || X86_32
+	depends on S390 || X86
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
Index: linux-2.6.29-rc3/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.29-rc3.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6.29-rc3/arch/x86/kernel/acpi/realmode/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
Index: linux-2.6.29-rc3/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.29-rc3.orig/arch/x86/boot/Makefile
+++ linux-2.6.29-rc3/arch/x86/boot/Makefile
@@ -71,6 +71,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 $(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
Index: linux-2.6.29-rc3/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.29-rc3.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6.29-rc3/arch/x86/boot/compressed/Makefile
@@ -14,6 +14,7 @@ KBUILD_CFLAGS += $(call cc-option,-ffree
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
Index: linux-2.6.29-rc3/arch/x86/vdso/Makefile
===================================================================
--- linux-2.6.29-rc3.orig/arch/x86/vdso/Makefile
+++ linux-2.6.29-rc3/arch/x86/vdso/Makefile
@@ -123,6 +123,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
 
 VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
 
 #
 # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
Index: linux-2.6.29-rc3/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.29-rc3.orig/arch/x86/kernel/Makefile
+++ linux-2.6.29-rc3/arch/x86/kernel/Makefile
@@ -23,6 +23,8 @@ nostackp := $(call cc-option, -fno-stack
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
+GCOV_PROFILE_vsyscall_64.o	:= n
+GCOV_PROFILE_hpet.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o



