Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXKSCSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXKSCSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 21:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXKSCR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 21:17:58 -0500
Received: from [222.73.24.84] ([222.73.24.84]:59930 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbXKSCR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 21:17:57 -0500
Message-ID: <4740F1D6.3060201@cn.fujitsu.com>
Date: Mon, 19 Nov 2007 10:15:50 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <47034D80.2080408@cn.fujitsu.com>
In-Reply-To: <47034D80.2080408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

If a process uses alternative signal stack by using sigaltstack(),
then that stack overflows and stack wraparound may occur.
Simple explanation:
The accurate esp order is A,B,C,D,...
But now the esp points to A,B,C and A,B,C... dropping into a recursion.

The upper bug and patch about "alternative signal stack wraparound occurs"
has been contributed here at 10/3.
(subject:[PATCH 0/3] signal: alternative signal stack wraparound occurs)
(Please refer to http://lkml.org/lkml/2007/10/3/41).

Now, I renewed the patch and it can stop wraparound.
Can you give me some advice about storing the previous esp?

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---
diff -urpN linux-2.6.24-rc2.orig/arch/x86/kernel/signal_32.c linux-2.6.24-rc2/arch/x86/kernel/signal_32.c
--- linux-2.6.24-rc2.orig/arch/x86/kernel/signal_32.c	2007-11-13 14:30:45.000000000 +0800
+++ linux-2.6.24-rc2/arch/x86/kernel/signal_32.c	2007-11-13 14:38:03.000000000 +0800
@@ -297,7 +297,8 @@ get_sigframe(struct k_sigaction *ka, str
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(esp) == 0)
+		if (sas_ss_flags(esp) == 0 &&
+			!on_sig_stack(current->pre_ss_sp))
 			esp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
@@ -330,9 +331,15 @@ static int setup_frame(int sig, struct k
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
+	if ((ka->sa.sa_flags & SA_ONSTACK) &&
+		!sas_ss_flags((unsigned long)frame))
+		goto give_sigsegv;
+
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
+	current->pre_ss_sp = (unsigned long)frame;
+
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
 		&& sig < 32
diff -urpN linux-2.6.24-rc2.orig/include/linux/sched.h linux-2.6.24-rc2/include/linux/sched.h
--- linux-2.6.24-rc2.orig/include/linux/sched.h	2007-11-13 14:29:17.000000000 +0800
+++ linux-2.6.24-rc2/include/linux/sched.h	2007-11-13 14:31:46.000000000 +0800
@@ -1059,6 +1059,7 @@ struct task_struct {
 	struct sigpending pending;
 
 	unsigned long sas_ss_sp;
+	unsigned long pre_ss_sp;
 	size_t sas_ss_size;
 	int (*notifier)(void *priv);
 	void *notifier_data;
diff -urpN linux-2.6.24-rc2.orig/kernel/signal.c linux-2.6.24-rc2/kernel/signal.c
--- linux-2.6.24-rc2.orig/kernel/signal.c	2007-11-13 14:29:16.000000000 +0800
+++ linux-2.6.24-rc2/kernel/signal.c	2007-11-13 14:33:00.000000000 +0800
@@ -2403,6 +2403,9 @@ do_sigaltstack (const stack_t __user *us
 
 		current->sas_ss_sp = (unsigned long) ss_sp;
 		current->sas_ss_size = ss_size;
+
+		/* reset previous sp */
+		current->pre_ss_sp = 0;
 	}
 
 	if (uoss) {


Shi Weihua wrote::
> Fixing alternative signal stack wraparound.
> 
> If a process uses alternative signal stack by using sigaltstack()
> and that stack overflow, stack wraparound occurs.
> This patch checks whether the signal frame is on the alternative
> stack. If the frame is not on there, kill a signal SIGSEGV to the
> process forcedly
> then the process will be terminated.
> 
> This patch is for i386,version is 2.6.23-rc8.
> 
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
> 
> diff -pur linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c
> linux-2.6.23-rc8/arch/i386/kernel/signal.c
> --- linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c    2007-09-26
> 09:44:08.000000000 +0900
> +++ linux-2.6.23-rc8/arch/i386/kernel/signal.c    2007-09-26
> 13:14:25.000000000 +0900
> @@ -332,6 +332,10 @@ static int setup_frame(int sig, struct k
> 
>      frame = get_sigframe(ka, regs, sizeof(*frame));
> 
> +    if ((ka->sa.sa_flags & SA_ONSTACK) &&
> +        !sas_ss_flags((unsigned long)frame))
> +        goto give_sigsegv;
> +
>      if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>          goto give_sigsegv;
> 
> @@ -425,6 +429,10 @@ static int setup_rt_frame(int sig, struc
> 
>      frame = get_sigframe(ka, regs, sizeof(*frame));
> 
> +    if ((ka->sa.sa_flags & SA_ONSTACK) &&
> +        !sas_ss_flags((unsigned long)frame))
> +        goto give_sigsegv;
> +
>      if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>          goto give_sigsegv;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

