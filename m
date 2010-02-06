Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0BFMMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 07:12:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:55465 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750968Ab0BFML7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 07:11:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ndBIdkCMn/Gc8M3tkzRX/aw0iWJlhEbhn5CGSEs
	o90hOlMoRxzTNX
Subject: Re: Scheduler oddity
From: Mike Galbraith <efault@gmx.de>
To: malc <av1474@comtv.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1002051928230.4744@linmac>
References: <alpine.LNX.2.00.1002051928230.4744@linmac>
Content-Type: text/plain
Date: Sat, 06 Feb 2010 13:11:55 +0100
Message-Id: <1265458315.8803.79.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 19:33 +0300, malc wrote:
> Following test exhibits somewhat odd behaviour on, at least, 2.6.32.3 
> (ppc) and 2.6.29.1 (x86_64), perhaps someone could explain why.

Expected behavior.

SCHED_BATCH tasks do not wakeup preempt, preemption is tick driven.  The
writer therefore has time to fill the pipe/block, so reader can then
drain the pipe, leading to efficient data transfer.

SCHED_NORMAL tasks do preempt.  Every write wakes a reader who's
vruntime (CPU utilization fairness yardstick) lags the writer enough to
warrant preemption, so one write translates to one preemption followed
by a read.  The reader can't possibly catch up to the writer (being
synchronous) in either case, but the scheduler doesn't know that or
care, it simply tries to equalize the two.  Since the writer's CPU
utilization stems entirely from tiny writes, that time is what goes
toward equalizing the reader.  Result is the tiny I/Os the programmer
asked for, extreme low latency, and utterly horrid throughput.

	-Mike

