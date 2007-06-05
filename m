Return-Path: <linux-kernel-owner+w=401wt.eu-S1765793AbXFEU20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765793AbXFEU20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbXFEU2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:28:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:40715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764965AbXFEU2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:28:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="235910879"
Date: Tue, 5 Jun 2007 13:24:33 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, akpm@osdl.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routines for handling pre-allocated pool of objects
Message-ID: <20070605202433.GA27638@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.156875000@askeshav-devel.jf.intel.com> <20070604225714.GM20299@havoc.gtf.org> <20070604230649.GB9948@linux-os.sc.intel.com> <20070604234354.GC31462@havoc.gtf.org> <20070604235105.GA13390@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604235105.GA13390@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 04:51:05PM -0700, Keshavamurthy, Anil S wrote:
> On Mon, Jun 04, 2007 at 07:43:54PM -0400, Jeff Garzik wrote:
> > On Mon, Jun 04, 2007 at 04:06:49PM -0700, Keshavamurthy, Anil S wrote:
> > > On Mon, Jun 04, 2007 at 06:57:14PM -0400, Jeff Garzik wrote:
> > > > you should add logic to free resources here (or queue_work to free the
> > > > resources), if the pool grows beyond a certain size.
> > 
> > > Can be added as an add on, testing showed that pool 
> > > grows to a certain size and will not grow beyond that 
> > > as we tend to reuse the elements.
> > 
> > Yes, but is it possible?  If no, what part of the code guarantees the
> > pool is limited?
> > 
> > We should not merge code that allows the pool to grow without bound.
> > In-house testing certainly never covers all the cases seen in the
> > field, so I wouldn't make too many assumptions based on that.  Some
> > vendor will inevitably build a $BigNum system where the IOMMU is very
> > heavily used.
> 
> No problem, I can add the code to free the pool element if
> the curr_count ever goes greater than (min_count + 2 * grow_count)
> then bring the curr_count to min_count + grow_count by freeing 
> some pool objects.
> 
> A patch which will apply to this current patch will follow soon.

Here goes the patch as promised...
------------------------------------

Now adding the logic to shrink the resource pool
and give back the excess pool object's memory space 
back to OS.

This patch add's on top of my previous posting.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 lib/respool.c |   84 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 19 deletions(-)

Index: linux-2.6.22-rc3/lib/respool.c
===================================================================
--- linux-2.6.22-rc3.orig/lib/respool.c	2007-06-05 12:22:26.000000000 -0700
+++ linux-2.6.22-rc3/lib/respool.c	2007-06-05 12:58:01.000000000 -0700
@@ -67,6 +67,7 @@
 {
 	unsigned long	flags;
 	struct list_head *plist = (struct list_head *)vaddr;
+	bool queue_work = 0;
 
 	BUG_ON(!vaddr);
 	BUG_ON(!ppool);
@@ -74,21 +75,74 @@
 	spin_lock_irqsave(&ppool->pool_lock, flags);
 	list_add(plist, &ppool->pool_head);
 	ppool->curr_count++;
+	if (ppool->curr_count > (ppool->min_count +
+		ppool->grow_count * 2))
+		queue_work = 1;
 	spin_unlock_irqrestore(&ppool->pool_lock, flags);
+
+	if (queue_work)
+		schedule_work(&ppool->work); /* queue work to shrink the pool */
+}
+
+void
+__grow_resource_pool(struct resource_pool *ppool,
+	unsigned int grow_count)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+
+	while (grow_count) {
+		plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
+			GFP_KERNEL);
+
+		if (!plist)
+			break;
+
+		/* Add the element to the list */
+		spin_lock_irqsave(&ppool->pool_lock, flags);
+		list_add(plist, &ppool->pool_head);
+		ppool->curr_count++;
+		spin_unlock_irqrestore(&ppool->pool_lock, flags);
+		grow_count--;
+	}
 }
 
+void
+__shrink_resource_pool(struct resource_pool *ppool,
+	unsigned int shrink_count)
+{
+	unsigned long	flags;
+	struct list_head *plist;
+
+	while (shrink_count) {
+		/* remove an object from the pool */
+		spin_lock_irqsave(&ppool->pool_lock, flags);
+		if (list_empty(&ppool->pool_head)) {
+			spin_unlock_irqrestore(&ppool->pool_lock, flags);
+			break;
+		}
+		plist = ppool->pool_head.next;
+		list_del(plist);
+		ppool->curr_count--;
+		spin_unlock_irqrestore(&ppool->pool_lock, flags);
+		ppool->free_mem(plist, ppool->alloc_size);
+		shrink_count--;
+	}
+}
+
+
 /**
- * grow_resource_pool - grows the given resource pool
+ * resize_resource_pool - resize the given resource pool
  * @work - work struct
  * This functions gets the resource pool pointer from the
  * work struct and grows the resource pool by grow_count.
  */
 static void
-grow_resource_pool(struct work_struct * work)
+resize_resource_pool(struct work_struct * work)
 {
 	struct resource_pool *ppool;
-	struct list_head *plist;
 	unsigned int min_count, grow_count = 0;
+	unsigned int shrink_count = 0;
 	unsigned long	flags;
 
 	ppool = container_of(work, struct resource_pool, work);
@@ -98,22 +152,14 @@
 	min_count = ppool->min_count + ppool->grow_count;
 	if (ppool->curr_count < min_count)
 		grow_count = min_count - ppool->curr_count;
+	else if (ppool->curr_count > min_count + ppool->grow_count)
+		shrink_count = ppool->curr_count - min_count;
 	spin_unlock_irqrestore(&ppool->pool_lock, flags);
 
-	while(grow_count) {
-		plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
-			GFP_KERNEL);
-
-		if (!plist)
-			break;
-
-		/* Add the element to the list */
-		spin_lock_irqsave(&ppool->pool_lock, flags);
-		list_add(plist, &ppool->pool_head);
-		ppool->curr_count++;
-		spin_unlock_irqrestore(&ppool->pool_lock, flags);
-		grow_count--;
-	}
+	if (grow_count)
+		__grow_resource_pool(ppool, grow_count);
+	else if (shrink_count)
+		__shrink_resource_pool(ppool, shrink_count);
 }
 
 /**
@@ -166,10 +212,10 @@
 	res->free_mem = free_fn;
 	spin_lock_init(&res->pool_lock);
 	INIT_LIST_HEAD(&res->pool_head);
-	INIT_WORK(&res->work, grow_resource_pool);
+	INIT_WORK(&res->work, resize_resource_pool);
 
 	/* grow the pool */
-	grow_resource_pool(&res->work);
+	resize_resource_pool(&res->work);
 
 	return (res->curr_count == 0);
 }
