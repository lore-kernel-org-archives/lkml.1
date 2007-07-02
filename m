Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXGBXJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXGBXJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbXGBXJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:09:22 -0400
Received: from aun.it.uu.se ([130.238.12.36]:52140 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbXGBXJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:09:20 -0400
Date: Tue, 3 Jul 2007 01:09:05 +0200 (MEST)
Message-Id: <200707022309.l62N9597007667@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] sata_promise: SATA hotplug support, take 2
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables hotplugging of SATA devices in the
sata_promise driver. It's been tested successfully on
both first- and second-generation Promise SATA chips:
SATA150 TX2plus, SATAII150 TX2plus, SATAII150 TX4,
SATA300 TX2plus, and SATA300 TX4.

The only quirk I've seen is that hotplugging (insertion)
on the first-generation SATA150 TX2plus requires a lengthier
EH sequence than on the second-generation chips.
On the second-generation chips a simple soft reset seems
to suffice, but on the first-generation chip there's a
"port is slow to respond" after the initial soft reset,
after which libata issues a hard reset, and then the
device is recognised.

The hotplug checks are high up in the interrupt handling
path, not deep down in error_intr as in ahci/sata_sil24.
That's because the chip doesn't signal hotplug status changes
in the per-port status register: instead a global register
contains hotplug control and status flags for all ports.
I considered following the ahci/sata_sil24 structure, but
that would have required non-trivial changes to the interrupt
handling path, so I chose to keep the hotplug changes simple
and unobtrusive.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
--
This patch depends on the "sata_promise: cleanups" patch.

Changes since the previous version (posted June 19):
- Correct pdc_interrupt() to increment 'handled' also in
  the hotplug case. This prevents IRQ_NONE from being
  returned when an interrupt only has hotplug events to
  handle, which could confuse the kernel's IRQ machinery.
- Added testing on the SATAII150 TX4.

 drivers/ata/sata_promise.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc7/drivers/ata/sata_promise.c.~1~	2007-07-02 23:31:33.000000000 +0200
+++ linux-2.6.22-rc7/drivers/ata/sata_promise.c	2007-07-02 23:32:15.000000000 +0200
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.08"
+#define DRV_VERSION	"2.09"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -716,6 +716,9 @@ static irqreturn_t pdc_interrupt (int ir
 	unsigned int i, tmp;
 	unsigned int handled = 0;
 	void __iomem *mmio_base;
+	unsigned int hotplug_offset, ata_no;
+	u32 hotplug_status;
+	int is_sataii_tx4;
 
 	VPRINTK("ENTER\n");
 
@@ -726,10 +729,20 @@ static irqreturn_t pdc_interrupt (int ir
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	/* read and clear hotplug flags for all ports */
+	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
+		hotplug_offset = PDC2_SATA_PLUG_CSR;
+	else
+		hotplug_offset = PDC_SATA_PLUG_CSR;
+	hotplug_status = readl(mmio_base + hotplug_offset);
+	if (hotplug_status & 0xff)
+		writel(hotplug_status | 0xff, mmio_base + hotplug_offset);
+	hotplug_status &= 0xff;	/* clear uninteresting bits */
+
 	/* reading should also clear interrupts */
 	mask = readl(mmio_base + PDC_INT_SEQMASK);
 
-	if (mask == 0xffffffff) {
+	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
 		return IRQ_NONE;
 	}
@@ -737,16 +750,34 @@ static irqreturn_t pdc_interrupt (int ir
 	spin_lock(&host->lock);
 
 	mask &= 0xffff;		/* only 16 tags possible */
-	if (!mask) {
+	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
 		goto done_irq;
 	}
 
 	writel(mask, mmio_base + PDC_INT_SEQMASK);
 
+	is_sataii_tx4 = pdc_is_sataii_tx4(host->ports[0]->flags);
+
 	for (i = 0; i < host->n_ports; i++) {
 		VPRINTK("port %u\n", i);
 		ap = host->ports[i];
+
+		/* check for a plug or unplug event */
+		ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
+		tmp = hotplug_status & (0x11 << ata_no);
+		if (tmp && ap &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			ata_ehi_clear_desc(ehi);
+			ata_ehi_hotplugged(ehi);
+			ata_ehi_push_desc(ehi, "hotplug_status %#x", tmp);
+			ata_port_freeze(ap);
+			++handled;
+			continue;
+		}
+
+		/* check for a packet interrupt */
 		tmp = mask & (1 << (i + 1));
 		if (tmp && ap &&
 		    !(ap->flags & ATA_FLAG_DISABLED)) {
@@ -902,9 +933,9 @@ static void pdc_host_init(struct ata_hos
 	tmp = readl(mmio + hotplug_offset);
 	writel(tmp | 0xff, mmio + hotplug_offset);
 
-	/* mask plug/unplug ints */
+	/* unmask plug/unplug ints */
 	tmp = readl(mmio + hotplug_offset);
-	writel(tmp | 0xff0000, mmio + hotplug_offset);
+	writel(tmp & ~0xff0000, mmio + hotplug_offset);
 
 	/* don't initialise TBG or SLEW on 2nd generation chips */
 	if (is_gen2)
