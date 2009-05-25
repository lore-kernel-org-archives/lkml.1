Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZEYLgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZEYLgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZEYLgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:36:11 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51741 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEYLgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:36:10 -0400
Date: Mon, 25 May 2009 13:35:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090525133504.62c3a6d7@skybase>
In-Reply-To: <1243249766.26820.665.camel@twins>
References: <20090518160904.7df88425@skybase>
	<1242660243.26820.439.camel@twins>
	<20090519104900.12e1f80c@skybase>
	<1242723635.26820.471.camel@twins>
	<20090525125034.159ecb78@skybase>
	<1243249766.26820.665.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 13:09:26 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-05-25 at 12:50 +0200, Martin Schwidefsky wrote:
> > On Tue, 19 May 2009 11:00:35 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > So, I'm really not objecting too much to the patch at hand, but I'd love
> > > to find a solution to this problem.
> > 
> > It is not hard so solve the problem for /proc/uptime, e.g. like this:
> > 
> > static u64 uptime_jiffies = INITIAL_JIFFIES;
> > static struct timespec ts_uptime;
> > static struct timespec ts_idle;
> > 
> > static int uptime_proc_show(struct seq_file *m, void *v)
> > {
> >         cputime_t idletime;
> >         u64 now;
> >         int i;
> > 
> >         now = get_jiffies_64();
> >         if (uptime_jiffies != now) {
> >                 uptime_jiffies = now;
> >                 idletime = cputime_zero;
> >                 for_each_possible_cpu(i)
> >                         idletime = cputime64_add(idletime,
> >                                                  kstat_cpu(i).cpustat.idle);
> >                 do_posix_clock_monotonic_gettime(&ts_uptime);
> >                 monotonic_to_bootbased(&ts_uptime);
> >                 cputime_to_timespec(idletime, &ts_idle);
> >         }
> > 
> >         seq_printf(m, "%lu.%02lu %lu.%02lu\n",
> >                         (unsigned long) ts_uptime.tv_sec,
> >                         (ts_uptime.tv_nsec / (NSEC_PER_SEC / 100)),
> >                         (unsigned long) ts_idle.tv_sec,
> >                         (ts_idle.tv_nsec / (NSEC_PER_SEC / 100)));
> >         return 0;
> > }
> > 
> > For /proc/stat it is less clear. Just storing the values in static
> > variables is not such a good idea as there are lots of values.
> > 10*NR_CPUS + NR_IRQS values to be exact. With NR_CPUS in the thousands
> > this will waste quite a bit of memory.
> 
> Right, I know of for_each_possible_cpu() loops that took longer than a
> jiffy and caused general melt-down -- not saying the loop for idle time
> will be one such a loop, but then it seems silly anyway, who's
> incrementing the idle time when we're idle?

Psst, I do ;-) Look at the arch_idle_time macro in fs/proc/stat.c..
 
> I really prefer using things like percpu_counter/vmstat that have error
> bounds that scale with the number of cpus in the system.
> 
> We simply have to start educating people that numbers on the global
> state of the machine are inaccurate (they were anyway, because by the
> time the userspace bits that read the /proc file get scheduled again the
> numbers will have changed again).

That is one problem, the other is that the values you'll get are not
atomic in any way. Not even the totals in /proc/stat match the sum over
the cpus.

> There's a variant of Heisenberg's uncertainty principle applicable to
> (parallel) computers in that one either gets concurrency or accuracy on
> global state, you cannot have both.

If the time you need to generate a value is longer than the maximum
error you do have a problem.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

