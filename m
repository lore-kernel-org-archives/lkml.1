Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZKRCi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZKRCi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 21:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZKRCiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 21:38:25 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:16902 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbZKRCiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 21:38:25 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2.6.32] cxgb3: fix premature page unmap
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 17 Nov 2009 18:38:28 -0800
Message-ID: <20091118023828.16411.57681.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

unmap Rx page only when guaranteed that this page won't be
used anymore to allocate rx page chunks.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index f866128..6366061 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -879,7 +879,7 @@ recycle:
 	pci_dma_sync_single_for_cpu(adap->pdev, dma_addr, len,
 				    PCI_DMA_FROMDEVICE);
 	(*sd->pg_chunk.p_cnt)--;
-	if (!*sd->pg_chunk.p_cnt)
+	if (!*sd->pg_chunk.p_cnt && sd->pg_chunk.page != fl->pg_chunk.page)
 		pci_unmap_page(adap->pdev,
 			       sd->pg_chunk.mapping,
 			       fl->alloc_size,
@@ -2088,7 +2088,7 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 				    PCI_DMA_FROMDEVICE);
 
 	(*sd->pg_chunk.p_cnt)--;
-	if (!*sd->pg_chunk.p_cnt)
+	if (!*sd->pg_chunk.p_cnt && sd->pg_chunk.page != fl->pg_chunk.page)
 		pci_unmap_page(adap->pdev,
 			       sd->pg_chunk.mapping,
 			       fl->alloc_size,

