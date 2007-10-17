Return-Path: <linux-kernel-owner+w=401wt.eu-S1765104AbXJQNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765104AbXJQNzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbXJQNzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:55:33 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:59689 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbXJQNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:55:32 -0400
Message-ID: <47161451.9010309@tiscali.nl>
Date: Wed, 17 Oct 2007 15:55:29 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl>
In-Reply-To: <47161243.6060007@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    if(!x & y) should either be if(!(x & y)) or if(!x && y)
    I made changes as seemed appropriate, but please review
    
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
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 3d45d24..7d78d22 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -858,7 +858,7 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	lsapic = (struct acpi_madt_local_sapic *)obj->buffer.pointer;
 
 	if ((lsapic->header.type != ACPI_MADT_TYPE_LOCAL_SAPIC) ||
-	    (!lsapic->lapic_flags & ACPI_MADT_ENABLED)) {
+	    (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))) {
 		kfree(buffer.pointer);
 		return -EINVAL;
 	}
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
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index cd8c740..a2cf955 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -1070,7 +1070,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 	 * Not having a register set can lead to trouble.
 	 * Also starfire doesn't have a tod clock.
 	 */
-	if (!mregs && !dregs & !bregs)
+	if (!mregs && !dregs && !bregs)
 		return -1;
 
 	if (mregs) {
diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index d915fec..5a67a87 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -596,7 +596,7 @@ write_led(const char __user * buffer, unsigned long count,
 	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
 
 	if (invert)		/* invert target value */
-		led_out = !led_out & 0x1;
+		led_out = !(led_out & 0x1);
 
 	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
 		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 9b2c0f7..48fbe9e 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -420,8 +420,8 @@ static int acpi_battery_update(struct acpi_battery *battery,
 		result = acpi_battery_get_status(battery);
 		if (result)
 			goto end;
-		if ((!battery->flags.battery_present_prev & acpi_battery_present(battery))
-		    || (battery->flags.battery_present_prev & !acpi_battery_present(battery))) {
+		if ((!battery->flags.battery_present_prev && acpi_battery_present(battery))
+		    || (battery->flags.battery_present_prev && !acpi_battery_present(battery))) {
 			result = acpi_battery_init_update(battery);
 			if (result)
 				goto end;
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 9f4e67e..37079d9 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -660,11 +660,11 @@ static int pt_open(struct inode *inode, struct file *file)
 	pt_identify(tape);
 
 	err = -ENODEV;
-	if (!tape->flags & PT_MEDIA)
+	if (!(tape->flags & PT_MEDIA))
 		goto out;
 
 	err = -EROFS;
-	if ((!tape->flags & PT_WRITE_OK) && (file->f_mode & 2))
+	if ((!(tape->flags & PT_WRITE_OK)) && (file->f_mode & 2))
 		goto out;
 
 	if (!(iminor(inode) & 128))

