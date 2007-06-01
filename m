Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbXFARMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbXFARMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbXFARME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:12:04 -0400
Received: from ms-smtp-02.tampabay.rr.com ([65.32.5.132]:37435 "EHLO
	ms-smtp-02.tampabay.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759698AbXFARMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:12:01 -0400
Message-ID: <4660534E.6050903@cfl.rr.com>
Date: Fri, 01 Jun 2007 13:11:42 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Mark Hounschell <markh@compro.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru>
In-Reply-To: <20070601151605.GA108@tv-sign.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/01, Mark Hounschell wrote:
>> Oleg Nesterov wrote:
>>> Yes, but see above. flush_scheduled_work() needs a cooperation from events/2
>>> which is bound to CPU 2.
>>>
>> Again I don't understand why flush_scheduled_work() running on behalf of a process
>> affinitized to processor-1 requires cooperation from events/2 (affinitized to processor-2)
>> when there is an events/1 already affinitized to processor 1?
> 
> flush_workqueue() blocks until any scheduled work on any CPU has run to
> completion. If we have some work_struct pending on CPU 2, it can be completed
> only when events/2 executes it.
> 
>>> If you changed irq/X/smp_affinity, the patch I sent should help, because
>>> floppy_work can't be scheduled on CPU 2, but still I don't think it is right
>>> to run 100% cpu-bound RT-process.
>> The patch you sent helps with no other intervention from me. But then so does 
>> the patch mentioned in the original post.  I am able to bang on the floppies pretty
>> hard doing all kinds of things with no trouble using either. 
> 
> This patch replaces flush_scheduled_work() with cancel_work_sync(). The latter
> can still hang if the floppy interrupt happens on CPU 2 and does schedule_bh(),
> events/2 starts running floppy_work->func() and preempted by RT-thread. This is
> very unlikely, but possible.
> 
>>From your original post:
> 	>
> 	> The application only runs on SMP machines and uses process and irq affinities
> 
> if the floppy interrupt can't happen on CPU 2, the above scenario is not possible.
> 

All the irq affinities but one are set to processor-1. The only irq not
is from an rtom (Real-Time Option Module). It's irq is handled by
processor-2.

>> As far as a 100% cpu-bound RT-process goes, well I say I don't intentionally relinquish
>> the processor but it's not really 100% cpu-bound. Running xosview I see some spare time. 
> 
> Well, I don't know what is xosview, sorry :) so I don't understand what does
> "spare time" precisely mean. If this thread does some i/o or something which
> can sleep, then...
> 

I don't understand the _real_ meaning of spare time either but xosview
is just a little graphical window showing information obtained from the
proc fs i think.

> OK. In that case we may have another reason for deadlock, say a pending
> floppy_work needs open_lock or test_and_set_bit(0, &fdc_busy).
> 
> Could you apply the trivial patch below, and change the i/o thread to do
> 
> 		prctl(1234);				// hangs ???
> 		printf(something);
> 		ioctl(Q->DevSpec1, FDSETPRM, &medprm);	// this hangs
> 
> to see if prctl() hangs or not? This way we can narrow the problem.
> (of course, you can just kill the above ioctl() if this is possible).
> 
> Thanks!
> 
> Oleg.
> 
> --- OLD/kernel/sys.c~	2007-04-03 13:05:02.000000000 +0400
> +++ OLD/kernel/sys.c	2007-06-01 18:56:22.000000000 +0400
> @@ -2147,6 +2147,11 @@ asmlinkage long sys_prctl(int option, un
>  {
>  	long error;
>  
> +	if (option == 1234) {
> +		flush_scheduled_work();
> +		return 0;
> +	}
> +
>  	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
>  	if (error)
>  		return error;
> 
> -


Ok the prctl never returned. I just replaced the ioctl with it and added
a printf before and after. I only get the one before. The thread is hung
at this point just as if I'd done the ioctl?

Regards
Mark
