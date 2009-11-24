Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbZKXRld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbZKXRld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933661AbZKXRlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:41:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54732 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbZKXRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:41:32 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20091120211139.GB19106@sgi.com>
	<m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	<alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	<1259069986.4531.1453.camel@laptop>
	<alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	<20091124065022.6933be1a@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Nov 2009 09:41:18 -0800
In-Reply-To: <20091124065022.6933be1a@infradead.org> (Arjan van de Ven's message of "Tue\, 24 Nov 2009 06\:50\:22 -0800")
Message-ID: <m1ws1f6csh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Tue, 24 Nov 2009 14:55:15 +0100 (CET)
>> > Furthermore, the /sysfs topology information should include IRQ
>> > routing data in this case.
>> 
>> Hmm, not sure about that. You'd need to scan through all the nodes to
>> find the set of CPUs where an irq can be routed to. I prefer to have
>> the information exposed by the irq enumeration (which is currently in
>> /proc/irq though).
>
> yes please.
>
> one device can have multiple irqs
> one irq can be servicing multiple devices
>
> expressing that in sysfs is a nightmare, while
> sticking it in /proc/irq *where the rest of the info is* is
> much nicer for apps like irqbalance

Oii.

I don't think it is bad to export information to applications like irqbalance.

I think it pretty horrible that one of the standard ways I have heard
to improve performance on 10G nics is to kill irqbalance.

Guys.  Migrating an irq from one cpu to another while the device is
running without dropping interrupts is hard.

At the point we start talking about limiting what a process with
CAP_SYS_ADMIN can do because it makes bad decisions I think something
is really broken.

Currently the irq code treats /proc/irq/N/smp_affinity as a strong hint
on where we would like interrupts to be delivered, and we don't have good
feedback from there to architecture specific code that knows what we really
can do.  It is going to take some effort and some work to make that happen.

I think the irq scheduler is the only scheduler (except for batch jobs) that we
don't put in the kernel.  It seems to me that if we are going to go to all of the
trouble to rewrite the generic code to better support irqbalance because we
are having serious irqbalance problems, it will be less effort to suck irqbalance
into the kernel along with everything else.

I really think irqbalancing belongs in the kernel.  It is hard to
export all of the information we need to user space and the
information that we need to export keeps changing.  Until we master
this new trend of exponentially increasing core counts that
information is going to keep changing.  Today we barely know how to balance
flows across cpus.  So because of the huge communication problem and
the fact that there appears to be no benefit in keeping irqbalance in
user space (there is no config file) if we are going to rework all of the
interfaces let's pull irqbalance into the kernel.


As for the UV code, what we are looking at is a fundamental irq
routing property.  Those irqs cannot be routed to some cpus.  That is
something the code that sets up the routes needs to be aware of.
Dimitri could you put your the extra code in assign_irq_vector instead
of in the callers of assign_irq_vector?  Since the probably is not
likely to stay unique we probably want to put the information you base
things on in struct irq_desc, but the logic I seems to live best in
in assign_irq_vector.

Eric
