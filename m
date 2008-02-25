Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYBYQao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYBYQao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYBYQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:24 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53920
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756564AbYBYQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:23 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 4/9] optimize rt lock wakeup
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:00:58 -0500
Message-ID: <20080225160058.11268.96036.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is redundant to wake the grantee task if it is already running

Credit goes to Peter for the general idea.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Morreale <pmorreale@novell.com>
---

 kernel/rtmutex.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index ef52db6..bf9e230 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -531,6 +531,41 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 	pendowner = waiter->task;
 	waiter->task = NULL;
 
+	/*
+	 * Do the wakeup before the ownership change to give any spinning
+	 * waiter grantees a headstart over the other threads that will
+	 * trigger once owner changes.
+	 */
+	if (!savestate)
+		wake_up_process(pendowner);
+	else {
+		/*
+		 * We can skip the actual (expensive) wakeup if the
+		 * waiter is already running, but we have to be careful
+		 * of race conditions because they may be about to sleep.
+		 *
+		 * The waiter-side protocol has the following pattern:
+		 * 1: Set state != RUNNING
+		 * 2: Conditionally sleep if waiter->task != NULL;
+		 *
+		 * And the owner-side has the following:
+		 * A: Set waiter->task = NULL
+		 * B: Conditionally wake if the state != RUNNING
+		 *
+		 * As long as we ensure 1->2 order, and A->B order, we
+		 * will never miss a wakeup.
+		 *
+		 * Therefore, this barrier ensures that waiter->task = NULL
+		 * is visible before we test the pendowner->state.  The
+		 * corresponding barrier is in the sleep logic.
+		 */
+		smp_mb();
+
+		if ((pendowner->state != TASK_RUNNING)
+		    && (pendowner->state != TASK_RUNNING_MUTEX))
+			wake_up_process_mutex(pendowner);
+	}
+
 	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
 
 	spin_unlock(&current->pi_lock);
@@ -557,11 +592,6 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
 	}
 	spin_unlock(&pendowner->pi_lock);
-
-	if (savestate)
-		wake_up_process_mutex(pendowner);
-	else
-		wake_up_process(pendowner);
 }
 
 /*
@@ -762,6 +792,11 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 		debug_rt_mutex_print_deadlock(&waiter);
 
 		update_current(TASK_UNINTERRUPTIBLE, &saved_state);
+		/*
+		 * The xchg() in update_current() is an implicit barrier
+		 * which we rely upon to ensure current->state is visible
+		 * before we test waiter.task.
+		 */
 		if (waiter.task)
 			schedule_rt_mutex(lock);
 		else

