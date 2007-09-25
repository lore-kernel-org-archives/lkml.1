Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXIYXrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXIYXrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXIYXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57666 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbXIYXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:53 -0400
Message-Id: <20070925234252.220601640@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:17 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [13/17] Virtual compound page freeing in interrupt context
Content-Disposition: inline; filename=vcompound_interrupt_free
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we are in an interrupt context then simply defer the free via a workqueue.

Removing a virtual mappping *must* be done with interrupts enabled
since tlb_xx functions are called that rely on interrupts for
processor to processor communications.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-25 00:20:56.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-25 00:20:57.000000000 -0700
@@ -1294,7 +1294,12 @@ abort:
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
 	struct page **pages;
 	int i;
@@ -1319,6 +1324,22 @@ static void vcompound_free(void *addr)
 	kfree(pages);
 }
 
+static void vcompound_free_work(struct work_struct *w)
+{
+	__vcompound_free((void *)w);
+}
+
+static noinline void vcompound_free(void *addr)
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
