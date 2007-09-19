Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXISDkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXISDkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXISDg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033643.306595969@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:18 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [13/17] Virtual compound page freeing in interrupt context
Content-Disposition: inline; filename=vcompound_interrupt_free
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we are in an interrupt context then simply defer the free via a workqueue.

In an interrupt context it is not possible to use vmalloc_addr() to determine
the vmalloc address. So add a variant that does that too.

Removing a virtual mappping *must* be done with interrupts enabled
since tlb_xx functions are called that rely on interrupts for
processor to processor communications.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-18 20:10:55.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-18 20:11:40.000000000 -0700
@@ -1297,7 +1297,12 @@ abort:
 	return NULL;
 }
 
-static void vcompound_free(void *addr)
+/*
+ * Virtual Compound freeing functions. This is complicated by the vmalloc
+ * layer not being able to free virtual allocations when interrupts are
+ * disabled. So we defer the frees via a workqueue if necessary.
+ */
+static void __vcompound_free(void *addr)
 {
 	struct page **pages = vunmap(addr);
 	int i;
@@ -1320,6 +1325,22 @@ static void vcompound_free(void *addr)
 	kfree(pages);
 }
 
+static void vcompound_free_work(struct work_struct *w)
+{
+	__vcompound_free((void *)w);
+}
+
+static void vcompound_free(void *addr)
+{
+	if (in_interrupt()) {
+		struct work_struct *w = addr;
+
+		INIT_WORK(w, vcompound_free_work);
+		schedule_work(w);
+	} else
+		__vcompound_free(addr);
+}
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */

-- 
