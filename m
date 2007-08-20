Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXHTRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXHTRA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbXHTRAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:00:17 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:36068 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXHTRAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:00:15 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070820154529.GA300@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708141037.48001.borntraeger@de.ibm.com>  <20070820154529.GA300@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 20 Aug 2007 19:03:58 +0200
Message-Id: <1187629438.8541.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 17:45 +0200, Ingo Molnar wrote: 
> * Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > 1. Jan could finish his sched_clock implementation for s390 and we 
> > would get close to the precise numbers. This would also let CFS make 
> > better decisions. [...]
> 
> i think this is the best option and it should give us the same /proc 
> accuracy on s390 as before, plus improved scheduler precision. (and 
> improved tracing accuracy, etc. etc.) Note that for architectures that 
> already have sched_clock() at least as precise as the stime/utime stats 
> there's no problem - and that seems to include all architectures except 
> s390.

For far we have used the TOD clock for sched_clock. This clocks measures
real time with an accuracy of 1usec or better. The [us]time accounting
with CONFIG_VIRT_CPU_ACCOUNTING=y is done using the CPU timer. This
timer measures virtual time with an accuracy of 1usec of better. Without
CONFIG_VIRT_CPU_ACCOUNTING the [us]time accounting is done with HZ
ticks. Which means that sched_clock() is at least as precise as [us]time
on s390 as well, only that we distinguish between real time / virtual
time if the improved accounting is used.

> could you send that precise sched_clock() patch? It should be an order 
> of magnitude simpler than the high-precision stime/utime tracking you 
> already do, and it's needed for quality scheduling anyway.

Sure if you can explain what it should do. This is still unclear to me,
for a non-idle CPU the virtual cpu time should be used but for an idle
CPU the real time should be used ? That seems rather ill-defined to me.
On s390 we have three times to consider, real time, virtual cpu time and
steal time. For a given period we have real = virtual + steal. And if a
cpu is idle we have real = steal, virtual = 0. My best interpretation of
what you want is that sched_clock should progress with virtual cpu time
if the current process is not idle and with the real time if it is. No ?

> > [...] Downside: its not as precise as before as we do some math on the 
> > numbers and it will burn cycles to compute numbers we already have 
> > (utime=sum*utime/stime).
> 
> i can see no real downside to it: if all of stime, utime and 
> sum_exec_clock are precise, then the numbers we present via /proc are 
> precise too:
> 
>    sum_exec * utime / stime;
> 
> there should be no loss of precision on s390 because the 
> multiplication/division rounding is not accumulating - we keep the 
> precise sum_exec, utime and stime values untouched.

But then sched_clock() has to return the virtual cpu time only,
otherwise it will be hard to make sum_exec exact, wouldn't it?
And why should we jump through all these loops to come up with values
that are only as good as the values we already have?

> on x86 we dont really want to slow down every irq and syscall event with 
> precise stime/utime stats for 'top' to display. On s390 the 
> multiplication and division is indeed superfluous but it keeps the code 
> generic for arches where utime/stime is less precise and irq-sampled - 
> while the sum is always precise. It also animates architectures that 
> have an imprecise sched_clock() implementation to improve its accuracy. 
> Accessing the /proc files alone is many orders of magnitude more 
> expensive than this simple multiplication and division.

Yes, I can understand why you don't want to have the exact cpu
accounting scheme on x86 since it will slow down every context switch
quite a bit (that includes user <-> kernel, softirq <-> hardirq <->
process context, ..). On s390 the cost is acceptable, for an empty
system call it is about 40 additional cycles for the precise accounting.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


