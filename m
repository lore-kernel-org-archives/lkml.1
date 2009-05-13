Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbZEMUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbZEMUFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761158AbZEMUF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:05:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41197 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760957AbZEMUFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=H+81D9mq8BcZLN+6wsSazcIXkCPHlZyboE0BO6xwdXmGIgZnuzHdZJ78PrB6qEjlkn
         1Ts3ZAg68PMABY0OYWgH8kimM9BMTRsRtqkwnmFm0fNfhbHEF5OnhNobOuHiXb0B7vJ9
         t0CJz5fxEiI6uMKM1ORnAkYVVpFNxK/y2ej6E=
MIME-Version: 1.0
Date: Wed, 13 May 2009 22:05:20 +0200
X-Google-Sender-Auth: bd0453045c41cd33
Message-ID: <10f740e80905131305w332540e5oedfca75a136b7bb@mail.gmail.com>
Subject: [PATCH] m68k: amiga - GVP Series II SCSI zorro_driver conversion 
	(was: Re: [PATCH] m68k: amiga - A2091/A590 SCSI zorro_driver conversion (was: 
	Re: [PATCH/RFC 0/16] m68k: Device model patches))
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 22:30, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, May 5, 2009 at 09:36, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Sat, Apr 18, 2009 at 20:52, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> [07] m68k: amiga - A3000 SCSI platform device conversion
>>>
>>> Due to lack of hardware (only Amiga 4000 here), I couldn't test all drivers.
>>> Especially the SCSI drivers could use some testing feedback.
>>> The changes to most other drivers are fairly trivial.
>>
>> I'm a bit reluctant to apply the A3000 SCSI platform device conversion without
>> having received any feedback, and I would like to apply the whole series ASAP.
>> Did anyone try on A3000/A3000T? Similar changes are needed to convert the
>> A2091 and GVP II SCSI drivers to the zorro_driver model, so if we have
>> more users
>> of those, I can do that conversion first, so it can receive some testing.
>
> Here's the conversion of the A2091/A590 SCSI driver to a proper zorro_driver.
> Due to the lack of hardware, it's untested.
>
> BTW, when comparing a2091.c to a3000.c, a3000.c has several additional mb()s
> and one additiona barrier(). Do we need those in a2091.c, too?

And here's his brother for the GVP Series II SCSI driver. Same comments...

(Yes, I'm gonna split these patches to make it more obvious that the
other cleanups
 are correct).

>From 2d7553423a90db8f4083e88472ef10b1e4a211fa Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 13 May 2009 21:58:48 +0200
Subject: [PATCH] m68k: amiga - GVP Series II SCSI zorro_driver conversion

---
 drivers/scsi/gvp11.c |  555 ++++++++++++++++++++++++++------------------------
 drivers/scsi/gvp11.h |    6 -
 2 files changed, 292 insertions(+), 269 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 5d1bf7e..53826cc 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -1,228 +1,208 @@
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/zorro.h>

 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
-#include <linux/zorro.h>
-#include <asm/irq.h>
-#include <linux/spinlock.h>

 #include "scsi.h"
-#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "gvp11.h"

-#include<linux/stat.h>

-#define DMA(ptr) ((gvp11_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
+#define CHECK_WD33C93

-static irqreturn_t gvp11_intr (int irq, void *_instance)
+static irqreturn_t gvp11_intr(int irq, void *data)
 {
-    unsigned long flags;
-    unsigned int status;
-    struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
-
-    status = DMA(instance)->CNTR;
-    if (!(status & GVP11_DMAC_INT_PENDING))
-	return IRQ_NONE;
-
-    spin_lock_irqsave(instance->host_lock, flags);
-    wd33c93_intr(instance);
-    spin_unlock_irqrestore(instance->host_lock, flags);
-    return IRQ_HANDLED;
+	struct Scsi_Host *host = data;
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(host->base);
+	unsigned int status = regs->CNTR;
+	unsigned long flags;
+
+	if (!(status & GVP11_DMAC_INT_PENDING))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	wd33c93_intr(host);
+	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
 }

 static int gvp11_xfer_mask = 0;

-void gvp11_setup (char *str, int *ints)
+void gvp11_setup(char *str, int *ints)
 {
-    gvp11_xfer_mask = ints[1];
+	gvp11_xfer_mask = ints[1];
 }

 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned short cntr = GVP11_DMAC_INT_ENABLE;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-    int bank_mask;
-    static int scsi_alloc_out_of_range = 0;
-
-    /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
-    {
-	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
-	    & ~0x1ff;
-
- 	if( !scsi_alloc_out_of_range ) {
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		kmalloc (HDATA(cmd->device->host)->dma_bounce_len, GFP_KERNEL);
-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_SCSI_ALLOCED;
-	}
+	struct Scsi_Host *host = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(host);
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(host->base);
+	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
+	int bank_mask;
+	static int scsi_alloc_out_of_range;
+
+	/* use bounce buffer if the physical address is bad */
+	if (addr & hdata->dma_xfer_mask) {
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+
+		if (!scsi_alloc_out_of_range) {
+			hdata->dma_bounce_buffer =
+				kmalloc(hdata->dma_bounce_len, GFP_KERNEL);
+			hdata->dma_buffer_pool = BUF_SCSI_ALLOCED;
+		}

-	if (scsi_alloc_out_of_range ||
-	    !HDATA(cmd->device->host)->dma_bounce_buffer) {
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
-				       "GVP II SCSI Bounce Buffer");
+		if (scsi_alloc_out_of_range || !hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_buffer =
+				amiga_chip_alloc(hdata->dma_bounce_len,
+						 "GVP II SCSI Bounce Buffer");

-	    if(!HDATA(cmd->device->host)->dma_bounce_buffer)
-	    {
-		HDATA(cmd->device->host)->dma_bounce_len = 0;
-		return 1;
-	    }
+			if (!hdata->dma_bounce_buffer) {
+				hdata->dma_bounce_len = 0;
+				return 1;
+			}

-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_CHIP_ALLOCED;
-	}
+			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
+		}

-	/* check if the address of the bounce buffer is OK */
-	addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
-
-	if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
-	    /* fall back to Chip RAM if address out of range */
-	    if( HDATA(cmd->device->host)->dma_buffer_pool == BUF_SCSI_ALLOCED) {
-		kfree (HDATA(cmd->device->host)->dma_bounce_buffer);
-		scsi_alloc_out_of_range = 1;
-	    } else {
-		amiga_chip_free (HDATA(cmd->device->host)->dma_bounce_buffer);
-            }
-		
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
-				       "GVP II SCSI Bounce Buffer");
-
-	    if(!HDATA(cmd->device->host)->dma_bounce_buffer)
-	    {
-		HDATA(cmd->device->host)->dma_bounce_len = 0;
-		return 1;
-	    }
-
-	    addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_CHIP_ALLOCED;
-	}
-	
-	if (!dir_in) {
-	    /* copy to bounce buffer for a write */
-	    memcpy (HDATA(cmd->device->host)->dma_bounce_buffer,
-		    cmd->SCp.ptr, cmd->SCp.this_residual);
+		/* check if the address of the bounce buffer is OK */
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
+
+		if (addr & hdata->dma_xfer_mask) {
+			/* fall back to Chip RAM if address out of range */
+			if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED) {
+				kfree(hdata->dma_bounce_buffer);
+				scsi_alloc_out_of_range = 1;
+			} else {
+				amiga_chip_free(hdata->dma_bounce_buffer);
+			}
+
+			hdata->dma_bounce_buffer =
+				amiga_chip_alloc(hdata->dma_bounce_len,
+						 "GVP II SCSI Bounce Buffer");
+
+			if (!hdata->dma_bounce_buffer) {
+				hdata->dma_bounce_len = 0;
+				return 1;
+			}
+
+			addr = virt_to_bus(hdata->dma_bounce_buffer);
+			hdata->dma_buffer_pool = BUF_CHIP_ALLOCED;
+		}
+
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			       cmd->SCp.this_residual);
+		}
 	}
-    }

-    /* setup dma direction */
-    if (!dir_in)
-	cntr |= GVP11_DMAC_DIR_WRITE;
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= GVP11_DMAC_DIR_WRITE;

-    HDATA(cmd->device->host)->dma_dir = dir_in;
-    DMA(cmd->device->host)->CNTR = cntr;
+	hdata->dma_dir = dir_in;
+	regs->CNTR = cntr;

-    /* setup DMA *physical* address */
-    DMA(cmd->device->host)->ACR = addr;
+	/* setup DMA *physical* address */
+	regs->ACR = addr;

-    if (dir_in)
-	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    else
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
+	if (dir_in) {
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	} else {
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
+	}

-    if ((bank_mask = (~HDATA(cmd->device->host)->dma_xfer_mask >> 18)
& 0x01c0))
-	    DMA(cmd->device->host)->BANK = bank_mask & (addr >> 18);
+	bank_mask = (~hdata->dma_xfer_mask >> 18) & 0x01c0;
+	if (bank_mask)
+		regs->BANK = bank_mask & (addr >> 18);

-    /* start DMA */
-    DMA(cmd->device->host)->ST_DMA = 1;
+	/* start DMA */
+	regs->ST_DMA = 1;

-    /* return success */
-    return 0;
+	/* return success */
+	return 0;
 }

 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-    /* stop DMA */
-    DMA(instance)->SP_DMA = 1;
-    /* remove write bit from CONTROL bits */
-    DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
-
-    /* copy from a bounce buffer, if necessary */
-    if (status && HDATA(instance)->dma_bounce_buffer) {
-	if (HDATA(instance)->dma_dir && SCpnt)
-	    memcpy (SCpnt->SCp.ptr,
-		    HDATA(instance)->dma_bounce_buffer,
-		    SCpnt->SCp.this_residual);
-	
-	if (HDATA(instance)->dma_buffer_pool == BUF_SCSI_ALLOCED)
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	else
-	    amiga_chip_free(HDATA(instance)->dma_bounce_buffer);
-	
-	HDATA(instance)->dma_bounce_buffer = NULL;
-	HDATA(instance)->dma_bounce_len = 0;
-    }
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+
+	/* stop DMA */
+	regs->SP_DMA = 1;
+	/* remove write bit from CONTROL bits */
+	regs->CNTR = GVP11_DMAC_INT_ENABLE;
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && hdata->dma_bounce_buffer) {
+		if (hdata->dma_dir && SCpnt)
+			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
+			       SCpnt->SCp.this_residual);
+
+		if (hdata->dma_buffer_pool == BUF_SCSI_ALLOCED)
+			kfree(hdata->dma_bounce_buffer);
+		else
+			amiga_chip_free(hdata->dma_bounce_buffer);
+
+		hdata->dma_bounce_buffer = NULL;
+		hdata->dma_bounce_len = 0;
+	}
 }

-#define CHECK_WD33C93

-int __init gvp11_detect(struct scsi_host_template *tpnt)
+static int gvp11_bus_reset(struct scsi_cmnd *cmd)
 {
-    static unsigned char called = 0;
-    struct Scsi_Host *instance;
-    unsigned long address;
-    unsigned int epc;
-    struct zorro_dev *z = NULL;
-    unsigned int default_dma_xfer_mask;
-    wd33c93_regs regs;
-    int num_gvp11 = 0;
-#ifdef CHECK_WD33C93
-    volatile unsigned char *sasr_3393, *scmd_3393;
-    unsigned char save_sasr;
-    unsigned char q, qq;
-#endif
+	struct Scsi_Host *host = cmd->device->host;

-    if (!MACH_IS_AMIGA || called)
-	return 0;
-    called = 1;
+	/* FIXME perform bus-specific reset */

-    tpnt->proc_name = "GVP11";
-    tpnt->proc_info = &wd33c93_proc_info;
+	/* FIXME 2: shouldn't we no-op this function (return
+	   FAILED), and fall back to host reset function,
+	   wd33c93_host_reset ? */

-    while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-	/*
-	 * This should (hopefully) be the correct way to identify
-	 * all the different GVP SCSI controllers (except for the
-	 * SERIES I though).
-	 */
+	spin_lock_irq(host->host_lock);
+	wd33c93_host_reset(cmd);
+	spin_unlock_irq(host->host_lock);

-	if (z->id == ZORRO_PROD_GVP_COMBO_030_R3_SCSI ||
-	    z->id == ZORRO_PROD_GVP_SERIES_II)
-	    default_dma_xfer_mask = ~0x00ffffff;
-	else if (z->id == ZORRO_PROD_GVP_GFORCE_030_SCSI ||
-		 z->id == ZORRO_PROD_GVP_A530_SCSI ||
-		 z->id == ZORRO_PROD_GVP_COMBO_030_R4_SCSI)
-	    default_dma_xfer_mask = ~0x01ffffff;
-	else if (z->id == ZORRO_PROD_GVP_A1291 ||
-		 z->id == ZORRO_PROD_GVP_GFORCE_040_SCSI_1)
-	    default_dma_xfer_mask = ~0x07ffffff;
-	else
-	    continue;
+	return SUCCESS;
+}

-	/*
-	 * Rumors state that some GVP ram boards use the same product
-	 * code as the SCSI controllers. Therefore if the board-size
-	 * is not 64KB we asume it is a ram board and bail out.
-	 */
-	if (z->resource.end-z->resource.start != 0xffff)
-		continue;

-	address = z->resource.start;
-	if (!request_mem_region(address, 256, "wd33c93"))
-	    continue;
+static struct scsi_host_template gvp11_scsi_template = {
+	.module			= THIS_MODULE,
+	.name			= "GVP Series II SCSI",
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "GVP11",
+	.queuecommand		= wd33c93_queuecommand,
+	.eh_abort_handler	= wd33c93_abort,
+	.eh_bus_reset_handler	= gvp11_bus_reset,
+	.eh_host_reset_handler	= wd33c93_host_reset,
+	.can_queue		= CAN_QUEUE,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= CMD_PER_LUN,
+	.use_clustering		= DISABLE_CLUSTERING
+};

+static int __devinit check_wd33c93(gvp11_scsiregs *regs)
+{
 #ifdef CHECK_WD33C93
+	volatile unsigned char *sasr_3393, *scmd_3393;
+	unsigned char save_sasr;
+	unsigned char q, qq;

 	/*
 	 * These darn GVP boards are a problem - it can be tough to tell
@@ -230,37 +210,36 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	 * ultimate Yet-Another-GVP-Detection-Hack in that it actually
 	 * probes for a WD33c93 chip: If we find one, it's extremely
 	 * likely that this card supports SCSI, regardless of Product_
-	 * Code, Board_Size, etc.
+	 * Code, Board_Size, etc.
 	 */

-    /* Get pointers to the presumed register locations and save contents */
+	/* Get pointers to the presumed register locations and save contents */

-	sasr_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SASR);
-	scmd_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SCMD);
+	sasr_3393 = &regs->SASR;
+	scmd_3393 = &regs->SCMD;
 	save_sasr = *sasr_3393;

-    /* First test the AuxStatus Reg */
-
+	/* First test the AuxStatus Reg */
 	q = *sasr_3393;		/* read it */
 	if (q & 0x08)		/* bit 3 should always be clear */
-		goto release;
+		return -ENODEV;
 	*sasr_3393 = WD_AUXILIARY_STATUS;	 /* setup indirect address */
 	if (*sasr_3393 == WD_AUXILIARY_STATUS) { /* shouldn't retain the write */
 		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-		goto release;
-		}
+		return -ENODEV;
+	}
 	if (*sasr_3393 != q) {	/* should still read the same */
 		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-		goto release;
-		}
+		return -ENODEV;
+	}
 	if (*scmd_3393 != q)	/* and so should the image at 0x1f */
-		goto release;
-
+		return -ENODEV;

-    /* Ok, we probably have a wd33c93, but let's check a few other places
-     * for good measure. Make sure that this works for both 'A and 'B
-     * chip versions.
-     */
+	/*
+	 * Ok, we probably have a wd33c93, but let's check a few other places
+	 * for good measure. Make sure that this works for both 'A and 'B
+	 * chip versions.
+	 */

 	*sasr_3393 = WD_SCSI_STATUS;
 	q = *scmd_3393;
@@ -271,7 +250,7 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	*sasr_3393 = WD_SCSI_STATUS;
 	*scmd_3393 = q;
 	if (qq != q)			/* should be read only */
-		goto release;
+		return -ENODEV;
 	*sasr_3393 = 0x1e;	/* this register is unimplemented */
 	q = *scmd_3393;
 	*sasr_3393 = 0x1e;
@@ -281,7 +260,7 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	*sasr_3393 = 0x1e;
 	*scmd_3393 = q;
 	if (qq != q || qq != 0xff)	/* should be read only, all 1's */
-		goto release;
+		return -ENODEV;
 	*sasr_3393 = WD_TIMEOUT_PERIOD;
 	q = *scmd_3393;
 	*sasr_3393 = WD_TIMEOUT_PERIOD;
@@ -291,109 +270,159 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	*sasr_3393 = WD_TIMEOUT_PERIOD;
 	*scmd_3393 = q;
 	if (qq != (~q & 0xff))		/* should be read/write */
-		goto release;
-#endif
+		return -ENODEV;
+#endif /* CHECK_WD33C93 */

-	instance = scsi_register (tpnt, sizeof (struct WD33C93_hostdata));
-	if(instance == NULL)
-		goto release;
-	instance->base = ZTWO_VADDR(address);
-	instance->irq = IRQ_AMIGA_PORTS;
-	instance->unique_id = z->slotaddr;
+	return 0;
+}

-	if (gvp11_xfer_mask)
-		HDATA(instance)->dma_xfer_mask = gvp11_xfer_mask;
-	else
-		HDATA(instance)->dma_xfer_mask = default_dma_xfer_mask;
+static int __devinit gvp11_probe(struct zorro_dev *z,
+				 const struct zorro_device_id *ent)
+{
+	struct Scsi_Host *host;
+	struct WD33C93_hostdata *hdata;
+	int error;
+	wd33c93_regs wdregs;
+	gvp11_scsiregs *regs;

+	unsigned long address;
+	unsigned int epc;
+	unsigned int default_dma_xfer_mask;

-	DMA(instance)->secret2 = 1;
-	DMA(instance)->secret1 = 0;
-	DMA(instance)->secret3 = 15;
-	while (DMA(instance)->CNTR & GVP11_DMAC_BUSY) ;
-	DMA(instance)->CNTR = 0;
+	default_dma_xfer_mask = ent->driver_data;

-	DMA(instance)->BANK = 0;
+	/*
+	 * Rumors state that some GVP ram boards use the same product
+	 * code as the SCSI controllers. Therefore if the board-size
+	 * is not 64KB we asume it is a ram board and bail out.
+	 */
+	if (zorro_resource_len(z) != 0x10000)
+		return -ENODEV;

-	epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
+	address = z->resource.start;
+	if (!request_mem_region(address, 256, "wd33c93"))
+		return -EBUSY;
+
+	regs = (gvp11_scsiregs *)(ZTWO_VADDR(address));
+
+	error = check_wd33c93(regs);
+	if (error)
+		goto fail_check_or_alloc;
+
+	host = scsi_host_alloc(&gvp11_scsi_template,
+			       sizeof(struct WD33C93_hostdata));
+	if (!host) {
+		error = -ENOMEM;
+		goto fail_check_or_alloc;
+	}
+
+	host->base = (unsigned long)regs;
+	host->irq = IRQ_AMIGA_PORTS;
+	host->unique_id = z->slotaddr;
+
+	regs->secret2 = 1;
+	regs->secret1 = 0;
+	regs->secret3 = 15;
+	while (regs->CNTR & GVP11_DMAC_BUSY)
+		;
+	regs->CNTR = 0;
+	regs->BANK = 0;
+
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
+
+	hdata = shost_priv(host);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
+	if (gvp11_xfer_mask)
+		hdata->dma_xfer_mask = gvp11_xfer_mask;
+	else
+		hdata->dma_xfer_mask = default_dma_xfer_mask;

 	/*
 	 * Check for 14MHz SCSI clock
 	 */
-	regs.SASR = &(DMA(instance)->SASR);
-	regs.SCMD = &(DMA(instance)->SCMD);
-	HDATA(instance)->no_sync = 0xff;
-	HDATA(instance)->fast = 0;
-	HDATA(instance)->dma_mode = CTRL_DMA;
-	wd33c93_init(instance, regs, dma_setup, dma_stop,
+	epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
+	wd33c93_init(host, wdregs, dma_setup, dma_stop,
 		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 					     : WD33C93_FS_12_15);

-	if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED, "GVP11 SCSI",
-			instance))
-		goto unregister;
-	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
-	num_gvp11++;
-	continue;
-
-unregister:
-	scsi_unregister(instance);
-	wd33c93_release();
-release:
-	release_mem_region(address, 256);
-    }
+	error = request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED,
+			    "GVP11 SCSI", host);
+	if (error)
+		goto fail_irq;

-    return num_gvp11;
-}
+	regs->CNTR = GVP11_DMAC_INT_ENABLE;

-static int gvp11_bus_reset(struct scsi_cmnd *cmd)
-{
-	/* FIXME perform bus-specific reset */
+	error = scsi_add_host(host, NULL);
+	if (error)
+		goto fail_host;

-	/* FIXME 2: shouldn't we no-op this function (return
-	   FAILED), and fall back to host reset function,
-	   wd33c93_host_reset ? */
+	zorro_set_drvdata(z, host);

-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	scsi_scan_host(host);
+	return 0;

-	return SUCCESS;
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, host);
+fail_irq:
+	scsi_host_put(host);
+fail_check_or_alloc:
+	release_mem_region(address, 256);
+	return error;
 }

+static void __devexit gvp11_remove(struct zorro_dev *z)
+{
+	struct Scsi_Host *host = zorro_get_drvdata(z);
+	gvp11_scsiregs *regs = (gvp11_scsiregs *)(host->base);
+
+	regs->CNTR = 0;
+	scsi_remove_host(host);
+	free_irq(IRQ_AMIGA_PORTS, host);
+	scsi_host_put(host);
+	release_mem_region(z->resource.start, 256);
+}

-#define HOSTS_C
+	/*
+	 * This should (hopefully) be the correct way to identify
+	 * all the different GVP SCSI controllers (except for the
+	 * SERIES I though).
+	 */

-#include "gvp11.h"
+static struct zorro_device_id gvp11_zorro_tbl[] __devinitdata = {
+	{ ZORRO_PROD_GVP_COMBO_030_R3_SCSI,	~0x00ffffff },
+	{ ZORRO_PROD_GVP_SERIES_II,		~0x00ffffff },
+	{ ZORRO_PROD_GVP_GFORCE_030_SCSI,	~0x01ffffff },
+	{ ZORRO_PROD_GVP_A530_SCSI,		~0x01ffffff },
+	{ ZORRO_PROD_GVP_COMBO_030_R4_SCSI,	~0x01ffffff },
+	{ ZORRO_PROD_GVP_A1291,			~0x07ffffff },
+	{ ZORRO_PROD_GVP_GFORCE_040_SCSI_1,	~0x07ffffff },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(zorro, gvp11_zorro_tbl);

-static struct scsi_host_template driver_template = {
-	.proc_name		= "GVP11",
-	.name			= "GVP Series II SCSI",
-	.detect			= gvp11_detect,
-	.release		= gvp11_release,
-	.queuecommand		= wd33c93_queuecommand,
-	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= gvp11_bus_reset,
-	.eh_host_reset_handler	= wd33c93_host_reset,
-	.can_queue		= CAN_QUEUE,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= CMD_PER_LUN,
-	.use_clustering		= DISABLE_CLUSTERING
+static struct zorro_driver gvp11_driver = {
+	.name		= "gvp11",
+	.id_table	= gvp11_zorro_tbl,
+	.probe		= gvp11_probe,
+	.remove		= __devexit_p(gvp11_remove),
 };

+static int __init gvp11_init(void)
+{
+	return zorro_register_driver(&gvp11_driver);
+}

-#include "scsi_module.c"
+module_init(gvp11_init);

-int gvp11_release(struct Scsi_Host *instance)
+static void __exit gvp11_exit(void)
 {
-#ifdef MODULE
-    DMA(instance)->CNTR = 0;
-    release_mem_region(ZTWO_PADDR(instance->base), 256);
-    free_irq(IRQ_AMIGA_PORTS, instance);
-    wd33c93_release();
-#endif
-    return 1;
+	zorro_unregister_driver(&gvp11_driver);
 }

+module_exit(gvp11_exit);
+
+MODULE_DESCRIPTION("GVP Series II SCSI");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
index bf22859..c1befe4 100644
--- a/drivers/scsi/gvp11.h
+++ b/drivers/scsi/gvp11.h
@@ -11,9 +11,6 @@

 #include <linux/types.h>

-int gvp11_detect(struct scsi_host_template *);
-int gvp11_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
@@ -22,7 +19,6 @@ int gvp11_release(struct Scsi_Host *);
 #define CAN_QUEUE 16
 #endif

-#ifndef HOSTS_C

 /*
  * if the transfer address ANDed with this results in a non-zero
@@ -54,6 +50,4 @@ typedef struct {
 #define GVP11_DMAC_INT_ENABLE	(1<<3)
 #define GVP11_DMAC_DIR_WRITE	(1<<4)

-#endif /* else def HOSTS_C */
-
 #endif /* GVP11_H */
-- 
1.6.3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
