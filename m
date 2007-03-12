Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXCLEqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXCLEqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965119AbXCLEqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:46:54 -0400
Received: from pool-71-111-97-248.ptldor.dsl-w.verizon.net ([71.111.97.248]:17111
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965114AbXCLEqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:46:53 -0400
Date: Sun, 11 Mar 2007 21:41:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070312044143.GB4124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <45F07715.9090502@googlemail.com> <20070309181851.e96d468a.akpm@linux-foundation.org> <20070310154511.GB9645@linux.vnet.ibm.com> <6bffcb0e0703111002t75a8ac51vcce7d52684e04a9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bffcb0e0703111002t75a8ac51vcce7d52684e04a9d@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 06:02:31PM +0100, Michal Piotrowski wrote:
> On 10/03/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >On Fri, Mar 09, 2007 at 06:18:51PM -0800, Andrew Morton wrote:
> >> > On Thu, 08 Mar 2007 21:50:29 +0100 Michal Piotrowski 
> ><michal.k.k.piotrowski@gmail.com> wrote:
> >> > Andrew Morton napisał(a):
> >> > > Temporarily at
> >> > >
> >> > >   http://userweb.kernel.org/~akpm/2.6.21-rc3-mm1/
> >> > >
> >> > > Will appear later at
> >> > >
> >> > >   
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/
> >> > >
> >> >
> >> > cpu_hotplug (AutoTest) hangs at this
> >> >
> >> > =============================================
> >> > [ INFO: possible recursive locking detected ]
> >> > 2.6.21-rc3-mm1 #2
> >> > ---------------------------------------------
> >> > sh/7213 is trying to acquire lock:
> >> >  (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
> >> >
> >> > but task is already holding lock:
> >> >  (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
> >> >
> >> > other info that might help us debug this:
> >> > 4 locks held by sh/7213:
> >> >  #0:  (cpu_add_remove_lock){--..}, at: [<c033883a>] 
> >mutex_lock+0x1c/0x1f
> >> >  #1:  (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
> >> >  #2:  (cache_chain_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
> >> >  #3:  (workqueue_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
> >>
> >> That's pretty useless, isn't it?  We need to know the mutex_lock() caller
> >> here.
> >>
> >> > stack backtrace
> >> >  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
> >> >  [<c010597b>] show_trace+0x12/0x14
> >> >  [<c0105a3d>] dump_stack+0x16/0x18
> >> >  [<c013fc73>] __lock_acquire+0x1aa/0xceb
> >> >  [<c014082d>] lock_acquire+0x79/0x93
> >> >  [<c03385dc>] __mutex_lock_slowpath+0x107/0x349
> >> >  [<c033883a>] mutex_lock+0x1c/0x1f
> >> >  [<c011d924>] sched_getaffinity+0x14/0x91
> >> >  [<c015796d>] __synchronize_sched+0x11/0x5f
> >> >  [<c011d257>] detach_destroy_domains+0x2c/0x30
> >> >  [<c011fc1a>] update_sched_domains+0x27/0x3a
> >> >  [<c012fe7a>] notifier_call_chain+0x2b/0x4a
> >> >  [<c012fec6>] __raw_notifier_call_chain+0x19/0x1e
> >> >  [<c0145756>] _cpu_down+0x70/0x282
> >> >  [<c014598e>] cpu_down+0x26/0x38
> >> >  [<c0272714>] store_online+0x27/0x5a
> >> >  [<c026f610>] sysdev_store+0x20/0x25
> >> >  [<c01b7a8e>] sysfs_write_file+0xc1/0xe9
> >> >  [<c0180052>] vfs_write+0xd1/0x15a
> >> >  [<c0180682>] sys_write+0x3d/0x72
> >> >  [<c0104270>] syscall_call+0x7/0xb
> >> >
> >> > l *0xc033883a
> >> > 0xc033883a is in mutex_lock 
> >(/mnt/md0/devel/linux-mm/kernel/mutex.c:92).
> >> > 87              /*
> >> > 88               * The locking fastpath is the 1->0 transition from
> >> > 89               * 'unlocked' into 'locked' state.
> >> > 90               */
> >> > 91              __mutex_fastpath_lock(&lock->count, 
> >__mutex_lock_slowpath);
> >> > 92      }
> >> > 93
> >> > 94      EXPORT_SYMBOL(mutex_lock);
> >> > 95
> >> > 96      static void fastcall noinline __sched
> >> >
> >> > I didn't test other -mm's with this test.
> >> >
> >> > 
> >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-mm1/console.log
> >> > 
> >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-mm1/mm-config
> >>
> >> I can't immediately spot the bug.  Probably it's caused by rcu-preempt's
> >> changes to synchronize_sched(): that function now does a heap more than 
> >it
> >> used to, including taking sched_hotcpu_muex.
> >>
> >> So, what to do about this.  Paul, I'm thinking that I should drop
> >> rcu-preempt for now - I don't think we ended up being able to identify 
> >any
> >> particular benefit which it brings to current mainline, and I suspect 
> >that
> >> things will become simpler if/when we start using the process freezer for
> >> CPU hotplug.
> >
> >It certainly makes sense for Michal to try backing out rcu-preempt using
> >your broken-out list of patches.  If that makes the problem go away,
> 
> Problem is caused by rcu-preempt.patch.

OK, clearly we need to fix this.  You might be right about the freezer
code having to go in first, Andrew -- will see!

							Thanx, Paul

> >then I would certainly have a hard time arguing with you.  We are working
> >on getting measurements showing benefit of rcu-preempt, but aren't there
> >yet.


