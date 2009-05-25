Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZEYKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZEYKuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZEYKuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:50:37 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43333 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEYKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:50:36 -0400
Date: Mon, 25 May 2009 12:50:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
Message-ID: <20090525125034.159ecb78@skybase>
In-Reply-To: <1242723635.26820.471.camel@twins>
References: <20090518160904.7df88425@skybase>
 <1242660243.26820.439.camel@twins>
 <20090519104900.12e1f80c@skybase>
 <1242723635.26820.471.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 11:00:35 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> So, I'm really not objecting too much to the patch at hand, but I'd love
> to find a solution to this problem.

It is not hard so solve the problem for /proc/uptime, e.g. like this:

static u64 uptime_jiffies = INITIAL_JIFFIES;
static struct timespec ts_uptime;
static struct timespec ts_idle;

static int uptime_proc_show(struct seq_file *m, void *v)
{
        cputime_t idletime;
        u64 now;
        int i;

        now = get_jiffies_64();
        if (uptime_jiffies != now) {
                uptime_jiffies = now;
                idletime = cputime_zero;
                for_each_possible_cpu(i)
                        idletime = cputime64_add(idletime,
                                                 kstat_cpu(i).cpustat.idle);
                do_posix_clock_monotonic_gettime(&ts_uptime);
                monotonic_to_bootbased(&ts_uptime);
                cputime_to_timespec(idletime, &ts_idle);
        }

        seq_printf(m, "%lu.%02lu %lu.%02lu\n",
                        (unsigned long) ts_uptime.tv_sec,
                        (ts_uptime.tv_nsec / (NSEC_PER_SEC / 100)),
                        (unsigned long) ts_idle.tv_sec,
                        (ts_idle.tv_nsec / (NSEC_PER_SEC / 100)));
        return 0;
}

For /proc/stat it is less clear. Just storing the values in static
variables is not such a good idea as there are lots of values.
10*NR_CPUS + NR_IRQS values to be exact. With NR_CPUS in the thousands
this will waste quite a bit of memory.

I fixed another problem with Michael original patch and added the new
one to reduce the frequency of accesses to kstat_cpu for /proc/uptime.
You'll find both at:

	git://git390.marist.edu/pub/scm/linux-2.6.git cputime

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

