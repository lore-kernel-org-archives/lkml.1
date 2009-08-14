Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZHNWr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZHNWr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZHNWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:47:56 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50774 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbZHNWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:47:55 -0400
Subject: [PATCH] kmemleak: Allow rescheduling during an object scanning
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
References: <20090812205215.GA21451@elte.hu>
	 <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 14 Aug 2009 23:47:44 +0100
Message-Id: <1250290064.5085.20.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2009 22:47:44.0856 (UTC) FILETIME=[3D104580:01CA1D31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the object size is bigger than a predefined value (4K in this case),
release the object lock during scanning and call cond_resched().
Re-acquire the lock after rescheduling and test whether the object is
still valid.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4872673..6debe0d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -107,6 +107,7 @@
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
+#define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -642,6 +643,7 @@ static void make_black_object(unsigned long ptr)
 
 	spin_lock_irqsave(&object->lock, flags);
 	object->min_count = -1;
+	object->flags |= OBJECT_NO_SCAN;
 	spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
 }
@@ -949,10 +951,21 @@ static void scan_object(struct kmemleak_object *object)
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
+		while (start < end && (object->flags & OBJECT_ALLOCATED) &&
+		       !(object->flags & OBJECT_NO_SCAN)) {
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


