Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbYCGJYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbYCGJYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbYCGJNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:36 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63359 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761534AbYCGJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/7] Add mempool support for page allocation through the mask allocator
Message-Id: <20080307091324.0031D1B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:23 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:53.0705 (UTC) FILETIME=[96384790:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Right now for struct page *s because that is what the block bounce code
needs.

I chose to add a small scratch area to the mempool structure instead
of allocating separately.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/mempool.h |    3 +++
 mm/mempool.c            |   31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

Index: linux/mm/mempool.c
===================================================================
--- linux.orig/mm/mempool.c
+++ linux/mm/mempool.c
@@ -338,3 +338,34 @@ void mempool_free_pages(void *element, v
 	__free_pages(element, order);
 }
 EXPORT_SYMBOL(mempool_free_pages);
+
+struct mempool_apm_data {
+	u64 mask;
+	unsigned size;
+};
+
+static void *mempool_alloc_pages_mask(gfp_t gfp_mask, void *pool_data)
+{
+	struct mempool_apm_data *apm = (struct mempool_apm_data *)pool_data;
+	return alloc_pages_mask(gfp_mask, apm->size, apm->mask);
+}
+
+static void mempool_free_pages_mask(void *element, void *pool_data)
+{
+	struct mempool_apm_data *apm = (struct mempool_apm_data *)pool_data;
+	__free_pages_mask(element, apm->size);
+}
+
+mempool_t *mempool_create_pool_pmask(int min_nr, int size, u64 mask)
+{
+	struct mempool_apm_data apm = { .size = size, .mask = mask };
+	mempool_t *m = mempool_create(min_nr, mempool_alloc_pages_mask,
+				      mempool_free_pages_mask, &apm);
+	if (m) {
+		BUILD_BUG_ON(sizeof(m->private) < sizeof(apm));
+		memcpy(m->private, &apm, sizeof(struct mempool_apm_data));
+		m->pool_data = (struct mempool_apm_data *)&m->private;
+	}
+	return m;
+}
+EXPORT_SYMBOL(mempool_create_pool_pmask);
Index: linux/include/linux/mempool.h
===================================================================
--- linux.orig/include/linux/mempool.h
+++ linux/include/linux/mempool.h
@@ -21,6 +21,7 @@ typedef struct mempool_s {
 	mempool_alloc_t *alloc;
 	mempool_free_t *free;
 	wait_queue_head_t wait;
+	char private[16];
 } mempool_t;
 
 extern mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
@@ -76,4 +77,6 @@ static inline mempool_t *mempool_create_
 			      (void *)(long)order);
 }
 
+mempool_t *mempool_create_pool_pmask(int min_nr, int size, u64 mask);
+
 #endif /* _LINUX_MEMPOOL_H */
