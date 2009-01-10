Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZAJNhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZAJNhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZAJNh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:37:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZAJNhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:37:24 -0500
Date: Sat, 10 Jan 2009 14:36:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [bisected] Re: todays git: WARNING: at
	drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110133617.GA22304@elte.hu>
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk> <200901101242.05203.borntraeger@de.ibm.com> <49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk> <20090110130745.GA14049@elte.hu> <49689EA8.20506@garzik.org> <20090110132412.GB14049@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110132412.GB14049@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> build its random kernel and reboot into it (800 MHz P3), so i started a 
> full automated bisection instead driven from a faster box.

and the winner is:

| 871af1210f13966ab911ed2166e4ab2ce775b99d is first bad commit
| commit 871af1210f13966ab911ed2166e4ab2ce775b99d
| Author: Alan Cox <alan@redhat.com>
| Date:   Mon Jan 5 14:16:39 2009 +0000
|
|     libata: Add 32bit PIO support

And the revert below does the trick.

	Ingo

--------------------->
>From f1d26da598230cc050ee2c7890bd3cebd2e76e27 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 10 Jan 2009 14:04:57 +0100
Subject: [PATCH] Revert "libata: Add 32bit PIO support"

This reverts commit 871af1210f13966ab911ed2166e4ab2ce775b99d.

[    3.834413] PM: Adding info for No Bus:8:0
[    3.835116] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.835237] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[    3.835249] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[    3.835272] device: '0:0:0:0': device_add
[    3.835374] PM: Adding info for No Bus:0:0:0:0
[    4.112738] ata2.00: ATAPI: QSI DVD-ROM SDR-081, EHA8, max UDMA/33
[    4.120617] ata2.00: configured for UDMA/33
[    4.121275] ------------[ cut here ]------------
[    4.121380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x3d9/0x840()
[    4.121538] Hardware name: HP OmniBook PC
[    4.121644] Pid: 0, comm: swapper Not tainted 2.6.28-tip-10029-g20e9954-dirty #3
[    4.121798] Call Trace:
[    4.121912]  [<c013d006>] warn_slowpath+0x86/0xa0
[    4.122030]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122136]  [<c0133270>] ? default_wake_function+0x10/0x20
[    4.122260]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.122368]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122490]  [<c06513d3>] ? ata_qc_complete_internal+0x13/0x20
[    4.122602]  [<c064f6ed>] ? __ata_qc_complete+0x6d/0xe0
[    4.122710]  [<c065e0a9>] ? ata_sff_qc_fill_rtf+0x19/0x30
[    4.122817]  [<c065fa07>] ? ata_sff_data_xfer32+0x77/0xd0
[    4.122923]  [<c0660739>] ata_sff_hsm_move+0x3d9/0x840
[    4.123029]  [<c034eb06>] ? _raw_spin_lock+0x46/0x170
[    4.123134]  [<c0660ef9>] ata_sff_interrupt+0x129/0x1e0
[    4.123246]  [<c0171dc0>] handle_IRQ_event+0x30/0x70
[    4.123354]  [<c0173b05>] handle_level_irq+0x75/0xe0
[    4.123459]  [<c0173a90>] ? handle_level_irq+0x0/0xe0
[    4.123562]  <IRQ>  [<c0104607>] ? common_interrupt+0x27/0x2c
[    4.123725]  [<c0120120>] ? native_safe_halt+0x0/0x10
[    4.123830]  [<c012012a>] ? native_safe_halt+0xa/0x10
[    4.123942]  [<c010aaf9>] ? default_idle+0x69/0xa0
[    4.124053]  [<c015f792>] ? tick_nohz_restart_sched_tick+0x32/0x1b0
[    4.124167]  [<c011715f>] ? apm_cpu_idle+0xdf/0x260
[    4.124273]  [<c01027d8>] ? cpu_idle+0x78/0x100
[    4.124379]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.124490]  [<c09a92b3>] ? rest_init+0x53/0x60
[    4.124601]  [<c0e4d82a>] ? start_kernel+0x2ba/0x360
[    4.124709]  [<c0e4d260>] ? unknown_bootoption+0x0/0x210
[    4.124820]  [<c0e4d07c>] ? i386_start_kernel+0x7c/0xb0
[    4.124948] ---[ end trace 83f9033b42a87df9 ]---
[    4.126783] scsi 1:0:0:0: CD-ROM            QSI      DVD-ROM SDR-081  EHA8 PQ: 0 ANSI: 5
[    4.126979] device: 'target1:0:0': device_add
[    4.127040] PM: Adding info for No Bus:target1:0:0
[    4.127057] device: '1:0:0:0': device_add
[    4.127191] bus: 'scsi': add device 1:0:0:0
[    4.127235] PM: Adding info for scsi:1:0:0:0
[    4.127994] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver osst
---
 drivers/ata/ata_piix.c    |    2 +-
 drivers/ata/libata-sff.c  |   53 ---------------------------------------------
 drivers/ata/pata_ali.c    |    6 ++--
 drivers/ata/pata_amd.c    |    4 +-
 drivers/ata/pata_mpiix.c  |    3 +-
 drivers/ata/pata_sil680.c |    4 +-
 include/linux/libata.h    |    3 --
 7 files changed, 9 insertions(+), 66 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 887d8f4..7865954 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -310,7 +310,7 @@ static struct scsi_host_template piix_sht = {
 };
 
 static struct ata_port_operations piix_pata_ops = {
-	.inherits		= &ata_bmdma32_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 0eae9b4..e7c8514 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -80,13 +80,6 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 };
 EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
 
-const struct ata_port_operations ata_bmdma32_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-
-	.sff_data_xfer		= ata_sff_data_xfer32,
-};
-EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);
-
 /**
  *	ata_fill_sg - Fill PCI IDE PRD table
  *	@qc: Metadata associated with taskfile to be transferred
@@ -743,52 +736,6 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer);
 
 /**
- *	ata_sff_data_xfer32 - Transfer data by PIO
- *	@dev: device to target
- *	@buf: data buffer
- *	@buflen: buffer length
- *	@rw: read/write
- *
- *	Transfer data from/to the device data register by PIO using 32bit
- *	I/O operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- *
- *	RETURNS:
- *	Bytes consumed.
- */
-
-unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,
-			       unsigned int buflen, int rw)
-{
-	struct ata_port *ap = dev->link->ap;
-	void __iomem *data_addr = ap->ioaddr.data_addr;
-	unsigned int words = buflen >> 2;
-	int slop = buflen & 3;
-
-	/* Transfer multiple of 4 bytes */
-	if (rw == READ)
-		ioread32_rep(data_addr, buf, words);
-	else
-		iowrite32_rep(data_addr, buf, words);
-
-	if (unlikely(slop)) {
-		__le32 pad;
-		if (rw == READ) {
-			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-			memcpy(buf + buflen - slop, &pad, slop);
-		} else {
-			memcpy(&pad, buf + buflen - slop, slop);
-			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-		}
-		words++;
-	}
-	return words << 2;
-}
-EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
-
-/**
  *	ata_sff_data_xfer_noirq - Transfer data by PIO
  *	@dev: device to target
  *	@buf: data buffer
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index a7999c1..a4f9e39 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -151,7 +151,8 @@ static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int o
 
 	pci_read_config_byte(pdev, pio_fifo, &fifo);
 	fifo &= ~(0x0F << shift);
-	fifo |= (on << shift);
+	if (on)
+		fifo |= (on << shift);
 	pci_write_config_byte(pdev, pio_fifo, fifo);
 }
 
@@ -369,11 +370,10 @@ static struct ata_port_operations ali_early_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= ali_set_piomode,
-	.sff_data_xfer  = ata_sff_data_xfer32,
 };
 
 static const struct ata_port_operations ali_dma_base_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
+	.inherits	= &ata_bmdma_port_ops,
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 };
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 63719ab..0ec9c7d 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.11"
+#define DRV_VERSION "0.3.10"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -345,7 +345,7 @@ static struct scsi_host_template amd_sht = {
 };
 
 static const struct ata_port_operations amd_base_port_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
+	.inherits	= &ata_bmdma_port_ops,
 	.prereset	= amd_pre_reset,
 };
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index aa576ca..7c8faa4 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_mpiix"
-#define DRV_VERSION "0.7.7"
+#define DRV_VERSION "0.7.6"
 
 enum {
 	IDETIM = 0x6C,		/* IDE control register */
@@ -146,7 +146,6 @@ static struct ata_port_operations mpiix_port_ops = {
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= mpiix_set_piomode,
 	.prereset	= mpiix_pre_reset,
-	.sff_data_xfer	= ata_sff_data_xfer32,
 };
 
 static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 9e764e5..83580a5 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -32,7 +32,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.9"
+#define DRV_VERSION "0.4.8"
 
 #define SIL680_MMIO_BAR		5
 
@@ -195,7 +195,7 @@ static struct scsi_host_template sil680_sht = {
 };
 
 static struct ata_port_operations sil680_port_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
+	.inherits	= &ata_bmdma_port_ops,
 	.cable_detect	= sil680_cable_detect,
 	.set_piomode	= sil680_set_piomode,
 	.set_dmamode	= sil680_set_dmamode,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4f7c8fb..3449de5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1518,7 +1518,6 @@ extern void sata_pmp_error_handler(struct ata_port *ap);
 
 extern const struct ata_port_operations ata_sff_port_ops;
 extern const struct ata_port_operations ata_bmdma_port_ops;
-extern const struct ata_port_operations ata_bmdma32_port_ops;
 
 /* PIO only, sg_tablesize and dma_boundary limits can be removed */
 #define ATA_PIO_SHT(drv_name)					\
@@ -1546,8 +1545,6 @@ extern void ata_sff_exec_command(struct ata_port *ap,
 				 const struct ata_taskfile *tf);
 extern unsigned int ata_sff_data_xfer(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
-extern unsigned int ata_sff_data_xfer32(struct ata_device *dev,
-			unsigned char *buf, unsigned int buflen, int rw);
 extern unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 extern u8 ata_sff_irq_on(struct ata_port *ap);
