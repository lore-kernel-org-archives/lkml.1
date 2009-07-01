Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZGANuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZGANuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGANuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:50:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZGANun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:50:43 -0400
Date: Wed, 1 Jul 2009 15:50:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090701135032.GA21069@elte.hu>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp> <20090701073139.GA12073@elte.hu> <20090701134501.GA5097@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701134501.GA5097@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Jul 01, 2009 at 09:31:39AM +0200, Ingo Molnar wrote:
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > Hi,
> > > 
> > > I wrote a test patch which add information of counts processes 
> > > acquired how many spinlocks to schedstat. After applied this 
> > > patch, /proc/<PID>/sched will change like this,
> > > 
> > > init (1, #threads: 1)
> > > ---------------------------------------------------------
> > > se.exec_start                      :        482130.851458
> > > se.vruntime                        :         26883.107980
> > > se.sum_exec_runtime                :          2316.651816
> > > se.avg_overlap                     :             0.480053
> > > se.avg_wakeup                      :            14.999993
> > > ....
> > > se.nr_wakeups_passive              :                    1
> > > se.nr_wakeups_idle                 :                    0
> > > se.nr_acquired_spinlock            :                74483
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Looks potentially useful - but it would be nice and go one step 
> > further and add lock acquire stats as a software-counter.
> > 
> > Perfcounters is a feature of the latest upstream kernel, there's a 
> > (still very small) Wiki page about it at:
> > 
> >    http://perf.wiki.kernel.org
> > 
> > With perfcounters we can instrument various software properties of 
> > the kernel as well, for example the number of page-faults in the 
> > system per second:
> > 
> >   $ perf stat -a -e page-faults sleep 1
> > 
> >   Performance counter stats for 'sleep 1':
> > 
> >           294387  page-faults             
> > 
> >      1.022318527  seconds time elapsed
> > 
> > Now, it would be nice to have a lock-acquire software-counter as 
> > well, which would output things like:
> > 
> >   $ perf stat -a -e lock-acquires sleep 1
> > 
> >   Performance counter stats for 'sleep 1':
> > 
> >           294387  lock-acquires
> > 
> >      1.022318527  seconds time elapsed
> > 
> > Furthermore, beyond plain counts, doing this would also allow the 
> > profiling of lock acquire places: perf record -e lock-acquires and 
> > perf report would work fine.
> > 
> > It is really easy to add a new sw counter, check how it is done for 
> > the pagefault counter(s), see the uses of PERF_COUNT_SW_PAGE_FAULTS 
> > in the following files:
> > 
> >   $ git grep -l PERF_COUNT_SW_PAGE_FAULTS
> > 
> >   arch/powerpc/mm/fault.c
> >   arch/x86/mm/fault.c
> >   include/linux/perf_counter.h
> >   kernel/perf_counter.c
> >   tools/perf/builtin-stat.c
> >   tools/perf/design.txt
> 
> 
> Indeed, the raw number of lock acquired may be useful for a perf 
> profiling especially in the case of profile comparison.
> 
> But IMHO, this information is too much orphan and lonesome. We 
> would gain a lot if this information is provided per lock. Another 
> useful info would be the rate of the time spent in a contended 
> state for a given lock.
> 
> Which makes me think it may be better to use the existing ftrace 
> lock events as softwares counters for that, which takes into 
> account the following events:
> 
> - lock_acquire
> - lock_release
> - lock_contended
> - lock_acquired
> 
> And these events are per lock.
> 
> Now the missing piece is the sampling count for events...

Yeah, this is an even better idea. It gets the acquire counts - and 
much more.

	Ingo
