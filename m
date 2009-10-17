Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZJQGoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZJQGoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZJQGoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:44:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:44001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751404AbZJQGoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:44:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18XoGoq/CQXaLKo7vfRZFCJV0IgQYFf19/8eHNyXB
	e9OnFqDJYbIyFr
Subject: Re: BFS cpu scheduler v0.304 stable release
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200910162158.58054.kernel@kolivas.org>
References: <200910162158.58054.kernel@kolivas.org>
Content-Type: text/plain
Date: Sat, 17 Oct 2009 08:44:18 +0200
Message-Id: <1255761858.12209.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 21:58 +1100, Con Kolivas wrote:
> A lot of people have been wanting to know when BFS, the Brain Fuck Scheduler 
> had reached a stable version, so as requested, I'm announcing the first known 
> stable release of the Brain Fuck Scheduler, version 0.304. The goals and 
> purpose of this patch should be well known by now. It is aimed at end users
> and for comparison purposes, though constructive developer input is welcome.

I've taken BFS out for a few spins while looking into BFS vs CFS latency
reports, and noticed a couple problems I'll share, comparison testing
has been healthy for CFS, so maybe BFS can profit as well.  Below are
some bfs304 vs my working tree numbers from a run this morning, looking
to see if some issues seen in earlier releases were still present.

Comments on noted issues: 

It looks like there may be some affinity troubles, and there definitely
seems to be a fairness bug still lurking.  No idea what's up with that,
but see data below, it's pretty nasty.  Any sleepy load competing with a
pure hog seems to be troublesome. 

The pgsql+oltp test data is very interesting to me, pgsql+oltp hates
preemption with a passion, because of it's USERLAND spinlocks.  Preempt
the lock holder, and watch the fun.  Your preemption model suits it very
well at the low end, and does pretty well all the way though.  Really
interesting to me is the difference in 1 and 2 client throughput, why
I'm including these.

msql+oltp and tbench look like they're griping about affinity to me, but
I haven't instrumented anything, so can't be sure.  mysql+oltp I know is
a wakeup preemption and is very affinity sensitive.  Too little wakeup
preemption, it suffers, any load balancing, it suffers.

What vmark is so upset about, I have no idea.  I know it's very affinity
sensitive, and hates wakeup preemption passionately.

Numbers:

vmark
tip           108841 messages per second 
tip++         116260 messages per second
31.bfs304      28279 messages per second

tbench 8
tip           938.421 MB/sec 8 procs
tip++         952.302 MB/sec 8 procs
31.bfs304     709.121 MB/sec 8 procs

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip           9999.36   18493.54   34652.91   34253.13   32057.64   30297.43   28300.96   25450.14   20675.99
tip++        10041.16   18531.16   34934.22   34192.65   32829.65   32010.55   30341.31   27340.65   22724.87
31.bfs304     9459.85   14952.44   32209.07   29724.03   28608.02   27051.10   24851.44   21223.15   15809.46

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13577.63   26510.67   51871.05   51374.62   50190.69   45494.64   37173.83   27767.09   22795.23
tip++        13685.69   26693.42   52056.45   51733.30   50854.75   49790.95   48972.02   47517.34   44999.22
31.bfs304    15467.03   21126.57   52673.76   50972.41   49652.54   46015.73   44567.18   40419.90   33276.67

fairness bug in 31.bfs304?

prep:
set CPU governor to performance first, as in all benchmarking.
taskset -c 0 pert (100% CPU hog TSC perturbation measurement proggy)
taskset -p 0x1 `pidof Xorg`

perf stat taskset -c 0 konsole -e exit
31.bfs304    2.073724549  seconds time elapsed
tip++        0.989323860  seconds time elapsed

note: amarok pins itself to CPU0, and is set up to use mysql database.

prep: cache warmup run.
perf stat amarokapp (quit after 12000 song mp3 collection is loaded)

31.bfs304    136.418518486  seconds time elapsed
tip++         19.439268066  seconds time elapsed

prep: restart amarok, wait for load, start playing

perf stat taskset -c 0 mplayer -nosound 3DMark2000.mkv (exact 6 minute movie)
31.bfs304    432.712500554  seconds time elapsed
tip++        363.622519583  seconds time elapsed


