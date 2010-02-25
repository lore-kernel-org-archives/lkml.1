Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0BYIjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:39:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab0BYIjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:39:39 -0500
Date: Thu, 25 Feb 2010 09:37:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paulmck@linux.vnet.ibm.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH 00/10] __rcu annotations, first draft
Message-ID: <20100225083751.GA18272@elte.hu>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
 <1267041846-10469-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 23 February 2010, Paul E. McKenney wrote:
> > > I've just started an experimental implementation and got stuck at list rcu.
> > > The two to deal with it that I can see are
> > > - ignore list-rcu for now, and make all include/linux/rculist.h __force the
> > >   problem to be ignored.
> > > - introduce a new struct rcu_list_head that needs to be used for list rcu.
> > >
> > > A nicer option might be if sparse would let you write
> > > 'struct list_head __rcu head' and interpret that as having the pointers
> > > inside it annotated as __rcu.
> >
> > Only the "next" pointer, not the "prev" pointer, but yes.
> >
> > Perhaps it would be best to see if the sparse guys are willing to take
> > this on?
> 
> I've implemented the second option now, and this seems to work alright.
> In order to test this out, I've annotated all rcu users in the kernel
> directory. One observation is that many members of task_struct are
> using RCU inconsistently. I'm not sure whether these should be considered
> bugs or false positives though. If we get a lot of false positives or
> people are generally unhappy about the annotations, they are not worth
> it, but if we find a few actual bugs, I guess it would be good to
> have this.
> 
> Examples of pointers that I did not annotate because most of the
> places accessing them do not use RCU are task->sighand, task->nsproxy,
> and task->real_parent.
> 
> Sorry for hijacking the discussion on your patch, but I assume that
> the same people interested in the lockdep diagnostics are also
> interested in the static annotations for RCU.
> 
> 	Arnd
> 
> Arnd Bergmann (10):
>   rcu: define __rcu address space modifier for sparse
>   rcu: annotated list rcu code
>   cgroups: __rcu annotations
>   credentials: rcu annotation
>   perf_event: __rcu annotations
>   audit: __rcu annotations
>   module: __rcu annotations
>   pid: __rcu annotations
>   notifiers: __rcu annotations
>   scheduler: __rcu annotations
> 
>  include/linux/cgroup.h     |    6 +-
>  include/linux/compiler.h   |    2 +
>  include/linux/cred.h       |    4 +-
>  include/linux/fdtable.h    |    2 +-
>  include/linux/init_task.h  |    6 +-
>  include/linux/module.h     |    4 +-
>  include/linux/notifier.h   |   10 ++--
>  include/linux/perf_event.h |   10 ++--
>  include/linux/pid.h        |    9 ++-
>  include/linux/rculist.h    |  152 ++++++++++++++++++++++++++++++++------------
>  include/linux/rcupdate.h   |   46 ++++++++++++--
>  include/linux/sched.h      |   14 ++--
>  kernel/audit.c             |    4 +-
>  kernel/audit.h             |    6 +-
>  kernel/audit_tree.c        |   14 ++--
>  kernel/auditfilter.c       |   28 ++++----
>  kernel/auditsc.c           |    8 +-
>  kernel/cgroup.c            |   63 ++++++++++---------
>  kernel/cpuset.c            |    2 +-
>  kernel/cred.c              |   50 ++++++++-------
>  kernel/exit.c              |   12 ++--
>  kernel/fork.c              |    6 +-
>  kernel/module.c            |   20 ++++--
>  kernel/notifier.c          |   12 ++--
>  kernel/perf_event.c        |   52 ++++++++--------
>  kernel/pid.c               |    8 +-
>  kernel/sched.c             |   31 +++++----
>  27 files changed, 352 insertions(+), 229 deletions(-)

This looks very clean IMO.

By far the biggest remaining design aspects of RCU is that it's somewhat on 
the opaque side of APIs: it's not immediately obvious when a data structure 
(and subsequently, code using that date structure) is affected by RCU 
semantics.

This is good in terms of API utility: you _can_ use it with very little 
resistence on the way - you can combine RCU and non-RCU code with few 
syntactic constraints imposed.

That kind of flexibility inevitably has its downsides: with a quick guess i'd 
say more than half of the non-trivial RCU related usage bugs in various 
subsystem stemmed out of using non-RCU facilities on RCU data structures.

So the annotation both 'look' clean [which alone is a plus as people write new 
code] and they also might result in bugfixes ...

	Ingo
