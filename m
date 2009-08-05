Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZHETFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZHETFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZHETFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:05:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40630 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZHETFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:05:24 -0400
Message-ID: <4A79D7F1.4000405@us.ibm.com>
Date: Wed, 05 Aug 2009 12:05:21 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [tip/urgent] Avoid deadlock in rt_mutex_start_proxy_lock()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

In the event of a lock steal or owner died, rt_mutex_start_proxy_lock() will
give the rt_mutex to the waiting task, but it fails to release the wait_lock.
This leads to subsequent deadlocks when other tasks try to acquire the
rt_mutex.

I also removed a few extra blank lines that really spaced this routine out.
I must have been high on the \n when I wrote this originally...

Note: This is the mainline version, a separate patch was sent for [RT]

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/rtmutex.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index fec77e7..0f2b9bb 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1039,16 +1039,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
 		/* We got the lock for task. */
 		debug_rt_mutex_lock(lock);
-
 		rt_mutex_set_owner(lock, task, 0);
-
+		spin_unlock(&lock->wait_lock);
 		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
-
 	if (ret && !waiter->task) {
 		/*
 		 * Reset the return value. We might have
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
