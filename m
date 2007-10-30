Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbXJ3QW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbXJ3QW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXJ3QO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbXJ3QOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:15 -0400
Message-Id: <20071030160911.788985000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:08 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/33] mm: serialize access to min_free_kbytes
Content-Disposition: inline; filename=mm-setup_per_zone_pages_min.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race between the procfs caller and the memory hotplug caller
of setup_per_zone_pages_min(). Not a big deal, but the next patch will add yet
another caller. Time to close the gap.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page_alloc.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -116,6 +116,7 @@ static char * const zone_names[MAX_NR_ZO
 	 "Movable",
 };
 
+static DEFINE_SPINLOCK(min_free_lock);
 int min_free_kbytes = 1024;
 
 unsigned long __meminitdata nr_kernel_pages;
@@ -4162,12 +4163,12 @@ static void setup_per_zone_lowmem_reserv
 }
 
 /**
- * setup_per_zone_pages_min - called when min_free_kbytes changes.
+ * __setup_per_zone_pages_min - called when min_free_kbytes changes.
  *
  * Ensures that the pages_{min,low,high} values for each zone are set correctly
  * with respect to min_free_kbytes.
  */
-void setup_per_zone_pages_min(void)
+static void __setup_per_zone_pages_min(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
@@ -4222,6 +4223,15 @@ void setup_per_zone_pages_min(void)
 	calculate_totalreserve_pages();
 }
 
+void setup_per_zone_pages_min(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&min_free_lock, flags);
+	__setup_per_zone_pages_min();
+	spin_unlock_irqrestore(&min_free_lock, flags);
+}
+
 /*
  * Initialise min_free_kbytes.
  *
@@ -4257,7 +4267,7 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 128;
 	if (min_free_kbytes > 65536)
 		min_free_kbytes = 65536;
-	setup_per_zone_pages_min();
+	__setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
 	return 0;
 }

--

