Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbYBUP7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbYBUP7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbYBUPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:51 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41375
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932450AbYBUPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:48 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 10/14] adjust pi_lock usage in wakeup
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:27:17 -0500
Message-ID: <20080221152717.4804.56212.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter W.Morreale <pmorreale@novell.com>

In wakeup_next_waiter(), we take the pi_lock, and then find out whether
we have another waiter to add to the pending owner.  We can reduce
contention on the pi_lock for the pending owner if we first obtain the
pointer to the next waiter outside of the pi_lock.

This patch adds a measureable increase in throughput.

Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
---

 kernel/rtmutex.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a7ed7b2..122f143 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -505,6 +505,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 {
 	struct rt_mutex_waiter *waiter;
 	struct task_struct *pendowner;
+	struct rt_mutex_waiter *next;
 
 	spin_lock(&current->pi_lock);
 
@@ -549,6 +550,12 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 	 * waiter with higher priority than pending-owner->normal_prio
 	 * is blocked on the unboosted (pending) owner.
 	 */
+
+	if (rt_mutex_has_waiters(lock))
+		next = rt_mutex_top_waiter(lock);
+	else
+		next = NULL;
+
 	spin_lock(&pendowner->pi_lock);
 
 	WARN_ON(!pendowner->pi_blocked_on);
@@ -557,12 +564,9 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 
 	pendowner->pi_blocked_on = NULL;
 
-	if (rt_mutex_has_waiters(lock)) {
-		struct rt_mutex_waiter *next;
-
-		next = rt_mutex_top_waiter(lock);
+	if (next)
 		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
-	}
+
 	spin_unlock(&pendowner->pi_lock);
 }
 

