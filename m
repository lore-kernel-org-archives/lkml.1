Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZKUPZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZKUPZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbZKUPZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:25:46 -0500
Received: from isilmar.linta.de ([213.133.102.198]:43851 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756477AbZKUPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:25:43 -0500
Date: Sat, 21 Nov 2009 16:25:46 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Julia Lawall <julia@diku.dk>, walter harms <wharms@bfs.de>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
Message-ID: <20091121152546.GA2513@isilmar.linta.de>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Julia Lawall <julia@diku.dk>, walter harms <wharms@bfs.de>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de> <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk> <20091121151647.GA13956@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121151647.GA13956@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 03:16:47PM +0000, Russell King - ARM Linux wrote:
> On Sat, Nov 21, 2009 at 04:12:59PM +0100, Julia Lawall wrote:
> > Both kzallocs were added at the same time, when the function was added in 
> > commit 701a5dc05ad99a06958b3f97cb69d99b47cebee3.  I have added the author 
> > to the CC list.
> 
> That commit id means nothing to me.

Well, it's equivalent to your patch 05/10 of your patch series, just with my
SOB added...
 

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Sun, 29 Mar 2009 19:42:44 +0100
Subject: [PATCH] PCMCIA: sa1111: wrap soc_pcmcia_socket to contain sa1111 specific data

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 3cb4fd2..c9c104b 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -228,7 +228,7 @@ static const char *skt_names[] = {
 #define SKT_DEV_INFO_SIZE(n) \
 	(sizeof(struct skt_dev_info) + (n)*sizeof(struct soc_pcmcia_socket))
 
-static int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
+int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
 {
 	skt->res_skt.start = _PCMCIA(skt->nr);
 	skt->res_skt.end = _PCMCIA(skt->nr) + PCMCIASp - 1;
@@ -253,9 +253,18 @@ static int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
 	return soc_pcmcia_add_one(skt);
 }
 
+void pxa2xx_drv_pcmcia_ops(struct pcmcia_low_level *ops)
+{
+	/* Provide our PXA2xx specific timing routines. */
+	ops->set_timing  = pxa2xx_pcmcia_set_timing;
+#ifdef CONFIG_CPU_FREQ
+	ops->frequency_change = pxa2xx_pcmcia_frequency_change;
+#endif
+}
+
 int __pxa2xx_drv_pcmcia_probe(struct device *dev)
 {
-	int i, ret;
+	int i, ret = 0;
 	struct pcmcia_low_level *ops;
 	struct skt_dev_info *sinfo;
 	struct soc_pcmcia_socket *skt;
@@ -265,11 +274,7 @@ int __pxa2xx_drv_pcmcia_probe(struct device *dev)
 
 	ops = (struct pcmcia_low_level *)dev->platform_data;
 
-	/* Provide our PXA2xx specific timing routines. */
-	ops->set_timing  = pxa2xx_pcmcia_set_timing;
-#ifdef CONFIG_CPU_FREQ
-	ops->frequency_change = pxa2xx_pcmcia_frequency_change;
-#endif
+	pxa2xx_drv_pcmcia_ops(ops);
 
 	sinfo = kzalloc(SKT_DEV_INFO_SIZE(ops->nr), GFP_KERNEL);
 	if (!sinfo)
diff --git a/drivers/pcmcia/pxa2xx_base.h b/drivers/pcmcia/pxa2xx_base.h
index 235d681..cb5efae 100644
--- a/drivers/pcmcia/pxa2xx_base.h
+++ b/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,6 @@
 /* temporary measure */
 extern int __pxa2xx_drv_pcmcia_probe(struct device *);
 
+int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt);
+void pxa2xx_drv_pcmcia_ops(struct pcmcia_low_level *ops);
+
diff --git a/drivers/pcmcia/pxa2xx_lubbock.c b/drivers/pcmcia/pxa2xx_lubbock.c
index 6cbb1b1..35d5280 100644
--- a/drivers/pcmcia/pxa2xx_lubbock.c
+++ b/drivers/pcmcia/pxa2xx_lubbock.c
@@ -32,6 +32,7 @@ static int
 lubbock_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
 				const socket_state_t *state)
 {
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
 	unsigned int pa_dwr_mask, pa_dwr_set, misc_mask, misc_set;
 	int ret = 0;
 
@@ -149,7 +150,7 @@ lubbock_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
 
 	if (ret == 0) {
 		lubbock_set_misc_wr(misc_mask, misc_set);
-		sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, pa_dwr_set);
+		sa1111_set_io(s->dev, pa_dwr_mask, pa_dwr_set);
 	}
 
 #if 1
@@ -175,7 +176,7 @@ lubbock_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
 			 * Switch to 5V,  Configure socket with 5V voltage
 			 */
 			lubbock_set_misc_wr(misc_mask, 0);
-			sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, 0);
+			sa1111_set_io(s->dev, pa_dwr_mask, 0);
 
 			/*
 			 * It takes about 100ms to turn off Vcc.
@@ -228,8 +229,9 @@ int pcmcia_lubbock_init(struct sa1111_dev *sadev)
 		/* Set CF Socket 1 power to standby mode. */
 		lubbock_set_misc_wr((1 << 15) | (1 << 14), 0);
 
-		sadev->dev.platform_data = &lubbock_pcmcia_ops;
-		ret = __pxa2xx_drv_pcmcia_probe(&sadev->dev);
+		pxa2xx_drv_pcmcia_ops(&lubbock_pcmcia_ops);
+		ret = sa1111_pcmcia_add(sadev, &lubbock_pcmcia_ops,
+				pxa2xx_drv_pcmcia_add_one);
 	}
 
 	return ret;
diff --git a/drivers/pcmcia/sa1100_badge4.c b/drivers/pcmcia/sa1100_badge4.c
index 1ca9737..6399314 100644
--- a/drivers/pcmcia/sa1100_badge4.c
+++ b/drivers/pcmcia/sa1100_badge4.c
@@ -134,6 +134,9 @@ static struct pcmcia_low_level badge4_pcmcia_ops = {
 
 	.socket_init		= sa1111_pcmcia_socket_init,
 	.socket_suspend		= sa1111_pcmcia_socket_suspend,
+
+	.first			= 0,
+	.nr			= 2,
 };
 
 int pcmcia_badge4_init(struct device *dev)
@@ -146,7 +149,9 @@ int pcmcia_badge4_init(struct device *dev)
 		       __func__,
 		       badge4_pcmvcc, badge4_pcmvpp, badge4_cfvcc);
 
-		ret = sa11xx_drv_pcmcia_probe(dev, &badge4_pcmcia_ops, 0, 2);
+		sa11xx_drv_pcmcia_ops(&badge4_pcmcia_ops);
+		ret = sa1111_pcmcia_add(dev, &badge4_pcmcia_ops,
+				sa11xx_drv_pcmcia_add_one);
 	}
 
 	return ret;
diff --git a/drivers/pcmcia/sa1100_jornada720.c b/drivers/pcmcia/sa1100_jornada720.c
index 7eedb42..4a32f4f 100644
--- a/drivers/pcmcia/sa1100_jornada720.c
+++ b/drivers/pcmcia/sa1100_jornada720.c
@@ -24,6 +24,7 @@
 
 static int jornada720_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
 	unsigned int pin = GPIO_A0 | GPIO_A1 | GPIO_A2 | GPIO_A3;
 
 	/*
@@ -31,9 +32,9 @@ static int jornada720_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 	*/
 	GRER |= 0x00000002;
 	/* Set GPIO_A<3:1> to be outputs for PCMCIA/CF power controller: */
-	sa1111_set_io_dir(SA1111_DEV(skt->dev), pin, 0, 0);
-	sa1111_set_io(SA1111_DEV(skt->dev), pin, 0);
-	sa1111_set_sleep_io(SA1111_DEV(skt->dev), pin, 0);
+	sa1111_set_io_dir(s->dev, pin, 0, 0);
+	sa1111_set_io(s->dev, pin, 0);
+	sa1111_set_sleep_io(s->dev, pin, 0);
 
 	return sa1111_pcmcia_hw_init(skt);
 }
@@ -41,6 +42,7 @@ static int jornada720_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 static int
 jornada720_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_state_t *state)
 {
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
 	unsigned int pa_dwr_mask, pa_dwr_set;
 	int ret;
 
@@ -97,7 +99,7 @@ jornada720_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_s
 		unsigned long flags;
 
 		local_irq_save(flags);
-		sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, pa_dwr_set);
+		sa1111_set_io(s->dev, pa_dwr_mask, pa_dwr_set);
 		local_irq_restore(flags);
 	}
 
@@ -113,14 +115,20 @@ static struct pcmcia_low_level jornada720_pcmcia_ops = {
 
 	.socket_init		= sa1111_pcmcia_socket_init,
 	.socket_suspend		= sa1111_pcmcia_socket_suspend,
+
+	.first			= 0,
+	.nr			= 2,
 };
 
 int __devinit pcmcia_jornada720_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
-	if (machine_is_jornada720())
-		ret = sa11xx_drv_pcmcia_probe(dev, &jornada720_pcmcia_ops, 0, 2);
+	if (machine_is_jornada720()) {
+		sa11xx_drv_pcmcia_ops(&jornada720_pcmcia_ops);
+		ret = sa1111_pcmcia_add(dev, &jornada720_pcmcia_ops,
+				sa11xx_drv_pcmcia_add_one);
+	}
 
 	return ret;
 }
diff --git a/drivers/pcmcia/sa1100_neponset.c b/drivers/pcmcia/sa1100_neponset.c
index 0c76d33..e39c65a 100644
--- a/drivers/pcmcia/sa1100_neponset.c
+++ b/drivers/pcmcia/sa1100_neponset.c
@@ -43,6 +43,7 @@
 static int
 neponset_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_state_t *state)
 {
+	struct sa1111_pcmcia_socket *s = to_skt(skt);
 	unsigned int ncr_mask, ncr_set, pa_dwr_mask, pa_dwr_set;
 	int ret;
 
@@ -99,7 +100,7 @@ neponset_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_sta
 		NCR_0 = (NCR_0 & ~ncr_mask) | ncr_set;
 
 		local_irq_restore(flags);
-		sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, pa_dwr_set);
+		sa1111_set_io(s->dev, pa_dwr_mask, pa_dwr_set);
 	}
 
 	return 0;
@@ -121,6 +122,8 @@ static struct pcmcia_low_level neponset_pcmcia_ops = {
 	.configure_socket	= neponset_pcmcia_configure_socket,
 	.socket_init		= neponset_pcmcia_socket_init,
 	.socket_suspend 	= sa1111_pcmcia_socket_suspend,
+	.first			= 0,
+	.nr			= 2,
 };
 
 int pcmcia_neponset_init(struct sa1111_dev *sadev)
@@ -135,7 +138,9 @@ int pcmcia_neponset_init(struct sa1111_dev *sadev)
 		sa1111_set_io_dir(sadev, GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0, 0);
 		sa1111_set_io(sadev, GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0);
 		sa1111_set_sleep_io(sadev, GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0);
-		ret = sa11xx_drv_pcmcia_probe(&sadev->dev, &neponset_pcmcia_ops, 0, 2);
+		sa11xx_drv_pcmcia_ops(&neponset_pcmcia_ops);
+		ret = sa1111_pcmcia_add(sadev, &neponset_pcmcia_ops,
+				sa11xx_drv_pcmcia_add_one);
 	}
 
 	return ret;
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
diff --git a/drivers/pcmcia/sa1111_generic.h b/drivers/pcmcia/sa1111_generic.h
index 10ced4a..536fe15 100644
--- a/drivers/pcmcia/sa1111_generic.h
+++ b/drivers/pcmcia/sa1111_generic.h
@@ -1,6 +1,20 @@
 #include "soc_common.h"
 #include "sa11xx_base.h"
 
+struct sa1111_pcmcia_socket {
+	struct soc_pcmcia_socket soc;
+	struct sa1111_dev *dev;
+	struct sa1111_pcmcia_socket *next;
+};
+
+static inline struct sa1111_pcmcia_socket *to_skt(struct soc_pcmcia_socket *s)
+{
+	return container_of(s, struct sa1111_pcmcia_socket, soc);
+}
+
+int sa1111_pcmcia_add(struct sa1111_dev *dev, struct pcmcia_low_level *ops,
+	int (*add)(struct soc_pcmcia_socket *));
+
 extern int sa1111_pcmcia_hw_init(struct soc_pcmcia_socket *);
 extern void sa1111_pcmcia_hw_shutdown(struct soc_pcmcia_socket *);
 extern void sa1111_pcmcia_socket_state(struct soc_pcmcia_socket *, struct pcmcia_state *);
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 92a4348..4db8149 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -171,7 +171,7 @@ static const char *skt_names[] = {
 #define SKT_DEV_INFO_SIZE(n) \
 	(sizeof(struct skt_dev_info) + (n)*sizeof(struct soc_pcmcia_socket))
 
-static int sa11xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
+int sa11xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
 {
 	skt->res_skt.start = _PCMCIA(skt->nr);
 	skt->res_skt.end = _PCMCIA(skt->nr) + PCMCIASp - 1;
@@ -195,14 +195,10 @@ static int sa11xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt)
 
 	return soc_pcmcia_add_one(skt);
 }
+EXPORT_SYMBOL(sa11xx_drv_pcmcia_add_one);
 
-int sa11xx_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops,
-			    int first, int nr)
+void sa11xx_drv_pcmcia_ops(struct pcmcia_low_level *ops)
 {
-	struct skt_dev_info *sinfo;
-	struct soc_pcmcia_socket *skt;
-	int i;
-
 	/*
 	 * set default MECR calculation if the board specific
 	 * code did not specify one...
@@ -216,6 +212,17 @@ int sa11xx_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops,
 #ifdef CONFIG_CPU_FREQ
 	ops->frequency_change = sa1100_pcmcia_frequency_change;
 #endif
+}
+EXPORT_SYMBOL(sa11xx_drv_pcmcia_ops);
+
+int sa11xx_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops,
+			    int first, int nr)
+{
+	struct skt_dev_info *sinfo;
+	struct soc_pcmcia_socket *skt;
+	int i, ret = 0;
+
+	sa11xx_drv_pcmcia_ops(ops);
 
 	sinfo = kzalloc(SKT_DEV_INFO_SIZE(nr), GFP_KERNEL);
 	if (!sinfo)
diff --git a/drivers/pcmcia/sa11xx_base.h b/drivers/pcmcia/sa11xx_base.h
index 7bc2082..3d76d72 100644
--- a/drivers/pcmcia/sa11xx_base.h
+++ b/drivers/pcmcia/sa11xx_base.h
@@ -118,6 +118,8 @@ static inline unsigned int sa1100_pcmcia_cmd_time(unsigned int cpu_clock_khz,
 }
 
 
+int sa11xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt);
+void sa11xx_drv_pcmcia_ops(struct pcmcia_low_level *ops);
 extern int sa11xx_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops, int first, int nr);
 
 #endif  /* !defined(_PCMCIA_SA1100_H) */

