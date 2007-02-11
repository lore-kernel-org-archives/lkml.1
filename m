Return-Path: <linux-kernel-owner+w=401wt.eu-S1750900AbXBKViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbXBKViS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXBKViS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:38:18 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50762 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXBKViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:38:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Natalie Protasevich" <protasnb@gmail.com>
Cc: "Zwane Mwaikambo" <zwane@infradead.org>, "Ashok Raj" <ashok.raj@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Andi Kleen" <ak@suse.de>, "Coywolf Qi Hunt" <coywolf@lovecn.org>
Subject: Re: What are the real ioapic rte programming constraints?
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<32209efe0702111212j77f5011xe2430cb13c13686@mail.gmail.com>
Date: Sun, 11 Feb 2007 14:36:47 -0700
In-Reply-To: <32209efe0702111212j77f5011xe2430cb13c13686@mail.gmail.com>
	(Natalie Protasevich's message of "Sun, 11 Feb 2007 12:12:19 -0800")
Message-ID: <m1ejowz89c.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Natalie Protasevich" <protasnb@gmail.com> writes:

> On 2/11/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>     The code currently in the kernel does:
>
>     pending
>     mask
>     read io_apic
>     ack
>     reprogram vector and destination
>     unmask
>
>     So I guess it does retain the bug fix.
>
>     What I am looking at doing is:
>
>     mask
>     read io_apic
>     -- Past this point no more irqs are expected from the io_apic
>     -- Now I work to drain any inflight/pending instances of the irq
>     send ipi to all irq destinations cpus and wait for it to return
>     read lapic
>     disable local irqs
>     take irq lock
>     -- Now no more irqs are expected to arrive
>     reprogram vector and destination
>     enable local irqs
>     unmask
>
>     What I need to ensure is that I have a point where I will not receive any
>     new messages from an ioapic about a particular irq anymore.  Even if
>     everything is working perfectly setting the disable bit is not enough
>     because there could be an irq message in flight. So I need to give any
>     in flight irqs a chance to complete.
>
>
> It is probably safer to have "interlapping" time in having second rte
> programmed, then both willl have the same vector and receive the eoi. And if
> you have interrupts disabled for a little while before you dismantle the old
> entry it should insure that all the in-flight ones got services and acked...
> --Natalie

I am assuming you mean interrupts disabled at the ioapic.  If that
is true mostly I agree with your assertion.

If you look above the mask is where I disable that interrupt source on
the ioapic.  I then send an ipi to all of the other possible cpus and
read the local apic to ensure that the window is over in which I need
to handle interrupts at the old destination. 

If I don't know when the window ends I can never dismantle the data
structures for receiving the irq at the old destination.  Ouch!

If I know how long I have to wait until I can clean up the data
structure at the old destination I don't have to worry about
overlapping interrupts.

Therefore it doesn't by me anything but complexity to setup the data
structures on the new cpu before the window for receiving the irqs
has completed.

Make sense?

Eric



