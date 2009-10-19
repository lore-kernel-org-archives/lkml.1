Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZJSOtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZJSOtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZJSOti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:49:38 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36939 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493AbZJSOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:49:36 -0400
Subject: [PATCH 4/4] kmemleak: Allow two scanning passes before reported an
	object as leak
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 19 Oct 2009 15:49:40 +0100
Message-ID: <20091019144940.14221.81556.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:49:40.0758 (UTC) FILETIME=[6345C360:01CA50CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of the transient false positives in kmemleak are caused by
pointers being moved to a data structure after kmemleak scanned it
during a scanning episode. This may cause a false positive report on the
object pointed to by such pointer. This patch simplifies the scanning
algorithm for objects allocated during a scanning episode and instead
requires an object to be found as a leak twice consecutively before
being reported.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   77 ++++++++++++++-------------------------------------------
 1 files changed, 19 insertions(+), 58 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 998162f..efdd4b5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -108,7 +108,6 @@
 #define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
-#define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
 #define MAX_REV_REF		4	/* number of reverse references */
 
@@ -166,8 +165,8 @@ struct kmemleak_object {
 #define OBJECT_REPORTED		(1 << 1)
 /* flag set to not scan the object */
 #define OBJECT_NO_SCAN		(1 << 2)
-/* flag set on newly allocated objects */
-#define OBJECT_NEW		(1 << 3)
+/* flag set on unreferenced objects during first a scanning pass */
+#define OBJECT_FIRST_PASS	(1 << 3)
 
 /* number of bytes to print per line; must be 16 or 32 */
 #define HEX_ROW_SIZE		16
@@ -205,9 +204,6 @@ static unsigned long min_addr = ULONG_MAX;
 static unsigned long max_addr;
 
 static struct task_struct *scan_thread;
-/* used to avoid reporting of recently allocated objects */
-static unsigned long jiffies_min_age;
-static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static signed long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
@@ -323,21 +319,13 @@ static bool color_gray(const struct kmemleak_object *object)
 		object->count >= object->min_count;
 }
 
-static bool color_black(const struct kmemleak_object *object)
-{
-	return object->min_count == KMEMLEAK_BLACK;
-}
-
 /*
- * Objects are considered unreferenced only if their color is white, they have
- * not be deleted and have a minimum age to avoid false positives caused by
- * pointers temporarily stored in CPU registers.
+ * Objects are considered unreferenced only if their color is white and they
+ * have not been deleted.
  */
 static bool unreferenced_object(struct kmemleak_object *object)
 {
-	return (object->flags & OBJECT_ALLOCATED) && color_white(object) &&
-		time_before_eq(object->jiffies + jiffies_min_age,
-			       jiffies_last_scan);
+	return (object->flags & OBJECT_ALLOCATED) && color_white(object);
 }
 
 /*
@@ -529,11 +517,11 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	INIT_HLIST_HEAD(&object->area_list);
 	spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
-	object->flags = OBJECT_ALLOCATED | OBJECT_NEW;
+	object->flags = OBJECT_ALLOCATED;
 	object->pointer = ptr;
 	object->size = size;
 	object->min_count = min_count;
-	object->count = -1;			/* no color initially */
+	object->count = KMEMLEAK_BLACK;		/* no white color initially */
 	object->jiffies = jiffies;
 
 	/* task information */
@@ -1100,9 +1088,6 @@ static void kmemleak_scan(void)
 	struct kmemleak_object *object, *tmp;
 	int i;
 	int new_leaks = 0;
-	int gray_list_pass = 0;
-
-	jiffies_last_scan = jiffies;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
@@ -1121,7 +1106,6 @@ static void kmemleak_scan(void)
 #endif
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		object->flags &= ~OBJECT_NEW;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1185,7 +1169,6 @@ static void kmemleak_scan(void)
 	 * kmemleak objects cannot be freed from outside the loop because their
 	 * use_count was increased.
 	 */
-repeat:
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
 		cond_resched();
@@ -1203,38 +1186,12 @@ repeat:
 
 		object = tmp;
 	}
-
-	if (scan_should_stop() || ++gray_list_pass >= GRAY_LIST_PASSES)
-		goto scan_end;
-
-	/*
-	 * Check for new objects allocated during this scanning and add them
-	 * to the gray list.
-	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(object, &object_list, object_list) {
-		spin_lock_irqsave(&object->lock, flags);
-		if ((object->flags & OBJECT_NEW) && !color_black(object) &&
-		    get_object(object)) {
-			object->flags &= ~OBJECT_NEW;
-			list_add_tail(&object->gray_list, &gray_list);
-		}
-		spin_unlock_irqrestore(&object->lock, flags);
-	}
-	rcu_read_unlock();
-
-	if (!list_empty(&gray_list))
-		goto repeat;
-
-scan_end:
 	WARN_ON(!list_empty(&gray_list));
 
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
@@ -1243,11 +1200,16 @@ scan_end:
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
 		spin_lock_irqsave(&object->lock, flags);
-		if (unreferenced_object(object) &&
-		    !(object->flags & OBJECT_REPORTED)) {
-			object->flags |= OBJECT_REPORTED;
-			new_leaks++;
-		}
+		if (unreferenced_object(object)) {
+			if (!(object->flags & OBJECT_FIRST_PASS))
+				object->flags |= OBJECT_FIRST_PASS;
+			else if (!(object->flags & OBJECT_REPORTED)) {
+				/* previously found as leak, report it */
+				new_leaks++;
+				object->flags |= OBJECT_REPORTED;
+			}
+		} else
+			object->flags &= ~OBJECT_FIRST_PASS;
 		spin_unlock_irqrestore(&object->lock, flags);
 	}
 	rcu_read_unlock();
@@ -1609,7 +1571,6 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
 	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);

