Return-Path: <linux-kernel-owner+w=401wt.eu-S1763082AbXK2MBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763082AbXK2MBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762912AbXK2MA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:00:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762739AbXK2MA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 10/11] x86 ptrace merge complete
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Zippy-Says: Okay, BARBRA STREISAND, I recognize you now!!  Also EFREM
    ZIMBALIST, JUNIOR!!  And BEAUMONT NEWHALL!!  Everybody into th'
    BATHROOM!
Message-Id: <20071129120049.1226D26F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 04:00:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This switches over the 64-bit build to use the shared ptrace code,
instead of the old ptrace_64.c and arch/x86/ia32/ptrace32.c code.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/Makefile      |    2 +-
 arch/x86/kernel/Makefile_64 |    3 ++-
 include/asm-x86/ptrace.h    |    3 ---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index ea60886..ec71cfe 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o \
-	ia32_binfmt.o fpu32.o ptrace32.o
+	ia32_binfmt.o fpu32.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index d8d0a28..8c24601 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -7,12 +7,13 @@ CPPFLAGS_vmlinux.lds += -Ux86_64
 EXTRA_AFLAGS	:= -traditional
 
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
-		ptrace_64.o time_64.o ioport_64.o ldt.o setup_64.o i8259_64.o sys_x86_64.o \
+		time_64.o ioport_64.o ldt.o setup_64.o i8259_64.o sys_x86_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
 		i8253.o rtc.o
 
+obj-y				+= ptrace.o
 obj-y				+= step.o
 
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 1b7a8b8..9228870 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -164,9 +164,6 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 struct task_struct;
 
-extern unsigned long ptrace_get_debugreg(struct task_struct *child, int n);
-extern int ptrace_set_debugreg(struct task_struct *child, int n, unsigned long);
-
 extern unsigned long
 convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
