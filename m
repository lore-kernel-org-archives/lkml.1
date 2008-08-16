Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYHPOxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYHPOxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 10:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYHPOxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 10:53:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:46668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYHPOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 10:53:24 -0400
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
From: Peter Zijlstra <peterz@infradead.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <1218880552.11912.9.camel@matrix>
References: <1218880552.11912.9.camel@matrix>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 16:53:33 +0200
Message-Id: <1218898413.10800.252.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 11:55 +0200, Stefani Seibold wrote:
> Hi kernel hackers,
> 
> it seems that the new completely fair scheduler breaks the SCHED_RR and
> SCHED_FIFO realtime scheduler.
> 
> In my opinion a high priority real time user process with SCHED_FIFO
> should be only interrupted by the kernel or a process with an higher
> priority. So a user process running under SCHED_FIFO and priority 99
> should never be interrupted by any other process.  This was true under
> kernel 2.6.20. 
> 
> On my pentium/celeron III/400 MHz system with kernel 2.6.20 a busy loop
> using the "time stamp counter" of the x86 cpu for delaying, this was
> very accurate. The max. jitter of the delaying was about 5 microseconds.
> 
> With the new kernel 2.6.26 the jitter is about 51177 microseconds or in
> other words 51 milliseconds or more the 10000 times greater than kernel
> 2.6.20. This huge latency is far away from realtime.
> 
> Below are the results of the attached test program. Maybe somebody else
> can confirm this results. All measurements was done with no other
> process running, only the busybox 1.11.1 shell and the init process was
> there.

Has nothing to do with CFS, but everything to do with the fact that we
now have a 95% bandwidth control by default.

Does doing:

echo -1 > /proc/sys/kernel/sched_rt_runtime_us

fix it?

So, up to 95% cpu usage (per sched_rt_period_us) FIFO and RR behave like
they always did, once they cross that line, they'll be throttled.

95% seemed like a sane default in that it leaves a little room to
recover from a run-away rt process (esp handy now that !root users can
also use RT scheduling classes), and should be enough for most
applications as they usually don't consume all that much time.



