Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYE2VwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYE2VwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757000AbYE2VwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:52:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754951AbYE2VwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:52:00 -0400
Date: Thu, 29 May 2008 22:37:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [RFC PATCH] libata-sff: Fix oops reported in kerneloops.org for
 pnp devices with no ctl
Message-ID: <20080529223755.12610b87@core>
In-Reply-To: <20080529221058.1169e140@core>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<20080529190235.258d304e@core>
	<483EF536.90801@garzik.org>
	<20080529194238.36458a46@core>
	<483F049E.2090809@garzik.org>
	<20080529221058.1169e140@core>
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

The Linusified version:

- Make ata_sff_altstatus private so nobody uses it by mistake
- Drop the 400nS delay from it

Add

ata_sff_irq_status	-	encapsulates the IRQ check logic

This function keeps the existing behaviour for altstatus using devices. I
actually suspect the logic was wrong before the changes but -rc isn't the
time to play with that

ata_sff_sync		-	ensure writes hit the device

Really we want an io* operation for 'is posted' eg ioisposted(ioaddr) so
that we can fix the nasty delay this causes on most systems.

- ata_sff_pause		-	400nS delay

Ensure the command hit the device and delay 400nS

- ata_sff_dma_pause
 
Ensure the I/O hit the device and enforce an HDMA1:0 transition delay.
Requires altstatus register exists, BUG if not so we don't risk
corruption in MWDMA modes. (UDMA the checksum will save your backside in
theory)

The only other complication then is devices with their own handlers.
rb532 can use dma_pause but scc needs to access its own altstatus
register for internal errata workarounds so directly call the drivers own
altstatus function.

Signed-off-by: Alan Cox <alan@redhat.com>

 drivers/ata/libata-sff.c    |  117 +++++++++++++++++++++++++++++++++++++------
 drivers/ata/pata_icside.c   |    2 -
 drivers/ata/pata_rb532_cf.c |    4 +
 drivers/ata/pata_scc.c      |    5 +-
 include/linux/libata.h      |   16 +-----
 5 files changed, 109 insertions(+), 35 deletions(-)


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3c2d228..43049ba 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -239,7 +239,8 @@ u8 ata_sff_check_status(struct ata_port *ap)
  *	@ap: port where the device is
  *
  *	Reads ATA taskfile alternate status register for
- *	currently-selected device and return its value.
+ *	currently-selected device and return its value. Returns
+ *	NO_ALTSTATUS (0x100) if no status is present.
  *
  *	Note: may NOT be used as the check_altstatus() entry in
  *	ata_port_operations.
@@ -247,12 +248,96 @@ u8 ata_sff_check_status(struct ata_port *ap)
  *	LOCKING:
  *	Inherited from caller.
  */
-u8 ata_sff_altstatus(struct ata_port *ap)
+static unsigned int ata_sff_altstatus(struct ata_port *ap)
 {
 	if (ap->ops->sff_check_altstatus)
 		return ap->ops->sff_check_altstatus(ap);
+	if (ap->ioaddr.altstatus_addr)
+		return ioread8(ap->ioaddr.altstatus_addr);
+#define NO_ALTSTATUS 0x100
+	return NO_ALTSTATUS;
+}
+
+/**
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
+	status = ata_sff_altstatus(ap);
+	/* Not us: We are busy */
+	if (status & ATA_BUSY)
+	    	return status;
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
 
-	return ioread8(ap->ioaddr.altstatus_addr);
+static void ata_sff_sync(struct ata_port *ap)
+{
+	/* For the moment we read altstatus. Ideally we should only
+	   do this if we *know* a fence is needed - eg with MMIO */
+	ata_sff_altstatus(ap);
+}
+
+/**
+ *	ata_sff_pause		-	Flush writes and wait 400nS
+ *	@ap: Port to pause for.
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
+/**
+ *	ata_sff_dma_pause	-	Pause before commencing DMA
+ *	@ap: Port to pause for.
+ *
+ *	Perform I/O fencing and ensure sufficient cycle delays occur
+ *	for the HDMA1:0 transition
+ */
+ 
+void ata_sff_dma_pause(struct ata_port *ap)
+{
+	/* An altstatus read will cause the needed delay without
+	   messing up the IRQ status */
+	unsigned int v = ata_sff_altstatus(ap);
+	if (unlikely(v == NO_ALTSTATUS))
+		/* There are no DMA controllers without ctl. BUG here to
+		   ensure we never violate the HDMA1:0 transition timing
+		   and risk corruption. */
+		BUG();
 }
 
 /**
@@ -742,7 +827,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
 	} else
 		ata_pio_sector(qc);
 
-	ata_sff_altstatus(qc->ap); /* flush */
+	ata_sff_sync(qc->ap); /* flush */
 }
 
 /**
@@ -763,8 +848,9 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	WARN_ON(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
-	ata_sff_altstatus(ap); /* flush */
-
+	ata_sff_sync(ap);
+	/* FIXME: If the CDB is for DMA do we need to do the transition delay
+	   or is bmdma_start guaranteed to do it ? */
 	switch (qc->tf.protocol) {
 	case ATAPI_PROT_PIO:
 		ap->hsm_task_state = HSM_ST;
@@ -905,7 +991,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_sync(ap); /* flush */
 
 	return;
 
@@ -1489,14 +1575,10 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
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
@@ -2030,7 +2112,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 		ap->ops->bmdma_stop(qc);
 	}
 
-	ata_sff_altstatus(ap);
+	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
 
@@ -2203,7 +2285,7 @@ void ata_bmdma_stop(struct ata_queued_cmd *qc)
 		 mmio + ATA_DMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);        /* dummy read */
+	ata_sff_dma_pause(ap);
 }
 
 /**
@@ -2722,7 +2804,8 @@ EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 EXPORT_SYMBOL_GPL(ata_sff_check_status);
-EXPORT_SYMBOL_GPL(ata_sff_altstatus);
+EXPORT_SYMBOL_GPL(ata_sff_dma_pause);
+EXPORT_SYMBOL_GPL(ata_sff_pause);
 EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 1713843..cf9e984 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -270,7 +270,7 @@ static void pata_icside_bmdma_stop(struct ata_queued_cmd *qc)
 	disable_dma(state->dma);
 
 	/* see ata_bmdma_stop */
-	ata_sff_altstatus(ap);
+	ata_sff_dma_pause(ap);
 }
 
 static u8 pata_icside_bmdma_status(struct ata_port *ap)
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index a108d25..f8b3ffc 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -57,7 +57,9 @@ static inline void rb532_pata_finish_io(struct ata_port *ap)
 	struct ata_host *ah = ap->host;
 	struct rb532_cf_info *info = ah->private_data;
 
-	ata_sff_altstatus(ap);
+	/* FIXME: Keep previous delay. If this is merely a fence then
+	   ata_sff_sync might be sufficient. */
+	ata_sff_dma_pause(ap);
 	ndelay(RB500_CF_IO_DELAY);
 
 	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index e965b25..bbf5aa3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -726,7 +726,7 @@ static void scc_bmdma_stop (struct ata_queued_cmd *qc)
 		 in_be32(bmid_base + SCC_DMA_CMD) & ~ATA_DMA_START);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);	/* dummy read */
+	ata_sff_dma_pause(ap);	/* dummy read */
 }
 
 /**
@@ -747,7 +747,8 @@ static u8 scc_bmdma_status (struct ata_port *ap)
 		return host_stat;
 
 	/* errata A252,A308 workaround: Step4 */
-	if ((ata_sff_altstatus(ap) & ATA_ERR) && (int_status & INTSTS_INTRQ))
+	if ((scc_check_altstatus(ap) & ATA_ERR)
+					&& (int_status & INTSTS_INTRQ))
 		return (host_stat | ATA_DMA_INTR);
 
 	/* errata A308 workaround Step5 */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4a92fba..57cfd92 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1435,7 +1435,8 @@ extern void ata_sff_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
-extern u8 ata_sff_altstatus(struct ata_port *ap);
+extern void ata_sff_pause(struct ata_port *ap);
+extern void ata_sff_dma_pause(struct ata_port *ap);
 extern int ata_sff_busy_sleep(struct ata_port *ap,
 			      unsigned long timeout_pat, unsigned long timeout);
 extern int ata_sff_wait_ready(struct ata_link *link, unsigned long deadline);
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
