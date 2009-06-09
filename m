Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFIXsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFIXsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZFIXr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:47:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53549 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZFIXr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:47:56 -0400
Date: Tue, 9 Jun 2009 16:47:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, ego@in.ibm.com,
       rusty@rustcorp.com.au, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, oleg@redhat.com, dipankar@in.ibm.com
Subject: Re: [PATCH -mm] cpuhotplug: introduce try_get_online_cpus() take 3
Message-ID: <20090609234757.GH16117@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090605153714.GB6778@linux.vnet.ibm.com> <20090608041934.GB17979@in.ibm.com> <20090608142520.GA6961@linux.vnet.ibm.com> <4A2E506D.9090107@cn.fujitsu.com> <20090609123438.b936137e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609123438.b936137e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 12:34:38PM -0700, Andrew Morton wrote:
> On Tue, 09 Jun 2009 20:07:09 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > get_online_cpus() is a typically coarsely granular lock.
> > It's a source of ABBA deadlock.
> > 
> > Thanks to the CPU notifiers, Some subsystem's global lock will
> > be required after cpu_hotplug.lock. Subsystem's global lock
> > is coarsely granular lock too, thus a lot's of lock in kernel
> > should be required after cpu_hotplug.lock(if we need
> > cpu_hotplug.lock held too)
> > 
> > Otherwise it may come to a ABBA deadlock like this:
> > 
> > thread 1                                      |        thread 2
> > _cpu_down()                                   |  Lock a-kernel-lock.
> >   cpu_hotplug_begin()                         |
> >     down_write(&cpu_hotplug.lock)             |
> >   __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
> > ------------------------------------------------------------------------
> >     Lock a-kernel-lock.(wait thread2)         |    down_read(&cpu_hotplug.lock)
> >                                                    (wait thread 1)
> 
> Confused.  cpu_hotplug_begin() doesn't do
> down_write(&cpu_hotplug.lock).  If it _were_ to do that then yes, we'd
> be vulnerable to the above deadlock.

The current implementation is a bit more complex.  If you hold a kernel
mutex across get_online_cpus() and also acquire that same kernel mutex
in a hotplug notifier that permits sleeping, I believe that you really
can get a deadlock as follows:

Task 1					 |	Task 2
					 | mutex_lock(&mylock);
cpu_hotplug_begin()			 |
   mutex_lock(&cpu_hotplug.lock);	 |
   [assume cpu_hotplug.refcount == 0]	 | get_online_cpus()
---------------------------------------------------------------------------
   mutex_lock(&mylock);			 |   mutex_lock(&cpu_hotplug.lock);


That said, when I look at the raw_notifier_call_chain() and
unregister_cpu_notifier() code paths, it is not obvious to me that they
exclude each other or otherwise protect the cpu_chain list...

							Thanx, Paul
