Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZKUPXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZKUPXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbZKUPXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:23:54 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37185 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZKUPXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:23:51 -0500
Date: Sat, 21 Nov 2009 16:23:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: walter harms <wharms@bfs.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
In-Reply-To: <20091121151647.GA13956@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0911211621580.26930@ask.diku.dk>
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de>
 <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk> <20091121151647.GA13956@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009, Russell King - ARM Linux wrote:

> On Sat, Nov 21, 2009 at 04:12:59PM +0100, Julia Lawall wrote:
> > Both kzallocs were added at the same time, when the function was added in 
> > commit 701a5dc05ad99a06958b3f97cb69d99b47cebee3.  I have added the author 
> > to the CC list.
> 
> That commit id means nothing to me.

It seems to only exist under linux-next, even though it dates from March.  
The relevant part of the patch is below (see the definition of 
sa1111_pcmcia_add).

julia

commit 701a5dc05ad99a06958b3f97cb69d99b47cebee3
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Sun Mar 29 19:42:44 2009 +0100

    PCMCIA: sa1111: wrap soc_pcmcia_socket to contain sa1111 specific data
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/sa1111_generic.c b/drivers/pcmcia/sa1111_generic.c
index a6793e3..98c7915 100644
--- a/drivers/pcmcia/sa1111_generic.c
+++ b/drivers/pcmcia/sa1111_generic.c
@@ -30,9 +30,6 @@ static struct pcmcia_irqs irqs[] = {
 
 int sa1111_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
-	if (skt->irq == NO_IRQ)
-		skt->irq = skt->nr ? IRQ_S1_READY_NINT : IRQ_S0_READY_NINT;
-
 	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
 }
 
@@ -43,8 +40,8 @@ void sa1111_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
 
 void sa1111_pcmcia_socket_state(struct soc_pcmcia_socket *skt, struct pcmcia_state *state)
 {
-	struct sa1111_dev *sadev = SA1111_DEV(skt->dev);
-	unsigned long status = sa1111_readl(sadev->mapbase + SA1111_PCSR);
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
+	unsigned long status = sa1111_readl(s->dev->mapbase + SA1111_PCSR);
 
 	switch (skt->nr) {
 	case 0:
@@ -71,7 +68,7 @@ void sa1111_pcmcia_socket_state(struct soc_pcmcia_socket *skt, struct pcmcia_sta
 
 int sa1111_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_state_t *state)
 {
-	struct sa1111_dev *sadev = SA1111_DEV(skt->dev);
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
 	unsigned int pccr_skt_mask, pccr_set_mask, val;
 	unsigned long flags;
 
@@ -100,10 +97,10 @@ int sa1111_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_s
 		pccr_set_mask |= PCCR_S0_FLT|PCCR_S1_FLT;
 
 	local_irq_save(flags);
-	val = sa1111_readl(sadev->mapbase + SA1111_PCCR);
+	val = sa1111_readl(s->dev->mapbase + SA1111_PCCR);
 	val &= ~pccr_skt_mask;
 	val |= pccr_set_mask & pccr_skt_mask;
-	sa1111_writel(val, sadev->mapbase + SA1111_PCCR);
+	sa1111_writel(val, s->dev->mapbase + SA1111_PCCR);
 	local_irq_restore(flags);
 
 	return 0;
@@ -119,10 +116,45 @@ void sa1111_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
 	soc_pcmcia_disable_irqs(skt, irqs, ARRAY_SIZE(irqs));
 }
 
+int sa1111_pcmcia_add(struct sa1111_dev *dev, struct pcmcia_low_level *ops,
+	int (*add)(struct soc_pcmcia_socket *))
+{
+	struct sa1111_pcmcia_socket *s;
+	int i, ret = 0;
+
+	s = kzalloc(sizeof(*s) * ops->nr, GFP_KERNEL);
+	if (!s)
+		return -ENODEV;
+
+	for (i = 0; i < ops->nr; i++) {
+		s = kzalloc(sizeof(*s), GFP_KERNEL);
+		if (!s)
+			return -ENOMEM;
+
+		s->soc.nr = ops->first + i;
+		s->soc.irq = s->soc.nr ? IRQ_S1_READY_NINT : IRQ_S0_READY_NINT;
+		s->soc.ops = ops;
+		s->soc.socket.owner = ops->owner;
+		s->soc.socket.dev.parent = &dev->dev;
+		s->dev = dev;
+
+		ret = add(&s->soc);
+		if (ret == 0) {
+			s->next = dev_get_drvdata(&dev->dev);
+			dev_set_drvdata(&dev->dev, s);
+		} else
+			kfree(s);
+	}
+
+	return ret;
+}
+
 static int pcmcia_probe(struct sa1111_dev *dev)
 {
 	void __iomem *base;
 
+	dev_set_drvdata(&dev->dev, NULL);
+
 	if (!request_mem_region(dev->res.start, 512,
 				SA1111_DRIVER_NAME(dev)))
 		return -EBUSY;
@@ -152,15 +184,15 @@ static int pcmcia_probe(struct sa1111_dev *dev)
 
 static int __devexit pcmcia_remove(struct sa1111_dev *dev)
 {
-	struct skt_dev_info *sinfo = dev_get_drvdata(&dev->dev);
-	int i;
+	struct sa1111_pcmcia_socket *next, *s = dev_get_drvdata(&dev->dev);
 
 	dev_set_drvdata(&dev->dev, NULL);
 
-	for (i = 0; i < sinfo->nskt; i++)
-		soc_pcmcia_remove_one(&sinfo->skt[i]);
+	for (; next = s->next, s; s = next) {
+		soc_pcmcia_remove_one(&s->soc);
+		kfree(s);
+	}
 
-	kfree(sinfo);
 	release_mem_region(dev->res.start, 512);
 	return 0;
 }
