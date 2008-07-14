Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYGNF7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYGNF7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYGNF73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:59:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:41865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYGNF72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:59:28 -0400
Message-ID: <487AEAC6.60307@kernel.org>
Date: Mon, 14 Jul 2008 14:57:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 05:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of preemptible RCU, RCU doesn't gurantee that
its critical section runs on the CPU it started to run.  As there are
cases where non-preemptible RCU critical section makes sense, create
new RCU read lock variants which turns of preemption -
rcu_read_[un]lock_preempt() which are identical to rcu_read_[un]lock()
for classic implementation and have enclosing preempt disable/enable
for preemptible RCU.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This will be used by following block layer updates.  If this and the
block changes get acked, it'll be best to push this through block
tree.

Thanks.

 include/linux/rcuclassic.h |    2 ++
 include/linux/rcupdate.h   |   18 ++++++++++++++++++
 include/linux/rcupreempt.h |    6 ++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index b3aa05b..08c6153 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -136,6 +136,8 @@ extern struct lockdep_map rcu_lock_map;
 		__release(RCU); \
 		preempt_enable(); \
 	} while (0)
+#define __rcu_read_lock_preempt()	__rcu_read_lock()
+#define __rcu_read_unlock_preempt()	__rcu_read_unlock()
 #define __rcu_read_lock_bh() \
 	do { \
 		local_bh_disable(); \
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d42dbec..e0e3486 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -112,6 +112,24 @@ struct rcu_head {
 #define rcu_read_unlock() __rcu_read_unlock()
 
 /**
+ * rcu_read_lock_preempt - mark the beginning of non-preemptible RCU
+ *			   critical section
+ *
+ * Identical to rcu_read_lock() but the critical section is guaranteed
+ * to be non-preemptible.  Note that this is identical to
+ * rcu_read_lock() on classic RCU implementation.
+ */
+#define rcu_read_lock_preempt() __rcu_read_lock_preempt()
+
+/**
+ * rcu_read_unlock_preempt - mark the end of of non-preemptible RCU
+ *			     critical section
+ *
+ * See rcu_read_lock_preempt() for more information.
+ */
+#define rcu_read_unlock_preempt() __rcu_read_unlock_preempt()
+
+/**
  * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
  *
  * This is equivalent of rcu_read_lock(), but to be used when updates
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 8a05c7e..b263ceb 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -49,8 +49,10 @@ extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
-#define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
-#define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
+#define __rcu_read_lock_preempt()	{ rcu_read_lock(); preempt_disable(); }
+#define __rcu_read_unlock_preempt()	{ preempt_enable(); rcu_read_unlock(); }
+#define __rcu_read_lock_bh()		{ rcu_read_lock(); local_bh_disable(); }
+#define __rcu_read_unlock_bh()		{ local_bh_enable(); rcu_read_unlock(); }
 
 extern void __synchronize_sched(void);
 
-- 
1.5.4.5

