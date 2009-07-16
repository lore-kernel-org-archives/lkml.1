Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZGPG2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZGPG2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZGPG2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:59564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZGPG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FR0g67I1pe5VYlQVGH/K/MH3UTCnR/MheW8RaP2MEc2WsdVC9nA3/ye+kTATDqUz1m
         79VjK1iDzR38nYilLukxX6gbfyl+3fsnVOww2Cww827VhjA/jEcehsSJTBpAV1SByX6h
         uP0FEnaRHJSZsxhGvH0IALj8aRi7/eKP/EUV0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] sched: Cover the CONFIG_DEBUG_SPINLOCK_SLEEP off-case for __might_sleep()
Date: Thu, 16 Jul 2009 02:28:10 -0400
Message-Id: <1247725694-6082-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cover the off case for __might_sleep(), so that we avoid #ifdefs
in files that make use of it. Especially, this prepares for the
__might_sleep() pull up on cond_resched().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra a.p.zijlstra@chello.nl
---
 include/linux/kernel.h |    1 +
 kernel/sched.c         |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b0ff486..99882e8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -231,6 +231,7 @@ extern int _cond_resched(void);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
 #else
+  static inline void __might_sleep(char *file, int line) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index bb11547..ac334ba 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6610,9 +6610,8 @@ static inline int should_resched(void)
 
 static void __cond_resched(void)
 {
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 	__might_sleep(__FILE__, __LINE__);
-#endif
+
 	add_preempt_count(PREEMPT_ACTIVE);
 	schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
-- 
1.6.2.3

