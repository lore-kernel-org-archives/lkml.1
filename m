Return-Path: <linux-kernel-owner+w=401wt.eu-S1763728AbXKJDwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763728AbXKJDwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXKJDwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:52:32 -0500
Received: from www.tglx.de ([62.245.132.106]:53214 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXKJDwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:52:31 -0500
Date: Sat, 10 Nov 2007 04:52:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 updates
Message-ID: <alpine.LRH.0.999.0711100450020.28218@www.tglx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

please pull x86 updates from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git master

Thanks,

	tglx

Chuck Ebbert (1):
      x86 - 32-bit ptrace emulation mishandles 6th arg

Randy Dunlap (1):
      voyager: use struct instead of PARAM

Roland McGrath (1):
      x86_64: ia32 ptrace THREAD_AREA fix

 arch/x86/ia32/ia32entry.S                 |   19 ++++++-------------
 arch/x86/ia32/ptrace32.c                  |   10 ++--------
 include/asm-x86/mach-voyager/setup_arch.h |    4 +++-
 3 files changed, 11 insertions(+), 22 deletions(-)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 18b2318..df588f0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -159,20 +159,16 @@ sysenter_do_call:
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
+	xchgl	%r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	movl	%ebp, %ebp
-	/* no need to do an access_ok check here because rbp has been
-	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
+	xchgl	%ebp,%r9d
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -262,20 +258,17 @@ cstar_do_call:
 	
 cstar_tracesys:	
 	CFI_RESTORE_STATE
+	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq %r9,R9(%rsp)
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
+	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index f52770e..4a233ad 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -228,8 +228,6 @@ static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
 	return ret;
 }
 
-#define COMPAT_GDT_ENTRY_TLS_MIN 6
-
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
 	struct task_struct *child;
@@ -248,6 +246,8 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SYSCALL:
 	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
+	case PTRACE_SET_THREAD_AREA:
+	case PTRACE_GET_THREAD_AREA:
 		return sys_ptrace(request, pid, addr, data); 
 
 	default:
@@ -271,12 +271,6 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETSIGINFO:
 	case PTRACE_GETSIGINFO:
 		return ptrace32_siginfo(request, pid, addr, data);
-
-	case PTRACE_SET_THREAD_AREA:
-	case PTRACE_GET_THREAD_AREA:
-		return sys_ptrace(request, pid,
-			addr + GDT_ENTRY_TLS_MIN - COMPAT_GDT_ENTRY_TLS_MIN,
-			data);
 	}
 
 	child = ptrace_get_task_struct(pid);
diff --git a/include/asm-x86/mach-voyager/setup_arch.h b/include/asm-x86/mach-voyager/setup_arch.h
index 84d01ad..1710ae1 100644
--- a/include/asm-x86/mach-voyager/setup_arch.h
+++ b/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,7 @@
 #include <asm/voyager.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
+#include <asm/setup_32.h>
+#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
+			(&boot_params.apm_bios_info))
 
 /* Hook to call BIOS initialisation function */
 
