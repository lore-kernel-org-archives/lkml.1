Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbXEKBYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbXEKBYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXEKBYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:24:06 -0400
Received: from ozlabs.org ([203.10.76.45]:43033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXEKBYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:24:05 -0400
Subject: [PATCH 4/5] lguest block driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1178846572.23513.29.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <1178846572.23513.29.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:23:52 +1000
Message-Id: <1178846632.23513.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Use new dma wrapper functions, and handle bind failure (may happen
   in future)
2) Use new lgdev_irq() "get me a good interrupt number" function.
3)  __force the ioremap: guests can use it as normal memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/lguest_blk.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

===================================================================
--- a/drivers/block/lguest_blk.c
+++ b/drivers/block/lguest_blk.c
@@ -123,7 +123,7 @@ static void do_write(struct blockdev *bd
 	pr_debug("lgb: WRITE sector %li\n", (long)req->sector);
 	setup_req(bd, 1, req, &send);
 
-	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&send), 0);
+	lguest_send_dma(bd->phys_addr, &send);
 }
 
 static void do_read(struct blockdev *bd, struct request *req)
@@ -134,7 +134,7 @@ static void do_read(struct blockdev *bd,
 	setup_req(bd, 0, req, &bd->dma);
 
 	empty_dma(&ping);
-	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&ping), 0);
+	lguest_send_dma(bd->phys_addr, &ping);
 }
 
 static void do_lgb_request(request_queue_t *q)
@@ -183,13 +183,13 @@ static int lguestblk_probe(struct lguest
 		return -ENOMEM;
 
 	spin_lock_init(&bd->lock);
-	bd->irq = lgdev->index+1;
+	bd->irq = lgdev_irq(lgdev);
 	bd->req = NULL;
 	bd->dma.used_len = 0;
 	bd->dma.len[0] = 0;
 	bd->phys_addr = (lguest_devices[lgdev->index].pfn << PAGE_SHIFT);
 
-	bd->lb_page = (void *)ioremap(bd->phys_addr, PAGE_SIZE);
+	bd->lb_page = (__force void *)ioremap(bd->phys_addr, PAGE_SIZE);
 	if (!bd->lb_page) {
 		err = -ENOMEM;
 		goto out_free_bd;
@@ -225,7 +225,9 @@ static int lguestblk_probe(struct lguest
 	if (err)
 		goto out_cleanup_queue;
 
-	hcall(LHCALL_BIND_DMA, bd->phys_addr, __pa(&bd->dma), (1<<8)+bd->irq);
+	err = lguest_bind_dma(bd->phys_addr, &bd->dma, 1, bd->irq);
+	if (err)
+		goto out_free_irq;
 
 	bd->disk->major = bd->major;
 	bd->disk->first_minor = 0;
@@ -241,6 +243,8 @@ static int lguestblk_probe(struct lguest
 	lgdev->private = bd;
 	return 0;
 
+out_free_irq:
+	free_irq(bd->irq, bd);
 out_cleanup_queue:
 	blk_cleanup_queue(bd->disk->queue);
 out_put_disk:
@@ -248,7 +252,7 @@ out_unregister_blkdev:
 out_unregister_blkdev:
 	unregister_blkdev(bd->major, "lguestblk");
 out_unmap:
-	iounmap(bd->lb_page);
+	iounmap((__force void *__iomem)bd->lb_page);
 out_free_bd:
 	kfree(bd);
 	return err;


