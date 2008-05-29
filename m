Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYE2SeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYE2SeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbYE2Sd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:33:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38231 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756588AbYE2Sdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:33:55 -0400
Date: Thu, 29 May 2008 19:19:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529191920.12609c32@core>
In-Reply-To: <483EEBE5.5030708@garzik.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<483EEBE5.5030708@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this is how a revised one would look.

libata-sff: Fix oops reported in kerneloops.org for pnp devices with no ctl

From: Alan Cox <alan@redhat.com>


---

 drivers/ata/libata-sff.c  |   88 +++++++++++++++++++++++++++++++++++++++------
 drivers/ata/pata_icside.c |    2 +
 include/linux/libata.h    |   14 +------
 3 files changed, 78 insertions(+), 26 deletions(-)


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3c2d228..7958da7 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -256,6 +256,73 @@ u8 ata_sff_altstatus(struct ata_port *ap)
 }
 
 /**
+ *	ata_sff_irq_status - Check if the device is busy
+ *	@ap: port where the device is
+ *
+ *	Determine if the port is currently busy. Uses altstatus
+ *	if available in order to avoid clearing shared IRQ status
+ *	when finding an IRQ source. Non ctl capable devices don't
+ *	share interrupt lines fortunately for us.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static u8 ata_sff_irq_status(struct ata_port *ap)
+{
+	u8 status;
+
+	if (ap->ops->sff_check_altstatus || ap->ioaddr.altstatus_addr) {
+		status = ata_sff_altstatus(ap);
+		/* Not us: We are busy */
+		if (status & ATA_BUSY)
+		    	return status;
+	}
+	/* Clear INTRQ latch */
+	status = ata_sff_check_status(ap);
+	return status;
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
@@ -742,7 +809,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
 	} else
 		ata_pio_sector(qc);
 
-	ata_sff_altstatus(qc->ap); /* flush */
+	ata_sff_sync(qc->ap); /* flush */
 }
 
 /**
@@ -763,7 +830,7 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	WARN_ON(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap);
 
 	switch (qc->tf.protocol) {
 	case ATAPI_PROT_PIO:
@@ -905,7 +972,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap); /* flush */
 
 	return;
 
@@ -1489,14 +1556,10 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 		goto idle_irq;
 	}
 
-	/* check altstatus */
-	status = ata_sff_altstatus(ap);
-	if (status & ATA_BUSY)
-		goto idle_irq;
 
-	/* check main status, clearing INTRQ */
-	status = ap->ops->sff_check_status(ap);
-	if (unlikely(status & ATA_BUSY))
+	/* check main status, clearing INTRQ if needed */
+	status = ata_sff_irq_status(ap);
+	if (status & ATA_BUSY)
 		goto idle_irq;
 
 	/* ack bmdma irq events */
@@ -2030,7 +2093,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 		ap->ops->bmdma_stop(qc);
 	}
 
-	ata_sff_altstatus(ap);
+	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
 
@@ -2203,7 +2266,7 @@ void ata_bmdma_stop(struct ata_queued_cmd *qc)
 		 mmio + ATA_DMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);        /* dummy read */
+	ata_sff_sync(ap);        /* dummy read */
 }
 
 /**
@@ -2723,6 +2786,7 @@ EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
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
