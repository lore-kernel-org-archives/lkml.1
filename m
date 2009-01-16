Return-Path: <linux-kernel-owner+w=401wt.eu-S934730AbZAPNre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbZAPNre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZAPNqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:46:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765572AbZAPNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:46:49 -0500
Subject: Re: [PATCH v3 0/2] fixes for tip/sched/rt
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, rostedt@home.goodmis.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090116133530.GA23674@elte.hu>
References: <496DE6E4.1010209@novell.com>
	 <20090114144317.11627.69111.stgit@dev.haskins.net>
	 <20090115123051.GA21096@elte.hu>  <20090116133530.GA23674@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 14:46:40 +0100
Message-Id: <1232113600.14073.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 14:35 +0100, Ingo Molnar wrote:
> here's a new build failure with tip/sched/rt:
> 
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `set_curr_task_rt':
> sched.c:(.text+0x3675): undefined reference to `plist_del'
> kernel/built-in.o: In function `pick_next_task_rt':
> sched.c:(.text+0x37ce): undefined reference to `plist_del'
> kernel/built-in.o: In function `enqueue_pushable_task':
> sched.c:(.text+0x381c): undefined reference to `plist_del'

diff --git a/init/Kconfig b/init/Kconfig
index 6504ca6..3e66d41 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -995,7 +995,6 @@ config SLABINFO
 
 config RT_MUTEXES
 	boolean
-	select PLIST
 
 config BASE_SMALL
 	int
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b859faf..c3fe932 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -114,14 +114,23 @@ static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 
 #else
 
+static inline void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
+{
+}
+
 static inline
-void enqueue_pushable_task(struct rq *rq, struct task_struct *p) {}
-static inline
-void dequeue_pushable_task(struct rq *rq, struct task_struct *p) {}
-static inline
-void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
+void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+}
+
 static inline
-void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
+void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) 
+{
+}
 
 #endif /* CONFIG_SMP */
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 03c2c24..fc8ea1c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -136,12 +136,6 @@ config TEXTSEARCH_BM
 config TEXTSEARCH_FSM
 	tristate
 
-#
-# plist support is select#ed if needed
-#
-config PLIST
-	boolean
-
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..902d738 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o \
+	 is_single_threaded.o plist.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -40,7 +41,6 @@ lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
-obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o


