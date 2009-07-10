Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZGJOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZGJOu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZGJOuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:50:02 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:16238 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZGJOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sJRRkwunpPNESB2qnLB9eFIHoOCkGmEcMXokdGNPM69Qvs5xYTKiLNiNnl2OtARQRJ
         CUjh5QMey64d9oyoXiSdvwdTCvGSlBnboj6gjC7i0g9d00A5GHp02onZwzg0Q7DOETDn
         w705+mdD1CHaB3+L7WUA02r0RV+ibJKEUXEO8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] sched: Move the sleeping while atomic checks early in cond_resched()
Date: Fri, 10 Jul 2009 16:49:51 +0200
Message-Id: <1247237391-5352-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might_sleep() is called lately in cond_resched(), after the
need_resched()/preempt enabled/system running tests are checked.

It's better to check the sleeps while atomic earlier and not depend
on some environment datas that reduce the chances to detect a
problem.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 ++
 kernel/sched.c        |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0cb0d8d..e357dc7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2279,11 +2279,13 @@ extern int _cond_resched(void);
 #ifdef CONFIG_PREEMPT_BKL
 static inline int cond_resched(void)
 {
+	might_sleep();
 	return 0;
 }
 #else
 static inline int cond_resched(void)
 {
+	might_sleep();
 	return _cond_resched();
 }
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 87ecac1..c22804b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6605,9 +6605,6 @@ SYSCALL_DEFINE0(sched_yield)
 
 static void __cond_resched(void)
 {
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-	__might_sleep(__FILE__, __LINE__);
-#endif
 	/*
 	 * The BKS might be reacquired before we have dropped
 	 * PREEMPT_ACTIVE, which could trigger a second
-- 
1.6.2.3

