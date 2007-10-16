Return-Path: <linux-kernel-owner+w=401wt.eu-S1764982AbXJPKd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764982AbXJPKd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXJPKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:33:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60110 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbXJPKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:33:17 -0400
Date: Tue, 16 Oct 2007 16:03:08 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: [RFC PATCH 0/4] Refcount Based Cpu-Hotplug Revisit.
Message-ID: <20071016103308.GA9907@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
This patch series attempts to revisit the topic of 
cpu-hotplug locking model. 

Prior to this attempt, there were several different suggestions on 
how it should be implemented. 

The ones that were posted before were

a) Refcount + Waitqueue model:
   Here the threads that want to avoid a cpu hotplug operation while 
   they are operating in cpu-hotplug critical section, bump up the 
   reference to the global online cpu state. 
   The thread which wants to perform a cpu-hotplug, 
   blocks until the reference to the global online state goes
   to zero. Any threads which want to enter the cpu-hotplug critical
   section during an ongoing cpu-hotplug operatoin, are blocked using 
   a waitqueue.

   The advantange of this model was that it is along the lines of 
   the well known get/put model. Only that it allows sleeping of readers
   and writers.

   The disadvantage, as Andrew pointed out was that there do exist
   a whole bunch of lock_cpu_hotplug()'s whose existance is undocumented,
   and an approach like this will not improve such a situation.

b) Per Subsystem cpu-hotplug locks: Each subsystem which has cpu-hotplug
   critical data, uses a lock to protect that data. Such a subsystem
   needs to subscribe to the cpu-hotplug notification, especially the
   CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE events which are sent before
   and and after a cpu-hotplug operation. While handling these events
   respectively, the subsystem lock is taken or released. 
   
   The advantage this model offered was that lock was associated with the
   data, which made easy to understand the purpose of locking. 

   The disadvantage was that any cpu-hotplug aware function, could 
   not be called from a cpu-hotplug callback path, since we would have 
   acquired the subsystem lock during CPU_LOCK_ACQUIRE and attempting
   to reacquire it would result in a deadlock. 
   The case which pointed this limitation out was the implementation of
   synchronize_sched in preemptible rcu.

c) Freezer based cpu-hotplug: 
   The idea here was to freeze the system using the process freezer
   technique which is being used for suspend/hibernate purpose, before
   performing a cpu-hotplug operation. This would ensure that none of
   the kernel threads are accessing any of the cpu-hotplug critical
   data, because they are frozen at well known points. 

   This would have helped to remove all kinds of locks because when a 
   thread is accessing a cpu-hotplug critical data, it meant that the
   system was not frozen and hence there would be no cpu-hotplug 
   operation untill the thread either voluntarily calls try_to_freeze 
   or returns out of the kernel.

   The disadvantage of this approach was that any kind of dependencies
   between threads might call the freezer to fail. For eg, thread A is
   waiting for thread B to accomplish something, but thread B is already
   frozen, leading to a freeze failure. There could be other subtle
   races which might be difficult to track.

Some time in May 2007, Linus suggested using the refcount model, and
this patch series simplifies and reimplements the Refcount + waitqueue
model, based on the discussions in the past and inputs from
Vatsa and Rusty.

Patch 1/4: Implements the core refcount + waitqueue model.
Patch 2/4: Replaces all the lock_cpu_hotplug/unlock_cpu_hotplug instances
	   with get_online_cpus()/put_online_cpus()
Patch 3/4: Replaces the subsystem mutexes (we do have three of them now, 
           in sched.c, slab.c and workqueue.c) with get_online_cpus,
	   put_online_cpus.
Patch 4/4: Eliminates the CPU_DEAD and CPU_UP_CANCELLED event handling
 	   from workqueue.c

The patch series has survived an overnight test with kernbench on i386.
and has been tested with Paul Mckenney's latest preemptible rcu code.

Awaiting thy feedback!

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
