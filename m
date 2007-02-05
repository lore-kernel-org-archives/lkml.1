Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXBETUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXBETUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXBETUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:20:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:63541 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbXBETUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KkwFdJkeF/cX718eZcVe4oOpWhrTpxAitQk2zmnoqXpAQ4c+SDRgJtgc8Q/tH9izk+HybokmoXf+MAX5RZoxwVeyQCHjTbztxsAyZ7CjjmNPSiEO3yuR9kiF9xCSOncqRizOu9wyeD8MX0Fv+1hRbwbFzFYhITVW2kjSStWwxsM=
Date: Mon, 5 Feb 2007 22:13:21 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Sam Creasey <sammy@sammy.net>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] SUN3/3X Lance trivial fix
Message-ID: <20070205191321.GA12839@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for allocated DVMA
memory and granted IRQ line.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

---

 drivers/net/sun3lance.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sun3lance.c b/drivers/net/sun3lance.c
index c62e85d..e4c2c88 100644
--- a/drivers/net/sun3lance.c
+++ b/drivers/net/sun3lance.c
@@ -336,13 +336,20 @@ static int __init lance_probe( struct net_device *dev)
 
 	/* XXX - leak? */
 	MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
+	if (MEM == NULL) {
+		printk(KERN_WARNING "SUN3 Lance couldn't allocate DVMA memory\n");
+		return 0;
+	}
 
 	lp->iobase = (volatile unsigned short *)ioaddr;
 	dev->base_addr = (unsigned long)ioaddr; /* informational only */
 
 	REGA(CSR0) = CSR0_STOP;
 
-	request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev);
+	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
+		printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
+		return 0;
+	}
 	dev->irq = (unsigned short)LANCE_IRQ;
 
 
