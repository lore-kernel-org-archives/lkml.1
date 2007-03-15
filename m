Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXCOSIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXCOSIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXCOSIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:08:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:58810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXCOSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HKXvy/Zp/75nDdlkqlzYjqUb3uVg0RLKx2NtCVfH8q4T9eJbuoUm6CfZJ7swV3ECeub8xiNPrAqG7/565pfmRCe/mTf+s5bU72Wer7EVvDk/6xNDbe69MTabN+oR8liFyM9ToOEaXohf3g1TvnBXf+5zaGpvtmpYCOwWiQo85R8=
Date: Thu, 15 Mar 2007 21:05:09 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] SUN3/3X Lance trivial fix improved
Message-ID: <20070315180509.GA10235@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for allocated DVMA memory
and granted IRQ line.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

---

Andrew, I've sent the patch almost the month ago...
It seems the patch was lost :(

drivers/net/sun3lance.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sun3lance.c b/drivers/net/sun3lance.c
index c62e85d..7bee45b 100644
--- a/drivers/net/sun3lance.c
+++ b/drivers/net/sun3lance.c
@@ -336,13 +336,27 @@ static int __init lance_probe( struct net_device *dev)
 
 	/* XXX - leak? */
 	MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
+	if (MEM == NULL) {
+#ifdef CONFIG_SUN3
+		iounmap((void __iomem *)ioaddr);
+#endif
+		printk(KERN_WARNING "SUN3 Lance couldn't allocate DVMA memory\n");
+		return 0;
+	}
 
 	lp->iobase = (volatile unsigned short *)ioaddr;
 	dev->base_addr = (unsigned long)ioaddr; /* informational only */
 
 	REGA(CSR0) = CSR0_STOP;
 
-	request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev);
+	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
+#ifdef CONFIG_SUN3
+		iounmap((void __iomem *)ioaddr);
+#endif
+		dvma_free((void *)MEM);
+		printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
+		return 0;
+	}
 	dev->irq = (unsigned short)LANCE_IRQ;
 
 
