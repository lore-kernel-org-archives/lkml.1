Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZICFgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZICFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZICFfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZICFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/5] kmemleak: move common painting code together
Date: Thu,  3 Sep 2009 01:35:38 -0400
Message-Id: <1251956140-5499-4-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When painting grey or black we do the same thing, bring
this together into a helper and identify coloring grey or
black explicitly with defines. This makes this a little
easier to read.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index b6bc34e..58c07b1 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -120,6 +120,9 @@ struct kmemleak_scan_area {
 	size_t length;
 };
 
+#define KMEMLEAK_GREY	0
+#define KMEMLEAK_BLACK	-1
+
 /*
  * Structure holding the metadata for each allocated memory block.
  * Modifications to such objects should be made while holding the
@@ -266,17 +269,19 @@ static void kmemleak_disable(void);
  */
 static bool color_white(const struct kmemleak_object *object)
 {
-	return object->count != -1 && object->count < object->min_count;
+	return object->count != KMEMLEAK_BLACK &&
+		object->count < object->min_count;
 }
 
 static bool color_gray(const struct kmemleak_object *object)
 {
-	return object->min_count != -1 && object->count >= object->min_count;
+	return object->min_count != KMEMLEAK_BLACK &&
+		object->count >= object->min_count;
 }
 
 static bool color_black(const struct kmemleak_object *object)
 {
-	return object->min_count == -1;
+	return object->min_count == KMEMLEAK_BLACK;
 }
 
 /*
@@ -604,13 +609,21 @@ static void delete_object_part(unsigned long ptr, size_t size)
 
 	put_object(object);
 }
+
+static void paint_it(struct kmemleak_object *object, int color)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&object->lock, flags);
+	object->min_count = color;
+	spin_unlock_irqrestore(&object->lock, flags);
+}
+
 /*
  * Make a object permanently as gray-colored so that it can no longer be
  * reported as a leak. This is used in general to mark a false positive.
  */
 static void make_gray_object(unsigned long ptr)
 {
-	unsigned long flags;
 	struct kmemleak_object *object;
 
 	object = find_and_get_object(ptr, 0);
@@ -618,10 +631,7 @@ static void make_gray_object(unsigned long ptr)
 		kmemleak_warn("Graying unknown object at 0x%08lx\n", ptr);
 		return;
 	}
-
-	spin_lock_irqsave(&object->lock, flags);
-	object->min_count = 0;
-	spin_unlock_irqrestore(&object->lock, flags);
+	paint_it(object, KMEMLEAK_GREY);
 	put_object(object);
 }
 
@@ -631,7 +641,6 @@ static void make_gray_object(unsigned long ptr)
  */
 static void make_black_object(unsigned long ptr)
 {
-	unsigned long flags;
 	struct kmemleak_object *object;
 
 	object = find_and_get_object(ptr, 0);
@@ -639,10 +648,7 @@ static void make_black_object(unsigned long ptr)
 		kmemleak_warn("Blacking unknown object at 0x%08lx\n", ptr);
 		return;
 	}
-
-	spin_lock_irqsave(&object->lock, flags);
-	object->min_count = -1;
-	spin_unlock_irqrestore(&object->lock, flags);
+	paint_it(object, KMEMLEAK_BLACK);
 	put_object(object);
 }
 
-- 
1.6.3.3

