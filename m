Return-Path: <linux-kernel-owner+w=401wt.eu-S1946156AbXBIGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946156AbXBIGlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 01:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXBIGlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 01:41:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37056 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946156AbXBIGlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 01:41:19 -0500
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
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
Date: Thu, 08 Feb 2007 23:40:29 -0700
In-Reply-To: <m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Thu, 08 Feb 2007 13:19:17 -0700")
Message-ID: <m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The version I would up testing is below, and it doesn't work.
> I still get "No irq handler for vector" warnings as well as
> a couple of complaints from lock/irq debugging.    The debugging
> doesn't worry me.  The fact that I don't have a good way to ensure
> I have no more irqs in flight does.
>
> So unless someone can find a sure way to drain the irqs in flight,
> I can't migrate an irq from process context, and looking at irr and
> handling a pending irq appears required.  '

Bah.  I had not taken into account that the local apic despite
being tightly coupled with the cpu is for programming purposes
an asynchronous device.  If I want to give it time to react to something
I need to read from it.

The routine below actually works. 

My remaining practical question is can this been done cleanly.

Ingo's lock debugging dislikes this routine.  
By using raw_local_irq_enable I have avoided all but a message on
the irq return path, I haven't quite worked out where.

But at least this version feels like it could be done better
(less inline? different helpers?) someone.

For interrupts coming through a sane interrupt controller moving
this into process context would certainly simplify things.  For edge
triggered interrupts coming through an io_apic I'm not at all certain
what makes sense.

When the routine below is used to ack an edge triggered interrupt
it runs before the edge triggered interrupt handler so losing an
edge shouldn't happen (we haven't acknowledged the hardware yet)
and even if we do the device driver gets to run at least once.

So doing migration in the irq handler still looks like the best
solution even if it is ugly.  As long as the little bit of
stack overhead isn't a problem I think enabling interrupts to
clear out any pending irqs certainly looks simpler. 

In another vein.  I went and looked through all of Intel's and
AMD's public errata that I could find and there weren't any associated
with irr or isr, so I think my previous version of the code is still
sane, and not likely to break.

I can improve it a little by getting the vector as:
"vector = ~ get_irq_regs()->orig_rax;" instead of reading
ISR.  That still leaves reading the pending bit in ISR and the
other funny tricks.

I'm conflicted between the two approaches a little because playing
games with enabling interrupts in an interrupt handler seems to
have some weird corner cases.

static void ack_apic(unsigned int irq)
{
#if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
	struct irq_desc *desc;
	desc = irq_desc + irq;
	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
		goto simple;

	if (hardirq_count() != HARDIRQ_OFFSET)
		goto simple;

	desc->chip->mask(irq);
	ack_APIC_irq();

	/* Ensure all of the irq handlers for this irq have completed
	 * before we migrate it.
	 */
	spin_unlock(&desc->lock);
	raw_local_irq_enable();
	apic_read(APIC_ID);
	raw_local_irq_disable();
	spin_lock(&desc->lock);

	move_masked_irq(irq);
	desc->chip->unmask(irq);
	return;
simple:
#endif
	ack_APIC_irq();
}


BUG: at /home/eric/projects/linux/linux-2.6-devel/kernel/lockdep.c:1860 trace_hardirqs_on()

Call Trace:
 <IRQ>  [<ffffffff8048562f>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80290401>] generic_delete_inode+0x0/0x13e
 [<ffffffff8020a0fc>] restore_args+0x0/0x30
 [<ffffffff80290401>] generic_delete_inode+0x0/0x13e
 [<ffffffff8021648d>] ack_apic+0x63/0x99
 [<ffffffff80216485>] ack_apic+0x5b/0x99
 [<ffffffff8025881e>] handle_fasteoi_irq+0xc1/0xd1
 [<ffffffff80290401>] generic_delete_inode+0x0/0x13e
 [<ffffffff8020c0de>] do_IRQ+0x89/0xf3
 [<ffffffff80208ce8>] default_idle+0x35/0x51
 [<ffffffff80208cb3>] default_idle+0x0/0x51
 [<ffffffff8020a0a6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80290401>] generic_delete_inode+0x0/0x13e
 [<ffffffff80208cb3>] default_idle+0x0/0x51
 [<ffffffff80208ce8>] default_idle+0x35/0x51
 [<ffffffff80208cea>] default_idle+0x37/0x51
 [<ffffffff80208ce8>] default_idle+0x35/0x51
 [<ffffffff80208d5a>] cpu_idle+0x56/0x75
 [<ffffffff808b9a69>] start_secondary+0x481/0x490

