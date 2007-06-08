Return-Path: <linux-kernel-owner+w=401wt.eu-S969382AbXFHOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969382AbXFHOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXFHOdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:33:18 -0400
Received: from www.osadl.org ([213.239.205.134]:57248 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030439AbXFHOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:33:17 -0400
Subject: [patch] lock debugging: loop nicer in mark_rt_mutex_waiters
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 16:33:14 +0200
Message-Id: <1181313194.4404.325.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Loop nicer in the mark_rt_mutex_waiters() busy loop.

Fix white space damage while at it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.22-rc4/kernel/rtmutex_common.h
===================================================================
--- linux-2.6.22-rc4.orig/kernel/rtmutex_common.h	2007-06-08 01:48:02.000000000 +0200
+++ linux-2.6.22-rc4/kernel/rtmutex_common.h	2007-06-08 16:25:55.000000000 +0200
@@ -103,7 +103,7 @@ static inline struct task_struct *rt_mut
 
 static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
 {
- 	return (struct task_struct *)
+	return (struct task_struct *)
 		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
 }
 
@@ -120,11 +120,13 @@ static inline unsigned long rt_mutex_own
 # define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
 static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 {
-	unsigned long owner, *p = (unsigned long *) &lock->owner;
+	unsigned long *p = (unsigned long *) &lock->owner;
+	unsigned long owner = *p;
 
-	do {
+	while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner) {
+		cpu_relax();
 		owner = *p;
-	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
+	}
 }
 #else
 # define rt_mutex_cmpxchg(l,c,n)	(0)


