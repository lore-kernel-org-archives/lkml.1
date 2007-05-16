Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXEPQpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXEPQpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762608AbXEPQph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:45:37 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:65054 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbXEPQpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CjVcvz6aep+YLgmuLTCNUpHXKCfOTO4i02J/89g88twGj8+LxuIrl7agGhhkaycw4Wm+dxGRnsbSTOGAcEBQKTBsY7mulYejluIFErmqxgGbnGkD+gU+uk6WlztyGnuK4XDNAC8JXdR6NYBZp/Er7lJ1wcy4iqMSQxEjjcdvDQw=
Message-ID: <464B3505.20004@gmail.com>
Date: Wed, 16 May 2007 18:44:53 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com> <20070512034928.GB29259@linux-sh.org> <20070516003002.GA18863@linux-sh.org>
In-Reply-To: <20070516003002.GA18863@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On certain device/controller combination, 0xff status is asserted
after reset and doesn't get cleared during 150ms post-reset wait.  As
0xff status is interpreted as no device (for good reasons), this can
lead to misdetection on such cases.

This patch implements ata_wait_after_reset() which replaces the 150ms
sleep and waits upto ATA_TMOUT_FF_WAIT if status is 0xff.
ATA_TMOUT_FF_WAIT is currently 800ms which is enough for
HHD424020F7SV00 to get detected but not enough for Quantum GoVault
drive which is known to take upto 2s.

Without parallel probing, spending 2s on 0xff port would incur too
much delay on ata_piix's which use 0xff to indicate empty port and
doesn't have SCR register, so GoVault needs to wait till parallel
probing.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---

This patch is against the current libata-dev#upstream +
pata_scc-fix-build-failure[1].

  [1] http://article.gmane.org/gmane.linux.kernel/528405

Paul, please verify this fixes your problem.  You can skip the
pata_scc patch, it will cause pata_scc part to be rejected but doesn't
matter.

Jeff, added 800ms delay is sad but this seems to be the only way to
avoid iVDR drive detection regression for 2.6.22.  I'll cook up
parallel probing for 2.6.23.

Thanks.

 drivers/ata/ahci.c          |   11 +------
 drivers/ata/libata-core.c   |   67 +++++++++++++++++++++++++++++++++++---------
 drivers/ata/pata_scc.c      |   13 +-------
 drivers/ata/sata_inic162x.c |    2 -
 include/linux/libata.h      |    8 +++++
 5 files changed, 67 insertions(+), 34 deletions(-)

Index: work/drivers/ata/ahci.c
===================================================================
--- work.orig/drivers/ata/ahci.c
+++ work/drivers/ata/ahci.c
@@ -947,15 +947,8 @@ static int ahci_softreset(struct ata_por
 	writel(1, port_mmio + PORT_CMD_ISSUE);
 	readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
 
-	/* spec mandates ">= 2ms" before checking status.
-	 * We wait 150ms, because that was the magic delay used for
-	 * ATAPI devices in Hale Landis's ATADRVR, for the period of time
-	 * between when the ATA command register is written, and then
-	 * status is checked.  Because waiting for "a while" before
-	 * checking status is fine, post SRST, we perform this magic
-	 * delay here as well.
-	 */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
Index: work/drivers/ata/libata-core.c
===================================================================
--- work.orig/drivers/ata/libata-core.c
+++ work/drivers/ata/libata-core.c
@@ -3008,6 +3008,55 @@ int ata_busy_sleep(struct ata_port *ap,
 }
 
 /**
+ *	ata_wait_after_reset - wait before checking status after reset
+ *	@ap: port containing status register to be polled
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	After reset, we need to pause a while before reading status.
+ *	Also, certain combination of controller and device report 0xff
+ *	for some duration (e.g. until SATA PHY is up and running)
+ *	which is interpreted as empty port in ATA world.  This
+ *	function also waits for such devices to get out of 0xff
+ *	status.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ */
+void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline)
+{
+	unsigned long until = jiffies + ATA_TMOUT_FF_WAIT;
+
+	if (time_before(until, deadline))
+		deadline = until;
+
+	/* Spec mandates ">= 2ms" before checking status.  We wait
+	 * 150ms, because that was the magic delay used for ATAPI
+	 * devices in Hale Landis's ATADRVR, for the period of time
+	 * between when the ATA command register is written, and then
+	 * status is checked.  Because waiting for "a while" before
+	 * checking status is fine, post SRST, we perform this magic
+	 * delay here as well.
+	 *
+	 * Old drivers/ide uses the 2mS rule and then waits for ready.
+	 */
+	msleep(150);
+
+	/* Wait for 0xff to clear.  Some SATA devices take a long time
+	 * to clear 0xff after reset.  For example, HHD424020F7SV00
+	 * iVDR needs >= 800ms while.  Quantum GoVault needs even more
+	 * than that.
+	 */
+	while (1) {
+		u8 status = ata_chk_status(ap);
+
+		if (status != 0xff || time_after(jiffies, deadline))
+			return;
+
+		msleep(50);
+	}
+}
+
+/**
  *	ata_wait_ready - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
  *	@deadline: deadline jiffies for the operation
@@ -3117,17 +3166,8 @@ static int ata_bus_softreset(struct ata_
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
 
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
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
@@ -3543,8 +3583,8 @@ int sata_std_hardreset(struct ata_port *
 		return 0;
 	}
 
-	/* wait a while before checking status, see SRST for more info */
-	msleep(150);
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
@@ -6847,6 +6887,7 @@ EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_busy_sleep);
+EXPORT_SYMBOL_GPL(ata_wait_after_reset);
 EXPORT_SYMBOL_GPL(ata_wait_ready);
 EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
Index: work/include/linux/libata.h
===================================================================
--- work.orig/include/linux/libata.h
+++ work/include/linux/libata.h
@@ -218,6 +218,13 @@ enum {
 	ATA_TMOUT_INTERNAL	= 30 * HZ,
 	ATA_TMOUT_INTERNAL_QUICK = 5 * HZ,
 
+	/* FIXME: GoVault needs 2s but we can't afford that without
+	 * parallel probing.  800ms is enough for iVDR disk
+	 * HHD424020F7SV00.  Increase to 2secs when parallel probing
+	 * is in place.
+	 */
+	ATA_TMOUT_FF_WAIT	= 4 * HZ / 5,
+
 	/* ATA bus states */
 	BUS_UNKNOWN		= 0,
 	BUS_DMA			= 1,
@@ -734,6 +741,7 @@ extern void ata_host_resume(struct ata_h
 extern int ata_ratelimit(void);
 extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
+extern void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline);
 extern int ata_wait_ready(struct ata_port *ap, unsigned long deadline);
 extern void ata_port_queue_task(struct ata_port *ap, work_func_t fn,
 				void *data, unsigned long delay);
Index: work/drivers/ata/pata_scc.c
===================================================================
--- work.orig/drivers/ata/pata_scc.c
+++ work/drivers/ata/pata_scc.c
@@ -557,17 +557,8 @@ static unsigned int scc_bus_softreset(st
 	udelay(20);
 	out_be32(ioaddr->ctl_addr, ap->ctl);
 
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
+	/* wait a while before checking status */
+	ata_wait_after_reset(ap, deadline);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
Index: work/drivers/ata/sata_inic162x.c
===================================================================
--- work.orig/drivers/ata/sata_inic162x.c
+++ work/drivers/ata/sata_inic162x.c
@@ -446,7 +446,7 @@ static int inic_hardreset(struct ata_por
 		struct ata_taskfile tf;
 
 		/* wait a while before checking status */
-		msleep(150);
+		ata_wait_after_reset(ap, deadline);
 
 		rc = ata_wait_ready(ap, deadline);
 		/* link occupied, -ENODEV too is an error */
