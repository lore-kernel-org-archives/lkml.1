Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYCJRmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYCJRmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYCJRme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:42:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYCJRmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:42:33 -0400
Date: Mon, 10 Mar 2008 10:41:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH] sysrq show-all-cpus
Message-Id: <20080310104154.56fd4825.akpm@linux-foundation.org>
In-Reply-To: <20080310133242.0ab69084@bree.surriel.com>
References: <20080310133242.0ab69084@bree.surriel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 13:32:42 -0400
Rik van Riel <riel@redhat.com> wrote:

> SysRQ-P is not always useful on SMP systems, since it usually ends up showing the
> backtrace of a CPU that is doing just fine, instead of the backtrace of the CPU
> that is having problems.
> 
> This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every active
> CPU in the system.  It skips idle CPUs because some SMP systems are just too large
> and we already know what the backtrace of the idle task looks like.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff -up linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu linux-2.6.25-rc3-mm1/drivers/char/sysrq.c
> --- linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu	2008-03-09 20:22:17.000000000 -0400
> +++ linux-2.6.25-rc3-mm1/drivers/char/sysrq.c	2008-03-10 13:03:00.000000000 -0400
> @@ -196,6 +196,44 @@ static struct sysrq_key_op sysrq_showloc
>  #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
>  #endif
>  
> +#ifdef CONFIG_SMP
> +static DEFINE_SPINLOCK(show_lock);
> +static void showacpu(void *dummy)
> +{
> +	unsigned long flags;
> +
> +	/* Idle CPUs have no interesting backtrace. */
> +	if (idle_cpu(smp_processor_id()))
> +		return;
> +
> +	spin_lock_irqsave(&show_lock, flags);
> +	printk("CPU%d:\n", smp_processor_id());
> +	show_stack(NULL, NULL);
> +	spin_unlock_irqrestore(&show_lock, flags);
> +}
> +static void sysrq_showregs_othercpus(struct work_struct *dummy)
> +{
> +	smp_call_function(showacpu, NULL, 0, 0);
> +}
> +static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
> +
> +static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
> +{
> +	struct pt_regs *regs = get_irq_regs();
> +	if (regs) {
> +		printk("CPU%d:\n", smp_processor_id());
> +		show_regs(regs);
> +	}
> +	schedule_work(&sysrq_showallcpus);
> +}
> +static struct sysrq_key_op sysrq_showallcpus_op = {
> +	.handler	= sysrq_handle_showallcpus,
> +	.help_msg	= "show-all-cpus(L)",
> +	.action_msg	= "Show backtrace of all active CPUs",
> +	.enable_mask	= SYSRQ_ENABLE_DUMP,
> +};
> +#endif

So the CPU which took the interrupt is always the first to display - that's
nice.

Even if it's idle.  I guess that's OK.

How come the sysrq-handling CPU uses show_regs() and the others use
show_stack()?  Do we not set up the get_irq_regs() data for IPIs?

>  static void sysrq_handle_showregs(int key, struct tty_struct *tty)
>  {
>  	struct pt_regs *regs = get_irq_regs();
> @@ -340,7 +378,11 @@ static struct sysrq_key_op *sysrq_key_ta
>  	&sysrq_kill_op,			/* i */
>  	NULL,				/* j */
>  	&sysrq_SAK_op,			/* k */
> +#ifdef CONFIG_SMP
> +	&sysrq_showallcpus_op,		/* l */
> +#else
>  	NULL,				/* l */
> +#endif
>  	&sysrq_showmem_op,		/* m */
>  	&sysrq_unrt_op,			/* n */
>  	/* o: This will often be registered as 'Off' at init time */
