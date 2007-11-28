Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbXK1GK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbXK1GK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 01:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXK1GKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 01:10:47 -0500
Received: from [222.73.24.84] ([222.73.24.84]:60539 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXK1GKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 01:10:46 -0500
Message-ID: <474D05AE.60905@cn.fujitsu.com>
Date: Wed, 28 Nov 2007 14:07:42 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: roland@redhat.com, mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <474CF7D5.6010702@cn.fujitsu.com>
In-Reply-To: <474CF7D5.6010702@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Roland McGrath wrote::
> cf http://lkml.org/lkml/2007/10/3/41
> 
> To summarize: on Linux, SA_ONSTACK decides whether you are already on the
> signal stack based on the value of the SP at the time of a signal.  If
> you are not already inside the range, you are not "on the signal stack"
> and so the new signal handler frame starts over at the base of the signal
> stack.
> 
> sigaltstack (and sigstack before it) was invented in BSD.  There, the
> SA_ONSTACK behavior has always been different.  It uses a kernel state
> flag to decide, rather than the SP value.  When you first take an
> SA_ONSTACK signal and switch to the alternate signal stack, it sets the
> SS_ONSTACK flag in the thread's sigaltstack state in the kernel.
> Thereafter you are "on the signal stack" and don't switch SP before
> pushing a handler frame no matter what the SP value is.  Only when you
> sigreturn from the original handler context do you clear the SS_ONSTACK
> flag so that a new handler frame will start over at the base of the
> alternate signal stack.
> 
> The undesireable effect of the Linux behavior is that an overflow of the
> alternate signal stack can not only go undetected, but lead to a ring
> buffer effect of clobbering the original handler frame at the base of the
> signal stack for each successive signal that comes just after the
> overflow.  This is what Shi Weihua's test case demonstrates.  Normally
> this does not come up because of the signal mask, but the test case uses
> SA_NODEFER for its SIGSEGV handler.
> 
> The other subtle part of the existing Linux semantics is that a simple
> longjmp out of a signal handler serves to take you off the signal stack
> in a safe and reliable fashion without having used sigreturn (nor having
> just returned from the handler normally, which means the same).  After
> the longjmp (or even informal stack switching not via any proper libc or
> kernel interface), the alternate signal stack stands ready to be used
> again.
> 
> A paranoid program would allocate a PROT_NONE red zone around its
> alternate signal stack.  Then a small overflow would trigger a SIGSEGV in
> handler setup, and be fatal (core dump) whether or not SIGSEGV is
> blocked.  As with thread stack red zones, that cannot catch all overflows
> (or underflows).  e.g., a local array as large as page size allocated in
> a function called from a handler, but not actually touched before more
> calls push more stack, could cause an overflow that silently pushes into
> some unrelated allocated pages.
> 
> The BSD behavior does not do anything in particular about overflow.  But
> it does at least avoid the wraparound or "ring buffer effect", so you'll
> just get a straightforward all-out overflow down your address space past
> the low end of the alternate signal stack.  I don't know what the BSD
> behavior is for longjmp out of an SA_ONSTACK handler.
> 
> The POSIX wording relating to sigaltstack is pretty minimal.  I don't
> think it speaks to this issue one way or another.  (The program that
> overflows its stack is clearly in undefined behavior territory of one
> sort or another anyhow.)
> 
> Given the longjmp issue and the potential for highly subtle complications
> in existing programs relying on this in arcane ways deep in their code, I
> am very dubious about changing the behavior to the BSD style persistent
> flag.  I think Shi Weihua's patches have a similar effect by tracking the
> SP used in the last handler setup.
> 
> I think it would be sensible for the signal handler setup code to detect
> when it would itself be causing a stack overflow.  Maybe something like
> the following patch (untested).  This issue exists in the same way on all
> machines, so ideally they would all do a similar check.  
> 
> When it's the handler function itself or its callees that cause the
> overflow, rather than the signal handler frame setup alone crossing the
> boundary, this still won't help.  But I don't see any way to distinguish
> that from the valid longjmp case.

Thank you for your detailed explanation and patch.
I tested your patch, unfortunately it can not stop all kinds of overflow.

The esp is a user space pointer, so the user can move it. 
For example, the user defines "int i[1000];" in  the handler function.
Please run the following test program, and pay attention to "int i[1000];".
-------------------------------------------------------------------------
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

volatile int counter = 0;

#ifdef __i386__
void print_esp()
{
	unsigned long esp;
	__asm__ __volatile__("movl %%esp, %0":"=g"(esp));

	printf("esp = 0x%08lx\n", esp);
}
#endif

void segv_handler()
{
#ifdef __i386__
	print_esp();
#endif

	int *c = NULL;
	counter++;
	printf("%d\n", counter);

	int i[1000];	// <- Pay attention here.

	*c = 1;			// SEGV
}

int main()
{
	int *c = NULL;
	char *s = malloc(SIGSTKSZ);
	stack_t stack;
	struct sigaction action;

	memset(s, 0, SIGSTKSZ);
	stack.ss_sp = s;
	stack.ss_flags = 0;
	stack.ss_size = SIGSTKSZ;
	int error = sigaltstack(&stack, NULL);
	if (error) {
		printf("Failed to use sigaltstack!\n");
		return -1;
	}

	memset(&action, 0, sizeof(action));
	action.sa_handler = segv_handler;
	action.sa_flags = SA_ONSTACK | SA_NODEFER;

	sigemptyset(&action.sa_mask);

	sigaction(SIGSEGV, &action, NULL);

	*c = 0;			//SEGV

	if (!s)
		free(s);

	return 0;
}
-------------------------------------------------------------------------

So, the patch I posted is still needed 
Surely, adding a variable to sched.h is not a good idea. 
Could you tell me a better place to store the previous esp?

Here is a new patch rebased on 2.6.24-rc3-git2.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

--- /shiwh-tmp/linux-2.6.24-rc3-git2.orig/arch/x86/kernel/signal_32.c	2007-11-28 09:15:34.000000000 +0800
+++ /shiwh-tmp/linux-2.6.24-rc3-git2/arch/x86/kernel/signal_32.c	2007-11-28 13:19:13.000000000 +0800
@@ -297,7 +297,8 @@ get_sigframe(struct k_sigaction *ka, str
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(esp) == 0)
+		if (sas_ss_flags(esp) == 0 &&
+		    !on_sig_stack(current->pre_ss_sp))
 			esp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
@@ -330,9 +331,15 @@ static int setup_frame(int sig, struct k
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
+	if ((ka->sa.sa_flags & SA_ONSTACK) &&
+	    !sas_ss_flags((unsigned long)frame))
+		goto give_sigsegv;
+
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
+	current->pre_ss_sp = (unsigned long)frame;
+
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
 		&& sig < 32
@@ -422,9 +429,15 @@ static int setup_rt_frame(int sig, struc
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
+	if ((ka->sa.sa_flags & SA_ONSTACK) &&
+	    !sas_ss_flags((unsigned long)frame))
+		goto give_sigsegv;
+
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
+	current->pre_ss_sp = (unsigned long)frame;
+
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
 		&& sig < 32
--- /shiwh-tmp/linux-2.6.24-rc3-git2.orig/include/linux/sched.h	2007-11-28 09:15:52.000000000 +0800
+++ /shiwh-tmp/linux-2.6.24-rc3-git2/include/linux/sched.h	2007-11-28 13:20:04.000000000 +0800
@@ -1059,6 +1059,7 @@ struct task_struct {
 	struct sigpending pending;
 
 	unsigned long sas_ss_sp;
+	unsigned long pre_ss_sp;
 	size_t sas_ss_size;
 	int (*notifier)(void *priv);
 	void *notifier_data;
--- /shiwh-tmp/linux-2.6.24-rc3-git2.orig/kernel/signal.c	2007-11-28 09:15:52.000000000 +0800
+++ /shiwh-tmp/linux-2.6.24-rc3-git2/kernel/signal.c	2007-11-28 13:20:54.000000000 +0800
@@ -2403,6 +2403,9 @@ do_sigaltstack (const stack_t __user *us
 
 		current->sas_ss_sp = (unsigned long) ss_sp;
 		current->sas_ss_size = ss_size;
+
+		/* reset previous sp */
+		current->pre_ss_sp = 0;
 	}
 
 	if (uoss) {

Thanks,
Shi Weihua

> 
> 
> Thanks,
> Roland
> 
> ---
> 
> diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
> index d58d455..0000000 100644  
> --- a/arch/x86/kernel/signal_32.c
> +++ b/arch/x86/kernel/signal_32.c
> @@ -295,6 +295,13 @@ get_sigframe(struct k_sigaction *ka, str
>  	/* Default to using normal stack */
>  	esp = regs->esp;
>  
> +	/*
> +	 * If we are on the alternate signal stack and would overflow it, don't.
> +	 * Return an always-bogus address instead so we will die with SIGSEGV.
> +	 */
> +	if (on_sig_stack(esp) && !likely(on_sig_stack(esp - frame_size)))
> +		return (void __user *) -1L;
> +
>  	/* This is the X/Open sanctioned signal stack switching.  */
>  	if (ka->sa.sa_flags & SA_ONSTACK) {
>  		if (sas_ss_flags(esp) == 0)

