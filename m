Return-Path: <linux-kernel-owner+w=401wt.eu-S934436AbZGQLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbZGQLK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934411AbZGQLK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 07:10:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:39838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934403AbZGQLK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 07:10:26 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/vqylhyg3vey5YPaG9Jo4puIhmFDSM0g+tyv8SqI
	Kdyeu81VLwTh2Y
Date: Fri, 17 Jul 2009 13:10:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: MMC: Make the configuration memory resource optional
Message-ID: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for tmio_mmc hardware configurations, that lack the cnf io 
area, like SuperH SoCs. With this patch such hardware can pass a single 
ctl io area with the platform data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Magnus Damm <damm@opensource.se>
---
Pierre, I know you wanted to step down as a MMC maintainer (thanks for 
your great work btw!), but since we don't have a new one yet, I'm CC-ing 
you.

A version of this patch has previously been submitted by Magnus Damm 
(CCed), but it hasn't been accepted back at 2.6.29 times (about 4 months 
ago). Now this driver extension has become much simpler, so, I think, 
there should be no problem accepting this patch now.

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 91991b4..c246191 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -519,12 +519,12 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
 
-	if (dev->num_resources != 3)
+	if (dev->num_resources < 2 || dev->num_resources > 3)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf)
+	if (!res_ctl)
 		goto out;
 
 	pdata = cell->driver_data;
@@ -548,9 +548,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
+	if (res_cnf) {
+		host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
+		if (!host->cnf)
+			goto unmap_ctl;
+	}
 
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
@@ -606,7 +608,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	return 0;
 
 unmap_cnf:
-	iounmap(host->cnf);
+	if (host->cnf)
+		iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -626,7 +629,8 @@ static int __devexit tmio_mmc_remove(struct platform_device *dev)
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
+		if (host->cnf)
+			iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 9fa9985..45f06aa 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -166,18 +166,24 @@ static inline void sd_ctrl_write32(struct tmio_mmc_host *host, int addr,
 static inline void sd_config_write8(struct tmio_mmc_host *host, int addr,
 		u8 val)
 {
+	if (!host->cnf)
+		return;
 	writeb(val, host->cnf + (addr << host->bus_shift));
 }
 
 static inline void sd_config_write16(struct tmio_mmc_host *host, int addr,
 		u16 val)
 {
+	if (!host->cnf)
+		return;
 	writew(val, host->cnf + (addr << host->bus_shift));
 }
 
 static inline void sd_config_write32(struct tmio_mmc_host *host, int addr,
 		u32 val)
 {
+	if (!host->cnf)
+		return;
 	writew(val, host->cnf + (addr << host->bus_shift));
 	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
 }
