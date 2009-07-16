Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZGPG2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZGPG2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZGPG2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:32 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:63897 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZGPG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u+2dU/mvviRd9v4PIzstmsiW8f4UEStD8M+R8hWpy1ViFIKNn7xAWC6nbEcsvfYMgD
         jjYrYjqCV59pOp7GsnQyeTJln1U1XQRH+s9kNs/z0RhBCEtncKgaYTQ1Kh044Fel3BYY
         oevlj7OaYcd6PBO8a/fP7Qb5IlfmbArtqkaoo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/7] sched: Convert the only user of cond_resched_bkl to use cond_resched()
Date: Thu, 16 Jul 2009 02:28:14 -0400
Message-Id: <1247725694-6082-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/locks.c:flock_lock_file() is the only user of cond_resched_bkl()

This helper doesn't do anything more than cond_resched(). The latter
naming is enough to explain that we are rescheduling if needed.

The bkl suffix suggests another semantics but it's actually
a synonym of cond_resched().

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/locks.c            |    2 +-
 include/linux/sched.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 09502f3..0fb66dd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -768,7 +768,7 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	 * give it the opportunity to lock the file.
 	 */
 	if (found)
-		cond_resched_bkl();
+		cond_resched();
 
 find_conflict:
 	for_each_lock(inode, before) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 099408f..d7ffd3f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2305,8 +2305,6 @@ extern int __cond_resched_softirq(void);
 	__cond_resched_softirq();				\
 })
 
-#define cond_resched_bkl()	cond_resched()
-
 /*
  * Does a critical section need to be broken due to another
  * task waiting?: (technically does not depend on CONFIG_PREEMPT,
-- 
1.6.2.3

