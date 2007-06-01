Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbXFAPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbXFAPQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbXFAPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:16:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:35538 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXFAPQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:16:08 -0400
Date: Fri, 1 Jun 2007 19:16:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <markh@compro.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-ID: <20070601151605.GA108@tv-sign.ru>
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466028DB.3060509@compro.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Mark Hounschell wrote:
>
> Oleg Nesterov wrote:
> > Yes, but see above. flush_scheduled_work() needs a cooperation from events/2
> > which is bound to CPU 2.
> > 
> 
> Again I don't understand why flush_scheduled_work() running on behalf of a process
> affinitized to processor-1 requires cooperation from events/2 (affinitized to processor-2)
> when there is an events/1 already affinitized to processor 1?

flush_workqueue() blocks until any scheduled work on any CPU has run to
completion. If we have some work_struct pending on CPU 2, it can be completed
only when events/2 executes it.

> > If you changed irq/X/smp_affinity, the patch I sent should help, because
> > floppy_work can't be scheduled on CPU 2, but still I don't think it is right
> > to run 100% cpu-bound RT-process.
> 
> The patch you sent helps with no other intervention from me. But then so does 
> the patch mentioned in the original post.  I am able to bang on the floppies pretty
> hard doing all kinds of things with no trouble using either. 

This patch replaces flush_scheduled_work() with cancel_work_sync(). The latter
can still hang if the floppy interrupt happens on CPU 2 and does schedule_bh(),
events/2 starts running floppy_work->func() and preempted by RT-thread. This is
very unlikely, but possible.

>From your original post:
	>
	> The application only runs on SMP machines and uses process and irq affinities

if the floppy interrupt can't happen on CPU 2, the above scenario is not possible.

> As far as a 100% cpu-bound RT-process goes, well I say I don't intentionally relinquish
> the processor but it's not really 100% cpu-bound. Running xosview I see some spare time. 

Well, I don't know what is xosview, sorry :) so I don't understand what does
"spare time" precisely mean. If this thread does some i/o or something which
can sleep, then...

OK. In that case we may have another reason for deadlock, say a pending
floppy_work needs open_lock or test_and_set_bit(0, &fdc_busy).

Could you apply the trivial patch below, and change the i/o thread to do

		prctl(1234);				// hangs ???
		printf(something);
		ioctl(Q->DevSpec1, FDSETPRM, &medprm);	// this hangs

to see if prctl() hangs or not? This way we can narrow the problem.
(of course, you can just kill the above ioctl() if this is possible).

Thanks!

Oleg.

--- OLD/kernel/sys.c~	2007-04-03 13:05:02.000000000 +0400
+++ OLD/kernel/sys.c	2007-06-01 18:56:22.000000000 +0400
@@ -2147,6 +2147,11 @@ asmlinkage long sys_prctl(int option, un
 {
 	long error;
 
+	if (option == 1234) {
+		flush_scheduled_work();
+		return 0;
+	}
+
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
 	if (error)
 		return error;

