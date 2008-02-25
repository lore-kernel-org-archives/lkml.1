Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYBYQa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYBYQa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYBYQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:19 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53906
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756118AbYBYQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:18 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 3/9] rearrange rt_spin_lock sleep
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:00:53 -0500
Message-ID: <20080225160053.11268.60719.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
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

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index cd39c26..ef52db6 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -681,6 +681,14 @@ rt_spin_lock_fastunlock(struct rt_mutex *lock,
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
@@ -720,7 +728,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	 * saved_state accordingly. If we did not get a real wakeup
 	 * then we return with the saved state.
 	 */
-	saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+	saved_state = current->state;
+	smp_mb();
 
 	for (;;) {
 		unsigned long saved_flags;
@@ -752,14 +761,15 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		schedule_rt_mutex(lock);
+		update_current(TASK_UNINTERRUPTIBLE, &saved_state);
+		if (waiter.task)
+			schedule_rt_mutex(lock);
+		else
+			update_current(TASK_RUNNING_MUTEX, &saved_state);
 
 		spin_lock_irqsave(&lock->wait_lock, flags);
 		current->flags |= saved_flags;
 		current->lock_depth = saved_lock_depth;
-		state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
-		if (unlikely(state == TASK_RUNNING))
-			saved_state = TASK_RUNNING;
 	}
 
 	state = xchg(&current->state, saved_state);

