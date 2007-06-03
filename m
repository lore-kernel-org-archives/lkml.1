Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbXFCIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbXFCIOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbXFCIOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:14:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:51438 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbXFCIOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:14:18 -0400
Date: Sun, 3 Jun 2007 12:14:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: Mark Hounschell <markh@compro.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-ID: <20070603081417.GA81@tv-sign.ru>
References: <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com> <20070601183642.GA92@tv-sign.ru> <466078FF.2080508@cfl.rr.com> <20070602123030.GA719@tv-sign.ru> <4661D698.5040009@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4661D698.5040009@cfl.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Mark Hounschell wrote:
>
> Jun  2 16:36:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
> c201dbc0 10012 10012
> Jun  2 16:36:11 harley kernel: CURR: 7974 7974 vrsx 93 26
> Jun  2 16:36:11 harley kernel:     wq_barrier_func+0x0/0x8
> Jun  2 16:36:11 harley kernel:     vmstat_update+0x0/0x24
> Jun  2 16:36:11 harley kernel:     ----
> Jun  2 16:36:11 harley kernel:     cache_reap+0x0/0xf4

As expected.

Note that ->nivcsw/->nvcsw doesn't change. There is no "spare time"
on CPU 1, "vrsx" monopolizes CPU. events/1->cache_reap() was preempted
by vrsx, it had no chance to run since then. Note that jobs == 7974
doesn't change too. I forgot to print cwq->thread->state, but it should
be TASK_RUNNING. It would not be possible to kill vrsx if cache_reap()
stalled.

I don't think this is a kernel problem, vrsx breaks flush_workqueue().
Ingo can answer authoritatively, but I think SCHED_RR/SCHED_FIFO were
not designed to be 100% cpu-bound.

That said, I think it makes sense to get rid of flush_scheduled_work()
in floppy.c.

Thanks!

Oleg.

