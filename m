Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZCaEdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZCaEdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZCaEdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:33:11 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34710 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZCaEdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:33:10 -0400
Date: Tue, 31 Mar 2009 10:03:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v6
Message-ID: <20090331043317.GB4093@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090325043950.GA3276@in.ibm.com> <20090330092002.GB16497@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330092002.GB16497@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:50:02PM +0530, Balbir Singh wrote:
> * Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-03-25 10:09:50]:
> 
> > Here is the next version which fixes the bug pointed by Li Zefan in v5.
> > 
> > We currently have two stats named stime and utime. In future if we
> > decide to have more fine grained stats like time spent in irq, softirq
> > etc, it will be difficult to name them similar to stime and utime. Hence
> > would it make sense to name these stats as system and user so that we
> > could easily add nice, irq, steal, softirq etc in future ?
> > 
> > Regards,
> > Bharata.
> > 
> > cpuacct: Add stime and utime statistics
> > 
> > Add per-cgroup cpuacct controller statistics like the system and user
> > time consumed by the group of tasks.
> > 
> > Changelog:
> > 
> > v6
> > - Fixed a bug in the error path of cpuacct_create() (pointed by Li Zefan).
> > 
> > v5
> > - In cpuacct_stats_show(), use cputime64_to_clock_t() since we are
> >   operating on a 64bit variable here.
> > 
> > v4
> > - Remove comments in cpuacct_update_stats() which explained why rcu_read_lock()
> >   was needed (as per Peter Zijlstra's review comments).
> > - Don't say that percpu_counter_read() is broken in Documentation/cpuacct.txt
> >   as per KAMEZAWA Hiroyuki's review comments.
> > 
> > v3
> > - Fix a small race in the cpuacct hierarchy walk.
> > 
> > v2
> > - stime and utime now exported in clock_t units instead of msecs.
> > - Addressed the code review comments from Balbir and Li Zefan.
> > - Moved to -tip tree.
> > 
> > v1
> > - Moved the stime/utime accounting to cpuacct controller.
> > 
> > Earlier versions
> > - http://lkml.org/lkml/2009/2/25/129
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> > Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Cc: Paul Menage <menage@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> >  Documentation/cgroups/cpuacct.txt |   18 +++++++
> >  kernel/sched.c                    |   87 +++++++++++++++++++++++++++++++++++---
> >  2 files changed, 99 insertions(+), 6 deletions(-)
> > 
> > --- a/Documentation/cgroups/cpuacct.txt
> > +++ b/Documentation/cgroups/cpuacct.txt
> > @@ -30,3 +30,21 @@ The above steps create a new group g1 an
> >  process (bash) into it. CPU time consumed by this bash and its children
> >  can be obtained from g1/cpuacct.usage and the same is accumulated in
> >  /cgroups/cpuacct.usage also.
> > +
> > +cpuacct.stat file lists a few statistics which further divide the
> > +CPU time obtained by the cgroup into user and system times. Currently
> > +the following statistics are supported:
> > +
> > +utime: Time spent by tasks of the cgroup in user mode.
> > +stime: Time spent by tasks of the cgroup in kernel mode.
> > +
> 
> Bharata can we move away from stime, utime (names) to system and user with
> time being an implicit unit. I would like to see softirq, hardirq, etc
> times in the future being added.

Done. Posted next version with this change.

Regards,
Bharata.
