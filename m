Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbYESRkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbYESRkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760741AbYESRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:39:54 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:45698
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760458AbYESRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:39:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/8] rearrange rt_spin_lock_slowlock sleeping code
To: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, pavel@ucw.cz, acme@redhat.com,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Mon, 19 May 2008 13:07:22 -0400
Message-ID: <20080519170721.6820.47680.stgit@novell1.haskins.net>
In-Reply-To: <20080519170356.6820.5274.stgit@novell1.haskins.net>
References: <20080519170356.6820.5274.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic makes rather coarse adjustments to current->state since
it is planning on sleeping anyway.  We want to eventually move to an
adaptive (e.g. optional sleep) algorithm, so we tighten the scope of the
adjustments to bracket the schedule().  This should yield correct behavior
with or without the adaptive features that are added later in the series.
We add it here as a separate patch for greater review clarity on smaller
changes.

Thanks to Steven Rostedt for suggesting a cleanup to remove an extra
update_current(RUNNING_MUTEX) left over from the early days of
instrumentation.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 0d3f76f..223557f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -666,6 +666,14 @@ rt_spin_lock_fastunlock(struct rt_mutex *lock,
 		slowfn(lock);
 }
 
+static inline void
+update_current(unsigned long new_state, unsigned long *saved_state)
+{
+	unsigned long state = xchg(&current->state, new_state);
+	if (unlikely(state == TASK_RUNNING))
+		*saved_state = TASK_RUNNING;
+}
+
 /*
  * Slow path lock function spin_lock style: this variant is very
  * careful not to miss any non-lock wakeups.
@@ -705,7 +713,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * saved_state accordingly. If we did not get a real wakeup
 	 * then we return with the saved state.
 	 */
-	saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+	saved_state = current->state;
 
 	for (;;) {
 		unsigned long saved_flags;
@@ -737,14 +745,13 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		schedule_rt_mutex(lock);
+		update_current(TASK_UNINTERRUPTIBLE, &saved_state);
+		if (waiter.task)
+			schedule_rt_mutex(lock);
 
 		spin_lock_irqsave(&lock->wait_lock, flags);
 		current->flags |= saved_flags;
 		current->lock_depth = saved_lock_depth;
-		state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
-		if (unlikely(state == TASK_RUNNING))
-			saved_state = TASK_RUNNING;
 	}
 
 	state = xchg(&current->state, saved_state);

