Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZGROWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZGROWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZGROWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:22:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZGROWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:22:35 -0400
Date: Sat, 18 Jul 2009 14:21:58 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-3-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Cover the CONFIG_DEBUG_SPINLOCK_SLEEP off-case for __might_sleep()
Message-ID: <tip-e09758fae8ccde97e026c704319eaa18d488dc86@git.kernel.org>
Git-Commit-ID: e09758fae8ccde97e026c704319eaa18d488dc86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:21:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e09758fae8ccde97e026c704319eaa18d488dc86
Gitweb:     http://git.kernel.org/tip/e09758fae8ccde97e026c704319eaa18d488dc86
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:41 +0200

sched: Cover the CONFIG_DEBUG_SPINLOCK_SLEEP off-case for __might_sleep()

Cover the off case for __might_sleep(), so that we avoid
#ifdefs in files that make use of it. Especially, this prepares
for the __might_sleep() pull up on cond_resched().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/kernel.h |    1 +
 kernel/sched.c         |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..b804f69 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -139,6 +139,7 @@ extern int _cond_resched(void);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
 #else
+  static inline void __might_sleep(char *file, int line) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 4d39e96..370a6c3 100644
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
