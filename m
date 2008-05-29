Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYE2QkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYE2QkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbYE2Qjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:39:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60149 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758431AbYE2Qjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:39:49 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org for
	pnp devices with no ctl
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jeff@garzik.org,
       torvalds@osdl.org
Date: Thu, 29 May 2008 17:25:37 +0100
Message-ID: <20080529161453.24735.805.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Jeff would you please take a look at this: Its #4 or #5 top OOPS on Arjan's
 oops tracker, and it generally causes the boot to fail. First sent 20th May)

From: Alan Cox <alan@redhat.com>

This fixes most common oops #5 on Arjan's kerneloops.org site

Not all controllers have ctl/altstatus. In particular many ISAPnP controllers
omit them. While libata should handle this it generally only got the ctl port
(the write side) correct.

Functions
- ata_sff_maybe_altstatus - this uses the status if altstatus is not available.
  In the longer term I believe each use of it is in fact removable but don't
  want to perturb anything during the -rc releases
- ata_sff_pause - don't use altstatus I/O for fencing if we don't have one
- ata_sff_sync - add a fencing call so we can distinguish fencing from real
		 altstatus usage. All non ctl/altstatus controllers are PIO
		 so do not need a fence

Code wise we then use maybe_altstatus in the IRQ path (where we should only
check status and the current code is actually I think buggy), and for DMA
completion (no non ctl/altstatus controller does DMA but need to finish
verifying the calling cases).

This has been tested with ctl/altstatus faked to be unavailable on controllers
I have and works. You get some spew about failed identify but that is another
issue that can be fixed later and it does all work. Also the spew only occurs
on controllers that currently just go wrong.



Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Tejun Heo <htejun@gmail.com>

---

 drivers/ata/libata-sff.c  |   81 +++++++++++++++++++++++++++++++++++++++++----
 drivers/ata/pata_icside.c |    2 +
 include/linux/libata.h    |   14 +-------
 3 files changed, 76 insertions(+), 21 deletions(-)


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3c2d228..25bcb58 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -256,6 +256,72 @@ u8 ata_sff_altstatus(struct ata_port *ap)
 }
 
 /**
+ *	ata_sff_maybe_altstatus - Read device alternate status reg
+ *	@ap: port where the device is
+ *
+ *	TEMPORARY:
+ *
+ *	Reads ATA taskfile alternate status register for
+ *	currently-selected device and return its value. Uses the
+ *	status register as an alternative.
+ *
+ *	Note: may NOT be used as the check_altstatus() entry in
+ *	ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static u8 ata_sff_maybe_altstatus(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus)
+		return ap->ops->sff_check_altstatus(ap);
+	else if (ap->ioaddr.altstatus_addr)
+		return ioread8(ap->ioaddr.altstatus_addr);
+	else
+		return ata_sff_check_status(ap);
+}
+
+/**
+ *	ata_sff_sync - Flush writes
+ *	@ap: Port to wait for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static void ata_sff_sync(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus)
+		ap->ops->sff_check_altstatus(ap);
+	else if (ap->ioaddr.altstatus_addr)
+		ioread8(ap->ioaddr.altstatus_addr);
+	ndelay(400);
+}
+
+/**
+ *	ata_sff_pause - Flush writes and wait 400nS
+ *	@ap: Port to wait for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ata_sff_pause(struct ata_port *ap)
+{
+	ata_sff_sync(ap);
+	ndelay(400);
+}
+
+
+/**
  *	ata_sff_busy_sleep - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
  *	@tmout_pat: impatience timeout
@@ -742,7 +808,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
 	} else
 		ata_pio_sector(qc);
 
-	ata_sff_altstatus(qc->ap); /* flush */
+	ata_sff_sync(qc->ap); /* flush */
 }
 
 /**
@@ -763,7 +829,7 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	WARN_ON(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap);
 
 	switch (qc->tf.protocol) {
 	case ATAPI_PROT_PIO:
@@ -905,7 +971,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap); /* flush */
 
 	return;
 
@@ -1489,8 +1555,8 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 		goto idle_irq;
 	}
 
-	/* check altstatus */
-	status = ata_sff_altstatus(ap);
+	/* check altstatus: We don't need to do this here */
+	status = ata_sff_maybe_altstatus(ap);
 	if (status & ATA_BUSY)
 		goto idle_irq;
 
@@ -2030,7 +2096,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 		ap->ops->bmdma_stop(qc);
 	}
 
-	ata_sff_altstatus(ap);
+	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
 
@@ -2203,7 +2269,7 @@ void ata_bmdma_stop(struct ata_queued_cmd *qc)
 		 mmio + ATA_DMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);        /* dummy read */
+	ata_sff_maybe_altstatus(ap);        /* dummy read */
 }
 
 /**
@@ -2723,6 +2789,7 @@ EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 EXPORT_SYMBOL_GPL(ata_sff_check_status);
 EXPORT_SYMBOL_GPL(ata_sff_altstatus);
+EXPORT_SYMBOL_GPL(ata_sff_pause);
 EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 1713843..bc685cd 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -269,7 +269,7 @@ static void pata_icside_bmdma_stop(struct ata_queued_cmd *qc)
 
 	disable_dma(state->dma);
 
-	/* see ata_bmdma_stop */
+	/* see ata_bmdma_stop: we know we have a ctl port in this case */
 	ata_sff_altstatus(ap);
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4a92fba..8eb5022 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1435,6 +1435,7 @@ extern void ata_sff_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
+extern void ata_sff_pause(struct ata_port *ap);
 extern u8 ata_sff_altstatus(struct ata_port *ap);
 extern int ata_sff_busy_sleep(struct ata_port *ap,
 			      unsigned long timeout_pat, unsigned long timeout);
@@ -1496,19 +1497,6 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 #endif /* CONFIG_PCI */
 
 /**
- *	ata_sff_pause - Flush writes and pause 400 nanoseconds.
- *	@ap: Port to wait for.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-static inline void ata_sff_pause(struct ata_port *ap)
-{
-	ata_sff_altstatus(ap);
-	ndelay(400);
-}
-
-/**
  *	ata_sff_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
  *	@bits: bits that must be clear

