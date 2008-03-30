Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYC3Tcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYC3Tcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYC3TbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:31:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYC3Tav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GYR0VrG5gg+dF25w4GCDNPDzzMEDle2Kv3rshOPt/it+t1sXzMAn9fLM3BSByTJZH9Vd562wwiKAS7eFB0c3PKRQmMYhCpAEQ+yI2wWiuYsQeOd772z4M5tfEjPfHsOlkDvGryyv8lAvseAOkC+CZaS1xkrxkDao3kHzgGd86+A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/6] ide: remove ->INS{W,L} and ->OUTS{W,L} methods
Date: Sun, 30 Mar 2008 21:44:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302144.43011.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use ins{w,l}()/outs{w,l}() and __ide_mm_ins{w,l}()/__ide_mm_outs{w,l}()
  directly in ata_{in,out}put_data() (by using IDE_HFLAG_MMIO host flag to
  decide which I/O ops are required).

* Remove no longer needed ->INS{W,L} and ->OUTS{W,L} methods (ide-h8300,
  au1xxx-ide and scc_pata implement their own ->{in,out}put_data methods).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    4 -
 drivers/ide/ide-iops.c        |  114 +++++++++++++++++-------------------------
 drivers/ide/mips/au1xxx-ide.c |    3 -
 drivers/ide/pci/scc_pata.c    |    4 -
 include/linux/ide.h           |    4 -
 5 files changed, 48 insertions(+), 81 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -88,11 +88,7 @@ static inline void hwif_setup(ide_hwif_t
 	hwif->output_data = h8300_output_data;
 
 	hwif->OUTW  = mm_outw;
-	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
-	hwif->INSW  = mm_insw;
-	hwif->OUTSL = NULL;
-	hwif->INSL  = NULL;
 }
 
 static int __init h8300_ide_init(void)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -42,16 +42,6 @@ static u16 ide_inw (unsigned long port)
 	return (u16) inw(port);
 }
 
-static void ide_insw (unsigned long port, void *addr, u32 count)
-{
-	insw(port, addr, count);
-}
-
-static void ide_insl (unsigned long port, void *addr, u32 count)
-{
-	insl(port, addr, count);
-}
-
 static void ide_outb (u8 val, unsigned long port)
 {
 	outb(val, port);
@@ -67,27 +57,13 @@ static void ide_outw (u16 val, unsigned 
 	outw(val, port);
 }
 
-static void ide_outsw (unsigned long port, void *addr, u32 count)
-{
-	outsw(port, addr, count);
-}
-
-static void ide_outsl (unsigned long port, void *addr, u32 count)
-{
-	outsl(port, addr, count);
-}
-
 void default_hwif_iops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_outb;
 	hwif->OUTBSYNC	= ide_outbsync;
 	hwif->OUTW	= ide_outw;
-	hwif->OUTSW	= ide_outsw;
-	hwif->OUTSL	= ide_outsl;
 	hwif->INB	= ide_inb;
 	hwif->INW	= ide_inw;
-	hwif->INSW	= ide_insw;
-	hwif->INSL	= ide_insl;
 }
 
 /*
@@ -104,16 +80,6 @@ static u16 ide_mm_inw (unsigned long por
 	return (u16) readw((void __iomem *) port);
 }
 
-static void ide_mm_insw (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_insw((void __iomem *) port, addr, count);
-}
-
-static void ide_mm_insl (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_insl((void __iomem *) port, addr, count);
-}
-
 static void ide_mm_outb (u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
@@ -129,16 +95,6 @@ static void ide_mm_outw (u16 value, unsi
 	writew(value, (void __iomem *) port);
 }
 
-static void ide_mm_outsw (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_outsw((void __iomem *) port, addr, count);
-}
-
-static void ide_mm_outsl (unsigned long port, void *addr, u32 count)
-{
-	__ide_mm_outsl((void __iomem *) port, addr, count);
-}
-
 void default_hwif_mmiops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_mm_outb;
@@ -146,12 +102,8 @@ void default_hwif_mmiops (ide_hwif_t *hw
 	   this one is controller specific! */
 	hwif->OUTBSYNC	= ide_mm_outbsync;
 	hwif->OUTW	= ide_mm_outw;
-	hwif->OUTSW	= ide_mm_outsw;
-	hwif->OUTSL	= ide_mm_outsl;
 	hwif->INB	= ide_mm_inb;
 	hwif->INW	= ide_mm_inw;
-	hwif->INSW	= ide_mm_insw;
-	hwif->INSL	= ide_mm_insl;
 }
 
 EXPORT_SYMBOL(default_hwif_mmiops);
@@ -202,24 +154,39 @@ static void ata_input_data(ide_drive_t *
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	len++;
 
 	if (io_32bit) {
-		if (io_32bit & 2) {
-			unsigned long flags;
+		unsigned long uninitialized_var(flags);
 
+		if (io_32bit & 2) {
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->INSL(data_addr, buf, len / 4);
+		}
+
+		if (mmio)
+			__ide_mm_insl((void __iomem *)data_addr, buf, len / 4);
+		else
+			insl(data_addr, buf, len / 4);
+
+		if (io_32bit & 2)
 			local_irq_restore(flags);
-		} else
-			hwif->INSL(data_addr, buf, len / 4);
 
-		if ((len & 3) >= 2)
-			hwif->INSW(data_addr, (u8 *)buf + (len & ~3), 1);
-	} else
-		hwif->INSW(data_addr, buf, len / 2);
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_insw((void __iomem *)data_addr,
+						(u8 *)buf + (len & ~3), 1);
+			else
+				insw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_insw((void __iomem *)data_addr, buf, len / 2);
+		else
+			insw(data_addr, buf, len / 2);
+	}
 }
 
 /*
@@ -231,22 +198,37 @@ static void ata_output_data(ide_drive_t 
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
 	if (io_32bit) {
-		if (io_32bit & 2) {
-			unsigned long flags;
+		unsigned long uninitialized_var(flags);
 
+		if (io_32bit & 2) {
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->OUTSL(data_addr, buf, len / 4);
+		}
+
+		if (mmio)
+			__ide_mm_outsl((void __iomem *)data_addr, buf, len / 4);
+		else
+			outsl(data_addr, buf, len / 4);
+
+		if (io_32bit & 2)
 			local_irq_restore(flags);
-		} else
-			hwif->OUTSL(data_addr, buf, len / 4);
 
-		if ((len & 3) >= 2)
-			hwif->OUTSW(data_addr, (u8 *)buf + (len & ~3), 1);
-	} else
-		hwif->OUTSW(data_addr, buf, len / 2);
+		if ((len & 3) >= 2) {
+			if (mmio)
+				__ide_mm_outsw((void __iomem *)data_addr,
+						 (u8 *)buf + (len & ~3), 1);
+			else
+				outsw(data_addr, (u8 *)buf + (len & ~3), 1);
+		}
+	} else {
+		if (mmio)
+			__ide_mm_outsw((void __iomem *)data_addr, buf, len / 2);
+		else
+			outsw(data_addr, buf, len / 2);
+	}
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -613,9 +613,6 @@ static int au_ide_probe(struct device *d
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
 	hwif->input_data  = au1xxx_input_data;
 	hwif->output_data = au1xxx_output_data;
-
-	hwif->INSW                      = auide_insw;
-	hwif->OUTSW                     = auide_outsw;
 #endif
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -624,13 +624,9 @@ static void __devinit init_mmio_iops_scc
 
 	hwif->INB = scc_ide_inb;
 	hwif->INW = scc_ide_inw;
-	hwif->INSW = scc_ide_insw;
-	hwif->INSL = scc_ide_insl;
 	hwif->OUTB = scc_ide_outb;
 	hwif->OUTBSYNC = scc_ide_outbsync;
 	hwif->OUTW = scc_ide_outw;
-	hwif->OUTSW = scc_ide_outsw;
-	hwif->OUTSL = scc_ide_outsl;
 
 	io_ports->data_addr	= dma_base + 0x20;
 	io_ports->error_addr	= dma_base + 0x24;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -477,13 +477,9 @@ typedef struct hwif_s {
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
 	void (*OUTW)(u16 addr, unsigned long port);
-	void (*OUTSW)(unsigned long port, void *addr, u32 count);
-	void (*OUTSL)(unsigned long port, void *addr, u32 count);
 
 	u8  (*INB)(unsigned long port);
 	u16 (*INW)(unsigned long port);
-	void (*INSW)(unsigned long port, void *addr, u32 count);
-	void (*INSL)(unsigned long port, void *addr, u32 count);
 
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
