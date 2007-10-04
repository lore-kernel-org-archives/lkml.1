Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbXJDRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbXJDRET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbXJDREK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:04:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41907 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbXJDREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:04:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Loic Prylli <loic@myri.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in their MSI capability
References: <470405BB.2000208@myri.com>
	<m14ph7amxq.fsf@ebiederm.dsl.xmission.com> <47044565.5070606@myri.com>
	<m1myuzy1i2.fsf@ebiederm.dsl.xmission.com> <4704AEF1.3000206@myri.com>
Date: Thu, 04 Oct 2007 11:03:38 -0600
In-Reply-To: <4704AEF1.3000206@myri.com> (Loic Prylli's message of "Thu, 04
	Oct 2007 05:14:25 -0400")
Message-ID: <m1zlyyvml1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli <loic@myri.com> writes:

I still looking through my copy of the pci specs and so will reply to
that part in a bit.

> To detect a crazy device generating storms of edge interrupts, I guess
> note_interrupt() could be called during this "reentrant detection" if
> masking was made conditional.

Hmm. Something like this?

Only mask it if the irq is disabled, and only disable it if
the user requests it or if note_interrupt decides we are screaming?

void handle_edge_irq(unsigned int irq, struct irq_desc *desc)
{
	const unsigned int cpu = smp_processor_id();

	spin_lock(&desc->lock);

	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);

	/*
	 * If we're currently running this IRQ, or its disabled,
	 * we shouldn't process the IRQ. Mark it pending, handle
	 * the necessary masking and go out
	 */
	if (unlikely((desc->status & IRQ_DISABLED) || !desc->action)){
        	desc->status |= (IRQ_PENDING | IRQ_MASKED);
                mask_ack_irq(desc, irq);
                goto out_unlock;
	}    
	if (unlikely(desc->status & IRQ_INPROGRESS)) {
		desc->status |= IRQ_PENDING;
		desc->chip->ack(desc, irq);
                note_interrupt(irq, desc, IRQ_NONE /* IRQ_DUP? */);
		goto out_unlock;
	}

	kstat_cpu(cpu).irqs[irq]++;

	/* Start handling the irq */
	desc->chip->ack(irq);

	/* Mark the IRQ currently in progress.*/
	desc->status |= IRQ_INPROGRESS;

	do {
		struct irqaction *action = desc->action;
		irqreturn_t action_ret;

		if (unlikely(!action)) {
			desc->chip->mask(irq);
			goto out_unlock;
		}

		desc->status &= ~IRQ_PENDING;
		spin_unlock(&desc->lock);
		action_ret = handle_IRQ_event(irq, action);
		if (!noirqdebug)
			note_interrupt(irq, desc, action_ret);
		spin_lock(&desc->lock);

	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);

	desc->status &= ~IRQ_INPROGRESS;
out_unlock:
	spin_unlock(&desc->lock);
}

Eric
