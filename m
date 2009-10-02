Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZJBMg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZJBMg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZJBMg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:36:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592AbZJBMgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:36:24 -0400
Date: Fri, 2 Oct 2009 14:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091002123615.GA19350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      x86: Don't generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y

Jan Beulich (1):
      x86: Don't leak 64-bit kernel register values to 32-bit processes

Jason Wessel (1):
      x86: earlyprintk: Fix regression to handle serial,ttySn as 1 arg

Jaswinder Singh Rajput (1):
      x86, SLUB: Remove unused CONFIG FAST_CMPXCHG_LOCAL

Linus Torvalds (1):
      x86: Optimize cmpxchg64() at build-time some more

Samuel Thibault (1):
      x86: Fix csum_ipv6_magic asm memory clobber


 Documentation/kernel-parameters.txt |    1 +
 arch/x86/Kconfig                    |    4 ---
 arch/x86/Kconfig.cpu                |    3 +-
 arch/x86/ia32/ia32entry.S           |   36 ++++++++++++++++++++++------------
 arch/x86/include/asm/checksum_32.h  |    3 +-
 arch/x86/kernel/early_printk.c      |    5 +++-
 arch/x86/kernel/i386_ksyms_32.c     |    2 +
 arch/x86/lib/Makefile               |    6 +++-
 8 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..9107b38 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -671,6 +671,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
 
 			Append ",keep" to not disable it when the real console
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8da9374..c876bac 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -86,10 +86,6 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
-config FAST_CMPXCHG_LOCAL
-	bool
-	default y
-
 config MMU
 	def_bool y
 
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 527519b..f2824fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
@@ -412,6 +412,7 @@ config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
 	default "6" if X86_32 && X86_P6_NOP
+	default "5" if X86_32 && X86_CMPXCHG64
 	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 74619c4..1733f9f 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -21,8 +21,8 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 #ifndef CONFIG_AUDITSYSCALL
-#define sysexit_audit int_ret_from_sys_call
-#define sysretl_audit int_ret_from_sys_call
+#define sysexit_audit ia32_ret_from_sys_call
+#define sysretl_audit ia32_ret_from_sys_call
 #endif
 
 #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
@@ -39,12 +39,12 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS _r9=rax
+	.macro  CLEAR_RREGS offset=0, _r9=rax
 	xorl 	%eax,%eax
-	movq	%rax,R11(%rsp)
-	movq	%rax,R10(%rsp)
-	movq	%\_r9,R9(%rsp)
-	movq	%rax,R8(%rsp)
+	movq	%rax,\offset+R11(%rsp)
+	movq	%rax,\offset+R10(%rsp)
+	movq	%\_r9,\offset+R9(%rsp)
+	movq	%rax,\offset+R8(%rsp)
 	.endm
 
 	/*
@@ -172,6 +172,10 @@ sysexit_from_sys_call:
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_ARGS 1,24,1,1,1,1
+	xorq	%r8,%r8
+	xorq	%r9,%r9
+	xorq	%r10,%r10
+	xorq	%r11,%r11
 	popfq
 	CFI_ADJUST_CFA_OFFSET -8
 	/*CFI_RESTORE rflags*/
@@ -202,7 +206,7 @@ sysexit_from_sys_call:
 
 	.macro auditsys_exit exit,ebpsave=RBP
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
-	jnz int_ret_from_sys_call
+	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	sti
 	movl %eax,%esi		/* second arg, syscall return value */
@@ -218,8 +222,9 @@ sysexit_from_sys_call:
 	cli
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags(%r10)
-	jnz int_with_check
-	jmp \exit
+	jz \exit
+	CLEAR_RREGS -ARGOFFSET
+	jmp int_with_check
 	.endm
 
 sysenter_auditsys:
@@ -329,6 +334,9 @@ sysretl_from_sys_call:
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
 	/*CFI_REGISTER rflags,r11*/
+	xorq	%r10,%r10
+	xorq	%r9,%r9
+	xorq	%r8,%r8
 	TRACE_IRQS_ON
 	movl RSP-ARGOFFSET(%rsp),%esp
 	CFI_RESTORE rsp
@@ -353,7 +361,7 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS r9
+	CLEAR_RREGS 0, r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
@@ -425,6 +433,8 @@ ia32_do_call:
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
 	movq %rax,RAX-ARGOFFSET(%rsp)
+ia32_ret_from_sys_call:
+	CLEAR_RREGS -ARGOFFSET
 	jmp int_ret_from_sys_call 
 
 ia32_tracesys:			 
@@ -442,8 +452,8 @@ END(ia32_syscall)
 
 ia32_badsys:
 	movq $0,ORIG_RAX-ARGOFFSET(%rsp)
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
-	jmp int_ret_from_sys_call
+	movq $-ENOSYS,%rax
+	jmp ia32_sysret
 
 quiet_ni_syscall:
 	movq $-ENOSYS,%rax
diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 7c5ef8b..46fc474 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	    : "memory");
 
 	return csum_fold(sum);
 }
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 41fd965..b9c830c 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -206,8 +206,11 @@ static int __init setup_early_printk(char *buf)
 
 	while (*buf != '\0') {
 		if (!strncmp(buf, "serial", 6)) {
-			early_serial_init(buf + 6);
+			buf += 6;
+			early_serial_init(buf);
 			early_console_register(&early_serial_console, keep);
+			if (!strncmp(buf, ",ttyS", 5))
+				buf += 5;
 		}
 		if (!strncmp(buf, "ttyS", 4)) {
 			early_serial_init(buf + 4);
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 1736c5a..9c3bd4a 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -15,8 +15,10 @@ EXPORT_SYMBOL(mcount);
  * the export, but dont use it from C code, it is used
  * by assembly code and is not using C calling convention!
  */
+#ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
 EXPORT_SYMBOL(cmpxchg8b_emu);
+#endif
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 3e549b8..85f5db9 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -15,8 +15,10 @@ ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
-
+        lib-y += semaphore_32.o string_32.o
+ifneq ($(CONFIG_X86_CMPXCHG64),y)
+        lib-y += cmpxchg8b_emu.o
+endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
