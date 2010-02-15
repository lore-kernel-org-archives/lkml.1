Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0BOVfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:35:42 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34926 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0BOVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:35:40 -0500
X-Auth-Info: eEHh3zVUkCmZ4zC/xkrVfpZc3CwiFJBxKFaIL8pblms=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anatolij Gustschin <agust@denx.de>,
       Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH] dmatest: correct raid6 PQ test
Date: Mon, 15 Feb 2010 22:35:23 +0100
Message-Id: <1266269723-556-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of PQ sources specified by module parameter "pq_sources"
is always forced odd to fit into dmatest's destination verificaton
scheme. But number of PQ sources and coefficients as passed to the
driver's prep_dma_pq() is not adjusted accordingly.

Fix it now to get correct PQ testing results in the case passed
"pq_sources" parameter is even.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
---
 drivers/dma/dmatest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 948d563..9ae3d11 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -237,7 +237,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
-	u8			pq_coefs[pq_sources];
+	u8			pq_coefs[pq_sources + 1];
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -257,7 +257,7 @@ static int dmatest_func(void *data)
 	} else if (thread->type == DMA_PQ) {
 		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
 		dst_cnt = 2;
-		for (i = 0; i < pq_sources; i++)
+		for (i = 0; i < src_cnt; i++)
 			pq_coefs[i] = 1;
 	} else
 		goto err_srcs;
@@ -355,7 +355,7 @@ static int dmatest_func(void *data)
 			for (i = 0; i < dst_cnt; i++)
 				dma_pq[i] = dma_dsts[i] + dst_off;
 			tx = dev->device_prep_dma_pq(chan, dma_pq, dma_srcs,
-						     pq_sources, pq_coefs,
+						     src_cnt, pq_coefs,
 						     len, flags);
 		}
 
-- 
1.6.3.3

