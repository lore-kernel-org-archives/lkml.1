Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbXFFCRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbXFFCRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 22:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbXFFCRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 22:17:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58055 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbXFFCRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 22:17:31 -0400
Subject: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 19:17:23 -0700
Message-Id: <1181096244.6018.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,
	So we've been seeing the following trace fairly frequently on our SMP
boxes when running kernbench:

BUG: at kernel/softirq.c:639 __tasklet_action()

Call Trace:
 [<ffffffff8106d5da>] dump_trace+0xaa/0x32a
 [<ffffffff8106d89b>] show_trace+0x41/0x5c
 [<ffffffff8106d8cb>] dump_stack+0x15/0x17
 [<ffffffff81094a97>] __tasklet_action+0xdf/0x12e
 [<ffffffff81094f76>] tasklet_action+0x27/0x29
 [<ffffffff8109530a>] ksoftirqd+0x16c/0x271
 [<ffffffff81033d4d>] kthread+0xf5/0x128
 [<ffffffff8105ff68>] child_rip+0xa/0x12


Paul also pointed this out awhile back: http://lkml.org/lkml/2007/2/25/1


Anyway, I think I finally found the issue. Its a bit hard to explain,
but the idea is while __tasklet_action is running the tasklet function
on CPU1, if a call to tasklet_schedule() on CPU2 is made, and if right
after we mark the TASKLET_STATE_SCHED bit we are preempted,
__tasklet_action on CPU1 might be able to re-run the function, clear the
bit and unlock the tasklet before CPU2 enters __tasklet_common_schedule.
Once __tasklet_common_schedule locks the tasklet, we will add the
tasklet to the list with the TASKLET_STATE_SCHED *unset*. 

I've verified this race occurs w/ a WARN_ON in
__tasklet_common_schedule().


This fix avoids this race by making sure *after* we've locked the
tasklet that the STATE_SCHED bit is set before adding it to the list.

Does it look ok to you?

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: 2.6-rt/kernel/softirq.c
===================================================================
--- 2.6-rt.orig/kernel/softirq.c	2007-06-05 18:30:54.000000000 -0700
+++ 2.6-rt/kernel/softirq.c	2007-06-05 18:36:44.000000000 -0700
@@ -544,10 +544,17 @@ static void inline
 __tasklet_common_schedule(struct tasklet_struct *t, struct tasklet_head *head, unsigned int nr)
 {
 	if (tasklet_trylock(t)) {
-		WARN_ON(t->next != NULL);
-		t->next = head->list;
-		head->list = t;
-		raise_softirq_irqoff(nr);
+		/* We may have been preempted before tasklet_trylock
+		 * and __tasklet_action may have already run.
+		 * So double check the sched bit while the takslet
+		 * is locked before adding it to the list.
+		 */
+		if (test_bit(TASKLET_STATE_SCHED, &t->state)) {
+			WARN_ON(t->next != NULL);
+			t->next = head->list;
+			head->list = t;
+			raise_softirq_irqoff(nr);
+		}
 		tasklet_unlock(t);
 	}
 }


