Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZFDXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZFDXQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZFDXQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:16:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40307 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZFDXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:16:16 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       lcm@us.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "active" device IRQ interrruption
References: <20090602193216.GC7282@us.ibm.com>
	<m1prdlttgz.fsf@fess.ebiederm.org> <20090603170617.GB7566@us.ibm.com>
	<m1oct5nhqk.fsf@fess.ebiederm.org> <20090604200437.GA9213@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 04 Jun 2009 16:16:13 -0700
In-Reply-To: <20090604200437.GA9213@us.ibm.com> (Gary Hade's message of "Thu\, 4 Jun 2009 13\:04\:37 -0700")
Message-ID: <m18wk7d1z6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, suresh.b.siddha@intel.com, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> On Wed, Jun 03, 2009 at 02:13:23PM -0700, Eric W. Biederman wrote:
>> Gary Hade <garyhade@us.ibm.com> writes:
>> 
>> > Correct, after the fix was applied my testing did _not_ show
>> > the lockups that you are referring to.  I wonder if there is a
>> > chance that the root cause of those old failures and the root
>> > cause of issue that my fix addresses are the same?
>> >
>> > Can you provide the test case that demonstrated the old failure
>> > cases so I can try it on our systems?  Also, do you recall what
>> > mainline version demonstrated the old failure 
>> 
>> The irq migration has already been moved to interrupt context by the
>> time I started working on it.  And I managed to verify that there were
>> indeed problems with moving it out of interrupt context before my code
>> merged.
>> 
>> So if you want to reproduce it reduce your irq migration to the essentials.
>> Set IRQ_MOVE_PCNTXT, and always migrate the irqs from process context
>> immediately.
>> 
>> Then migrate an irq that fires at a high rate rapidly from one cpu to
>> another.
>> 
>> Right now you are insulated from most of the failures because you still
>> don't have IRQ_MOVE_PCNTXT.  So you are only really testing your new code
>> in the cpu hotunplug path.
>
> OK, I'm confused. 
>
> It sounds like you want me force IRQ_MOVE_PCNTXT so that I can
> test in a configuration that you say is already broken.  Why
> in the heck would this config, where you expect lockups without 
> the fix, be a productive environment in which to test the fix?  

Because that is what the brokenness of fixup_irqs does.  It
effectively forces IRQ_MOVE_PCNTXT on code that has not been written
to deal with it and the failures are because of that forcing.

>> Now that I look at it in more detail you are doing a double
>> mask_IO_APIC_irq and unmask_IO_APIC_irq on the fast path
>
> Good question.  I had based my changes on the previous
> CONFIG_INTR_REMAP IRQ migration delay code that was doing
> the same thing.  I had assumed that the CONFIG_INTR_REMAP
> code was correct and that the nesting of
> mask_IO_APIC_irq_desc/unmask_IO_APIC_irq_desc sequences
> was OK.  Now that I look at how mask_IO_APIC_irq_desc and
> unmask_IO_APIC_irq_desc are implemented I see that there
> is e.g. no reference counting to assure that only the last
> caller of unmask_IO_APIC_irq_desc wins.  This reduces the
> range of code that is executed with the IRQ masked.
>
> Do you see any reason why the IRQ needs to be masked 
> downstream of the unmask_IO_APIC_irq_desc call that the
> patch adds?

No.  However I do see reason why the irq needs to be masked
upstream of where the mask call your patch adds.

>> and duplicating the pending irq check.
>
> Yes, I was aware of this and had considered removing
> the current check but I was trying to minimize the changes
> as much as possible, especially those changes affecting
> the normal IRQ migration path.
>
> Removal of the current check would simplify the code
> and would also eliminate the failed affinity change
> requests from user level that can result from the
> current check.
>
> Do you think it would be a good idea to remove this
> extra check?  If so, I would prefer to do it with a
> separate patch so that I can do a good job of testing it.

Well I tell you what.  

fixup_irqs already has a bunch of heuristics to make the code
mostly work when migrating irqs from process context.

If you can limit your changes to that path I will be sad because
we have not completely fixed the problem.  But at least we
are working on something that has a shot. 

Which means you won't destabilize the existing code.
By modifying it's set_affinity methods.

Something like:

static void fixup_irq_affinity(unsigned int irq, struct irq_desc *desc)
{
	const struct cpumask *affinity;
	int break_affinity = 0;
	int set_affinity = 1;

	/* interrupt's are disabled at this point */
	spin_lock(&desc->lock);

	affinity = desc->affinity;
	if (!irq_has_action(irq) ||
	    cpumask_equal(affinity, cpu_online_mask)) {
		spin_unlock(&desc->lock);
		return;
	}

	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
		break_affinity = 1;
		affinity = cpu_all_mask;
	}

	
        if (desc->status & IRQ_MOVE_PCNTXT) {
		spin_unlock(&desc->lock);
                if (irq_set_affinity(irq, affinity) != 0)
                	set_affinity = 0;
        } else {
		if (desc->chip->mask)
			desc->chip->mask(irq);

		if (desc->chip->set_affinity) {
			/* Any additional weird stabilitiy hacks can go here */
			desc->chip->set_affinity(irq, affinity);
		} else
			set_affinity = 0;

		if (desc->chip->unmask)
			desc->chip->unmask(irq);

		spin_unlock(&desc->lock);
	}
	if (break_affinity && set_affinity)
		printk("Broke affinity for irq %i\n", irq);
	else if (!set_affinity)
		printk("Cannot set affinity for irq %i\n", irq);

	/* Do something equivalent of sending the cleanup ipi here */
}

/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
void fixup_irqs(void)
{
	unsigned int irq;
	struct irq_desc *desc;

	for_each_irq_desc(irq, desc) {
		if (!desc)
			continue;
		if (irq == 2)
			continue;

                fixup_irq_affinity(irq, desc);
	}
}

Eric

