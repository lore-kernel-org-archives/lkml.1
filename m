Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYHFNX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYHFNX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYHFNUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:20:10 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53652 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbYHFNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:20:01 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Marc Zyngier <maz@misterjones.org>,
       Marc Zyngier <marc.zyngier@altran.com>
Subject: [PATCH 3/5] [PCMCIA] Add support for platform dependant quirks
Date: Wed,  6 Aug 2008 15:19:52 +0200
Message-Id: <b6f70421a31e59e19a0aaa79d068fa34876e60b7.1218018637.git.marc.zyngier@altran.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
References: <>
 <1218028794-850-1-git-send-email-maz@misterjones.org>
 <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
 <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
In-Reply-To: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
References: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk, linux@dominikbrodowski.net, maz@misterjones.org, marc.zyngier@altran.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms, namely the Arcom/Eurotech Viper, need some extra care
to run (on this board, the PC104 connector is actually wired to the
second PCMCIA slot, and needs to be powered on despite not being managed
by the PCMCIA code...).

Add a quirks field to the pcmcia_low_level structure that the SOC
dependant code can inspect.

Introduce a PXA2XX_QUIRK_NEEDS_MECR_NOS that can be used by the offending
board.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
---
 drivers/pcmcia/pxa2xx_base.c |   20 ++++++++++++++++++--
 drivers/pcmcia/pxa2xx_base.h |    7 +++++++
 drivers/pcmcia/soc_common.h  |    2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index ccfdf19..9e61f21 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -195,7 +195,7 @@ int __pxa2xx_drv_pcmcia_probe(struct device *dev)
 		MECR |= MECR_CIT;
 
 		/* Set MECR:NOS (Number Of Sockets) */
-		if (nr > 1)
+		if (nr > 1 || (ops->quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
 			MECR |= MECR_NOS;
 		else
 			MECR &= ~MECR_NOS;
@@ -226,7 +226,23 @@ static int pxa2xx_drv_pcmcia_resume(struct platform_device *dev)
 	struct pcmcia_low_level *ops = dev->dev.platform_data;
 	int nr = ops ? ops->nr : 0;
 
-	MECR = nr > 1 ? MECR_CIT | MECR_NOS : (nr > 0 ? MECR_CIT : 0);
+	if (nr > 0) {
+		u32 quirks = ops ? ops->quirks : 0;
+		int v;
+
+		/*
+		 * We have at least one socket, so set MECR:CIT
+		 * (Card Is There)
+		 */
+		v = MECR_CIT;
+
+		/* Set MECR:NOS (Number Of Sockets) */
+		if (nr > 1 || (quirks & PXA2XX_QUIRK_NEEDS_MECR_NOS))
+			v |= MECR_NOS;
+
+		MECR = v;
+	} else
+		MECR = 0;
 
 	return pcmcia_socket_dev_resume(&dev->dev);
 }
diff --git a/drivers/pcmcia/pxa2xx_base.h b/drivers/pcmcia/pxa2xx_base.h
index 235d681..956ee9d 100644
--- a/drivers/pcmcia/pxa2xx_base.h
+++ b/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,10 @@
+#ifndef PXA2XX_BASE
+#define PXA2XX_BASE
+
+#define PXA2XX_QUIRK_NEEDS_MECR_NOS		(1 << 0)
+
 /* temporary measure */
 extern int __pxa2xx_drv_pcmcia_probe(struct device *);
 
+#endif
+
diff --git a/drivers/pcmcia/soc_common.h b/drivers/pcmcia/soc_common.h
index 91ef6a0..9e288fc 100644
--- a/drivers/pcmcia/soc_common.h
+++ b/drivers/pcmcia/soc_common.h
@@ -76,6 +76,8 @@ struct pcmcia_low_level {
 	int first;
 	/* nr of sockets */
 	int nr;
+	/* Quirks required by this system, SOC dependant */
+	u32 quirks;
 
 	int (*hw_init)(struct soc_pcmcia_socket *);
 	void (*hw_shutdown)(struct soc_pcmcia_socket *);
-- 
1.5.4.3

