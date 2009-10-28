Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZJ1RSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZJ1RSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZJ1RSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:18:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33422 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755275AbZJ1RS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:18:28 -0400
Subject: [PATCH 3/3] kmemleak: Reduce the false positives by checking for
	modified objects
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 28 Oct 2009 17:18:32 +0000
Message-ID: <20091028171831.19220.76288.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
References: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-1-g9f9ed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 17:18:32.0305 (UTC) FILETIME=[AC9B6E10:01CA57F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an object was modified since it was previously suspected as leak, do
not report it. The modification check is done by calculating the
checksum (CRC32) of such object.

Several false positives are caused by objects being removed from linked
lists (e.g. allocation pools) and temporarily breaking the reference
chain since kmemleak runs concurrently with such list mutation
primitives.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |  124 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 70 insertions(+), 54 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index ce79d91..002adc3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -93,6 +93,7 @@
 #include <linux/nodemask.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/crc32.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -108,7 +109,6 @@
 #define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
-#define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
 
 #define BYTES_PER_POINTER	sizeof(void *)
@@ -149,6 +149,8 @@ struct kmemleak_object {
 	int min_count;
 	/* the total number of pointers found pointing to this object */
 	int count;
+	/* checksum for detecting modified objects */
+	u32 checksum;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
 	unsigned long trace[MAX_TRACE];
@@ -164,8 +166,6 @@ struct kmemleak_object {
 #define OBJECT_REPORTED		(1 << 1)
 /* flag set to not scan the object */
 #define OBJECT_NO_SCAN		(1 << 2)
-/* flag set on newly allocated objects */
-#define OBJECT_NEW		(1 << 3)
 
 /* number of bytes to print per line; must be 16 or 32 */
 #define HEX_ROW_SIZE		16
@@ -321,11 +321,6 @@ static bool color_gray(const struct kmemleak_object *object)
 		object->count >= object->min_count;
 }
 
-static bool color_black(const struct kmemleak_object *object)
-{
-	return object->min_count == KMEMLEAK_BLACK;
-}
-
 /*
  * Objects are considered unreferenced only if their color is white, they have
  * not be deleted and have a minimum age to avoid false positives caused by
@@ -333,7 +328,7 @@ static bool color_black(const struct kmemleak_object *object)
  */
 static bool unreferenced_object(struct kmemleak_object *object)
 {
-	return (object->flags & OBJECT_ALLOCATED) && color_white(object) &&
+	return (color_white(object) && object->flags & OBJECT_ALLOCATED) &&
 		time_before_eq(object->jiffies + jiffies_min_age,
 			       jiffies_last_scan);
 }
@@ -381,6 +376,7 @@ static void dump_object_info(struct kmemleak_object *object)
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%lx\n", object->flags);
+	pr_notice("  checksum = %d\n", object->checksum);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
@@ -522,12 +518,13 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	INIT_HLIST_HEAD(&object->area_list);
 	spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
-	object->flags = OBJECT_ALLOCATED | OBJECT_NEW;
+	object->flags = OBJECT_ALLOCATED;
 	object->pointer = ptr;
 	object->size = size;
 	object->min_count = min_count;
-	object->count = -1;			/* no color initially */
+	object->count = 0;			/* white color initially */
 	object->jiffies = jiffies;
+	object->checksum = 0;
 
 	/* task information */
 	if (in_irq()) {
@@ -949,6 +946,20 @@ void __ref kmemleak_no_scan(const void *ptr)
 EXPORT_SYMBOL(kmemleak_no_scan);
 
 /*
+ * Update an object's checksum and return true if it was modified.
+ */
+static bool update_checksum(struct kmemleak_object *object)
+{
+	u32 old_csum = object->checksum;
+
+	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
+		return false;
+
+	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	return object->checksum != old_csum;
+}
+
+/*
  * Memory scanning is a long process and it needs to be interruptable. This
  * function checks whether such interrupt condition occured.
  */
@@ -1082,6 +1093,39 @@ out:
 }
 
 /*
+ * Scan the objects already referenced (gray objects). More objects will be
+ * referenced and, if there are no memory leaks, all the objects are scanned.
+ */
+static void scan_gray_list(void)
+{
+	struct kmemleak_object *object, *tmp;
+
+	/*
+	 * The list traversal is safe for both tail additions and removals
+	 * from inside the loop. The kmemleak objects cannot be freed from
+	 * outside the loop because their use_count was incremented.
+	 */
+	object = list_entry(gray_list.next, typeof(*object), gray_list);
+	while (&object->gray_list != &gray_list) {
+		cond_resched();
+
+		/* may add new objects to the list */
+		if (!scan_should_stop())
+			scan_object(object);
+
+		tmp = list_entry(object->gray_list.next, typeof(*object),
+				 gray_list);
+
+		/* remove the object from the list and release it */
+		list_del(&object->gray_list);
+		put_object(object);
+
+		object = tmp;
+	}
+	WARN_ON(!list_empty(&gray_list));
+}
+
+/*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
@@ -1089,10 +1133,9 @@ out:
 static void kmemleak_scan(void)
 {
 	unsigned long flags;
-	struct kmemleak_object *object, *tmp;
+	struct kmemleak_object *object;
 	int i;
 	int new_leaks = 0;
-	int gray_list_pass = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1113,7 +1156,6 @@ static void kmemleak_scan(void)
 #endif
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		object->flags &= ~OBJECT_NEW;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1171,62 +1213,36 @@ static void kmemleak_scan(void)
 
 	/*
 	 * Scan the objects already referenced from the sections scanned
-	 * above. More objects will be referenced and, if there are no memory
-	 * leaks, all the objects will be scanned. The list traversal is safe
-	 * for both tail additions and removals from inside the loop. The
-	 * kmemleak objects cannot be freed from outside the loop because their
-	 * use_count was increased.
+	 * above.
 	 */
-repeat:
-	object = list_entry(gray_list.next, typeof(*object), gray_list);
-	while (&object->gray_list != &gray_list) {
-		cond_resched();
-
-		/* may add new objects to the list */
-		if (!scan_should_stop())
-			scan_object(object);
-
-		tmp = list_entry(object->gray_list.next, typeof(*object),
-				 gray_list);
-
-		/* remove the object from the list and release it */
-		list_del(&object->gray_list);
-		put_object(object);
-
-		object = tmp;
-	}
-
-	if (scan_should_stop() || ++gray_list_pass >= GRAY_LIST_PASSES)
-		goto scan_end;
+	scan_gray_list();
 
 	/*
-	 * Check for new objects allocated during this scanning and add them
-	 * to the gray list.
+	 * Check for new or unreferenced objects modified since the previous
+	 * scan and color them gray until the next scan.
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		spin_lock_irqsave(&object->lock, flags);
-		if ((object->flags & OBJECT_NEW) && !color_black(object) &&
-		    get_object(object)) {
-			object->flags &= ~OBJECT_NEW;
+		if (color_white(object) && (object->flags & OBJECT_ALLOCATED)
+		    && update_checksum(object) && get_object(object)) {
+			/* color it gray temporarily */
+			object->count = object->min_count;
 			list_add_tail(&object->gray_list, &gray_list);
 		}
 		spin_unlock_irqrestore(&object->lock, flags);
 	}
 	rcu_read_unlock();
 
-	if (!list_empty(&gray_list))
-		goto repeat;
-
-scan_end:
-	WARN_ON(!list_empty(&gray_list));
+	/*
+	 * Re-scan the gray list for modified unreferenced objects.
+	 */
+	scan_gray_list();
 
 	/*
-	 * If scanning was stopped or new objects were being allocated at a
-	 * higher rate than gray list scanning, do not report any new
-	 * unreferenced objects.
+	 * If scanning was stopped do not report any new unreferenced objects.
 	 */
-	if (scan_should_stop() || gray_list_pass >= GRAY_LIST_PASSES)
+	if (scan_should_stop())
 		return;
 
 	/*

