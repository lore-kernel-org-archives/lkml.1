Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZGTDwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZGTDwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZGTDwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:52:30 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:48684 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZGTDw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G0DlmuSxp/IDeX/lcURvfeZNMyf72FssF2oYfvI9ut6UmfobsGnapfgeYF3qogg5Ih
         ccyDclueT1hC470Mwep4Y5OdcMYPhJIsF+shkGkZy705pwgw3CsvZhzU8Fn8suzeSo2b
         VVo8oizfsYtXoBYRxuVVu/G0sRAgVlH2fIjRA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907171730070.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
	 <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>
	 <3c17e3570907170758g337703b7l12e1c262d6f385bf@mail.gmail.com>
	 <alpine.LFD.2.00.0907171730070.11571@localhost.localdomain>
Date: Mon, 20 Jul 2009 11:52:28 +0800
Message-ID: <3c17e3570907192052n4cac97b9s64c9246af2809258@mail.gmail.com>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
From: Barry Song <21cnbao@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another question, is it possible the irq thread run from a different
CPU with the hardirq?  If so, even in your patch, the
desc->thread_eoi(action->irq, desc) run on another CPU, maybe it can't
unmask the original CPU interrupt. Then the device will not work
later.


2009/7/18 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 17 Jul 2009, Barry Song wrote:
>> 2009/7/17 Thomas Gleixner <tglx@linutronix.de>:
>> > The correct thing to do is disabling it at the device level if you
>> > need to prevent interrupt storms.
>>
>> For some devices which use level trigger and  buses like spi, i2c.
>> Checking the interrupt source and clear IRQ probably need to
>> read/write the registers of devices by i2c,spi. But i2c, spi access
>> maybe causes schedule based on their driver framework. So the checking
>> operation and clear operation can only be done in process switch. So
>> the only way to avoid interrupt storms is disabling the irq line at
>> hardirq, after clearing irq in the bottom-half by work-queue or
>> thread, then enable it again.
>> For example, a spi touchscreen is touched, then it gives a high level
>> in a GPIO irq line to CPU. CPU enter hardirq, but to clear the high
>> level, it must write the touchscreen by spi, how could it avoid the
>> interrupt storms betweem hardirq and bottom-half if it doesn't disable
>> the irq line since it can't write the spi in hardirq?
>
> Sigh, I probably don't need to understand why hardware designers come
> up with such crap. Using a level triggered interrupt for a device
> which cannot be shut up in the hard interrupt routine is simply
> moronic. But yeah, we have to live with that. :(
>
> Removing the disabled check to fix that stupidity and replacing it by
> a complex accounting mechanism is not an option.
>
> The patently untested patch below should solve your problem without
> adding horrible complexity.
>
> I think that's a straight forward solution to the problem and reflects
> the semantics of your use case very clearly while it does not touch
> the disabled logic. You really do not want to disable the interrupt,
> you want to keep it masked until you can unmask it again. That makes a
> huge difference.
>
> All you need to do is to set the irq flow handler of your GPIO pin to
> handle_level_oneshot_irq and the generic code will take care of it.
>
> Thanks,
>
>        tglx
> ------
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index cb2e77a..5f22436 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -194,6 +194,8 @@ struct irq_desc {
>  #endif
>        atomic_t                threads_active;
>        wait_queue_head_t       wait_for_threads;
> +       void                    (*thread_eoi)(unsigned int irq,
> +                                             struct irq_desc *desc);
>  #ifdef CONFIG_PROC_FS
>        struct proc_dir_entry   *dir;
>  #endif
> @@ -284,6 +286,7 @@ extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
>  * callable via desc->chip->handle_irq()
>  */
>  extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
> +extern void handle_level_oneshot_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 13c68e7..2aa072c 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -341,27 +341,15 @@ out_unlock:
>        spin_unlock(&desc->lock);
>  }
>
> -/**
> - *     handle_level_irq - Level type irq handler
> - *     @irq:   the interrupt number
> - *     @desc:  the interrupt description structure for this irq
> - *
> - *     Level type interrupts are active as long as the hardware line has
> - *     the active level. This may require to mask the interrupt and unmask
> - *     it after the associated handler has acknowledged the device, so the
> - *     interrupt line is back to inactive.
> - */
> -void
> -handle_level_irq(unsigned int irq, struct irq_desc *desc)
> +static void __handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  {
>        struct irqaction *action;
>        irqreturn_t action_ret;
>
> -       spin_lock(&desc->lock);
>        mask_ack_irq(desc, irq);
>
>        if (unlikely(desc->status & IRQ_INPROGRESS))
> -               goto out_unlock;
> +               return;
>        desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
>        kstat_incr_irqs_this_cpu(irq, desc);
>
> @@ -371,7 +359,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
>         */
>        action = desc->action;
>        if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> -               goto out_unlock;
> +               return;
>
>        desc->status |= IRQ_INPROGRESS;
>        spin_unlock(&desc->lock);
> @@ -382,14 +370,69 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
>
>        spin_lock(&desc->lock);
>        desc->status &= ~IRQ_INPROGRESS;
> +}
> +
> +/**
> + *     handle_level_irq - Level type irq handler
> + *     @irq:   the interrupt number
> + *     @desc:  the interrupt description structure for this irq
> + *
> + *     Level type interrupts are active as long as the hardware line has
> + *     the active level. This may require to mask the interrupt and unmask
> + *     it after the associated handler has acknowledged the device, so the
> + *     interrupt line is back to inactive.
> + */
> +void
> +handle_level_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +       spin_lock(&desc->lock);
> +       __handle_level_irq(irq, desc);
>        if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
>                desc->chip->unmask(irq);
> -out_unlock:
>        spin_unlock(&desc->lock);
>  }
>  EXPORT_SYMBOL_GPL(handle_level_irq);
>
>  /**
> + *     handle_level_oneshot_irq - Level type oneshot irq handler
> + *     @irq:   the interrupt number
> + *     @desc:  the interrupt description structure for this irq
> + *
> + *     Level type interrupts are active as long as the hardware line has
> + *     the active level. This may require to mask the interrupt and unmask
> + *     it after the associated handler has acknowledged the device, so the
> + *     interrupt line is back to inactive. The oneshot variant keeps the
> + *     interrupt masked on return. This allows to use it with devices
> + *     where the interrupt can not be disabled or acknowledged on the
> + *     device level in the hard interrupt context (device is on i2c, spi..)
> + *     The unmask is done when the threaded interrupt has processed the
> + *     interrupt.
> + */
> +void
> +handle_level_oneshot_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +       spin_lock(&desc->lock);
> +       __handle_level_irq(irq, desc);
> +       desc->status |= IRQ_MASKED;
> +       spin_unlock(&desc->lock);
> +}
> +EXPORT_SYMBOL_GPL(handle_level_oneshot_irq);
> +
> +/*
> + * One shot mode handlers do not unmask the irq line in the hard
> + * interrupt context. Unmask when the handler has finished.
> + */
> +static void unmask_oneshot_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +       spin_lock_irq(&desc->lock);
> +       if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
> +               desc->status &= ~IRQ_MASKED;
> +               desc->chip->unmask(irq);
> +       }
> +       spin_unlock_irq(&desc->lock);
> +}
> +
> +/**
>  *     handle_fasteoi_irq - irq handler for transparent controllers
>  *     @irq:   the interrupt number
>  *     @desc:  the interrupt description structure for this irq
> @@ -584,6 +627,9 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
>        desc->handle_irq = handle;
>        desc->name = name;
>
> +       if (handle == handle_level_oneshot_irq)
> +               desc->thread_eoi = unmask_oneshot_irq;
> +
>        if (handle != handle_bad_irq && is_chained) {
>                desc->status &= ~IRQ_DISABLED;
>                desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 50da676..d0115d4 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -475,6 +475,8 @@ static int irq_thread(void *data)
>                        spin_unlock_irq(&desc->lock);
>
>                        action->thread_fn(action->irq, action->dev_id);
> +                       if (desc->thread_eoi)
> +                               desc->thread_eoi(action->irq, desc);
>                }
>
>                wake = atomic_dec_and_test(&desc->threads_active);
>
