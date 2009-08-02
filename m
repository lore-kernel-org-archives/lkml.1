Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZHBNMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZHBNMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZHBNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:12:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZHBNMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:12:09 -0400
Date: Sun, 2 Aug 2009 13:11:32 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1248458723-12146-1-git-send-email-fweisbec@gmail.com>
References: <1248458723-12146-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Fix cond_resched_lock() in !CONFIG_PREEMPT
Message-ID: <tip-716a42348cdaf04534b15fbdc9c83e25baebfed5@git.kernel.org>
Git-Commit-ID: 716a42348cdaf04534b15fbdc9c83e25baebfed5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:11:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  716a42348cdaf04534b15fbdc9c83e25baebfed5
Gitweb:     http://git.kernel.org/tip/716a42348cdaf04534b15fbdc9c83e25baebfed5
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 24 Jul 2009 20:05:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:03:57 +0200

sched: Fix cond_resched_lock() in !CONFIG_PREEMPT

The might_sleep() test inside cond_resched_lock() assumes the
spinlock is held and then preemption is disabled. This is true
with CONFIG_PREEMPT but the preempt_count() doesn't change
otherwise.

Check by starting from the appropriate preempt offset depending
on the config.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1248458723-12146-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cbbfca6..c472414 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2293,8 +2293,14 @@ extern int _cond_resched(void);
 
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
 
