Return-Path: <linux-kernel-owner+w=401wt.eu-S935172AbXK3PvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172AbXK3PvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXK3PvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:51:10 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42643 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbXK3PvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:51:09 -0500
Date: Fri, 30 Nov 2007 16:50:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: starvik@axis.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] arch/cris: Added a missing iounmap
Message-ID: <Pine.LNX.4.64.0711301649570.26269@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

An extra error handling label is needed for the case where the ioremap has
succeeded.

The problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2;
constant C;
int ret;
@@

  T E;
  ...
* E = ioremap(...);
  if (E == NULL) S
  ... when != iounmap(E)
      when != if (E != NULL) { ... iounmap(E); ...}
      when != x1 = (T1)E
  if (...) {
    ... when != iounmap(E)
        when != if (E != NULL) { ... iounmap(E); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return C;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c	2007-07-20 17:45:43.000000000 +0200
+++ b/arch/cris/arch-v32/drivers/pci/dma.c	2007-11-29 18:45:16.000000000 +0100
@@ -93,7 +93,7 @@ int dma_declare_coherent_memory(struct d
 
 	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
 	if (!dev->dma_mem)
-		goto out;
+		goto iounmap_out;
 	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dev->dma_mem->bitmap)
 		goto free1_out;
@@ -110,6 +110,8 @@ int dma_declare_coherent_memory(struct d
 
  free1_out:
 	kfree(dev->dma_mem);
+ iounmap_out:
+	iounmap(mem_base);
  out:
 	return 0;
 }
