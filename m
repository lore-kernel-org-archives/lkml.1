Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZDRBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZDRBMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZDRBMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 21:12:16 -0400
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:50786 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752964AbZDRBMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 21:12:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm/slab.c: fix sparse warnings
Date: Fri, 17 Apr 2009 21:11:56 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F923D@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/slab.c: fix sparse warnings
Thread-Index: Acm/wqp/b9AyfQ7WQu+0DCSZYYlrCw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Apr 2009 01:12:14.0004 (UTC) FILETIME=[B51F0740:01C9BFC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings in mm/slab.c.

  warning: symbol 'initkmem_list3' was not declared. Should it be
static?
  warning: symbol 'drain_array' was not declared. Should it be static?
  warning: symbol 'slabinfo_write' was not declared. Should it be
static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..d647b3f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -306,7 +306,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (3 * MAX_NUMNODES)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+static struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
 #define	SIZE_AC MAX_NUMNODES
 #define	SIZE_L3 (2 * MAX_NUMNODES)
@@ -2434,9 +2434,34 @@ static void check_spinlock_acquired_node(struct
kmem_cache *cachep, int node)
 #define check_spinlock_acquired_node(x, y) do { } while(0)
 #endif
 
+/*
+ * Drain an array if it contains any elements taking the l3 lock only
if
+ * necessary. Note that the l3 listlock also protects the array_cache
+ * if drain_array() is used on the shared array.
+ */
 static void drain_array(struct kmem_cache *cachep, struct kmem_list3
*l3,
-			struct array_cache *ac,
-			int force, int node);
+			 struct array_cache *ac, int force, int node)
+{
+	int tofree;
+
+	if (!ac || !ac->avail)
+		return;
+	if (ac->touched && !force) {
+		ac->touched = 0;
+	} else {
+		spin_lock_irq(&l3->list_lock);
+		if (ac->avail) {
+			tofree = force ? ac->avail : (ac->limit + 4) /
5;
+			if (tofree > ac->avail)
+				tofree = (ac->avail + 1) / 2;
+			free_block(cachep, ac->entry, tofree, node);
+			ac->avail -= tofree;
+			memmove(ac->entry, &(ac->entry[tofree]),
+				sizeof(void *) * ac->avail);
+		}
+		spin_unlock_irq(&l3->list_lock);
+	}
+}
 
 static void do_drain(void *arg)
 {
@@ -4001,35 +4026,6 @@ static int enable_cpucache(struct kmem_cache
*cachep)
 	return err;
 }
 
-/*
- * Drain an array if it contains any elements taking the l3 lock only
if
- * necessary. Note that the l3 listlock also protects the array_cache
- * if drain_array() is used on the shared array.
- */
-void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
-			 struct array_cache *ac, int force, int node)
-{
-	int tofree;
-
-	if (!ac || !ac->avail)
-		return;
-	if (ac->touched && !force) {
-		ac->touched = 0;
-	} else {
-		spin_lock_irq(&l3->list_lock);
-		if (ac->avail) {
-			tofree = force ? ac->avail : (ac->limit + 4) /
5;
-			if (tofree > ac->avail)
-				tofree = (ac->avail + 1) / 2;
-			free_block(cachep, ac->entry, tofree, node);
-			ac->avail -= tofree;
-			memmove(ac->entry, &(ac->entry[tofree]),
-				sizeof(void *) * ac->avail);
-		}
-		spin_unlock_irq(&l3->list_lock);
-	}
-}
-
 /**
  * cache_reap - Reclaim memory from caches.
  * @w: work descriptor
@@ -4269,7 +4265,7 @@ static const struct seq_operations slabinfo_op = {
  * @count: data length
  * @ppos: unused
  */
-ssize_t slabinfo_write(struct file *file, const char __user * buffer,
+static ssize_t slabinfo_write(struct file *file, const char __user *
buffer,
 		       size_t count, loff_t *ppos)
 {
 	char kbuf[MAX_SLABINFO_WRITE + 1], *tmp; 
