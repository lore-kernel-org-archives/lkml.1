Return-Path: <linux-kernel-owner+w=401wt.eu-S939917AbXG3VJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939917AbXG3VJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939274AbXG3VJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:09:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083AbXG3VJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:09:46 -0400
Date: Mon, 30 Jul 2007 14:09:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add a show-stacktrace-on-all-cpus command
Message-Id: <20070730140938.4ead69f9.akpm@linux-foundation.org>
In-Reply-To: <11857049662730-git-send-email-avi@qumranet.com>
References: <11857049662730-git-send-email-avi@qumranet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 13:29:26 +0300
Avi Kivity <avi@qumranet.com> wrote:

> If a cpu is spinning in the kernel but still responding to interrupts,
> pressing sysrq-y will show you where it's spinning.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> 
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index 39cc318..1dda709 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -45,6 +45,8 @@ int __read_mostly __sysrq_enabled = 1;
>  
>  static int __read_mostly sysrq_always_enabled;
>  
> +static spinlock_t show_stack_lock = SPIN_LOCK_UNLOCKED;

Use DEFINE_SPINLOCK to avoid confusing lockdep.

>  int sysrq_on(void)
>  {
>  	return __sysrq_enabled || sysrq_always_enabled;
> @@ -309,6 +311,26 @@ static struct sysrq_key_op sysrq_unrt_op = {
>  	.enable_mask	= SYSRQ_ENABLE_RTNICE,
>  };
>  
> +static void show_cpu_stack(void *garbage)
> +{
> +	spin_lock(&show_stack_lock);
> +	printk("CPU%d stacktrace:\n", raw_smp_processor_id());
> +	dump_stack();
> +	sysrq_handle_showregs(0, NULL);
> +	spin_unlock(&show_stack_lock);
> +}
> +
> +static void sysrq_show_stacks(int key, struct tty_struct *tty)
> +{
> +	on_each_cpu(show_cpu_stack, NULL, 0, 1);
> +}
> +
> +static struct sysrq_key_op sysrq_show_stacks_op = {
> +	.handler	= sysrq_show_stacks,
> +	.help_msg	= "stacktraces-on-all-cpus(Y)",
> +	.action_msg	= "Stack traces on all cpus",
> +};
> +
>  /* Key Operations table and lock */
>  static DEFINE_SPINLOCK(sysrq_key_table_lock);
>  
> @@ -356,7 +378,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	&sysrq_showstate_blocked_op,	/* w */
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	NULL,				/* x */
> -	NULL,				/* y */
> +	&sysrq_show_stacks_op,		/* y */
>  	NULL				/* z */
>  };
>  

but, but..  sysrq handlers called from hard IRQ.  Are we sure that none of
the drivers which call into the sysrq code do so with hard IRQs disabled?

Because if we call on_each_cpu() with hard IRQs disabled, the various
implementations will emit loud warnings due to the deadlockability.

