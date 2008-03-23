Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYCWRl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYCWRl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYCWRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:41:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55862 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYCWRlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:41:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18406.38445.717175.664615@harpo.it.uu.se>
Date: Sun, 23 Mar 2008 18:41:01 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: jeff@garzik.org
Cc: htejun@gmail.com, kurt@roeckx.be, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug events, take 2
In-Reply-To: <200803221421.m2MEL1oY021558@harpo.it.uu.se>
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Promise SATA controller will signal hotplug events when a hard
reset (COMRESET) is done on a port. These events aren't masked by
the driver, and the unexpected interrupts will cause a sequence
of failed reset attempts util libata's EH finally gives up.

This has not been a common problem so far, but the pending libata
hardreset-by-default changes makes it a critical issue.

The solution is to disable hotplug events before a reset, and to
reenable them afterwards. (Promise's driver does this too.)

This patch adds SATA-specific versions of ->freeze() and ->thaw()
that also disable and enable hotplug events. PATA ports continue
to use the old versions of ->freeze() and ->thaw().

Accesses to the hotplug register must be serialised via host->lock.
We rely on ap->lock == &ap->host->lock and that libata takes this
lock before ->freeze() and ->thaw(). Document this requirement.
The interrupt handler is adjusted so its hotplug register accesses
are inside the region protected by host->lock.

Tested on various chips (SATA300TX4, SATA300TX2plus, SATAII150TX4,
FastTrack TX4000) with various combinations of SATA and PATA disks,
with and without the pending hardreset-by-default changes.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
Changes since previous version:
- rephrase the problem description to avoid calling it a HW quirk,
  the behaviour is apparently standard
- fix double locking bug found by Tejun, now tested with SMP kernel
- document locking rules for the global hotplug register
- inline the hotplug enable/disable code in freeze/thaw

 drivers/ata/sata_promise.c |  109 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 21 deletions(-)

diff -rupN linux-2.6.25-rc6/drivers/ata/sata_promise.c linux-2.6.25-rc6.sata_promise-fix-hardreset-hotplug-events/drivers/ata/sata_promise.c
--- linux-2.6.25-rc6/drivers/ata/sata_promise.c	2008-03-22 12:53:32.000000000 +0100
+++ linux-2.6.25-rc6.sata_promise-fix-hardreset-hotplug-events/drivers/ata/sata_promise.c	2008-03-23 15:20:27.000000000 +0100
@@ -46,7 +46,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.11"
+#define DRV_VERSION	"2.12"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -145,7 +145,9 @@ static int pdc_old_sata_check_atapi_dma(
 static void pdc_irq_clear(struct ata_port *ap);
 static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc);
 static void pdc_freeze(struct ata_port *ap);
+static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
+static void pdc_sata_thaw(struct ata_port *ap);
 static void pdc_pata_error_handler(struct ata_port *ap);
 static void pdc_sata_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -180,8 +182,8 @@ static const struct ata_port_operations 
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -205,8 +207,8 @@ static const struct ata_port_operations 
 
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
-	.freeze			= pdc_freeze,
-	.thaw			= pdc_thaw,
+	.freeze			= pdc_sata_freeze,
+	.thaw			= pdc_sata_thaw,
 	.error_handler		= pdc_sata_error_handler,
 	.post_internal_cmd	= pdc_post_internal_cmd,
 	.cable_detect		= pdc_sata_cable_detect,
@@ -631,6 +633,41 @@ static void pdc_qc_prep(struct ata_queue
 	}
 }
 
+static int pdc_is_sataii_tx4(unsigned long flags)
+{
+	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
+	return (flags & mask) == mask;
+}
+
+static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
+					  int is_sataii_tx4)
+{
+	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
+}
+
+static unsigned int pdc_sata_nr_ports(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_4_PORTS) ? 4 : 2;
+}
+
+static unsigned int pdc_sata_ata_port_to_ata_no(const struct ata_port *ap)
+{
+	const struct ata_host *host = ap->host;
+	unsigned int nr_ports = pdc_sata_nr_ports(ap);
+	unsigned int i;
+
+	for(i = 0; i < nr_ports && host->ports[i] != ap; ++i)
+		;
+	BUG_ON(i >= nr_ports);
+	return pdc_port_no_to_ata_no(i, pdc_is_sataii_tx4(ap->flags));
+}
+
+static unsigned int pdc_sata_hotplug_offset(const struct ata_port *ap)
+{
+	return (ap->flags & PDC_FLAG_GEN_II) ? PDC2_SATA_PLUG_CSR : PDC_SATA_PLUG_CSR;
+}	
+
 static void pdc_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -643,6 +680,29 @@ static void pdc_freeze(struct ata_port *
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_freeze(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	/* Disable hotplug events on this port.
+	 *
+	 * Locking:
+	 * 1) hotplug register accesses must be serialised via host->lock
+	 * 2) ap->lock == &ap->host->lock
+	 * 3) ->freeze() and ->thaw() are called with ap->lock held
+	 */
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << (ata_no + 16);
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+
+	pdc_freeze(ap);
+}
+
 static void pdc_thaw(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->ioaddr.cmd_addr;
@@ -658,6 +718,26 @@ static void pdc_thaw(struct ata_port *ap
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static void pdc_sata_thaw(struct ata_port *ap)
+{
+	struct ata_host *host = ap->host;
+	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
+	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
+	u32 hotplug_status;
+
+	pdc_thaw(ap);
+
+	/* Enable hotplug events on this port.
+	 * Locking: see pdc_sata_freeze().
+	 */
+	hotplug_status = readl(host_mmio + hotplug_offset);
+	hotplug_status |= 0x11 << ata_no;
+	hotplug_status &= ~(0x11 << (ata_no + 16));
+	writel(hotplug_status, host_mmio + hotplug_offset);
+	readl(host_mmio + hotplug_offset); /* flush */
+}
+
 static void pdc_common_error_handler(struct ata_port *ap, ata_reset_fn_t hardreset)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
@@ -765,19 +845,6 @@ static void pdc_irq_clear(struct ata_por
 	readl(mmio + PDC_INT_SEQMASK);
 }
 
-static int pdc_is_sataii_tx4(unsigned long flags)
-{
-	const unsigned long mask = PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS;
-	return (flags & mask) == mask;
-}
-
-static unsigned int pdc_port_no_to_ata_no(unsigned int port_no,
-					  int is_sataii_tx4)
-{
-	static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
-	return is_sataii_tx4 ? sataii_tx4_port_remap[port_no] : port_no;
-}
-
 static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -799,6 +866,8 @@ static irqreturn_t pdc_interrupt(int irq
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	spin_lock(&host->lock);
+
 	/* read and clear hotplug flags for all ports */
 	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
 		hotplug_offset = PDC2_SATA_PLUG_CSR;
@@ -814,11 +883,9 @@ static irqreturn_t pdc_interrupt(int irq
 
 	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
-		return IRQ_NONE;
+		goto done_irq;
 	}
 
-	spin_lock(&host->lock);
-
 	mask &= 0xffff;		/* only 16 tags possible */
 	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
