Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHFAXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHFAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYHFAV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:21:29 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45606 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750759AbYHFAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:21:27 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=G5SLD0Qmh6T6T6GO9cIA:9 a=nKKZKlv8LDj0jp83_wQA:7 a=4mfahub0faYoVu-dz50VqG7t6AAA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10 a=ZCnnSLshPu8A:10 a=lN1hEWcJ4VIA:10
Message-ID: <4898EE70.1030604@shaw.ca>
Date: Tue, 05 Aug 2008 18:21:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk> <48977200.3050307@shaw.ca> <20080804220619.76b94ceb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804220619.76b94ceb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I guess that bit doesn't really make any difference with remotely modern 
>> drives, then.. Could we make that ata_id_has_dword_io check always 
>> return true if ata_id_is_ata returns true and only check word 48 if not?
> 
> I suspect (but need to dig further) that ata_id_has_dword_io should only
> be called by pata_legacy.
> 
>> I saw Willy Tarreau's patch from February for this, I agree that we 
>> should likely use a separate data_xfer method for 32-bit transfer (or if 
>> enough controllers should support 32-bit, then just make it be the 
>> default and make a separate 16-bit only function for those that don't), 
>> rather than punting the decision to the user with hdparm.
> 
> Definitely.
> 
>> You mentioned in the thread for Willy's patch that "some
>> controllers have quirky rules for 32bit xfers" - any details anywhere?
> 
> There are two main ones
> 
> - Some controllers only support 32bit I/O for a multiple of 32bit values
> [sometimes 'unless the fifo is disabled']. I'd have to go back over the
> docs but I think the AMD may be one of those
> - Some controllers (VLB generally) require a magic sequence before the
> transfer. You'll see that in the pata_legacy bits.

Here's my first cut at it. Compile tested only. This sets most controllers
to use 32-bit PIO except for those which could potentially be on a real ISA
or other 16-bit bus. It's a bit non-obvious what to do with some of the
drivers, so input is welcome.

This implementation doesn't check the ata_id_has_dword_io at all, since it
would only make a difference on controllers where we don't really want to
use it anyway.

It seems like regardless of whether we do 32-bit by default or not the 32-bit
data_xfer function should be added to libata core as we have several drivers
which duplicate the same code currently..

Signed-off-by: Robert Hancock <hancockr@shaw.ca>	

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 304fdc6..acb65a9 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -673,13 +673,14 @@ static inline void ata_tf_to_host(struct ata_port *ap,
 }
 
 /**
- *	ata_sff_data_xfer - Transfer data by PIO
+ *	ata_sff_data_xfer_16bit - Transfer data by PIO
  *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
  *	@rw: read/write
  *
- *	Transfer data from/to the device data register by PIO.
+ *	Transfer data from/to the device data register by PIO using only
+ *	16-bit transfers.
  *
  *	LOCKING:
  *	Inherited from caller.
@@ -687,7 +688,7 @@ static inline void ata_tf_to_host(struct ata_port *ap,
  *	RETURNS:
  *	Bytes consumed.
  */
-unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
+unsigned int ata_sff_data_xfer_16bit(struct ata_device *dev, unsigned char *buf,
 			       unsigned int buflen, int rw)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -719,6 +720,51 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
 }
 
 /**
+ *	ata_sff_data_xfer - Transfer data by PIO
+ *	@dev: device to target
+ *	@buf: data buffer
+ *	@buflen: buffer length
+ *	@rw: read/write
+ *
+ *	Transfer data from/to the device data register by PIO.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	Bytes consumed.
+ */
+unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
+			       unsigned int buflen, int rw)
+{
+	struct ata_port *ap = dev->link->ap;
+	void __iomem *data_addr = ap->ioaddr.data_addr;
+	unsigned int words = buflen >> 2;
+	unsigned int slop = buflen & 3;
+
+	/* Transfer multiple of 4 bytes */
+	if (rw == READ)
+		ioread32_rep(data_addr, buf, words);
+	else
+		iowrite32_rep(data_addr, buf, words);
+
+	/* Transfer trailing 1 byte, if any. */
+	if (unlikely(slop)) {
+		__le32 pad = 0;
+		if (rw == READ) {
+			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
+			memcpy(buf + buflen - slop, &pad, slop);
+		} else {
+			memcpy(&pad, buf + buflen - slop, slop);
+			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
+		}
+		buflen += 4 - slop;
+	}
+
+	return buflen;
+}
+
+/**
  *	ata_sff_data_xfer_noirq - Transfer data by PIO
  *	@dev: device to target
  *	@buf: data buffer
@@ -748,6 +794,36 @@ unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev, unsigned char *buf,
 }
 
 /**
+ *	ata_sff_data_xfer_noirq_16bit - Transfer data by PIO
+ *	@dev: device to target
+ *	@buf: data buffer
+ *	@buflen: buffer length
+ *	@rw: read/write
+ *
+ *	Transfer data from/to the device data register by PIO. Do the
+ *	transfer with interrupts disabled using only 16-bit transfers.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	Bytes consumed.
+ */
+unsigned int ata_sff_data_xfer_noirq_16bit(struct ata_device *dev,
+				     unsigned char *buf,
+				     unsigned int buflen, int rw)
+{
+	unsigned long flags;
+	unsigned int consumed;
+
+	local_irq_save(flags);
+	consumed = ata_sff_data_xfer_16bit(dev, buf, buflen, rw);
+	local_irq_restore(flags);
+
+	return consumed;
+}
+
+/**
  *	ata_pio_sector - Transfer a sector of data.
  *	@qc: Command on going
  *
@@ -2827,7 +2903,9 @@ EXPORT_SYMBOL_GPL(ata_sff_tf_load);
 EXPORT_SYMBOL_GPL(ata_sff_tf_read);
 EXPORT_SYMBOL_GPL(ata_sff_exec_command);
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer);
+EXPORT_SYMBOL_GPL(ata_sff_data_xfer_16bit);
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq);
+EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq_16bit);
 EXPORT_SYMBOL_GPL(ata_sff_irq_on);
 EXPORT_SYMBOL_GPL(ata_sff_irq_clear);
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 82fb6e2..aa90b19 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -173,6 +173,7 @@ static struct scsi_host_template at32_sht = {
 static struct ata_port_operations at32_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 	.cable_detect		= ata_cable_40wire,
+	.sff_data_xfer		= ata_sff_data_xfer_16bit,
 	.set_piomode		= pata_at32_set_piomode,
 };
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index cf9e984..a1f09ca 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -336,7 +336,7 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 	/* no need to build any PRD tables for DMA */
 	.qc_prep		= ata_noop_qc_prep,
-	.sff_data_xfer		= ata_sff_data_xfer_noirq,
+	.sff_data_xfer		= ata_sff_data_xfer_noirq_16bit,
 	.bmdma_setup		= pata_icside_bmdma_setup,
 	.bmdma_start		= pata_icside_bmdma_start,
 	.bmdma_stop		= pata_icside_bmdma_stop,
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 6a111ba..6f38f76 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -26,6 +26,7 @@ static struct scsi_host_template isapnp_sht = {
 static struct ata_port_operations isapnp_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	.cable_detect	= ata_cable_40wire,
+	.sff_data_xfer	= ata_sff_data_xfer_16bit,
 };
 
 /**
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index bc037ff..d919934 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -226,12 +226,12 @@ static const struct ata_port_operations legacy_base_port_ops = {
 
 static struct ata_port_operations simple_port_ops = {
 	.inherits	= &legacy_base_port_ops,
-	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_data_xfer	= ata_sff_data_xfer_noirq_16bit,
 };
 
 static struct ata_port_operations legacy_port_ops = {
 	.inherits	= &legacy_base_port_ops,
-	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_data_xfer	= ata_sff_data_xfer_noirq_16bit,
 	.set_mode	= legacy_set_mode,
 };
 
@@ -286,39 +286,18 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
-	if (ata_id_has_dword_io(dev->id)) {
-		struct ata_port *ap = dev->link->ap;
-		int slop = buflen & 3;
-		unsigned long flags;
+	unsigned long flags;
 
-		local_irq_save(flags);
+	local_irq_save(flags);
 
-		/* Perform the 32bit I/O synchronization sequence */
-		ioread8(ap->ioaddr.nsect_addr);
-		ioread8(ap->ioaddr.nsect_addr);
-		ioread8(ap->ioaddr.nsect_addr);
+	/* Perform the 32bit I/O synchronization sequence */
+	ioread8(ap->ioaddr.nsect_addr);
+	ioread8(ap->ioaddr.nsect_addr);
+	ioread8(ap->ioaddr.nsect_addr);
 
-		/* Now the data */
-		if (rw == READ)
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == READ) {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			} else {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			}
-			buflen += 4 - slop;
-		}
-		local_irq_restore(flags);
-	} else
-		buflen = ata_sff_data_xfer_noirq(dev, buf, buflen, rw);
+	buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
 
+	local_irq_restore(flags);
 	return buflen;
 }
 
@@ -733,33 +712,6 @@ static unsigned int qdi_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
-static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
-					unsigned int buflen, int rw)
-{
-	struct ata_port *ap = adev->link->ap;
-	int slop = buflen & 3;
-
-	if (ata_id_has_dword_io(adev->id)) {
-		if (rw == WRITE)
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == WRITE) {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			} else {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			}
-		}
-		return (buflen + 3) & ~3;
-	} else
-		return ata_sff_data_xfer(adev, buf, buflen, rw);
-}
-
 static int qdi_port(struct platform_device *dev,
 			struct legacy_probe *lp, struct legacy_data *ld)
 {
@@ -773,19 +725,19 @@ static struct ata_port_operations qdi6500_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6500_set_piomode,
 	.qc_issue	= qdi_qc_issue,
-	.sff_data_xfer	= vlb32_data_xfer,
+	.sff_data_xfer	= ata_sff_data_xfer,
 };
 
 static struct ata_port_operations qdi6580_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6580_set_piomode,
-	.sff_data_xfer	= vlb32_data_xfer,
+	.sff_data_xfer	= ata_sff_data_xfer,
 };
 
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6580dp_set_piomode,
-	.sff_data_xfer	= vlb32_data_xfer,
+	.sff_data_xfer	= ata_sff_data_xfer,
 };
 
 static DEFINE_SPINLOCK(winbond_lock);
@@ -856,7 +808,7 @@ static int winbond_port(struct platform_device *dev,
 static struct ata_port_operations winbond_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= winbond_set_piomode,
-	.sff_data_xfer	= vlb32_data_xfer,
+	.sff_data_xfer	= ata_sff_data_xfer,
 };
 
 static struct legacy_controller controllers[] = {
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index a9e8273..0ab2c8e 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -265,6 +265,7 @@ static struct ata_port_operations mpc52xx_ata_port_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= mpc52xx_ata_set_piomode,
 	.post_internal_cmd	= ATA_OP_NULL,
+	.sff_data_xfer		= ata_sff_data_xfer_16bit,
 };
 
 static int __devinit
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 41b4361..8cb4923 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -133,7 +133,7 @@ static struct scsi_host_template pcmcia_sht = {
 
 static struct ata_port_operations pcmcia_port_ops = {
 	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_data_xfer	= ata_sff_data_xfer_noirq_16bit,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= pcmcia_set_mode,
 };
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 8f65ad6..3310eb0 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -52,7 +52,7 @@ static struct scsi_host_template pata_platform_sht = {
 
 static struct ata_port_operations pata_platform_port_ops = {
 	.inherits		= &ata_sff_port_ops,
-	.sff_data_xfer		= ata_sff_data_xfer_noirq,
+	.sff_data_xfer		= ata_sff_data_xfer_noirq_16bit,
 	.cable_detect		= ata_cable_unknown,
 	.set_mode		= pata_platform_set_mode,
 	.port_start		= ATA_OP_NULL,
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 63b7a1c..36cc778 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -124,35 +124,6 @@ static unsigned int qdi_qc_issue(struct ata_queued_cmd *qc)
 	return ata_sff_qc_issue(qc);
 }
 
-static unsigned int qdi_data_xfer(struct ata_device *dev, unsigned char *buf,
-				  unsigned int buflen, int rw)
-{
-	if (ata_id_has_dword_io(dev->id)) {
-		struct ata_port *ap = dev->link->ap;
-		int slop = buflen & 3;
-
-		if (rw == READ)
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == READ) {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			} else {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			}
-			buflen += 4 - slop;
-		}
-	} else
-		buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
-
-	return buflen;
-}
-
 static struct scsi_host_template qdi_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
@@ -160,7 +131,6 @@ static struct scsi_host_template qdi_sht = {
 static struct ata_port_operations qdi6500_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	.qc_issue	= qdi_qc_issue,
-	.sff_data_xfer	= qdi_data_xfer,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= qdi6500_set_piomode,
 };
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index a7606b0..56f5f8e 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -92,42 +92,12 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 
-static unsigned int winbond_data_xfer(struct ata_device *dev,
-			unsigned char *buf, unsigned int buflen, int rw)
-{
-	struct ata_port *ap = dev->link->ap;
-	int slop = buflen & 3;
-
-	if (ata_id_has_dword_io(dev->id)) {
-		if (rw == READ)
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == READ) {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			} else {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			}
-			buflen += 4 - slop;
-		}
-	} else
-		buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
-
-	return buflen;
-}
-
 static struct scsi_host_template winbond_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
 
 static struct ata_port_operations winbond_port_ops = {
 	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= winbond_data_xfer,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= winbond_set_piomode,
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 06b8033..643328a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1481,8 +1481,12 @@ extern void ata_sff_exec_command(struct ata_port *ap,
 				 const struct ata_taskfile *tf);
 extern unsigned int ata_sff_data_xfer(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
+extern unsigned int ata_sff_data_xfer_16bit(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw);
 extern unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
+extern unsigned int ata_sff_data_xfer_noirq_16bit(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw);
 extern u8 ata_sff_irq_on(struct ata_port *ap);
 extern void ata_sff_irq_clear(struct ata_port *ap);
 extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,

