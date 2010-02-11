Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BKBVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 20:21:24 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54903 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0BKBVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 20:21:22 -0500
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100208132101.GA7129@redhat.com>
	<alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
	<20100208171643.GA19230@redhat.com>
	<201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
	<20100209140818.43bb9770.akpm@linux-foundation.org>
In-Reply-To: <20100209140818.43bb9770.akpm@linux-foundation.org>
Message-Id: <201002111021.EJG17183.FtOVFLSFQOJMHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 11 Feb 2010 10:21:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > What should we do? Adding rcu_read_lock()/rcu_read_unlock() to each
> > callers? Or adding rcu_read_lock()/rcu_read_unlock() inside
> > find_task_by_pid_ns()?
> 
> Putting rcu_read_lock() in the callee isn't a complete solution. 
> Because the function would still be returning a task_struct* without
> any locking held and without taking a reference against it.  So that
> pointer is useless to the caller!
> 
> We could add a new function which looks up the task and then takes a
> reference on it, insde suitable locks.  The caller would then use the
> task_struct and then remember to call put_task_struct() to unpin it. 
> This prevents the task_struct from getting freed while it's being
> manipulated, but it doesn't prevent fields within it from being altered
> - that's up to the caller to sort out.

Code for "struct task_struct" is too complicated for me to understand,
but my understanding is that

(1) tasklist_lock is acquired for writing.

(2) "struct task_struct" (to exit()) is removed from task's list.

(3) tasklist_lock is released.

(4) Wait for RCU grace period.

(5) kfree() members of "struct task_struct".

(6) kfree() "struct task_struct" itself.

If above sequence is correct, I think

	rcu_read_lock();
	task = find_task_by_pid_ns();
	if (task)
		do_something(task);
	rcu_read_unlock();

do_something() can safely access all members of task without
read_lock(&tasklist_lock), except task->prev (I don't know the exact member)
and task->usage, because do_something() finishes its work before (5).
I think we need to call find_task_by_pid_ns() with both
read_lock(&tasklist_lock) and rcu_read_lock()

	read_lock(&tasklist_lock);
	rcu_read_lock();
	task = find_task_by_pid_ns();
	if (task)
		atomido_something(task);
	rcu_read_unlock();
	read_unlock(&tasklist_lock);

only when do_something() wants to access task->prev or task->usage .

> 
> One fix is to go through all those callsites and add the rcu_read_lock.
> That kinda sucks.  Perhaps writing the new function which returns a
> pinned task_struct is better?
