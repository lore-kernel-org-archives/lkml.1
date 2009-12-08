Return-Path: <linux-kernel-owner+w=401wt.eu-S966351AbZLHVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966351AbZLHVSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966353AbZLHVSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:18:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49596 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966203AbZLHVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [28/31] HWPOISON: Use new shake_page in memory_failure
Message-Id: <20091208211644.92950B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


shake_page handles more types of page caches than
the much simpler lru_add_drain_all:

- slab (quite inefficiently for now)
- any other caches with a shrinker callback
- per cpu page allocator pages
- per CPU LRU

Use this call to try to turn pages into free or LRU pages.
Then handle the case of the page becoming free after drain everything.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -934,8 +934,15 @@ int __memory_failure(unsigned long pfn,
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
 	if (!PageLRU(p))
-		lru_add_drain_all();
+		shake_page(p);
 	if (!PageLRU(p)) {
+		/*
+		 * shake_page could have turned it free.
+		 */
+		if (is_free_buddy_page(p)) {
+			action_result(pfn, "free buddy, 2nd try", DELAYED);
+			return 0;
+		}
 		action_result(pfn, "non LRU", IGNORED);
 		put_page(p);
 		return -EBUSY;
