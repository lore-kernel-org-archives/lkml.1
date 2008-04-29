Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYD2Oi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYD2Oi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbYD2Ohj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49738 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbYD2Ohi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:38 -0400
Message-Id: <20080429143728.904849000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:06 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 02/10] Introduce the ridr structure
Content-Disposition: inline; filename=ridr_structure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/10]

This patch introduces the ridr structure as an RCU safe idr structure: a layer
is actually made of the existing idr layer, followed by the rcu head.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/idr.h  |    6 +++---
 include/linux/ridr.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 init/main.c          |    2 ++
 lib/Makefile         |    2 +-
 lib/idr.c            |    2 +-
 lib/ridr.c           |   26 ++++++++++++++++++++++++++
 6 files changed, 83 insertions(+), 5 deletions(-)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 13:08:00.000000000 +0200
@@ -0,0 +1,50 @@
+/*
+ * include/linux/ridr.h
+ *
+ * Small id to pointer translation service avoiding fixed sized
+ * tables. RCU-based implmentation of IDRs.
+ */
+
+#ifndef _RIDR_H_
+#define _RIDR_H_
+
+#include <linux/idr.h>
+#include <linux/rcupdate.h>
+
+/*
+ * The idr_layer part should stay at the beginning of the structure
+ */
+struct ridr_layer {
+	struct idr_layer idr;
+	struct rcu_head	 rcu_head;
+};
+
+struct ridr {
+	struct ridr_layer *top;
+	struct ridr_layer *id_free;
+	int		  layers;
+	int		  id_free_cnt;
+	spinlock_t	  lock;
+};
+
+#define RIDR_INIT(name)						\
+{								\
+	.top		= NULL,					\
+	.id_free	= NULL,					\
+	.layers 	= 0,					\
+	.id_free_cnt	= 0,					\
+	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+}
+#define DEFINE_RIDR(name)	struct ridr name = RIDR_INIT(name)
+
+#define idr_to_ridr(p) container_of((p), struct ridr_layer, idr)
+#define ridr_to_idr(p) (&((p)->idr))
+
+/*
+ * This is what we export.
+ */
+
+
+void __init ridr_init_cache(void);
+
+#endif /* _RIDR_H_ */
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 13:08:05.000000000 +0200
@@ -0,0 +1,26 @@
+/*
+ * RCU-based idr API
+ */
+
+
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/ridr.h>
+
+static struct kmem_cache *ridr_layer_cache;
+
+
+static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
+			void *ridr_layer)
+{
+	memset(ridr_layer, 0, sizeof(struct ridr_layer));
+}
+
+void __init ridr_init_cache(void)
+{
+	ridr_layer_cache = kmem_cache_create("ridr_layer_cache",
+				sizeof(struct ridr_layer), 0, SLAB_PANIC,
+				ridr_cache_ctor);
+}
+
Index: linux-2.6.25-mm1/lib/Makefile
===================================================================
--- linux-2.6.25-mm1.orig/lib/Makefile	2008-04-25 15:29:00.000000000 +0200
+++ linux-2.6.25-mm1/lib/Makefile	2008-04-25 15:57:39.000000000 +0200
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o ridr.o
 
 ifdef CONFIG_FTRACE
 # Do not profile string.o, since it may be used in early boot or vdso
Index: linux-2.6.25-mm1/init/main.c
===================================================================
--- linux-2.6.25-mm1.orig/init/main.c	2008-04-25 15:29:13.000000000 +0200
+++ linux-2.6.25-mm1/init/main.c	2008-04-25 15:58:15.000000000 +0200
@@ -61,6 +61,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/ridr.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -639,6 +640,7 @@ asmlinkage void __init start_kernel(void
 	kmem_cache_init();
 	debug_objects_mem_init();
 	idr_init_cache();
+	ridr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-25 17:22:43.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-04-29 13:08:05.000000000 +0200
@@ -342,7 +342,7 @@ static void sub_remove(struct idr *idp, 
 	while ((shift > 0) && p) {
 		n = (id >> shift) & IDR_MASK;
 		__clear_bit(n, &p->bitmap);
-		*++paa = &p->ary[n];
+		*++paa = (struct idr_layer **) &p->ary[n];
 		p = p->ary[n];
 		shift -= IDR_BITS;
 	}
Index: linux-2.6.25-mm1/include/linux/idr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-04-25 17:22:43.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/idr.h	2008-04-29 13:08:00.000000000 +0200
@@ -48,9 +48,9 @@
 #define IDR_FREE_MAX MAX_LEVEL + MAX_LEVEL
 
 struct idr_layer {
-	unsigned long		 bitmap; /* A zero bit means "space here" */
-	struct idr_layer	*ary[1<<IDR_BITS];
-	int			 count;	 /* When zero, we can release it */
+	unsigned long	 bitmap; /* A zero bit means "space here" */
+	void		*ary[1<<IDR_BITS];
+	int		 count;	 /* When zero, we can release it */
 };
 
 struct idr {

--
