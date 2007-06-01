Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbXFAOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbXFAOKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbXFAOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:10:27 -0400
Received: from mx2.compro.net ([216.54.166.4]:39985 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbXFAOK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:10:26 -0400
X-IronPort-AV: E=Sophos;i="4.16,373,1175486400"; 
   d="scan'208";a="404064"
Message-ID: <466028DB.3060509@compro.net>
Date: Fri, 01 Jun 2007 10:10:35 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru>
In-Reply-To: <20070601110058.GA83@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> I hope Ingo will correct me if I am wrong,
> 
> On 05/31, Mark Hounschell wrote:
>> Oleg Nesterov wrote:
>>> So, the main question is: is it possible that one of RT processes/threads pins itself
>>> to some CPU and eats 100% cpu power?
>>>
>> The main process is pinned to a processor(2) with all _non-kernel_  processes/threads forced over to processor 1.
>> Any already affinitized processes or kernel threads are left as is. Only user land stuff is moved. The main process
>> is for sure _not_ relinquishing it's processor(2) intentionally.
> 
> This means that a non-rt kernel thread bound to CPU 2 can't run. In particular,
> events/2. This means that the problem is not directly connected to floppy.c,
> any flush_scheduled_work() (or schedule_on_each_cpu()) can't succeed.
> 

Well, I have multiple I/O threads for many other types of I/O that don't have any problems. 
And until these changes in 2.6.18 I didn't have any problems with the floppy. I have multiple
ethernet threads, multiple scsi (SG) device threads, multiple rs232 device threads, parallel port, 
and others, no problem??


> You can change irq/X/smp_affinity, but smp_apic_timer_interrupt() still can
> queue work_struct on CPU 2 (for example, mm/slab.c uses per-cpu reap_work).
> Since events/2 is blocked by the main RT thread, such a work_struct can't be
> executed, and so flush_scheduled_work() hangs.
> 

I don't mean to sound stupid but why would a process running on processor 1 require anything
from events/2 when there is an events/1? Forgive my ignorance please.

>> All the I/O threads, floppy included, are running
>> on the other processor(1). During this failure only 1 or 2 of the I/O threads are actually doing anything.
>> I assume that what ever is going on in the kernel/floppy driver on behalf of the floppy thread is being done on processor 1? 
>> Processor 1 has lots of CPU time available.
> 
> Yes, but see above. flush_scheduled_work() needs a cooperation from events/2
> which is bound to CPU 2.
> 

Again I don't understand why flush_scheduled_work() running on behalf of a process
affinitized to processor-1 requires cooperation from events/2 (affinitized to processor-2)
when there is an events/1 already affinitized to processor 1? Again though, Forgive my 
ignorance please.

> If you changed irq/X/smp_affinity, the patch I sent should help, because
> floppy_work can't be scheduled on CPU 2, but still I don't think it is right
> to run 100% cpu-bound RT-process.
> 
> Oleg.
> 

The patch you sent helps with no other intervention from me. But then so does 
the patch mentioned in the original post.  I am able to bang on the floppies pretty
hard doing all kinds of things with no trouble using either. 

As far as a 100% cpu-bound RT-process goes, well I say I don't intentionally relinquish
the processor but it's not really 100% cpu-bound. Running xosview I see some spare time. 

Thanks
Mark

