Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXJROCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXJROCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765924AbXJROCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:02:23 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:37006 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765858AbXJROCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:02:22 -0400
Message-ID: <47176768.8070804@tiscali.nl>
Date: Thu, 18 Oct 2007 16:02:16 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: peterz@infradead.org, viro@ftp.linux.org.uk
Subject: [PATCH 4/4 returns] fix not-and/or errors
References: <47161243.6060007@tiscali.nl> <47161451.9010309@tiscali.nl>
In-Reply-To: <47161451.9010309@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Thanks for comments, here a second version with previously covered commits removed
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/mach-pxa/mfp.c b/arch/arm/mach-pxa/mfp.c
index 5cd3cad..7229319 100644
--- a/arch/arm/mach-pxa/mfp.c
+++ b/arch/arm/mach-pxa/mfp.c
@@ -199,7 +199,7 @@ void pxa3xx_mfp_set_edge(int mfp, int edge)
 
 	mfpr_val &= ~MFPR_EDGE_MASK;
 	mfpr_val |= (edge & 0x3u) << MFPR_ERE_OFFSET;
-	mfpr_val |= (!edge & 0x1) << MFPR_EC_OFFSET;
+	mfpr_val |= (!(edge & 0x1)) << MFPR_EC_OFFSET;
 
 	mfpr_writel(mfpr_off, mfpr_val);
 	mfpr_sync();
diff --git a/arch/sh/drivers/dma/dma-sh.c b/arch/sh/drivers/dma/dma-sh.c
index 958bac1..e8f9c85 100644
--- a/arch/sh/drivers/dma/dma-sh.c
+++ b/arch/sh/drivers/dma/dma-sh.c
@@ -89,7 +89,7 @@ static irqreturn_t dma_tei(int irq, void *dev_id)
 
 static int sh_dmac_request_dma(struct dma_channel *chan)
 {
-	if (unlikely(!chan->flags & DMA_TEI_CAPABLE))
+	if (unlikely(!(chan->flags & DMA_TEI_CAPABLE)))
 		return 0;
 
 	return request_irq(get_dmte_irq(chan->chan), dma_tei,
diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index d915fec..1db2055 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -596,7 +596,7 @@ write_led(const char __user * buffer, unsigned long count,
 	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
 
 	if (invert)		/* invert target value */
-		led_out = !led_out & 0x1;
+		led_out = !led_out;
 
 	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
 		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 9b2c0f7..3762ce2 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -420,8 +420,7 @@ static int acpi_battery_update(struct acpi_battery *battery,
 		result = acpi_battery_get_status(battery);
 		if (result)
 			goto end;
-		if ((!battery->flags.battery_present_prev & acpi_battery_present(battery))
-		    || (battery->flags.battery_present_prev & !acpi_battery_present(battery))) {
+		if (battery->flags.battery_present_prev != acpi_battery_present(battery)) {
 			result = acpi_battery_init_update(battery);
 			if (result)
 				goto end;
@@ -448,10 +447,7 @@ static void acpi_battery_notify_update(struct acpi_battery *battery)
 		return;
 	}
 
-	if ((!battery->flags.battery_present_prev &
-	     acpi_battery_present(battery)) ||
-	    (battery->flags.battery_present_prev &
-	     !acpi_battery_present(battery))) {
+	if (battery->flags.battery_present_prev != acpi_battery_present(battery)) {
 		battery->flags.init_update = 1;
 	} else {
 		battery->flags.update[ACPI_BATTERY_INFO] = 1;

