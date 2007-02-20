Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXBTBFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXBTBFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbXBTBFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:05:37 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:47560 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbXBTBFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:05:21 -0500
Date: Mon, 19 Feb 2007 19:03:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 5/5] sata_nv: enable hotplug interrupt and fix some readl/readw
 mismatches
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45DA48DF.8010906@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already have code that handles hotplug interrupt indications in ADMA
mode, this turns on the control flag that actually enables these interrupts.
Also fixes some cases in the same functions where a 16-bit register was read
using a readl instead of a readw.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-15 22:36:02.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c.delayandfixes	2007-02-19 17:00:14.000000000 -0600
@@ -1041,14 +1034,15 @@ static int nv_adma_port_start(struct ata
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN, mmio + NV_ADMA_CTL);
+	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1100,14 +1094,15 @@ static int nv_adma_port_resume(struct at
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew((tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN, mmio + NV_ADMA_CTL);
+	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1490,10 +1493,10 @@ static void nv_adma_error_handler(struct
 		/* Reset channel */
 		tmp = readw(mmio + NV_ADMA_CTL);
 		writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 		udelay(1);
 		writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	}
 
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,

