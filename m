Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXBFPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXBFPik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbXBFPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:38:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:47616 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXBFPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=VieBFmdoNb8QNlvL73a+SVQ5kcJl2SCjUKpE9lZ47U3AD4Wt0OgLrt2uJFe7TEB8cl5To2aXolOt1N1FyogJrM6TgdJFb0YUGiyD93jIXsatoUTdUB+QqhRNldL6O8bUj8O2Jrio1dbDrM0+RM4sGzzzd4It7oG9LmhgRATyZ3I=
Date: Tue, 6 Feb 2007 18:36:15 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Sam Creasey <sammy@sammy.net>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] SUN3/3X Lance trivial fix improved
Message-ID: <20070206153615.GA12371@cvg>
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

Sam, this patch is almost the same I've already sent you
except of some improvements (thanks to Jiri Slaby) like
iounmap(), dvma_free() calls.

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
 
 
