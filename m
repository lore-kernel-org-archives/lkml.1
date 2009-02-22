Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZBVWmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZBVWmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZBVWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:42:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbZBVWmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:42:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Sun, 22 Feb 2009 23:42:07 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902221839.50357.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902222342.08285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 February 2009, Linus Torvalds wrote:
> 
> On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Use these functions to rework the handling of interrupts during
> > suspend (hibernation) and resume.  Namely, interrupts will only be
> > disabled on the CPU right before suspending sysdevs, while device
> > interrupts will be disabled (at the IO-APIC level), with the help of
> > the new helper function, before calling "late" suspend callbacks
> > provided by device drivers and analogously during resume.
> 
> I think this patch is actually a bit too complicated.
> 
> > +struct disabled_irq {
> > +	struct list_head list;
> > +	int irq;
> > +};
> > +
> > +static LIST_HEAD(resume_irqs_list);
> > +
> > +/**
> > + *	enable_device_irqs - enable interrupts disabled by disable_device_irqs()
> > + *
> > + *	Enable all interrupt lines previously disabled by disable_device_irqs()
> > + *	that are on resume_irqs_list.
> > + */
> > +void enable_device_irqs(void)
> > +{
> > +	struct disabled_irq *resume_irq, *tmp;
> > +
> > +	list_for_each_entry_safe(resume_irq, tmp, &resume_irqs_list, list) {
> > +		enable_irq(resume_irq->irq);
> > +		list_del(&resume_irq->list);
> > +		kfree(resume_irq);
> > +	}
> > +}
> 
> Don't do this whole separate list. Instead, just add a per-irq-descriptor 
> flag to the desc->status field that says "suspended". IOW, just do 
> something like

OK

> 	diff --git a/include/linux/irq.h b/include/linux/irq.h
> 	index f899b50..7bc2a31 100644
> 	--- a/include/linux/irq.h
> 	+++ b/include/linux/irq.h
> 	@@ -65,6 +65,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
> 	 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
> 	 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
> 	 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
> 	+#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
> 	 
> 	 #ifdef CONFIG_IRQ_PER_CPU
> 	 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
> 
> and then just make the suspend sequence do
> 
> 	for_each_irq_desc(irq, desc) {
> 		.. check desc if we should disable it ..
> 		disable_irq(irq);
> 		desc->status |= IRQ_SUSPENDED;
> 	}
> 
> and the resume sequence do
> 
> 	for_each_irq_desc(irq, desc) {
> 		if (!(desc->status & IRQ_SUSPENDED))
> 			continue;
> 		desc->status &= ~IRQ_SUSPENDED;
> 		enabled_irq(irq);
> 	}
> 
> And that simplifcation then gets rid of
> 
> > +/**
> > + *	disable_device_irqs - disable all enabled interrupt lines
> > + *
> > + *	During system-wide suspend or hibernation device interrupts need to be
> > + *	disabled at the chip level and this function is provided for this
> > + *	purpose.  It disables all interrupt lines that are enabled at the
> > + *	moment and saves their numbers for enable_device_irqs().
> > + */
> > +int disable_device_irqs(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +		struct disabled_irq *resume_irq;
> > +		struct irqaction *action;
> > +		bool is_timer_irq;
> > +
> > +		resume_irq = kzalloc(sizeof(*resume_irq), GFP_NOIO);
> > +		if (!resume_irq) {
> > +			enable_device_irqs();
> > +			return -ENOMEM;
> > +		}
> 
> this just goes away.
> 
> > +		is_timer_irq = false;
> > +		action = desc->action;
> > +		while (action) {
> > +			if (action->flags | IRQF_TIMER) {
> > +				is_timer_irq = true;
> > +				break;
> > +			}
> > +			action = action->next;
> > +		}
> 
> This is also pointless and wrong (and buggy). You should use '&' to 
> test that flag, not '|',

Ouch, sorry.

> but more importantly, if you share interrupts with a timer irq, there's
> nothing sane the irq layer can do ANYWAY, so just ignore the whole problem.
> Just look at the first one, don't try to be clever, because your clever code
> doesn't buy anything at all. 
> 
> So get rid of the loop, and just do
> 
> 	if (desc->action && !(desc->action->flags & IRQF_TIMER)) {
> 		desc->depth++;
> 		desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
> 		desc->chip->disable(irq);
> 	}
> 	spin_unlock_irqrestore(&desc->lock, flags);
> 
> and you're done.

OK

> Also, I'd actually suggest that the whole "synchronize_irq()" be handled 
> in a separate loop after the main one, so make that one just be
> 
> 	for_each_irq_desc(irq, desc) {
> 		if (desc->status & IRQ_SUSPENDED)
> 			serialize_irq(irq);
> 	}
> 
> at the end. No need for desc->lock, since the IRQ_SUSPENDED bit is stable.	

OK

> Finally:
> 
> > +extern int disable_device_irqs(void);
> > +extern void enable_device_irqs(void);
> 
> I think the naming is not great. It's not about disable/enable, it's very 
> much about suspend/resume. In your version, it had that global 
> "disabled_irq" list, and in mine it has that IRQ_SUSPENDED bit - and in 
> both cases you can't nest things, and you can't consider them in any way 
> "generic" enable/disable things, they are very specialized "shut up 
> everything but the timer irq".

OK, would 

extern void suspend_device_irqs(void);
extern void resume_device_irqs(void);

be better?

> I also don't think there is any reasonable error case, so just make the 
> "suspend" thing return 'void', and don't complicate the caller. We don't 
> error out on the simple "disable_irq()" either. It's a imperative 
> statement, not a "please can you try to do that" thing.

The error is there just because the memory allocation can fail.  With the
IRQ_SUSPENDED flag as per your suggestion it won't be necessary any more.

Thanks a lot for your comments, I'll send an updated patch shortly.

Rafael
