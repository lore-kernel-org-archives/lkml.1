Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbYBUP5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbYBUP5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765066AbYBUPy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:29 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41333
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764939AbYBUPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:28 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 06/14] optimize rt lock wakeup
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:26:56 -0500
Message-ID: <20080221152656.4804.92248.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
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

 kernel/rtmutex.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 15fc6e6..cb27b08 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -511,6 +511,24 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
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
+		smp_mb();
+		/*
+		 * This may appear to be a race, but the barriers close the
+		 * window.
+		 */
+		if ((pendowner->state != TASK_RUNNING)
+		    && (pendowner->state != TASK_RUNNING_MUTEX))
+			wake_up_process_mutex(pendowner);
+	}
+
 	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
 
 	spin_unlock(&current->pi_lock);
@@ -537,11 +555,6 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
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

