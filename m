Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZLVUbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZLVUbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZLVUbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:31:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48401 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZLVUbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:31:05 -0500
Date: Tue, 22 Dec 2009 21:30:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] drivers/dma: Correct use after free
Message-ID: <Pine.LNX.4.64.0912222130370.28669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the kfree after the iounmap that refers to the same structure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/dma/coh901318.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 4a99cd9..b5f2ee0 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1294,8 +1294,8 @@ static int __exit coh901318_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&base->dma_slave);
 	coh901318_pool_destroy(&base->pool);
 	free_irq(platform_get_irq(pdev, 0), base);
-	kfree(base);
 	iounmap(base->virtbase);
+	kfree(base);
 	release_mem_region(pdev->resource->start,
 			   resource_size(pdev->resource));
 	return 0;
