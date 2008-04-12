Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbYDLMUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbYDLMUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761836AbYDLMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:18:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761795AbYDLMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MEibEWm9mKW+1JwemCuf+yj+qwc/Qwxd1Qap1TDPqxZHW+AaOqMvE+jJ+3l885UN1V29o0W/BAXEJqM18msd8cj8FlRLV1+oYIQmNypJp9ZG4A6pmRTrklKXN3wQNFdNKcT5/M981uHeWWwKPTTV0K16PpkyJsAjChgzC6Rv1hg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2008 14:34:58 +0200
Message-Id: <20080412123458.18751.70346.sendpatchset@localhost.localdomain>
In-Reply-To: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: remove ->INW and ->OUTW methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove no longer used ->INW and ->OUTW methods.

While at it:

* scc_pata.c: scc_ide_{out,in}w() is called only in scc_tf_{load,read}()
  so inline it there.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c   |    2 --
 drivers/ide/h8300/ide-h8300.c |    3 ---
 drivers/ide/ide-iops.c        |   24 ------------------------
 drivers/ide/pci/scc_pata.c    |   19 +++----------------
 include/linux/ide.h           |    2 --
 5 files changed, 3 insertions(+), 47 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -903,10 +903,8 @@ static int __init init_e100_ide(void)
 		hwif->output_data = cris_output_data;
 
 		hwif->OUTB = &cris_ide_outb;
-		hwif->OUTW = &cris_ide_outw;
 		hwif->OUTBSYNC = &cris_ide_outbsync;
 		hwif->INB = &cris_ide_inb;
-		hwif->INW = &cris_ide_inw;
 		hwif->cbl = ATA_CBL_PATA40;
 
 		idx[h] = hwif->index;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -174,9 +174,6 @@ static inline void hwif_setup(ide_hwif_t
 
 	hwif->input_data  = h8300_input_data;
 	hwif->output_data = h8300_output_data;
-
-	hwif->OUTW  = mm_outw;
-	hwif->INW   = mm_inw;
 }
 
 static int __init h8300_ide_init(void)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -37,11 +37,6 @@ static u8 ide_inb (unsigned long port)
 	return (u8) inb(port);
 }
 
-static u16 ide_inw (unsigned long port)
-{
-	return (u16) inw(port);
-}
-
 static void ide_outb (u8 val, unsigned long port)
 {
 	outb(val, port);
@@ -52,18 +47,11 @@ static void ide_outbsync (ide_drive_t *d
 	outb(addr, port);
 }
 
-static void ide_outw (u16 val, unsigned long port)
-{
-	outw(val, port);
-}
-
 void default_hwif_iops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_outb;
 	hwif->OUTBSYNC	= ide_outbsync;
-	hwif->OUTW	= ide_outw;
 	hwif->INB	= ide_inb;
-	hwif->INW	= ide_inw;
 }
 
 /*
@@ -75,11 +63,6 @@ static u8 ide_mm_inb (unsigned long port
 	return (u8) readb((void __iomem *) port);
 }
 
-static u16 ide_mm_inw (unsigned long port)
-{
-	return (u16) readw((void __iomem *) port);
-}
-
 static void ide_mm_outb (u8 value, unsigned long port)
 {
 	writeb(value, (void __iomem *) port);
@@ -90,20 +73,13 @@ static void ide_mm_outbsync (ide_drive_t
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outw (u16 value, unsigned long port)
-{
-	writew(value, (void __iomem *) port);
-}
-
 void default_hwif_mmiops (ide_hwif_t *hwif)
 {
 	hwif->OUTB	= ide_mm_outb;
 	/* Most systems will need to override OUTBSYNC, alas however
 	   this one is controller specific! */
 	hwif->OUTBSYNC	= ide_mm_outbsync;
-	hwif->OUTW	= ide_mm_outw;
 	hwif->INB	= ide_mm_inb;
-	hwif->INW	= ide_mm_inw;
 }
 
 EXPORT_SYMBOL(default_hwif_mmiops);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -126,12 +126,6 @@ static u8 scc_ide_inb(unsigned long port
 	return (u8)data;
 }
 
-static u16 scc_ide_inw(unsigned long port)
-{
-	u32 data = in_be32((void*)port);
-	return (u16)data;
-}
-
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
 {
 	u16 *ptr = (u16 *)addr;
@@ -154,11 +148,6 @@ static void scc_ide_outb(u8 addr, unsign
 	out_be32((void*)port, addr);
 }
 
-static void scc_ide_outw(u16 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-}
-
 static void
 scc_ide_outbsync(ide_drive_t * drive, u8 addr, unsigned long port)
 {
@@ -586,8 +575,8 @@ static void scc_tf_load(ide_drive_t *dri
 	ide_set_irq(drive, 1);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		scc_ide_outw((tf->hob_data << 8) | tf->data,
-			     io_ports->data_addr);
+		out_be32((void *)io_ports->data_addr,
+			 (tf->hob_data << 8) | tf->data);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
@@ -622,7 +611,7 @@ static void scc_tf_read(ide_drive_t *dri
 	struct ide_taskfile *tf = &task->tf;
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = scc_ide_inw(io_ports->data_addr);
+		u16 data = (u16)in_be32((void *)io_ports->data_addr);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
@@ -710,10 +699,8 @@ static void __devinit init_mmio_iops_scc
 	hwif->output_data = scc_output_data;
 
 	hwif->INB = scc_ide_inb;
-	hwif->INW = scc_ide_inw;
 	hwif->OUTB = scc_ide_outb;
 	hwif->OUTBSYNC = scc_ide_outbsync;
-	hwif->OUTW = scc_ide_outw;
 
 	io_ports->data_addr	= dma_base + 0x20;
 	io_ports->error_addr	= dma_base + 0x24;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -484,10 +484,8 @@ typedef struct hwif_s {
 
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
-	void (*OUTW)(u16 addr, unsigned long port);
 
 	u8  (*INB)(unsigned long port);
-	u16 (*INW)(unsigned long port);
 
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
