Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYCYLCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYCYLCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYCYLCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:02:17 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43178 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYCYLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:02:16 -0400
Date: Tue, 25 Mar 2008 07:02:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more simply.
Message-ID: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rewrite these source files more simply by deleting the superfluous
"tsk" task_struct pointer and rephrasing in terms of the "current"
task pointer.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  in addition to making the code slightly simpler, this makes it
easier to read since there's more information in:

  set_current_state(TASK_UNINTERRUPTIBLE);

as opposed to:

  set_task_state(tsk, TASK_UNINTERRUPTIBLE);

if it's not clear what "tsk" refers to.

  compile tested on x86 with "make defconfig", but that doesn't really
mean much since that configuration doesn't even compile the second of
those source files.  so i'll leave it to someone who's a locking
expert to sanity check this.  i'm quite willing to be told i screwed
something up.


 lib/rwsem-spinlock.c |   24 ++++++++++--------------
 lib/rwsem.c          |   11 +++++------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..8c3fc63 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -128,7 +128,6 @@ __rwsem_wake_one_writer(struct rw_semaphore *sem)
 void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk;

 	spin_lock_irq(&sem->wait_lock);

@@ -139,13 +138,12 @@ void __sched __down_read(struct rw_semaphore *sem)
 		goto out;
 	}

-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);

 	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.flags = RWSEM_WAITING_FOR_READ;
-	get_task_struct(tsk);
+	get_task_struct(current);

 	list_add_tail(&waiter.list, &sem->wait_list);

@@ -157,10 +155,10 @@ void __sched __down_read(struct rw_semaphore *sem)
 		if (!waiter.task)
 			break;
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 	}

-	tsk->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
  out:
 	;
 }
@@ -194,7 +192,6 @@ int __down_read_trylock(struct rw_semaphore *sem)
 void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk;

 	spin_lock_irq(&sem->wait_lock);

@@ -205,13 +202,12 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 		goto out;
 	}

-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);

 	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	get_task_struct(tsk);
+	get_task_struct(current);

 	list_add_tail(&waiter.list, &sem->wait_list);

@@ -223,10 +219,10 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 		if (!waiter.task)
 			break;
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 	}

-	tsk->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
  out:
 	;
 }
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 3e3365e..f1bdb97 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -150,15 +150,14 @@ static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
 			struct rwsem_waiter *waiter, signed long adjustment)
 {
-	struct task_struct *tsk = current;
 	signed long count;

-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);

 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
-	waiter->task = tsk;
-	get_task_struct(tsk);
+	waiter->task = current;
+	get_task_struct(current);

 	list_add_tail(&waiter->list, &sem->wait_list);

@@ -176,10 +175,10 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 		if (!waiter->task)
 			break;
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 	}

-	tsk->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);

 	return sem;
 }
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
