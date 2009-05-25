Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZEYLKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZEYLKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEYLKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:10:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZEYLKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:10:11 -0400
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090525125034.159ecb78@skybase>
References: <20090518160904.7df88425@skybase>
	 <1242660243.26820.439.camel@twins> <20090519104900.12e1f80c@skybase>
	 <1242723635.26820.471.camel@twins>  <20090525125034.159ecb78@skybase>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 13:09:26 +0200
Message-Id: <1243249766.26820.665.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 12:50 +0200, Martin Schwidefsky wrote:
> On Tue, 19 May 2009 11:00:35 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > So, I'm really not objecting too much to the patch at hand, but I'd love
> > to find a solution to this problem.
> 
> It is not hard so solve the problem for /proc/uptime, e.g. like this:
> 
> static u64 uptime_jiffies = INITIAL_JIFFIES;
> static struct timespec ts_uptime;
> static struct timespec ts_idle;
> 
> static int uptime_proc_show(struct seq_file *m, void *v)
> {
>         cputime_t idletime;
>         u64 now;
>         int i;
> 
>         now = get_jiffies_64();
>         if (uptime_jiffies != now) {
>                 uptime_jiffies = now;
>                 idletime = cputime_zero;
>                 for_each_possible_cpu(i)
>                         idletime = cputime64_add(idletime,
>                                                  kstat_cpu(i).cpustat.idle);
>                 do_posix_clock_monotonic_gettime(&ts_uptime);
>                 monotonic_to_bootbased(&ts_uptime);
>                 cputime_to_timespec(idletime, &ts_idle);
>         }
> 
>         seq_printf(m, "%lu.%02lu %lu.%02lu\n",
>                         (unsigned long) ts_uptime.tv_sec,
>                         (ts_uptime.tv_nsec / (NSEC_PER_SEC / 100)),
>                         (unsigned long) ts_idle.tv_sec,
>                         (ts_idle.tv_nsec / (NSEC_PER_SEC / 100)));
>         return 0;
> }
> 
> For /proc/stat it is less clear. Just storing the values in static
> variables is not such a good idea as there are lots of values.
> 10*NR_CPUS + NR_IRQS values to be exact. With NR_CPUS in the thousands
> this will waste quite a bit of memory.

Right, I know of for_each_possible_cpu() loops that took longer than a
jiffy and caused general melt-down -- not saying the loop for idle time
will be one such a loop, but then it seems silly anyway, who's
incrementing the idle time when we're idle?

I really prefer using things like percpu_counter/vmstat that have error
bounds that scale with the number of cpus in the system.

We simply have to start educating people that numbers on the global
state of the machine are inaccurate (they were anyway, because by the
time the userspace bits that read the /proc file get scheduled again the
numbers will have changed again).

There's a variant of Heisenberg's uncertainty principle applicable to
(parallel) computers in that one either gets concurrency or accuracy on
global state, you cannot have both.
