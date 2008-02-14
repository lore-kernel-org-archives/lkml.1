Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbYBNGRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbYBNGRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYBNGRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:17:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYBNGRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:17:13 -0500
Date: Thu, 14 Feb 2008 07:16:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080214061648.GB31327@elte.hu>
References: <20080213164853.GA25476@elte.hu> <47B333B1.28931.A31602E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B333B1.28931.A31602E@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > hm, had to pull it again because it crashed in testing:
> 
> i've only tested .24, not .25 so maybe something changed. did you make 
> sure that
> 
>   write_pda(stack_canary, next_p->stack_canary);
> 
> was removed from arch/x86/kernel/process_64.c:__switch_to? that's the 
> only reason i can think of that would trigger this trace.

I hand-ported your fixes [the patch was whitespace damaged] so i'm quite 
sure i got every bit of it - but find it below for reference. I think 
the percpu changes in .25 might have interfered somewhere. Will 
investigate.

	Ingo

--------------->
Subject: x86: fix stack protector and Makefiles
From: pageexec@freemail.hu
Date: Wed, 13 Feb 2008 15:38:45 +0200

there're so many problems with ssp here and in general.

1. despite the nice analysis in LWN, it unfortunately stopped half way where
   Jon declared that:

     And this turns the failure to read-verify the source array into a buffer
     overflow vulnerability within the kernel. Once that is in place, it is a
     relatively straightforward exercise for any suitably 31337 hacker to
     cause the kernel to jump into the code of his or her choice. Game over.

   fact of the matter is, it's far from game over at this point. and that's
   because despite all appearances, this is far from your run-of-the-mill
   stack buffer overflow. in particular, the overflow does *not* rely on
   overwriting any saved return address on the stack.

   the trickery with the fake compound page set up should have been a sign
   that something else is going on here and the lesson ain't over until you
   understand that part as well.

2. so why isn't this exploit about an overflowed return address? because
   before any potentially overflowed return address would be dereferenced,
   the kernel will attempt to release the page refcounts it acquired in
   get_user_pages (check splice_to_pipe, called from vmsplice_to_pipe
   where the overflowed buffer is). normally that wouldn't be a problem
   since even though the pages[PIPE_BUFFERS] array was overflowed, it was
   overflowed with valid struct page pointers, so releasing them should
   be fine. except there's a trick in the exploit that will cause a userland
   controlled struct page pointer to be released as well at which point
   the exploit takes matters into its own hands:

   previous to calling vmsplice, the exploit has prepared a specially
   constructed struct page array to fake a compound page. the point in
   using a compound page is that such a page has a destructor (read:
   function pointer) which is now under the direct control of the exploit
   and will result in ring-0 code execution of exploit code. *this* is
   the point where it becomes a trivial exercise to escalate privileges.

3. what's ssp got to do with all this? Arjan would have you believe that
   it would have caught this exploit in action, preventing the privilege
   escalation. nothing could be further from the truth though.

   for one if ssp were to kick into action, it could at most be at the
   time vmsplice_to_pipe returns. except it doesn't as explained above.

   but imagine for a second that vmsplice_to_pipe does return. would ssp
   detect anything? at least gentoo's gcc 4.2.2 doesn't at all instrument
   vmsplice_to_pipe with -fstack-protector, so no dice.

   let's go further and imagine we enable CONFIG_CC_STACKPROTECTOR_ALL
   (which in turn makes gcc use -fstack-protector-all). this will now
   properly instrument vmsplice_to_pipe. problem is, such a kernel doesn't
   boot. probably noone has ever tried it (why does it have a config option?).
   the fix isn't trivial and possibly incomplete, see the patches at the end.

   finally just imagine that ssp somehow caught this or another exploit in
   action. what will we learn about it? nothing. that's right, due to bad
   decisions made by certain developers (both gcc and kernel),__stack_chk_fail
   doesn't get passed any extra info (unlike Etoh's original ssp), nor does
   the kernel's version produce any actually useful output that, pray tell,
   could help identify the attacked function. instead it just panic's. a truly
   useful experience.

   it also bears a note here that the way ssp is currently implemented in
   the kernel is quite useless, a per-task static cookie is trivial to learn
   in a kernel info-leak exploit that in turn can be built into the actual
   attack payload to bypass any detection (a case that ssp was designed to
   protect against, this particular bug/exploit doesn't give direct control
   over the overflow content, hence even the current cookie method would have
   been fine, were it not irrelevant for reasons explained above).

[...]
> It would have made this exploit not possible for those kernels that
> enable this feature (and that includes distros like Fedora)

sadly for all those users living in a false sense of security, this has
never been true. but long live cargo cult security.

patches to get CONFIG_CC_STACKPROTECTOR_ALL actually to work (it includes
the Makefile patch proposed in this thread already).

note also that the vsyscall functions (more precisely, all the code that
goes into .vsyscall* sections) had better be separated into their own .c
files so that they can be compiled without -mcmodel=kernel and use %fs for
getting the ssp cookie, if ssp is desired at all there).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Makefile                     |    6 +++---
 arch/x86/kernel/Makefile     |    8 ++++++++
 arch/x86/kernel/entry_64.S   |    6 ++++--
 arch/x86/kernel/process_64.c |    5 ++---
 include/asm-x86/system.h     |    6 +++++-
 kernel/panic.c               |    2 ++
 6 files changed, 24 insertions(+), 9 deletions(-)

Index: linux-x86.q/Makefile
===================================================================
--- linux-x86.q.orig/Makefile
+++ linux-x86.q/Makefile
@@ -507,6 +507,9 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+# Force gcc to behave correct even for buggy distributions
+KBUILD_CFLAGS		+= $(call cc-option, -fno-stack-protector)
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
@@ -525,9 +528,6 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
-# Force gcc to behave correct even for buggy distributions
-KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
-
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
Index: linux-x86.q/arch/x86/kernel/Makefile
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/Makefile
+++ linux-x86.q/arch/x86/kernel/Makefile
@@ -8,6 +8,14 @@ extra-$(CONFIG_X86_64) += head64.o
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 CFLAGS_vsyscall_64.o := $(PROFILING) -g0
 
+#
+# Vsyscalls (which work on the user stack) should have
+# no stack-protector checks:
+#
+CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 -fno-stack-protector
+CFLAGS_hpet.o		:= -fno-stack-protector
+CFLAGS_tsc_64.o		:= -fno-stack-protector
+
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
Index: linux-x86.q/arch/x86/kernel/entry_64.S
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/entry_64.S
+++ linux-x86.q/arch/x86/kernel/entry_64.S
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
Index: linux-x86.q/arch/x86/kernel/process_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_64.c
+++ linux-x86.q/arch/x86/kernel/process_64.c
@@ -676,7 +676,6 @@ __switch_to(struct task_struct *prev_p, 
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
@@ -705,7 +704,7 @@ __switch_to(struct task_struct *prev_p, 
  */
 asmlinkage
 long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs regs)
+		char __user * __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char * filename;
@@ -714,7 +713,7 @@ long sys_execve(char __user *name, char 
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename)) 
 		return error;
-	error = do_execve(filename, argv, envp, &regs); 
+	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
 	return error;
 }
Index: linux-x86.q/include/asm-x86/system.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/system.h
+++ linux-x86.q/include/asm-x86/system.h
@@ -70,6 +70,8 @@ struct task_struct *__switch_to(struct t
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
 	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     "movq %P[task_canary](%%rsi),%%r8\n\t"			  \
+	     "movq %%r8,%%gs:%P[pda_canary]\n\t"			  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -81,7 +83,9 @@ struct task_struct *__switch_to(struct t
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	       [task_canary] "i" (offsetof(struct task_struct, stack_canary)),\
+	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent)), \
+	       [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))\
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
Index: linux-x86.q/kernel/panic.c
===================================================================
--- linux-x86.q.orig/kernel/panic.c
+++ linux-x86.q/kernel/panic.c
@@ -323,6 +323,8 @@ EXPORT_SYMBOL(warn_on_slowpath);
  */
 void __stack_chk_fail(void)
 {
+	print_symbol("stack corrupted in: %s\n", (unsigned long)__builtin_return_address(0));
+	dump_stack();
 	panic("stack-protector: Kernel stack is corrupted");
 }
 EXPORT_SYMBOL(__stack_chk_fail);
