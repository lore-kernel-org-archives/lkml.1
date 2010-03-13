Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab0CMAYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:24:38 -0500
Received: from kroah.org ([198.145.64.141]:32904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934942Ab0CMAVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.812359063@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [patch 122/123] sched: Dont use possibly stale sched_class
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 83ab0aa0d5623d823444db82c3b3c34d7ec364ae upstream.

setscheduler() saves task->sched_class outside of the rq->lock held
region for a check after the setscheduler changes have become
effective. That might result in checking a stale value.

rtmutex_setprio() has the same problem, though it is protected by
p->pi_lock against setscheduler(), but for correctness sake (and to
avoid bad examples) it needs to be fixed as well.

Retrieve task->sched_class inside of the rq->lock held region.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6065,7 +6065,7 @@ void rt_mutex_setprio(struct task_struct
 	unsigned long flags;
 	int oldprio, on_rq, running;
 	struct rq *rq;
-	const struct sched_class *prev_class = p->sched_class;
+	const struct sched_class *prev_class;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
@@ -6073,6 +6073,7 @@ void rt_mutex_setprio(struct task_struct
 	update_rq_clock(rq);
 
 	oldprio = p->prio;
+	prev_class = p->sched_class;
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -6292,7 +6293,7 @@ static int __sched_setscheduler(struct t
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
-	const struct sched_class *prev_class = p->sched_class;
+	const struct sched_class *prev_class;
 	struct rq *rq;
 	int reset_on_fork;
 
@@ -6406,6 +6407,7 @@ recheck:
 	p->sched_reset_on_fork = reset_on_fork;
 
 	oldprio = p->prio;
+	prev_class = p->sched_class;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)


