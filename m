Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYLIQNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLIQNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYLIQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:13:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYLIQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:13:43 -0500
Date: Tue, 9 Dec 2008 11:13:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: [ANNOUNCE] The -rt git tree
Message-ID: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The -rt branch has been static for some time. We are sorry about that, 
but most of those that maintain it have been working on other parts of the 
kernel. Mostly new mainline work.

People have also been asking about having an -rt git tree. Well, it is 
time to create one.

We have started working on an -rt git tree. Note, it is currently broken 
and not ready for use. An announcement will be made when it is ready. This 
email is only to let people know that we are currently actively working on 
the new -rt tree.

The git tree is located here:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

The branches include:

	linus - the mainline branch that the rest is based on
	rt-master - all the rt/* branches merged into one
	master - rt-master + converting of the locks (see below)
	rt/rt - some rt git scripts
	rt/convert-scripts - the scripts to convert spinlocks (see below)
	rt/mainline - clean ups for mainline that we need to push forward
	rt/not-for-mainline - rt only patches that we never want to push
                             to mainline
	rt/fs - filesystem changes for rt
	rt/ftrace - ftrace updates for rt
	rt/java - IBM patches for java
	rt/kmap
	rt/lockdep
	rt/pagecache
	rt/percpu - this may turn into rt/mm
	rt/rt-locks - the new lock API (see below)
	rt/sched
	rt/tasklet
	rt/threadirqs - full soft and hard irq threading
	rt/timer
	rt/workqueue - priority queues

We may add more rt/* branches. Most of those are self explanatory.

The new lock API.  The old -rt patch used macro magic to convert 
spin_locks into mutexes depending on which type they were. A spinlock that 
was declared as spinlock_t would convert into a mutex when PREEMPT_RT was 
configured, where as a spinlock that was declared as raw_spinlock_t would 
stay as a spinlock.

For example:

	spinlock_t	what_am_i;
	raw_spinlock_t	spinner;

	spin_lock(&what_am_i);
	spin_lock(&spinner);

The 'what_am_i' would turn into a mutex when PREEMPT_RT was configured and 
would be a spinlock when it was not. 'spinner' would always stay as a 
spinlock. The way this was done was with a builtin gcc option to compare 
the type used to determine what function to call:

#define spin_lock(lock) \
	if (__builtin_types_compatible(typeof(spinlock_t), lock)) \
		rt_lock(lock); \
	else if (__builtin_types_compatible(typeof(raw_spinlock_t), lock)) \
		raw_spin_lock(lock); \
	else \
		__bad_func_type();

If you are looking at this and scratching your head saying "this is not 
acceptable for mainline", we agree with you ;-)  This is the old way of 
doing things, which made porting -rt to mainline much easier than 
converting all locks to a new API. But the time has come to do just that.

The new locks
-------------

The old way is not acceptable because a developer can not know when seeing 
a 'spin_lock(x)' and knowing if it will stay a spinlock or not on 
PREEMPT_RT. The developer would need to go search for x and see what type 
it is. Then they still can not know if someone might change the type of 
x. This is just ripe for bugs.

The new RT has added a new lock API that will be a mutex when 
PREEMPT_RT is configured and a spinlock when it is not. The type is called 
'lock_t' and introduces a new API acquire_lock() and release_lock().  This 
also has all the irq variants that spin_locks have (acquire_lock_irqsave, 
acquire_lock_irq, etc).

	lock_t		lock;

	acquire_lock_irqsave(&lock, flags);

Although it has 'irqsave' when PREEMPT_RT is defined, it will not disable 
interrupts. This is fine, because with PREEMPT_RT, interrupts are threads, 
and we do not need to worry about being preempted by an interrupt and have 
that interrupt taking the same lock cause a deadlock.  But now, the 
developer knows that this is a special lock, and that the lock is not a 
spinlock all the time.

Note, you can not do:

	spin_lock(&spinner);
	acquire_lock(&lock);

This would be the same as doing:

	spin_lock(&spinner);
	mutex_lock(&mutex);


Converting the new locks
------------------------

In the git tree, there is a couple of scripts in rt/convert-scripts branch 
that will convert all spinlocks into the lock_t. Then there are scripts to 
convert the necessary spinlocks back to spinlock.  All rt/* branches 
should not need to define the type lock_t except for rt/rt-locks.

This git repo uses similar scripts that tip uses. The rt-master branch is 
a merge of all rt/* branches (except rt/rt). This may define PREEMPT_RT 
but no lock is made into 'lock_t' type yet.

The master branch is a copy of the rt-branch with the scripts to do the 
lock conversion run on the tree.  In other words, the master branch will 
be the new -rt patch.

Note, the current state of this git tree is still very much broken. We are 
rewriting a lot of code to pull this forward to 2.6.28. Unfortunately, 
this means that we are skipping 2.6.27 altogether. I will be making 
another announcement when this is ready for prime time.  Some of the 
branches have not been updated with the changes either.

-- Steve

