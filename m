Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYBWMdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYBWMdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYBWMdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:33:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbYBWMdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:33:42 -0500
Date: Sat, 23 Feb 2008 13:33:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [git pull] minimal stackprotector fixes on x86
Message-ID: <20080223123317.GA2321@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

i've prepared and tested the 5 minimal fixes needed to get the 
stackprotector working again on x86. If you agree with fixing it now you 
can pull the fixes from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

4 out of the 5 patches are structured in a way to make them not affect 
the !STACKPROTECTOR kernel at all.

the single fix that does touch the !STACKPROTECTOR kernel is:

      x86: fix execve with -fstack-protect

i could try to #ifdef my way around it but it would be pretty ugly and i 
think we want that fix on !stackprotector too. This patch has been 
tested quite extensively so i think it's safe for v2.6.25.

( This queue also contains the fix for the 64-bit PARAVIRT breakage
  reported by James Morris yesterday. )

	Ingo

------------------>
Arjan van de Ven (1):
      x86: setup stack canary for the idle threads

Ingo Molnar (4):
      x86: fix execve with -fstack-protect
      x86: stackprotector & PARAVIRT fix
      x86: fix stackprotector canary updates during context switches
      x86: fix canary of the boot CPU's idle task

 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/entry_64.S   |    6 ++++--
 arch/x86/kernel/process_64.c |   20 ++++++++++++++++----
 include/asm-x86/system.h     |   14 ++++++++++++++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4eb5ce8..b5d28e2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,6 +15,7 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc_64.o		:= $(nostackp)
+CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2ad9a1b..c20c9e7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -453,6 +453,7 @@ ENTRY(stub_execve)
 	CFI_REGISTER rip, r11
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
 	call sys_execve
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
@@ -1036,15 +1037,16 @@ ENDPROC(child_rip)
  *	rdi: name, rsi: argv, rdx: envp
  *
  * We want to fallback into:
- *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs regs)
+ *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs *regs)
  *
  * do_sys_execve asm fallback arguments:
- *	rdi: name, rsi: argv, rdx: envp, fake frame on the stack
+ *	rdi: name, rsi: argv, rdx: envp, rcx: fake frame on the stack
  */
 ENTRY(kernel_execve)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $0
 	SAVE_ALL	
+	movq %rsp,%rcx
 	call sys_execve
 	movq %rax, RAX(%rsp)	
 	RESTORE_REST
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b0cc8f0..d8b3de1 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -167,6 +167,19 @@ static inline void play_dead(void)
 void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/*
+	 * If we're the non-boot CPU, nothing set the PDA stack
+	 * canary up for us - and if we are the boot CPU we have
+	 * a 0 stack canary. This is a good place for updating
+	 * it, as we wont ever return from this function (so the
+	 * invalid canaries already on the stack wont ever
+	 * trigger):
+	 */
+	current->stack_canary = get_random_int();
+	write_pda(stack_canary, current->stack_canary);
+#endif
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
@@ -701,7 +714,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
@@ -730,16 +742,16 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
  */
 asmlinkage
 long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs regs)
+		char __user * __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char * filename;
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (IS_ERR(filename)) 
+	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, &regs); 
+	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
 	return error;
 }
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 9cff02f..2ddcefc 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -61,6 +61,18 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
 	  "r12", "r13", "r14", "r15"
 
+#ifdef CONFIG_CC_STACKPROTECTOR
+# define SWITCH_TO_UPDATE_CANARY_ASM					  \
+	     "movq %P[task_canary](%%rsi),%%r8\n\t"			  \
+	     "movq %%r8,%%gs:%P[pda_canary]\n\t"
+# define SWITCH_TO_UPDATE_CANARY_ASM_VARS				  \
+       , [task_canary] "i" (offsetof(struct task_struct, stack_canary)),  \
+       [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))
+#else
+# define SWITCH_TO_UPDATE_CANARY_ASM
+# define SWITCH_TO_UPDATE_CANARY_ASM_VARS
+#endif
+
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev, next, last) \
 	asm volatile(SAVE_CONTEXT						    \
@@ -70,6 +82,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
 	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     SWITCH_TO_UPDATE_CANARY_ASM				  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -82,6 +95,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
 	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	       SWITCH_TO_UPDATE_CANARY_ASM_VARS				  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
