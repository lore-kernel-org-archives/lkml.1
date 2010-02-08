Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0BHTmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:42:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0BHTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:42:19 -0500
Subject: Re: lockdep rcu-preempt and synchronize_srcu() awareness
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100208191858.GA16288@Krystal>
References: <20100208191858.GA16288@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 20:41:29 +0100
Message-ID: <1265658089.11509.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 14:18 -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> I just though about the following deadlock scenario involving rcu preempt and
> mutexes. I see that lockdep does not warn about it, and it actually triggers a
> deadlock on my box. It might be worth addressing for TREE_PREEMPT_RCU configs.
> 
> CPU A:
>     mutex_lock(&test_mutex);
>     synchronize_rcu();
>     mutex_unlock(&test_mutex);
> 
> CPU B:
>     rcu_read_lock();
>     mutex_lock(&test_mutex);
>     mutex_unlock(&test_mutex);
>     rcu_read_unlock();
> 
> But given that it's not legit to take a mutex from within a rcu read lock in
> non-preemptible configs, I guess it's not much of a real-life problem, but I
> think SRCU is also affected, because there is no lockdep annotation around
> synchronize_srcu().

Right, even if there were, the lockdep rcu_read_lock annotation is
check==1, lockdep needs significant work to properly deal with fully
recursive locks such as rcu_read_lock(), the read side of rwlock_t and
cpu-hotplug.

Both ego and myself have been poking at that at various times but never
followed through, I think the last series is:
  http://lkml.org/lkml/2009/5/11/203

Once we have lock_acquire(.check=2, .read=2) working properly, adding
the above annotation is trivial, basically add:

	lock_acquire(&rcu_lock_map, 0, 0, 0, 2, NULL, _THIS_IP_);
	lock_release(&rcu_lock_map, 0, _THIS_IP_);

To the various synchronize_*() primitives with the respective lock_map.

> 
> So I think it would be good to mark rcu_read_lock/unlock as not permitting
> "might_sleep()" in non preemptable RCU configs, and having a look at lockdep
> SRCU support might be worthwhile.

commit 234da7bcdc7aaa935846534c3b726dbc79a9cdd5
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Dec 16 20:21:05 2009 +0100

    sched: Teach might_sleep() about preemptible RCU
    
    In practice, it is harmless to voluntarily sleep in a
    rcu_read_lock() section if we are running under preempt rcu, but
    it is illegal if we build a kernel running non-preemptable rcu.
    
    Currently, might_sleep() doesn't notice sleepable operations
    under rcu_read_lock() sections if we are running under
    preemptable rcu because preempt_count() is left untouched after
    rcu_read_lock() in this case. But we want developers who test
    their changes under such config to notice the "sleeping while
    atomic" issues.
    
    So we add rcu_read_lock_nesting to prempt_count() in
    might_sleep() checks.
    
    [ v2: Handle rcu-tiny ]
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    LKML-Reference: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c4ba9a7..96cc307 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -101,4 +101,9 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c93eee5..8044b1b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,6 +45,12 @@ extern void __rcu_read_unlock(void);
 extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
+/*
+ * Defined as macro as it is a very low level header
+ * included from areas that don't even know about current
+ */
+#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
@@ -63,6 +69,11 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock_bh(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index af7dfa7..7be88a7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9682,7 +9682,7 @@ void __init sched_init(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
-	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
 
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }


