Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYDXGAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYDXGAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYDXF75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:59:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42983 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYDXF7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:59:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
Date: Wed, 23 Apr 2008 22:59:39 -0700
In-Reply-To: <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 23 Apr 2008 19:19:52 -0700 (PDT)")
Message-ID: <m1od7zkd2s.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git patch] free_irq() fixes
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 23 Apr 2008, Jeff Garzik wrote:
>> 
>> When drivers make assumptions about system irq numbering, particularly on x86,
>> IMO the situation is fragile.
>
> And when people make changes to long-standing and stable infrastructure, 
> the situation also gets fragile.
>
> The fact is, stability of interfaces is a really worthy goal in itself. 
> Making a change for its own sake is not a good thing. This fixes 
> *nothing*, and the driver changes I objected to I objected to because they 
> were ugly as sin.
>
> And I want to point out that your patches made it *much* uglier.
>
> So "cleanup" it sure as hell wasn't. That irq number may not be worth all 
> that much in itself, but it has no subtle implementation problems (we 
> _need_ that irq number for registration and irq handler lookup anyway, so 
> it is meaningful from a driver perspective, and is well-defined from a irq 
> core standpoint as well).
>
> I don't mind cleanups, but this is "churn". Change for its own sake. If it 
> doesn't lead to any _improvement_, it's pointless.
>
> If drivers don't need it, let them ignore it. But let them ignore it in 
> ways that work across versions, and in ways that don't cause ridiculous 
> and ugly work-arounds for when they do want it (even if it's just for a 
> printk() or similar).

I haven't looked at what Jeff's patches in particular so I can not
comment there.  I do remember looking at the drivers in question and
yes there were indeed bugs with the handful of drivers that used
the irq parameter.  So fixing and cleaning up those drivers so they
use the same idioms as the rest of the kernel should be a maintenance
win.  Even if we do keep the irq parameter to the interrupt handler.

I can comment on where there seems to be a real need for change.
The hard coded NR_IRQS parameter and the arrays of size NR_IRQS are a
kernel scaling bottle neck.  They prevents us from building one kernel
that works well on a large ranges of machines sizes.  Having a single
array prevents us from allocating the irq structures with NUMA
affinity which slows down irq processing.  Having a small number for
NR_IRQS to keep the table compact keeps the irq number from being
readable/useful in the case of MSI and occasionally in the case of
IO_APICs.


...
Since there does seem to be a real win it is my intention to kill all
arrays of NR_IRQs size in the generic code.  I did a quick search for
[NR_IRQS] and have only found about 7 of them.

Then modify the genirq code to allow architectures to provide an
alternative to todays irq_desc array.

To export the struct irq_desc to the rest of the kernel generically as
a struct irq, with a new API irq_request,irq_free etc.

To build the existing API on top of the new API with a potentially
slow function that maps an irq number to the struct irq. Irq actions
are not fast path so we should be ok with even if we do a linear walk
through the set of irqs.

After that I will see about removing irq number references from 
the bulk of kernel drivers.  Essentially transferring the drivers to
the new API in some stepwise fashion.  Which is where I see synergy
with Jeff's effort.

For old ISA drivers the irq number has real meaning and I don't
intend to loose that, and I don't fundamentally intend to loose
the irq number, instead  reserving it for talking to users.  Which
will allow us to use a stable mapping for MSI irqs where we simply
do not have enough bits below NR_IRQS today.

My goal is for an API upgrade that is a slight variation of todays
API that will be stable into the future as machines grow larger
and larger and we get more and more irq sources.  I believe the trend
line is for the number of irqs in a machine to grow linearly with
the number of cores, which means I expect them to start going
exponential.  Not having an integer which can and has been abused
in some hideous ways but instead a structure pointer is likely to keep
things more robust into the future.

Eric
