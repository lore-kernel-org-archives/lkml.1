Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXFALBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXFALBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXFALA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:00:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:56366 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXFALA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:00:56 -0400
Date: Fri, 1 Jun 2007 15:00:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <markh@compro.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-ID: <20070601110058.GA83@tv-sign.ru>
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465F2D96.9060502@compro.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I hope Ingo will correct me if I am wrong,

On 05/31, Mark Hounschell wrote:
>
> Oleg Nesterov wrote:
> > 
> > So, the main question is: is it possible that one of RT processes/threads pins itself
> > to some CPU and eats 100% cpu power?
> > 
> 
> The main process is pinned to a processor(2) with all _non-kernel_  processes/threads forced over to processor 1.
> Any already affinitized processes or kernel threads are left as is. Only user land stuff is moved. The main process
> is for sure _not_ relinquishing it's processor(2) intentionally.

This means that a non-rt kernel thread bound to CPU 2 can't run. In particular,
events/2. This means that the problem is not directly connected to floppy.c,
any flush_scheduled_work() (or schedule_on_each_cpu()) can't succeed.

You can change irq/X/smp_affinity, but smp_apic_timer_interrupt() still can
queue work_struct on CPU 2 (for example, mm/slab.c uses per-cpu reap_work).
Since events/2 is blocked by the main RT thread, such a work_struct can't be
executed, and so flush_scheduled_work() hangs.

> All the I/O threads, floppy included, are running
> on the other processor(1). During this failure only 1 or 2 of the I/O threads are actually doing anything.
> I assume that what ever is going on in the kernel/floppy driver on behalf of the floppy thread is being done on processor 1? 
> Processor 1 has lots of CPU time available.

Yes, but see above. flush_scheduled_work() needs a cooperation from events/2
which is bound to CPU 2.

If you changed irq/X/smp_affinity, the patch I sent should help, because
floppy_work can't be scheduled on CPU 2, but still I don't think it is right
to run 100% cpu-bound RT-process.

Oleg.

