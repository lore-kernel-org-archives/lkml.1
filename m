Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXEMEJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXEMEJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 00:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXEMEJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 00:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:49018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbXEMEJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 00:09:13 -0400
Subject: Re: [PATCH 4/5] lguest block driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1178846632.23513.30.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <1178846572.23513.29.camel@localhost.localdomain>
	 <1178846632.23513.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 13 May 2007 14:08:58 +1000
Message-Id: <1179029338.23513.124.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 11:23 +1000, Rusty Russell wrote:
> 1) Use new dma wrapper functions, and handle bind failure (may happen
>    in future)
> 2) Use new lgdev_irq() "get me a good interrupt number" function.
> 3)  __force the ioremap: guests can use it as normal memory.

And here is the update using lguest_map/unmap instead of ioremap +
__force:

1) Use new dma wrapper functions, and handle bind failure (may happen
   in future)
2) Use new lgdev_irq() "get me a good interrupt number" function.
3) Use new lguest_map()/lguest_unmap() instead of ioremap/iounmap.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/lguest_blk.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

===================================================================
--- a/drivers/block/lguest_blk.c
+++ b/drivers/block/lguest_blk.c
@@ -37,7 +37,7 @@ struct blockdev
 	int irq;
 
 	unsigned long phys_addr;
-	/* The ioremap'ed block page. */
+	/* The mapped block page. */
 	struct lguest_block_page *lb_page;
 
 	/* We only have a single request outstanding at a time. */
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
+	bd->lb_page = lguest_map(bd->phys_addr, 1);
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
+	lguest_unmap(bd->lb_page);
 out_free_bd:
 	kfree(bd);
 	return err;


