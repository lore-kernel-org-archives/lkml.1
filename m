Return-Path: <linux-kernel-owner+w=401wt.eu-S1422942AbXBHLth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942AbXBHLth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422946AbXBHLth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:49:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38716 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422942AbXBHLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:49:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
Date: Thu, 08 Feb 2007 04:48:50 -0700
In-Reply-To: <20070206222523.GA11602@elte.hu> (Ingo Molnar's message of "Tue,
	6 Feb 2007 23:25:23 +0100")
Message-ID: <m1irecamzh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo would it be reasonable to get a wait queue so I can wait for an 
>> irq that needs the delayed disable action to actually become masked?
>
> that might make sense, but what will do the wakeup - incidental IRQ 
> arriving on the new CPU? Isnt that a bit risky - maybe the device wont 
> generate IRQs for a really long time.

I still need to test this, but I believe I have found a simpler
way to avoid irr problems during migration, and I believe the code
works equally well with either edge or level triggered interrupts.

The idea is this: Instead of trying test for and handle when irr
occurs, simply enable local interrupts after disabling and
acknowledging the irq so that anything pending will be processed,
before we perform the migration operation.

I don't think the edge case cares about the mask/ack order but
but masking before acking appears important for the level triggered
case, so we might as well use that order for both.

Does this look like a sane way to handle this?

static void ack_apic(unsigned int irq)
{
	struct irq_desc *desc = irq_desc + irq;
	int do_unmask_irq = 0;
	if (unlikely((irq_desc[irq].status & IRQ_MOVE_PENDING) && !in_irq()) {
		do_unmask_irq = 1;
		desc->chip->mask(irq);
	}
	ack_APIC_irq();
	if (unlikely(do_unmask_irq)) {
		/* Don't let pending irqs accumulate */
		local_irq_enable();
                syncrhonize_irq(irq);
		move_masked_irq(irq);
		local_irq_disable();
		desc->chip->unmask(irq);
	}
}

Eric
