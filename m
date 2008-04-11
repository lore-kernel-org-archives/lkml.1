Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbYDKQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbYDKQVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760414AbYDKQU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34215 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbYDKQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:25 -0400
Message-Id: <20080411161957.931693000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:04 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 02/13] Change ridr structure
Content-Disposition: inline; filename=change_ridr_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/13]

This patch changes the ridr structures to make them use RCU.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

Index: linux-2.6.25-rc8-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-rc8-mm1.orig/include/linux/ridr.h	2008-04-11 17:17:41.000000000 +0200
+++ linux-2.6.25-rc8-mm1/include/linux/ridr.h	2008-04-11 17:34:35.000000000 +0200
@@ -9,41 +9,53 @@
 #define _RIDR_H_
 
 #include <linux/idr.h>
+#include <linux/rcupdate.h>
 
 struct ridr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct ridr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	struct rcu_head		 rcu_head;
 };
 
 struct ridr {
-	struct ridr_layer *top;
-	struct ridr_layer *id_free;
 	int		  layers;
-	int		  id_free_cnt;
-	spinlock_t	  lock;
+	gfp_t		  gfp_mask;
+	struct ridr_layer *top;
 };
 
-#define RIDR_INIT(name)						\
+#define RIDR_INIT(mask)						\
 {								\
-	.top		= NULL,					\
-	.id_free	= NULL,					\
 	.layers 	= 0,					\
-	.id_free_cnt	= 0,					\
-	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+	.gfp_mask 	= (mask),				\
+	.top		= NULL,					\
 }
-#define DEFINE_RIDR(name)	struct ridr name = RIDR_INIT(name)
+#define DEFINE_RIDR(name, mask)	struct ridr name = RIDR_INIT(mask)
 
-#define INIT_RIDR(name)							\
+#define INIT_RIDR(name, mask)						\
 do {									\
-	(name)->top		= NULL;					\
-	(name)->id_free		= NULL;					\
 	(name)->layers		= 0;					\
-	(name)->id_free_cnt	= 0;					\
-	(name)->lock		= __SPIN_LOCK_UNLOCKED(name.lock);	\
+	(name)->gfp_mask 	= (mask);				\
+	(name)->top		= NULL;					\
 } while (0)
 
 
+/**
+ * Ridr synchronization (see radix-tree.h)
+ *
+ * ridr_find() is able to be called locklessly, using RCU. The caller must
+ * ensure calls to this function are made within rcu_read_lock() regions.
+ * Other readers (lock-free or otherwise) and modifications may be running
+ * concurrently.
+ *
+ * It is still required that the caller manage the synchronization and
+ * lifetimes of the items. So if RCU lock-free lookups are used, typically
+ * this would mean that the items have their own locks, or are amenable to
+ * lock-free access; and that the items are freed by RCU (or only freed after
+ * having been deleted from the ridr tree *and* a synchronize_rcu() grace
+ * period).
+ */
+
 /*
  * This is what we export.
  */

--
