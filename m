Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbYETPXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbYETPXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbYETPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:22:04 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:57754
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933703AbYETPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:22:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/5] adjust pi_lock usage in wakeup
To: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com, ghaskins@novell.com
Date: Tue, 20 May 2008 10:49:31 -0400
Message-ID: <20080520144931.15992.96875.stgit@novell1.haskins.net>
In-Reply-To: <20080520143954.15992.85900.stgit@novell1.haskins.net>
References: <20080520143954.15992.85900.stgit@novell1.haskins.net>
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

Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index b6ff1eb..ec1f7d4 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -506,6 +506,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 {
 	struct rt_mutex_waiter *waiter;
 	struct task_struct *pendowner;
+	struct rt_mutex_waiter *next;
 
 	spin_lock(&current->pi_lock);
 
@@ -568,6 +569,12 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
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
@@ -576,12 +583,9 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 
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
 

