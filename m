Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXKOHJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXKOHJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbXKOGs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43772 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbXKOGsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:22 -0500
Date: Wed, 14 Nov 2007 22:45:57 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>
Subject: [patch 38/40] libata: backport ATA_FLAG_NO_SRST and
	ATA_FLAG_ASSUME_ATA, part 2
Message-ID: <20071115064557.GM19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-backport-ata_flag_no_srst-and-ata_flag_assume_ata-part-2.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

Differs from mainline, but the functionality is already there.

P5W-DH Deluxe has ICH7R which doesn't have PMP support but SIMG 4726
hardwired to the second port of AHCI controller at PCI device 1f.2.
The 4726 doesn't work as PMP but as a storage processor which can do
hardware RAID on downstream ports.

When no device is attached to the downstream port of the 4726, pseudo
ATA device for configuration appears.  Unfortunately, ATA emulation on
the device is very lousy and causes long hang during boot.

This patch implements workaround for the board.  If the mainboard is
P5W-DH Deluxe (matched using DMI), only hardreset is used on the
second port of AHCI controller @ 1f.2 and the hardreset doesn't depend
on receiving the first FIS and just proceed to IDENTIFY.

This workaround fixes bugzilla #8923.

  http://bugzilla.kernel.org/show_bug.cgi?id=8923

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |  143 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
+#include <linux/dmi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
@@ -231,6 +232,7 @@ static void ahci_freeze(struct ata_port 
 static void ahci_thaw(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
+static void ahci_p5wdh_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
@@ -329,6 +331,40 @@ static const struct ata_port_operations 
 	.port_stop		= ahci_port_stop,
 };
 
+static const struct ata_port_operations ahci_p5wdh_ops = {
+	.port_disable		= ata_port_disable,
+
+	.check_status		= ahci_check_status,
+	.check_altstatus	= ahci_check_status,
+	.dev_select		= ata_noop_dev_select,
+
+	.tf_read		= ahci_tf_read,
+
+	.qc_prep		= ahci_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+
+	.irq_clear		= ahci_irq_clear,
+	.irq_on			= ata_dummy_irq_on,
+	.irq_ack		= ata_dummy_irq_ack,
+
+	.scr_read		= ahci_scr_read,
+	.scr_write		= ahci_scr_write,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+
+	.error_handler		= ahci_p5wdh_error_handler,
+	.post_internal_cmd	= ahci_post_internal_cmd,
+
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
@@ -1176,6 +1212,52 @@ static int ahci_vt8251_hardreset(struct 
 	return rc ?: -EAGAIN;
 }
 
+static int ahci_p5wdh_hardreset(struct ata_port *ap, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	int rc;
+
+	ahci_stop_engine(ap);
+
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(ap->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+
+	rc = sata_port_hardreset(ap, sata_ehc_deb_timing(&ap->eh_context),
+				 deadline);
+
+	ahci_start_engine(ap);
+
+	if (rc || ata_port_offline(ap))
+		return rc;
+
+	/* spec mandates ">= 2ms" before checking status */
+	msleep(150);
+
+	/* The pseudo configuration device on SIMG4726 attached to
+	 * ASUS P5W-DH Deluxe doesn't send signature FIS after
+	 * hardreset if no device is attached to the first downstream
+	 * port && the pseudo device locks up on SRST w/ PMP==0.  To
+	 * work around this, wait for !BSY only briefly.  If BSY isn't
+	 * cleared, perform CLO and proceed to IDENTIFY (achieved by
+	 * ATA_LFLAG_NO_SRST and ATA_LFLAG_ASSUME_ATA).
+	 *
+	 * Wait for two seconds.  Devices attached to downstream port
+	 * which can't process the following IDENTIFY after this will
+	 * have to be reset again.  For most cases, this should
+	 * suffice while making probing snappish enough.
+	 */
+	rc = ata_wait_ready(ap, jiffies + 2 * HZ);
+	if (rc)
+		ahci_kick_engine(ap, 0);
+
+	return 0;
+}
+
 static void ahci_postreset(struct ata_port *ap, unsigned int *class)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -1556,6 +1638,19 @@ static void ahci_vt8251_error_handler(st
 		  ahci_postreset);
 }
 
+static void ahci_p5wdh_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
+		/* restart engine */
+		ahci_stop_engine(ap);
+		ahci_start_engine(ap);
+	}
+
+	/* perform recovery */
+	ata_do_eh(ap, ata_std_prereset, ahci_softreset, ahci_p5wdh_hardreset,
+		  ahci_postreset);
+}
+
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
@@ -1802,6 +1897,51 @@ static void ahci_print_info(struct ata_h
 		);
 }
 
+/* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
+ * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
+ * support PMP and the 4726 either directly exports the device
+ * attached to the first downstream port or acts as a hardware storage
+ * controller and emulate a single ATA device (can be RAID 0/1 or some
+ * other configuration).
+ *
+ * When there's no device attached to the first downstream port of the
+ * 4726, "Config Disk" appears, which is a pseudo ATA device to
+ * configure the 4726.  However, ATA emulation of the device is very
+ * lame.  It doesn't send signature D2H Reg FIS after the initial
+ * hardreset, pukes on SRST w/ PMP==0 and has bunch of other issues.
+ *
+ * The following function works around the problem by always using
+ * hardreset on the port and not depending on receiving signature FIS
+ * afterward.  If signature FIS isn't received soon, ATA class is
+ * assumed without follow-up softreset.
+ */
+static void ahci_p5wdh_workaround(struct ata_host *host)
+{
+	static struct dmi_system_id sysids[] = {
+		{
+			.ident = "P5W DH Deluxe",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR,
+					  "ASUSTEK COMPUTER INC"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
+			},
+		},
+		{ }
+	};
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	if (pdev->bus->number == 0 && pdev->devfn == PCI_DEVFN(0x1f, 2) &&
+	    dmi_check_system(sysids)) {
+		struct ata_port *ap = host->ports[1];
+
+		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
+			   "Deluxe on-board SIMG4726 workaround\n");
+
+		ap->ops = &ahci_p5wdh_ops;
+		ap->flags |= ATA_FLAG_NO_SRST | ATA_FLAG_ASSUME_ATA;
+	}
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -1863,6 +2003,9 @@ static int ahci_init_one(struct pci_dev 
 			ap->ops = &ata_dummy_port_ops;
 	}
 
+	/* apply workaround for ASUS P5W DH Deluxe mainboard */
+	ahci_p5wdh_workaround(host);
+
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
 	if (rc)

-- 
