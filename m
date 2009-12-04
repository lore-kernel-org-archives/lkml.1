Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZLDSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZLDSob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZLDSoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:44:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:60920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756756AbZLDSo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:44:27 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19Jo24ir4VJm8YMNWC8z4lCAKi+7WCFKZzcTx64KZ
	tzJ2oBSnwIRaKD
Date: Fri, 4 Dec 2009 19:44:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 2/5] dmaengine: fix dmatest to verify minimum transfer length
 and test buffer size
In-Reply-To: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912041940580.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transfers and the test buffer have to be at least align bytes long.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/dmatest.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a32a4cf..8b90516 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -298,10 +298,6 @@ static int dmatest_func(void *data)
 
 		total_tests++;
 
-		len = dmatest_random() % test_buf_size + 1;
-		src_off = dmatest_random() % (test_buf_size - len + 1);
-		dst_off = dmatest_random() % (test_buf_size - len + 1);
-
 		/* honor alignment restrictions */
 		if (thread->type == DMA_MEMCPY)
 			align = dev->copy_align;
@@ -310,7 +306,19 @@ static int dmatest_func(void *data)
 		else if (thread->type == DMA_PQ)
 			align = dev->pq_align;
 
+		if (1 << align > test_buf_size) {
+			pr_err("%u-byte buffer too small for %d-byte alignment\n",
+			       test_buf_size, 1 << align);
+			break;
+		}
+
+		len = dmatest_random() % test_buf_size + 1;
 		len = (len >> align) << align;
+		if (!len)
+			len = 1 << align;
+		src_off = dmatest_random() % (test_buf_size - len + 1);
+		dst_off = dmatest_random() % (test_buf_size - len + 1);
+
 		src_off = (src_off >> align) << align;
 		dst_off = (dst_off >> align) << align;
 
-- 
1.6.2.4

