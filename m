Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYCJFt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYCJFt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 01:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYCJFtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 01:49:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbYCJFtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 01:49:18 -0400
Date: Sun, 9 Mar 2008 22:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
Message-Id: <20080309224759.6fead9af.akpm@linux-foundation.org>
In-Reply-To: <20080309221458.20642e48@bree.surriel.com>
References: <20080309221458.20642e48@bree.surriel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 22:14:58 -0400 Rik van Riel <riel@surriel.com> wrote:

> SysRP-P is not all that useful on SMP systems, since the sysrq
> irq rarely ends up on the CPU that we actually want to investigate.
> 
> This patch extends sysrq-p to print a backtrace for every CPU,
> not just the lucky one that gets the sysrq irq.  With this patch,
> "echo p > /proc/sysrq-trigger" does something useful.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff -up linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu linux-2.6.25-rc3-mm1/drivers/char/sysrq.c
> --- linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu	2008-03-09 20:22:17.000000000 -0400
> +++ linux-2.6.25-rc3-mm1/drivers/char/sysrq.c	2008-03-09 21:54:02.000000000 -0400
> @@ -196,11 +196,29 @@ static struct sysrq_key_op sysrq_showloc
>  #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
>  #endif
>  
> +static DEFINE_SPINLOCK(show_lock);
> +static void showacpu(void *dummy)
> +{
> +	struct pt_regs *regs = get_irq_regs();
> +
> +	spin_lock(&show_lock);
> +	printk("CPU%d:\n", smp_processor_id());
> +	show_stack(NULL, NULL);
> +	spin_unlock(&show_lock);
> +}
> +static void sysrq_showregs_othercpus(struct work_struct *dummy)
> +{
> +	smp_call_function(showacpu, NULL, 0, 0);
> +}
> +static DECLARE_WORK(sysrq_showregs, sysrq_showregs_othercpus);
>  static void sysrq_handle_showregs(int key, struct tty_struct *tty)
>  {
>  	struct pt_regs *regs = get_irq_regs();
> -	if (regs)
> +	if (regs) {
> +		printk("CPU%d:\n", smp_processor_id());
>  		show_regs(regs);
> +	}
> +	schedule_work(&sysrq_showregs);
>  }
>  static struct sysrq_key_op sysrq_showregs_op = {
>  	.handler	= sysrq_handle_showregs,

Doesn't everyone have a copy of this somewhere? ;)

However it does have the downside that info can scroll away on large cpu
counts.  Maybe it should be a new sysrq command?

