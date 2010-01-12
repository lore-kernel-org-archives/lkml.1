Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271Ab0ALBwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0ALBwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264Ab0ALBwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:52:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43794 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0ALBwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:52:39 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
	<4B4BB0B7.3000106@zytor.com>
	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>
	<4B4BBEBA.4060403@zytor.com> <m17hro6ua9.fsf@fess.ebiederm.org>
	<4B4BC401.6010605@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 17:52:30 -0800
In-Reply-To: <4B4BC401.6010605@zytor.com> (H. Peter Anvin's message of "Mon\, 11 Jan 2010 16\:36\:17 -0800")
Message-ID: <m1k4vo144h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/11/2010 04:28 PM, Eric W. Biederman wrote:
>> 
>> Sorry.  I suck at multitasking.
>> 
>> Without changes assign_irq_vector will reuse vectors in the range
>> IRQ0_VECTOR to IRQ15_VECTOR in the code as it we currently ship it,
>> when we switch irq0-15 into ioapic mode.
>> 
>> Switching the loop to cover IRQ0_VECTOR to IRQ15_VECTOR is not a
>> problem.  I don't think it will find anything free as we assign those
>> vectors on all cpus, but the data structures are fine.
>> 
>> I am uncomfortable with the suggestion of sharing the priority of the
>> IRQ_MOVE_CLEANUP_VECTOR with other interrupts.  I know if it had be
>> clear from the documentation that it was safe to share the irq level
>> with other interrupts I would not have reserved the entire interrupt
>> level for the IRQ_MOVE_CLEANUP_VECTOR.
>> 
>
> What are the properties that you're looking for, and in what
> documentation?  We reviewed the Software Development Manual here at
> Intel, and it rather explicitly states:
>
> "Each interrupt priority level (sometimes interpreted by software as an
> interrupt priority class) encompasses 16 vectors. Prioritizing
> interrupts within a priority level is determined by the vector number.
> The higher the vector number, the higher the priority within that
> priority level.  In determining the priority of a vector and ranking
> of vectors within a priority group, the vector number is often divided
> into two parts, with the high 4 bits of the vector indicating its
> priority and the low 4 bit indicating its ranking within the priority
> group."
>
> [Intel® 64 and IA-32 Architectures Software Developer’s Manual
> Volume 3A: System Programming Guide, Part 1; September 2009, Order
> Number 253668-032US; section 10.9.3, page 10-57f.]
>
> So 0x20 is the lowest-priority vector within priority group 0x2.

After having the documentation quoted at me.  I am having a distinct
memory of one piece of documentation saying:
"interrupts within a priority level can be delivered in any order"

So I am guessing there is not any ordering of interrupts in the same
priority level until they get to the local apic.

What guarantee we need is the interesting question.

The cleanup ipi is sent when we have seen an interrupt arrive at it's
newly configured location.  It is possible that there is still an
interrupt in flight to the old configured location (think NUMA where
the interrupt has been migrated from off node to on node).  We want
the guarantee that the ipi arrives after the inflight irq.  Which
means on the wire ordering as well as in the local apic ordering is
interesting.

I am slammed with other stuff right now so I don't think I will have
time to find the old documentation I was looking at for a couple of
more days.

Eric
