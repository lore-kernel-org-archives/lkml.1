Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZIANdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZIANdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZIANdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:33:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:14682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZIANdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182785371"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 1 Sep 2009 14:32:01 +0100
Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix
 a race on perf_counter_ctx
Thread-Topic: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
Thread-Index: AcorBD3hWLILadQKTe6RKiCixPXMuQAAQyVg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
 <1251810046.7547.13.camel@twins>
In-Reply-To: <1251810046.7547.13.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Tuesday, September 01, 2009 3:01 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: Re: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix a race on
>perf_counter_ctx
>
>On Tue, 2009-09-01 at 12:17 +0100, Metzger, Markus T wrote:
>
>> My current theory is that the BTS buffer fills up so quickly when tracing
>> the kernel, that the kernel is busy handling overflows and reacting on
>> other interrupts that pile up while we're handling the BTS overflow.
>>
>> When I trace user-mode branches, it works.
>>
>> When I do not copy the trace during overflow handling, the kernel does not hang.
>
>Agreed, that was my suspicion as well. Would you happen to know where to
>get these USB debug port cables, and how to find out if a machine
>supports this?


I'm sorry but I don't understand what you mean with "these USB debug port cables".


>> I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though.
>
>And those pages have to be contiguous too, right? That's an order-6
>alloc, painful.


According to an earlier discussion with Roland, they don't have to.
They still need to be locked, though.
According to some other discussion with Andrew and Ingo, I still use
kmalloc to allocate those buffers.


>> One buffer
>> to switch in during overflow handling; another to switch in during sched_out
>> (assuming that we need to schedule out the traced task before we may start
>> the draining task). Even then, there's a chance that we will lose trace
>> when the draining task may not start immediately. I would even say that
>> this is quite likely.
>
>Right, is it possible to detect this loss?

It is. But in order to get the PERF_EVENT_LOST record into the correct place,
I need to defer logging the lost trace;-)

And we would loose this very nice feature of fixed-size entries.


>This makes me wonder how much time it takes to drain these buffers, it
>is at all possible to optimize that code path into oblivion, or will
>nothing be fast enough?


Are you saying that we should rather speed up that code path than try to
defer all the work? There definitely is a lot of redundant work done on
the generic path.

I did a few experiments where I would drain only parts of the buffer.
I could not drain too much before the system would hang.
Besides, that does not sound too robust to me. Would it sill work on
a slower system? Or on a faster one? Or on a fully loaded one?


>> What I do not have, yet, is the actual draining. Draining needs to start
>> after the counter has been disabled. But draining needs the perf_counter
>> to drain the trace into. The counter will thus be busy after it has been
>> disabled - ugly.
>
>Yes, this is a tad weird...


Hmmm, since the counter is removed during sched_out, and I can't drain the
buffer in x86_pmu_perf_disable(), I'm afraid we don't have much choice.


>> There already seems to be something in place regarding deferring work, i.e.
>> perf_counter_do_pending(). Would it be OK if I added the deferred BTS buffer
>> draining to that?
>
>Yes, note that this pending work runs from hardirq context as well. On
>x86 we self-ipi to get into IRQ context ASAP after the NMI.
>
>So if the remote cpu is blocked waiting on an SMP call, doing the work
>from hardirq context won't really help things.


I can't use that, then.

When I use schedule_work() instead, how would I ensure that the work is done
before the traced (or tracing) task is rescheduled?

I would need to ensure that the counter does not go away as long as draining
work is scheduled. I would store a pointer to the counter in the work struct.
Should perf_counter's be use-counted?


>> Looks like this would guarantee that the counter does not go away as long
>> as there is work pending. Is this correct?
>
>Agreed, it waits for all pending bits to complete before destroying the
>counter.

That would be an alternative to use-counting.


>> In any case, this is getting late for the upcoming merge window.
>> Would you rather drop the BTS patch or disable kernel tracing?
>
>I don't think we need to drop it, at worst we could defer the patch
>to .33, but I think we can indeed get away with disabling the kernel
>tracing for now.

There's some more review feedback from you that I have not integrated, yet.
One is that BTS should return an error instead of falling back to generic
counters.
Another is that BTS does not provide a counter value.

How important are those?


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

