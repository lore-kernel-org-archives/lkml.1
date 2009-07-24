Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZGXQNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZGXQNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZGXQNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:13:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51168 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbZGXQMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:14 -0400
Subject: [PATCH 2/8] kmemleak: Allow rescheduling during an object scanning
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:13 +0100
Message-ID: <20090724161213.5752.41867.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:13.0455 (UTC) FILETIME=[815F19F0:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the object size is bigger than a predefined value (4K in this case),
release the object lock during scanning and call cond_resched().
Re-acquire the lock after rescheduling and test whether the object is
still valid.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7e8e4b0..c665626 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -107,6 +107,7 @@
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
+#define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -950,10 +951,20 @@ static void scan_object(struct kmemleak_object *object)
 	if (!(object->flags & OBJECT_ALLOCATED))
 		/* already freed object */
 		goto out;
-	if (hlist_empty(&object->area_list))
-		scan_block((void *)object->pointer,
-			   (void *)(object->pointer + object->size), object, 0);
-	else
+	if (hlist_empty(&object->area_list)) {
+		void *start = (void *)object->pointer;
+		void *end = (void *)(object->pointer + object->size);
+
+		while (start < end && (object->flags & OBJECT_ALLOCATED)) {
+			scan_block(start, min(start + MAX_SCAN_SIZE, end),
+				   object, 0);
+			start += MAX_SCAN_SIZE;
+
+			spin_unlock_irqrestore(&object->lock, flags);
+			cond_resched();
+			spin_lock_irqsave(&object->lock, flags);
+		}
+	} else
 		hlist_for_each_entry(area, elem, &object->area_list, node)
 			scan_block((void *)(object->pointer + area->offset),
 				   (void *)(object->pointer + area->offset

