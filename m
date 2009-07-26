Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZGZTEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZGZTEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 15:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZGZTEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 15:04:15 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43715 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGZTEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 15:04:14 -0400
Date: Sun, 26 Jul 2009 20:03:43 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090726190343.GB12916@shareable.org>
References: <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org> <4A6A96AB.7030609@billgatliff.com> <20090725224848.GA15260@shareable.org> <4A6BC2FC.7020700@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6BC2FC.7020700@billgatliff.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff wrote:
> Jamie Lokier wrote:
> >I agree with communicting the desire explicitly to the scheduler.
> >
> >In the above example, the exact desire is "give me as much CPU as I
> >ask for, because my hardware servicing will be adversely but
> >non-fatally affected if you don't, and the amount of CPU needed to
> >service the hardware cannot be determined in advance, but prevent me
> >from blocking progress in the rest of the system by limiting my
> >exclusive ownership of the CPU".
> >
> >How do you propose to communicate that to the scheduler, if not by
> >something rather like RT-bandwidth with downgrading to SCHED_OTHER
> >when a policy limit is exceeded?
> 
> This is a great real-world problem.  And there's no one-size-fits-all 
> answer, unfortunately.
> 
> RT-bandwidth will give you the system behavior you are after, but it's a 
> pretty blunt instrument.

I'm under the impression that RT-bandwidth will *not* give the above
system behaviour, and that is the whole reason for this thread.

> I'd consider putting some throttling in your interrupt handler that 
> prevents it from running more than a certain amount of calculation per 
> interrupt event.

There is no interrupt handler in my specification above...

> And perhaps it's looking at execution timestamps to 
> determine how often it's running, and can therefore do a rough 
> calculation of how much CPU it's eating.  At least until threaded 
> interrupt scheduling is widespread, a runaway interrupt handler is 
> definitely an opportunity to hang up a system.

With threaded interrupt scheduling using RT priority, that opportunity
to hang the system is exactly the same.

Indeed, threaded interrupts are a good example of when you might want
a limit fraction of the CPU allocated to that thread at RT priority,
falling down to SCHED_OTHER if the handler needs to continue to run.
That is, in fact, how 

> Tasklets

tasklets, bottom halves and things like that work :-)

[snip explanation of tasklets]
> That's often a decent way to deal with system overload, especially if it 
> leaves the system functional enough to take some sort of "evasive 
> action" like reverting to polled i/o, issuing a diagnostic message, or 
> doing an orderly transition to a safe mode.

Polled I/O is good when this happens.  You can revert to polled I/O
automatically without coding it explicitly in interrupt handlers, if
the scheduler provides appropriate support.

When a threaded interrupt (with RT priority, naturally) is run too
often, then you stop scheduling it as RT and bring it down to
SCHED_OTHER or lower, periodically allowing it to have a fair share of
the CPU when there are other runnable tasks.  That's quite close to
polling I/O, without coding it explicitly in the device driver.

So RT-bandwidth would be nice for those threaded interrupts.

-- Jamie
