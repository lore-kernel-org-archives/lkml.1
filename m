Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbXLNTpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbXLNTpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXLNTpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:45:05 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:55632 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752558AbXLNTpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:45:03 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Date: Fri, 14 Dec 2007 21:44:46 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: shannon.nelson@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712142144.47310.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

After commit 7bb67c14fd3778504fb77da30ce11582336dfced, Linus's git tree gaves following compiliation error with gcc-3.4.6. Following patch solves this issue for me;


[...]
  CC [M]  drivers/dma/ioat.o
  CC [M]  drivers/dma/ioat_dma.o
drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining failed in call to '__ioat1_dma_memcpy_issue_pending': function body not available
drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
make[2]: *** [drivers/dma/ioat_dma.o] Hata 1
make[1]: *** [drivers/dma] Hata 2
make: *** [drivers] Hata 2

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index c1c2dcc..1d66b82 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -173,10 +173,25 @@ static void ioat_set_dest(dma_addr_t addr,
 	tx_to_ioat_desc(tx)->dst = addr;
 }
 
+/**
+ * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
+ *                                 descriptors to hw
+ * @chan: DMA channel handle
+ */
 static inline void __ioat1_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
+}
+
 static inline void __ioat2_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writew(ioat_chan->dmacount,
+	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+}
 
 static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 {
@@ -700,18 +715,6 @@ static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
 }
 
 
-/**
- * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
- *                                 descriptors to hw
- * @chan: DMA channel handle
- */
-static inline void __ioat1_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
-}
-
 static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
@@ -723,14 +726,6 @@ static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
 	}
 }
 
-static inline void __ioat2_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writew(ioat_chan->dmacount,
-	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
-}
-
 static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
