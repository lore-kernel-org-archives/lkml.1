Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZHBSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZHBSqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZHBSqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:46:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbZHBSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:46:33 -0400
Date: Sun, 2 Aug 2009 11:45:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: tip-bot for Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-Id: <20090802114545.f1520c81.akpm@linux-foundation.org>
In-Reply-To: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
References: <new-submission>
	<tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 13:09:34 GMT tip-bot for Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> Gitweb:     http://git.kernel.org/tip/c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sun, 2 Aug 2009 11:28:21 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 2 Aug 2009 13:27:17 +0200
> 
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -24,6 +24,7 @@
>  #include <linux/sysrq.h>
>  #include <linux/kbd_kern.h>
>  #include <linux/proc_fs.h>
> +#include <linux/nmi.h>
>  #include <linux/quotaops.h>
>  #include <linux/perf_counter.h>
>  #include <linux/kernel.h>
> @@ -222,12 +223,7 @@ static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
>  
>  static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
>  {
> -	struct pt_regs *regs = get_irq_regs();
> -	if (regs) {
> -		printk(KERN_INFO "CPU%d:\n", smp_processor_id());
> -		show_regs(regs);
> -	}
> -	schedule_work(&sysrq_showallcpus);
> +	trigger_all_cpu_backtrace();
>  }

I think this just broke all non-x86 non-sparc SMP architectures.

>  static struct sysrq_key_op sysrq_showallcpus_op = {
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 7717b95..9c5fa9f 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -35,6 +35,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> +#include <linux/nmi.h>
>  #include <asm/atomic.h>
>  #include <linux/bitops.h>
>  #include <linux/module.h>
> @@ -469,6 +470,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	}
>  	printk(" (detected by %d, t=%ld jiffies)\n",
>  	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
> +	trigger_all_cpu_backtrace();

Be aware that trigger_all_cpu_backtrace() is a PITA when you have a lot
of CPUs.

If a callsite is careful to ensure that the most important information
is emitted last then that might improve things.

otoh, log buffer overflow will truncate, I think.  So that info needs
to be emitted first too ;)

It's a PITA.


