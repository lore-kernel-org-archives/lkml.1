Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYLUSW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYLUSW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYLUSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:22:51 -0500
Received: from www.tglx.de ([62.245.132.106]:38246 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYLUSWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:22:50 -0500
Date: Sun, 21 Dec 2008 19:22:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v5] SGI RTC: add generic timer system interrupt
In-Reply-To: <20081219160919.GA18226@sgi.com>
Message-ID: <alpine.LFD.2.00.0812211915410.4548@localhost.localdomain>
References: <20081219160751.GA18071@sgi.com> <20081219160919.GA18226@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Dimitri Sivanich wrote:
> This patch allocates a system interrupt vector for platform specific use
> in implementing timer interrupts.

Why is this restricted to timer interrupts. That's simply a dynamic
allocation of an interrupt vector.
 
> +
> +/* Function pointer for generic timer interrupt handling */
> +static void (*generic_timer_interrupt_extension)(void);
> +
> +int
> +register_generic_timer_extension(void (*fn)(void))

One line. All over the place.

> +{
> +	if (generic_timer_interrupt_extension)
> +		return 1;

  -EBUSY perhaps ?

> +	generic_timer_interrupt_extension = fn;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_generic_timer_extension);
> +
> +void
> +unregister_generic_timer_extension(void)
> +{
> +	if (generic_timer_interrupt_extension)
> +		generic_timer_interrupt_extension = NULL;
> +}
> +EXPORT_SYMBOL_GPL(unregister_generic_timer_extension);
> +
> +void smp_generic_timer_interrupt(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	ack_APIC_irq();
> +
> +	exit_idle();
> +
> +	irq_enter();
> +
> +	if (generic_timer_interrupt_extension)
> +		generic_timer_interrupt_extension();

  interrupt statistics are missing. 

> +	irq_exit();
> +
> +	set_irq_regs(old_regs);
> +}
> +

Thanks,

	tglx
