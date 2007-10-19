Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbXJSSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbXJSSis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbXJSSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:38:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49081 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763060AbXJSSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:38:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
References: <20071019075443.GA6407@havoc.gtf.org>
	<alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain>
Date: Fri, 19 Oct 2007 12:38:12 -0600
In-Reply-To: <alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain>
	(Thomas Gleixner's message of "Fri, 19 Oct 2007 16:53:22 +0200
	(CEST)")
Message-ID: <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Fri, 19 Oct 2007, Jeff Garzik wrote:
>> 
>> WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE
>> 
>> This posting is just to demonstrate something that I have been keeping
>> alive in the background.  I have no urge to push it upstream anytime
>> soon.
>> 
>> The overwhelming majority of drivers do not ever bother with the 'irq'
>> argument that is passed to each driver's irq handler.
>> 
>> Of the minority of drivers that do use the arg, the majority of those
>> have the irq number stored in their private-info structure somewhere.
>> 
>> There are a tiny few -- a couple Mac drivers -- which do weird things
>> with that argument, but that's it.
>
> Jeff,
>
> thanks for doing this.

Yes.  keeping this alive is good.

The practical question is how do we make this change without breaking
the drivers that use their irq argument.

> Full ACK.
>
> We should do this right at the edge of -rc1. And let's do this right
> now in .24 and not drag it out for no good reason.

There are two problems with that suggestion.
- We don't have all of the architectures converted.
- We don't have a solid plan for how to keep drivers that are
  using the irq parameter today working.

I don't think the irq argument is something we want to keep
around forever, and I certainly don't see the need to do
the error prone get_irqfunc_irq and set_irqfunc_irq logic.

How about:

irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
{
	irqreturn_t ret, retval = IRQ_NONE;
	unsigned int status = 0;

	handle_dynamic_tick(action);

	if (!(action->flags & IRQF_DISABLED))
		local_irq_enable_in_hardirq();

	do {
		if (action->flags & IRQF_VERBOSE)
			ret = action->handler_verbose(irq, action->dev_id);
		else
                	ret = action->handler(action->dev_id);
		if (ret == IRQ_HANDLED)
			status |= action->flags;
		retval |= ret;
		action = action->next;
	} while (action);

	if (status & IRQF_SAMPLE_RANDOM)
		add_interrupt_randomness(irq);
	local_irq_disable();

	return retval;
}

And then:

typedef irqreturn_t (*irq_handler_verbose_t)(int, void *);
typedef irqreturn_t (*irq_handler_t)(void *);

struct irqaction {
	union {
		irq_handler_verbose_t handler_verbose;
		irq_handler_t handler;
        };
	unsigned long flags;
	cpumask_t mask;
	const char *name;
	void *dev_id;
	struct irqaction *next;
	int irq;
	struct proc_dir_entry *dir;
};

int request_irq(unsigned int irq, irq_handler_t handler,
		unsigned long irqflags, const char *devname, void *dev_id)

int request_verbose_irq(unsigned int irq, irq_handler_verbose_t handler,
		unsigned long irqflags, const char *devname, void *dev_id)

Then we just need to go through all of the drivers and either change
their interrupt handler prototype or change the flavor of request_irq.

It is a bit of a pain but we should be able to do that without breaking
any drivers.  Which it looks like we are in real danger of if someone
goes through them all interrupt handlers that are using the irq
argument and change them all at once.  Especially since most of those
drivers are old an rarely used right now.

Eric
