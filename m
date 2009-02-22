Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZBVSCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZBVSCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZBVSCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:02:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbZBVSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:02:32 -0500
Date: Sun, 22 Feb 2009 10:01:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <200902221839.50357.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902221839.50357.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> 
> Use these functions to rework the handling of interrupts during
> suspend (hibernation) and resume.  Namely, interrupts will only be
> disabled on the CPU right before suspending sysdevs, while device
> interrupts will be disabled (at the IO-APIC level), with the help of
> the new helper function, before calling "late" suspend callbacks
> provided by device drivers and analogously during resume.

I think this patch is actually a bit too complicated.

> +struct disabled_irq {
> +	struct list_head list;
> +	int irq;
> +};
> +
> +static LIST_HEAD(resume_irqs_list);
> +
> +/**
> + *	enable_device_irqs - enable interrupts disabled by disable_device_irqs()
> + *
> + *	Enable all interrupt lines previously disabled by disable_device_irqs()
> + *	that are on resume_irqs_list.
> + */
> +void enable_device_irqs(void)
> +{
> +	struct disabled_irq *resume_irq, *tmp;
> +
> +	list_for_each_entry_safe(resume_irq, tmp, &resume_irqs_list, list) {
> +		enable_irq(resume_irq->irq);
> +		list_del(&resume_irq->list);
> +		kfree(resume_irq);
> +	}
> +}

Don't do this whole separate list. Instead, just add a per-irq-descriptor 
flag to the desc->status field that says "suspended". IOW, just do 
something like

	diff --git a/include/linux/irq.h b/include/linux/irq.h
	index f899b50..7bc2a31 100644
	--- a/include/linux/irq.h
	+++ b/include/linux/irq.h
	@@ -65,6 +65,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
	 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
	 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
	 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
	+#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
	 
	 #ifdef CONFIG_IRQ_PER_CPU
	 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)

and then just make the suspend sequence do

	for_each_irq_desc(irq, desc) {
		.. check desc if we should disable it ..
		disable_irq(irq);
		desc->status |= IRQ_SUSPENDED;
	}

and the resume sequence do

	for_each_irq_desc(irq, desc) {
		if (!(desc->status & IRQ_SUSPENDED))
			continue;
		desc->status &= ~IRQ_SUSPENDED;
		enabled_irq(irq);
	}

And that simplifcation then gets rid of

> +/**
> + *	disable_device_irqs - disable all enabled interrupt lines
> + *
> + *	During system-wide suspend or hibernation device interrupts need to be
> + *	disabled at the chip level and this function is provided for this
> + *	purpose.  It disables all interrupt lines that are enabled at the
> + *	moment and saves their numbers for enable_device_irqs().
> + */
> +int disable_device_irqs(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		unsigned long flags;
> +		struct disabled_irq *resume_irq;
> +		struct irqaction *action;
> +		bool is_timer_irq;
> +
> +		resume_irq = kzalloc(sizeof(*resume_irq), GFP_NOIO);
> +		if (!resume_irq) {
> +			enable_device_irqs();
> +			return -ENOMEM;
> +		}

this just goes away.

> +		is_timer_irq = false;
> +		action = desc->action;
> +		while (action) {
> +			if (action->flags | IRQF_TIMER) {
> +				is_timer_irq = true;
> +				break;
> +			}
> +			action = action->next;
> +		}

This is also pointless and wrong (and buggy). You should use '&' to 
test that flag, not '|', but more importantly, if you share interrupts 
with a timer irq, there's nothing sane the irq layer can do ANYWAY, so 
just ignore the whole problem. Just look at the first one, don't try to be 
clever, because your clever code doesn't buy anything at all. 

So get rid of the loop, and just do

	if (desc->action && !(desc->action->flags & IRQF_TIMER)) {
		desc->depth++;
		desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
		desc->chip->disable(irq);
	}
	spin_unlock_irqrestore(&desc->lock, flags);

and you're done.

Also, I'd actually suggest that the whole "synchronize_irq()" be handled 
in a separate loop after the main one, so make that one just be

	for_each_irq_desc(irq, desc) {
		if (desc->status & IRQ_SUSPENDED)
			serialize_irq(irq);
	}

at the end. No need for desc->lock, since the IRQ_SUSPENDED bit is stable.	

Finally:

> +extern int disable_device_irqs(void);
> +extern void enable_device_irqs(void);

I think the naming is not great. It's not about disable/enable, it's very 
much about suspend/resume. In your version, it had that global 
"disabled_irq" list, and in mine it has that IRQ_SUSPENDED bit - and in 
both cases you can't nest things, and you can't consider them in any way 
"generic" enable/disable things, they are very specialized "shut up 
everything but the timer irq".

I also don't think there is any reasonable error case, so just make the 
"suspend" thing return 'void', and don't complicate the caller. We don't 
error out on the simple "disable_irq()" either. It's a imperative 
statement, not a "please can you try to do that" thing.

			Linus
