Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZGBP5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZGBP5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZGBP4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:56:54 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59995 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbZGBP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:56:53 -0400
Subject: [PATCH] kmemleak: Scan objects allocated during a scanning episode
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 02 Jul 2009 16:56:55 +0100
Message-ID: <20090702155347.12384.60368.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 15:56:55.0644 (UTC) FILETIME=[B939C1C0:01C9FB2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  (this patch improves on the kmemleak false positives. I'll give it a
  try tonight on a dual-core x86 system as well since that's where I get
  most of the false positives)

Many of the false positives in kmemleak happen on busy systems where
objects are allocated during a kmemleak scanning episode. These objects
aren't scanned by default until the next memory scan. When such object
is added, for example, at the head of a list, it is possible that all
the other objects in the list become unreferenced until the next scan.

This patch adds checking for newly allocated objects and the end of the
scan and repeats the scanning on these objects. If Linux allocates
new objects at a higher rate than their scanning, it stops after a
predefined number of passes.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 678baad..3395e48 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -106,6 +106,7 @@
 #define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
 #define SECS_FIRST_SCAN		300	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
+#define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -157,6 +158,8 @@ struct kmemleak_object {
 #define OBJECT_REPORTED		(1 << 1)
 /* flag set to not scan the object */
 #define OBJECT_NO_SCAN		(1 << 2)
+/* flag set on newly allocated objects */
+#define OBJECT_NEW		(1 << 3)
 
 /* the list of all allocated objects */
 static LIST_HEAD(object_list);
@@ -270,6 +273,11 @@ static int color_gray(const struct kmemleak_object *object)
 	return object->min_count != -1 && object->count >= object->min_count;
 }
 
+static int color_black(const struct kmemleak_object *object)
+{
+	return object->min_count == -1;
+}
+
 /*
  * Objects are considered unreferenced only if their color is white, they have
  * not be deleted and have a minimum age to avoid false positives caused by
@@ -447,7 +455,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	INIT_HLIST_HEAD(&object->area_list);
 	spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
-	object->flags = OBJECT_ALLOCATED;
+	object->flags = OBJECT_ALLOCATED | OBJECT_NEW;
 	object->pointer = ptr;
 	object->size = size;
 	object->min_count = min_count;
@@ -899,6 +907,7 @@ static void kmemleak_scan(void)
 	struct task_struct *task;
 	int i;
 	int new_leaks = 0;
+	int gray_list_pass = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -919,6 +928,7 @@ static void kmemleak_scan(void)
 #endif
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
+		object->flags &= ~OBJECT_NEW;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -985,6 +995,7 @@ static void kmemleak_scan(void)
 	 * kmemleak objects cannot be freed from outside the loop because their
 	 * use_count was increased.
 	 */
+repeat:
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
 		cond_resched();
@@ -1002,12 +1013,38 @@ static void kmemleak_scan(void)
 
 		object = tmp;
 	}
+
+	if (scan_should_stop() || ++gray_list_pass >= GRAY_LIST_PASSES)
+		goto scan_end;
+
+	/*
+	 * Check for new objects allocated during this scanning and add them
+	 * to the gray list.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		spin_lock_irqsave(&object->lock, flags);
+		if ((object->flags & OBJECT_NEW) && !color_black(object) &&
+		    get_object(object)) {
+			object->flags &= ~OBJECT_NEW;
+			list_add_tail(&object->gray_list, &gray_list);
+		}
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+	rcu_read_unlock();
+
+	if (!list_empty(&gray_list))
+		goto repeat;
+
+scan_end:
 	WARN_ON(!list_empty(&gray_list));
 
 	/*
-	 * If scanning was stopped do not report any new unreferenced objects.
+	 * If scanning was stopped or new objects were being allocated at a
+	 * higher rate than gray list scanning, do not report any new
+	 * unreferenced objects.
 	 */
-	if (scan_should_stop())
+	if (scan_should_stop() || gray_list_pass >= GRAY_LIST_PASSES)
 		return;
 
 	/*

