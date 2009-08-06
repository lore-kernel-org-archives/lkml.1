Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZHFDxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZHFDxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZHFDxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:53:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZHFDxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:53:07 -0400
Date: Thu, 6 Aug 2009 03:51:57 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@linux.vnet.ibm.com, peterz@infradead.org,
       dino@in.ibm.com, rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, johnstul@linux.vnet.ibm.com,
       rostedt@goodmis.org, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A79D7F1.4000405@us.ibm.com>
References: <4A79D7F1.4000405@us.ibm.com>
Subject: [tip:core/urgent] rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()
Message-ID: <tip-1bbf20835c4e088667a090ce6523a0f70b62dc76@git.kernel.org>
Git-Commit-ID: 1bbf20835c4e088667a090ce6523a0f70b62dc76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 03:52:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bbf20835c4e088667a090ce6523a0f70b62dc76
Gitweb:     http://git.kernel.org/tip/1bbf20835c4e088667a090ce6523a0f70b62dc76
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Wed, 5 Aug 2009 12:05:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 Aug 2009 05:50:21 +0200

rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()

In the event of a lock steal or owner died,
rt_mutex_start_proxy_lock() will give the rt_mutex to the
waiting task, but it fails to release the wait_lock. This leads
to subsequent deadlocks when other tasks try to acquire the
rt_mutex.

I also removed a few extra blank lines that really spaced this
routine out. I must have been high on the \n when I wrote this
originally...

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
LKML-Reference: <4A79D7F1.4000405@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rtmutex.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index fcd107a..29bd4ba 100644
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
