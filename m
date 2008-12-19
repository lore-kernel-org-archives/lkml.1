Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYLSQU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYLSQU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYLSQTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:19:07 -0500
Received: from www.tglx.de ([62.245.132.106]:48551 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYLSQTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:19:01 -0500
Message-Id: <20081219155556.225401784@linutronix.de>
References: <20081219155504.735865178@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 16:03:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 6/7] rtmutex: remove useless schedule enforcement
Content-Disposition: inline;
	filename=rtmutex-remove-useless-schedule-enforcement.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For !mtx the call to schedule() is forced even if the waiter is
already woken (waiter.task == NULL).

This makes no sense at all and is just waste.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.orig/kernel/rtmutex.c
+++ linux-2.6.24/kernel/rtmutex.c
@@ -1411,7 +1411,7 @@ rt_read_slowlock(struct rw_mutex *rwm, i
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (!mtx || waiter.task)
+		if (waiter.task)
 			schedule_rt_mutex(mutex);
 
 		spin_lock_irqsave(&mutex->wait_lock, flags);
@@ -1557,7 +1557,7 @@ rt_write_slowlock(struct rw_mutex *rwm, 
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (!mtx || waiter.task)
+		if (waiter.task)
 			schedule_rt_mutex(mutex);
 
 		spin_lock_irqsave(&mutex->wait_lock, flags);

-- 

