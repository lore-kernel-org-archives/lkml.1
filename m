Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZGXSF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZGXSF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZGXSF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:05:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:40602 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZGXSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YGZ4S6FQeOZ0OflxOm9jKWiq+WAzDzuFF1+5LaXBgNBzJ72Rc8qx0dVp3PeNcgdiPH
         CreGEGezcS9N92DeQ9FhWLfhYxb5dVq8OiYY2c6LphwTcm7HPU8krG0NsFqdQzZkVOyo
         zL3M7ZhW2wpoWbei1i1+NFT2AYgyEwyL25DS4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Fix cond_resched_lock() in !CONFIG_PREEMPT
Date: Fri, 24 Jul 2009 20:05:23 +0200
Message-Id: <1248458723-12146-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The might_sleep() test inside cond_resched_lock() assumes the spinlock
is held and then preemption is disabled. This is true with CONFIG_PREEMPT
but the preempt_count() doesn't change otherwise.

Check by starting from the appropriate preempt offset depending on the
config.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cb070dc..2c35bc2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2294,8 +2294,14 @@ extern int _cond_resched(void);
 
 extern int __cond_resched_lock(spinlock_t *lock);
 
+#ifdef CONFIG_PREEMPT
+#define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
+#else
+#define PREEMPT_LOCK_OFFSET	0
+#endif
+
 #define cond_resched_lock(lock) ({				\
-	__might_sleep(__FILE__, __LINE__, PREEMPT_OFFSET);	\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
 	__cond_resched_lock(lock);				\
 })
 
-- 
1.6.2.3

