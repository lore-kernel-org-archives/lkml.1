Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZGROXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZGROXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGROXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:23:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZGROX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:23:28 -0400
Date: Sat, 18 Jul 2009 14:22:47 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-7-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-7-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Convert the only user of cond_resched_bkl to use cond_resched()
Message-ID: <tip-def01bc53d03881acfc393bd10a5c7575187e008@git.kernel.org>
Git-Commit-ID: def01bc53d03881acfc393bd10a5c7575187e008
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:22:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  def01bc53d03881acfc393bd10a5c7575187e008
Gitweb:     http://git.kernel.org/tip/def01bc53d03881acfc393bd10a5c7575187e008
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:45 +0200

sched: Convert the only user of cond_resched_bkl to use cond_resched()

fs/locks.c:flock_lock_file() is the only user of
cond_resched_bkl()

This helper doesn't do anything more than cond_resched(). The
latter naming is enough to explain that we are rescheduling if
needed.

The bkl suffix suggests another semantics but it's actually a
synonym of cond_resched().

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-7-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/locks.c            |    2 +-
 include/linux/sched.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b6440f5..2eb8197 100644
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
index c41d424..cbbfca6 100644
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
