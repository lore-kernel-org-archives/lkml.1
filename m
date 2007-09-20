Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXITSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXITSg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbXITSgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:36:19 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:49619 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXITSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:36:18 -0400
Subject: [RFC PATCH] Add CRC checksum for RCU lists
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 14:34:11 -0400
Message-Id: <1190313251.4518.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In recent development of the RT kernel, some of our experimental code
corrupted the rcu header. But the side effect (crashing) didn't rear its
ugly head until way after the fact. Discussing this with Paul, he
suggested that RCU should have a "self checking" mechanism to detect
these kind of issues. He also suggested putting in a CRC into the
rcu_head structure.

This patch does so.

Since there is a bit of overhead with adding this checking, I made it a
config option that would best be turned on for any development that uses
RCU callbacks.

The way this works is when CRC is configured, two elements are added to
the rcu_head. A crc (long to be consistent, although it only uses a
32bit value) and a caller.  The caller is location of who called the
call_rcu, which is very useful when a corruption does occur. Although,
another item may have corrupted the rcu_head, from my experience (the
crash we had), there are several of the same items that do the call_rcu
together.

On call_rcu, the checksum is created of the next pointer and the
function to call. The checksum algorithm is simply a XOR of some magic
number with each 4 bytes of the next and func pointer of the rcu_head.
This is then placed into the crc of the rcu_head as well as the return
address.

Various stages of RCU handling does a checksum of the RCU lists to make
sure that everything is what it expects it to be. Again, this does have
a slight performance impact (although I haven't noticed it with various
tasks, but I'm sure any benchmark will), so should be turned off on
production systems. This is focused on development only.

This patch also takes care to update the crc when rcu_head items are
moved from list to list and whenever the next pointer is modified due to
addition.

This is against the lastest git (as of this morning) so it does not
include Paul's recent patches for RCU preempt and RCU boost. For this
reason, this is a RFC patch since it would be better to apply this after
those other patches make it upstream. I do have a version of this patch
for the RT kernel that includes Paul's other patches.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fe17d7d..baca7e6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -50,13 +50,81 @@
 struct rcu_head {
 	struct rcu_head *next;
 	void (*func)(struct rcu_head *head);
+#ifdef CONFIG_RCU_CRC_HEADER_CHECK
+	/*
+	 * Checks are made in C files knowing that "next" is
+	 * the first element. So keep it the first element.
+	 */
+	unsigned long crc;
+	void *caller;
+#endif
 };
 
-#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
+#ifdef CONFIG_RCU_CRC_HEADER_CHECK
+
+#define RCU_CRC_MAGIC 0xC4809168UL
+
+static inline unsigned long rcu_crc_calc(struct rcu_head *head)
+{
+	unsigned int *p = (unsigned int*)head; /* 32 bit */
+	unsigned long crc = RCU_CRC_MAGIC;
+
+	for (p=(void *)head; (void*)p < (void*)&head->crc; p++)
+		crc ^= *p;
+	return crc;
+}
+
+static inline void rcu_crc_check(struct rcu_head *head)
+{
+	static int once;
+	if (unlikely(head->crc != rcu_crc_calc(head)) && !once) {
+		once++;
+		printk("BUG: RCU check failed!");
+		if (head->caller)
+			printk(" (caller=%p)",
+			       head->caller);
+		printk("\n");
+		printk("  CRC was %08lx, expected %08lx\n",
+		       head->crc, rcu_crc_calc(head));
+		printk("  %p %p\n",
+		       head->next, head->func);
+		dump_stack();
+	}
+}
+
+static inline void rcu_assign_crc(struct rcu_head *head)
+{
+	head->crc = rcu_crc_calc(head);
+	head->caller = __builtin_return_address(0);
+}
+
+static inline void rcu_check_list(struct rcu_head *head)
+{
+	int loop;
+	for (loop = 0;
+	     head != NULL && loop < 100;
+	     head=head->next, loop++)
+		rcu_crc_check(head);
+}
+
+# define RCU_CRC_INIT , .crc = RCU_CRC_MAGIC
+# define RCU_CRC_SET(ptr) (ptr)->crc = RCU_CRC_MAGIC
+
+#else
+# define rcu_crc_calc(head) 0
+# define rcu_crc_check(head) do { } while(0)
+# define rcu_assign_crc(head) do { } while(0)
+# define rcu_check_list(head) do { } while(0)
+# define RCU_CRC_INIT
+# define RCU_CRC_SET(ptr) do { } while(0)
+#endif /* CONFIG_RCU_CRC_HEADER_CHECK */
+
+#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL RCU_CRC_INIT }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
+#define INIT_RCU_HEAD(ptr) do {				\
+		(ptr)->next = NULL; (ptr)->func = NULL; \
+		RCU_CRC_SET(ptr);			\
+	} while (0)
 
 
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2c2dd84..4c3cc9c 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -76,6 +76,23 @@ static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
 
+#ifdef CONFIG_RCU_CRC_HEADER_CHECK
+#define rcu_check_rdp(rdp)			\
+	do {					\
+		rcu_check_list(rdp->nxtlist);	\
+		rcu_check_list(rdp->curlist);	\
+		rcu_check_list(rdp->donelist);	\
+	} while(0)
+#define rcu_crc_update_tail(rdp, tail, list)				\
+	do {								\
+		if ((rdp)->tail != &(rdp)->list)			\
+			rcu_assign_crc((struct rcu_head*)(rdp)->tail);	\
+	} while(0)
+#else
+# define rcu_check_rdp(rdp) do { } while(0)
+# define rcu_crc_update_tail(rdp, tail, list) do { } while(0)
+#endif
+
 #ifdef CONFIG_SMP
 static void force_quiescent_state(struct rcu_data *rdp,
 			struct rcu_ctrlblk *rcp)
@@ -122,14 +139,19 @@ void fastcall call_rcu(struct rcu_head *head,
 
 	head->func = func;
 	head->next = NULL;
+	rcu_assign_crc(head);
 	local_irq_save(flags);
 	rdp = &__get_cpu_var(rcu_data);
 	*rdp->nxttail = head;
+	rcu_crc_update_tail(rdp, nxttail, nxtlist);
 	rdp->nxttail = &head->next;
 	if (unlikely(++rdp->qlen > qhimark)) {
 		rdp->blimit = INT_MAX;
 		force_quiescent_state(rdp, &rcu_ctrlblk);
 	}
+
+	rcu_check_rdp(rdp);
+
 	local_irq_restore(flags);
 }
 
@@ -157,9 +179,11 @@ void fastcall call_rcu_bh(struct rcu_head *head,
 
 	head->func = func;
 	head->next = NULL;
+	rcu_assign_crc(head);
 	local_irq_save(flags);
 	rdp = &__get_cpu_var(rcu_bh_data);
 	*rdp->nxttail = head;
+	rcu_crc_update_tail(rdp, nxttail, nxtlist);
 	rdp->nxttail = &head->next;
 
 	if (unlikely(++rdp->qlen > qhimark)) {
@@ -167,6 +191,8 @@ void fastcall call_rcu_bh(struct rcu_head *head,
 		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
 	}
 
+	rcu_check_rdp(rdp);
+
 	local_irq_restore(flags);
 }
 
@@ -233,6 +259,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	struct rcu_head *next, *list;
 	int count = 0;
 
+	rcu_check_rdp(rdp);
+
 	list = rdp->donelist;
 	while (list) {
 		next = list->next;
@@ -373,6 +401,7 @@ static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
 {
 	local_irq_disable();
 	*this_rdp->nxttail = list;
+	rcu_crc_update_tail(this_rdp, nxttail, nxtlist);
 	if (list)
 		this_rdp->nxttail = tail;
 	local_irq_enable();
@@ -424,6 +453,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 {
 	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
 		*rdp->donetail = rdp->curlist;
+		rcu_crc_update_tail(rdp, donetail, donelist);
 		rdp->donetail = rdp->curtail;
 		rdp->curlist = NULL;
 		rdp->curtail = &rdp->curlist;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 50a94ee..981fc93 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -424,6 +424,17 @@ config RCU_TORTURE_TEST
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
+config RCU_CRC_HEADER_CHECK
+	bool "RCU header self check"
+	depends on DEBUG_KERNEL
+	help
+	  This option enables CRC verification of RCU lists to catch
+	  possible corruption to the RCU list by improper application
+	  of RCU callbacks. This adds overhead to the running system
+	  so only enable it if you suspect RCU corruption is occurring.
+
+	  If unsure, say N.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL


