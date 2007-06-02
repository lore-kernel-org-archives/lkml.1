Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXFBQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXFBQLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbXFBQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:11:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXFBQLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:11:30 -0400
Message-ID: <466196AD.3090502@garzik.org>
Date: Sat, 02 Jun 2007 12:11:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
In-Reply-To: <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070203040900030907000800"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070203040900030907000800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gregor Jasny wrote:
> Hi,
> 
> 2007/5/26, Linus Torvalds <torvalds@linux-foundation.org>:
>> What more could you possibly want? Some ATA updates? USB suspend problem
> 
> 22-rc3 broke the CDROM in my Dell notebook.  After I've switched to
> libata som time ago, I've got some delays/timeouts during boot [1].
> But the drive works as expected. With 2.6.22-rc3 I've got the
> following messages during bootup:

Does this patch change the behavior at all?

	Jeff




--------------070203040900030907000800
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9c07b88..8b58597 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -288,6 +288,7 @@ static const struct ata_port_operations piix_pata_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
+	.cable_detect		= ata_cable_40wire,
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -300,7 +301,6 @@ static const struct ata_port_operations piix_pata_ops = {
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= piix_pata_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
-	.cable_detect		= ata_cable_40wire,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -322,6 +322,7 @@ static const struct ata_port_operations ich_pata_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
+	.cable_detect		= ich_pata_cable_detect,
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -334,7 +335,6 @@ static const struct ata_port_operations ich_pata_ops = {
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= piix_pata_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
-	.cable_detect		= ich_pata_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -353,6 +353,7 @@ static const struct ata_port_operations piix_sata_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
+	.cable_detect		= ata_cable_sata,
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3ca9c61..dbd590a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3035,7 +3035,7 @@ int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
 			warned = 1;
 		}
 
-		msleep(50);
+		msleep(5);
 	}
 }
 
@@ -3072,7 +3072,7 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 			break;
 		if (time_after(jiffies, deadline))
 			return -EBUSY;
-		msleep(50);	/* give drive a breather */
+		msleep(5);	/* give drive a breather */
 	}
 	if (dev1) {
 		rc = ata_wait_ready(ap, deadline);
@@ -3101,23 +3101,13 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
 	/* software reset.  causes dev0 to be selected */
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
+	ata_pause(ap);
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	ata_pause(ap);
 
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 *
-	 * Old drivers/ide uses the 2mS rule and then waits for ready
-	 */
-	msleep(150);
+	/* spec mandates ">= 2ms" before checking status */
+	msleep(2);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
@@ -3363,6 +3353,35 @@ int ata_std_prereset(struct ata_port *ap, unsigned long deadline)
 					"link for reset (errno=%d)\n", rc);
 	}
 
+	return 0;
+}
+
+/**
+ *	sata_std_prereset - prepare for reset
+ *	@ap: ATA port to be reset
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	@ap is about to be reset.  Initialize it.  Failure from
+ *	prereset makes libata abort whole reset sequence and give up
+ *	that port, so prereset should be best-effort.  It does its
+ *	best to prepare for reset sequence but if things go wrong, it
+ *	should just whine, not fail.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int sata_std_prereset(struct ata_port *ap, unsigned long deadline)
+{
+	struct ata_eh_context *ehc = &ap->eh_context;
+	int rc;
+
+	rc = ata_std_prereset(ap, deadline);
+	if (rc)
+		return rc;
+
 	/* Wait for !BSY if the controller can wait for the first D2H
 	 * Reg FIS and we don't know that no device is attached.
 	 */
@@ -3404,9 +3423,13 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
 
 	if (ata_port_offline(ap)) {
 		classes[0] = ATA_DEV_NONE;
+		classes[1] = ATA_DEV_NONE;
 		goto out;
 	}
 
+	/* set up Device Control */
+	iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+
 	/* determine if device 0/1 are present */
 	if (ata_devchk(ap, 0))
 		devmask |= (1 << 0);
@@ -3419,6 +3442,7 @@ int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
 	rc = ata_bus_softreset(ap, devmask, deadline);
+
 	/* if link is occupied, -ENODEV too is an error */
 	if (rc && (rc != -ENODEV || sata_scr_valid(ap))) {
 		ata_port_printk(ap, KERN_ERR, "SRST failed (errno=%d)\n", rc);
@@ -3534,7 +3558,7 @@ int sata_std_hardreset(struct ata_port *ap, unsigned int *class,
 	}
 
 	/* wait a while before checking status, see SRST for more info */
-	msleep(150);
+	msleep(3);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
@@ -6837,6 +6861,7 @@ EXPORT_SYMBOL_GPL(ata_bmdma_freeze);
 EXPORT_SYMBOL_GPL(ata_bmdma_thaw);
 EXPORT_SYMBOL_GPL(ata_bmdma_drive_eh);
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
+EXPORT_SYMBOL_GPL(sata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_port_probe);
 EXPORT_SYMBOL_GPL(ata_dev_disable);
@@ -6847,6 +6872,7 @@ EXPORT_SYMBOL_GPL(sata_phy_reset);
 EXPORT_SYMBOL_GPL(__sata_phy_reset);
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
+EXPORT_SYMBOL_GPL(sata_std_prereset);
 EXPORT_SYMBOL_GPL(ata_std_softreset);
 EXPORT_SYMBOL_GPL(sata_port_hardreset);
 EXPORT_SYMBOL_GPL(sata_std_hardreset);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e35d134..3233fe9 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -503,6 +503,27 @@ void ata_bmdma_error_handler(struct ata_port *ap)
 }
 
 /**
+ *	sata_bmdma_error_handler - Stock SATA error handler for BMDMA controller
+ *	@ap: port to handle error for
+ *
+ *	Stock error handler for BMDMA controller.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void sata_bmdma_error_handler(struct ata_port *ap)
+{
+	ata_reset_fn_t hardreset;
+
+	hardreset = NULL;
+	if (sata_scr_valid(ap))
+		hardreset = sata_std_hardreset;
+
+	ata_bmdma_drive_eh(ap, sata_std_prereset, ata_std_softreset, hardreset,
+			   ata_std_postreset);
+}
+
+/**
  *	ata_bmdma_post_internal_cmd - Stock post_internal_cmd for
  *				      BMDMA controller
  *	@qc: internal command to clean up
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index a3b339b..feac2c3 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -202,7 +202,7 @@ static const struct ata_port_operations sil_ops = {
 	.data_xfer		= ata_data_xfer,
 	.freeze			= sil_freeze,
 	.thaw			= sil_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 221099d..852e1e0 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -119,7 +119,7 @@ static const struct ata_port_operations sis_ops = {
 	.data_xfer		= ata_data_xfer,
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index bcb2cd8..362ad0b 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -343,7 +343,7 @@ static const struct ata_port_operations k2_sata_ops = {
 	.data_xfer		= ata_data_xfer,
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 6815de7..29c7be7 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -112,7 +112,7 @@ static const struct ata_port_operations uli_ops = {
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
 	.irq_clear		= ata_bmdma_irq_clear,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index e8b90e7..1a26aea 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -174,7 +174,7 @@ static const struct ata_port_operations vt6421_pata_ops = {
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.cable_detect		= vt6421_pata_cable_detect,
 
@@ -205,7 +205,7 @@ static const struct ata_port_operations vt6421_sata_ops = {
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.cable_detect		= ata_cable_sata,
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 8133017..177552b 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -331,7 +331,7 @@ static const struct ata_port_operations vsc_sata_ops = {
 	.data_xfer		= ata_data_xfer,
 	.freeze			= vsc_freeze,
 	.thaw			= vsc_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= sata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 85f7b1b..5f75d45 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -674,6 +674,7 @@ extern int sata_phy_debounce(struct ata_port *ap, const unsigned long *param,
 extern int sata_phy_resume(struct ata_port *ap, const unsigned long *param,
 			   unsigned long deadline);
 extern int ata_std_prereset(struct ata_port *ap, unsigned long deadline);
+extern int sata_std_prereset(struct ata_port *ap, unsigned long deadline);
 extern int ata_std_softreset(struct ata_port *ap, unsigned int *classes,
 			     unsigned long deadline);
 extern int sata_port_hardreset(struct ata_port *ap, const unsigned long *timing,
@@ -786,6 +787,7 @@ extern void ata_bmdma_drive_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 			       ata_reset_fn_t hardreset,
 			       ata_postreset_fn_t postreset);
 extern void ata_bmdma_error_handler(struct ata_port *ap);
+extern void sata_bmdma_error_handler(struct ata_port *ap);
 extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			u8 status, int in_wq);

--------------070203040900030907000800--
