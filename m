Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZELUak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZELUak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZELUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:30:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49792 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZELUaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=EATRQILA4sBFLYNZf79m0xI0X0b2LPvoVtLDsoakcWkudykAKjk1ydHopXmB9Vzute
         XX2e3zDQuZAF449YjcCZgXJVBLdMQV8SN5J91ZImBJkXa90VIFImeT9xwlWpz1JcNrSd
         OSuM0HtNk3bDpGVOIMF73o/NcExO1WjOXVjn8=
MIME-Version: 1.0
Date: Tue, 12 May 2009 22:30:19 +0200
X-Google-Sender-Auth: 056ba11b276f64d9
Message-ID: <10f740e80905121330m6dfab255o107f27b3f51dc97b@mail.gmail.com>
Subject: [PATCH] m68k: amiga - A2091/A590 SCSI zorro_driver conversion (was: 
	Re: [PATCH/RFC 0/16] m68k: Device model patches)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 09:36, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Apr 18, 2009 at 20:52, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> [07] m68k: amiga - A3000 SCSI platform device conversion
>>
>> Due to lack of hardware (only Amiga 4000 here), I couldn't test all drivers.
>> Especially the SCSI drivers could use some testing feedback.
>> The changes to most other drivers are fairly trivial.
>
> I'm a bit reluctant to apply the A3000 SCSI platform device conversion without
> having received any feedback, and I would like to apply the whole series ASAP.
> Did anyone try on A3000/A3000T? Similar changes are needed to convert the
> A2091 and GVP II SCSI drivers to the zorro_driver model, so if we have
> more users
> of those, I can do that conversion first, so it can receive some testing.

Here's the conversion of the A2091/A590 SCSI driver to a proper zorro_driver.
Due to the lack of hardware, it's untested.

BTW, when comparing a2091.c to a3000.c, a3000.c has several additional mb()s
and one additiona barrier(). Do we need those in a2091.c, too?

>From 3cffd671427facc80cc7dbfb0ca18ce11ea4a46b Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 12 May 2009 22:21:09 +0200
Subject: [PATCH] m68k: amiga - A2091/A590 SCSI zorro_driver conversion

---
 drivers/scsi/a2091.c |  385 ++++++++++++++++++++++++++-----------------------
 1 files changed, 204 insertions(+), 181 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 475e808..c294da1 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -1,203 +1,142 @@
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
 #include "a2091.h"

-#include<linux/stat.h>

-#define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
-
-static int a2091_release(struct Scsi_Host *instance);
-
-static irqreturn_t a2091_intr (int irq, void *_instance)
+static irqreturn_t a2091_intr(int irq, void *data)
 {
-    unsigned long flags;
-    unsigned int status;
-    struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
-
-    status = DMA(instance)->ISTR;
-    if (!(status & (ISTR_INT_F|ISTR_INT_P)) || !(status & ISTR_INTS))
-	return IRQ_NONE;
-
-    spin_lock_irqsave(instance->host_lock, flags);
-    wd33c93_intr(instance);
-    spin_unlock_irqrestore(instance->host_lock, flags);
-    return IRQ_HANDLED;
+	struct Scsi_Host *host = data;
+	a2091_scsiregs *regs = (a2091_scsiregs *)(host->base);
+	unsigned int status = regs->ISTR;
+	unsigned long flags;
+
+	if (!(status & (ISTR_INT_F|ISTR_INT_P)) || !(status & ISTR_INTS))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	wd33c93_intr(host);
+	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
 }

 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-    struct Scsi_Host *instance = cmd->device->host;
-
-    /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK)
-    {
-	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
-	    & ~0x1ff;
-	HDATA(instance)->dma_bounce_buffer =
-	    kmalloc (HDATA(instance)->dma_bounce_len, GFP_KERNEL);
-	
-	/* can't allocate memory; use PIO */
-	if (!HDATA(instance)->dma_bounce_buffer) {
-	    HDATA(instance)->dma_bounce_len = 0;
-	    return 1;
-	}
+	struct Scsi_Host *host = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(host);
+	a2091_scsiregs *regs = (a2091_scsiregs *)(host->base);
+	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);

-	/* get the physical address of the bounce buffer */
-	addr = virt_to_bus(HDATA(instance)->dma_bounce_buffer);
-
-	/* the bounce buffer may not be in the first 16M of physmem */
+	/* don't allow DMA if the physical address is bad */
 	if (addr & A2091_XFER_MASK) {
-	    /* we could use chipmem... maybe later */
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
-	    return 1;
-	}
-
-	if (!dir_in) {
-		/* copy to bounce buffer for a write */
-		memcpy (HDATA(instance)->dma_bounce_buffer,
-			cmd->SCp.ptr, cmd->SCp.this_residual);
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
+						   GFP_KERNEL);
+
+		/* can't allocate memory; use PIO */
+		if (!hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_len = 0;
+			return 1;
+		}
+
+		/* get the physical address of the bounce buffer */
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
+
+		/* the bounce buffer may not be in the first 16M of physmem */
+		if (addr & A2091_XFER_MASK) {
+			/* we could use chipmem... maybe later */
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
+			return 1;
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
-	cntr |= CNTR_DDIR;
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= CNTR_DDIR;

-    /* remember direction */
-    HDATA(cmd->device->host)->dma_dir = dir_in;
+	/* remember direction */
+	hdata->dma_dir = dir_in;

-    DMA(cmd->device->host)->CNTR = cntr;
+	regs->CNTR = cntr;

-    /* setup DMA *physical* address */
-    DMA(cmd->device->host)->ACR = addr;
+	/* setup DMA *physical* address */
+	regs->ACR = addr;

-    if (dir_in){
-	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    }else{
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
-      }
-    /* start DMA */
-    DMA(cmd->device->host)->ST_DMA = 1;
+	if (dir_in) {
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	} else {
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
+	}
+	/* start DMA */
+	regs->ST_DMA = 1;

-    /* return success */
-    return 0;
+	/* return success */
+	return 0;
 }

 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
-		      int status)
+		     int status)
 {
-    /* disable SCSI interrupts */
-    unsigned short cntr = CNTR_PDMD;
-
-    if (!HDATA(instance)->dma_dir)
-	    cntr |= CNTR_DDIR;
-
-    /* disable SCSI interrupts */
-    DMA(instance)->CNTR = cntr;
-
-    /* flush if we were reading */
-    if (HDATA(instance)->dma_dir) {
-	DMA(instance)->FLUSH = 1;
-	while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
-	    ;
-    }
-
-    /* clear a possible interrupt */
-    DMA(instance)->CINT = 1;
-
-    /* stop DMA */
-    DMA(instance)->SP_DMA = 1;
-
-    /* restore the CONTROL bits (minus the direction flag) */
-    DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
-
-    /* copy from a bounce buffer, if necessary */
-    if (status && HDATA(instance)->dma_bounce_buffer) {
-	if( HDATA(instance)->dma_dir )
-		memcpy (SCpnt->SCp.ptr,
-			HDATA(instance)->dma_bounce_buffer,
-			SCpnt->SCp.this_residual);
-	kfree (HDATA(instance)->dma_bounce_buffer);
-	HDATA(instance)->dma_bounce_buffer = NULL;
-	HDATA(instance)->dma_bounce_len = 0;
-    }
-}
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);

-static int __init a2091_detect(struct scsi_host_template *tpnt)
-{
-    static unsigned char called = 0;
-    struct Scsi_Host *instance;
-    unsigned long address;
-    struct zorro_dev *z = NULL;
-    wd33c93_regs regs;
-    int num_a2091 = 0;
-
-    if (!MACH_IS_AMIGA || called)
-	return 0;
-    called = 1;
-
-    tpnt->proc_name = "A2091";
-    tpnt->proc_info = &wd33c93_proc_info;
-
-    while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-	if (z->id != ZORRO_PROD_CBM_A590_A2091_1 &&
-	    z->id != ZORRO_PROD_CBM_A590_A2091_2)
-	    continue;
-	address = z->resource.start;
-	if (!request_mem_region(address, 256, "wd33c93"))
-	    continue;
-
-	instance = scsi_register (tpnt, sizeof (struct WD33C93_hostdata));
-	if (instance == NULL)
-	    goto release;
-	instance->base = ZTWO_VADDR(address);
-	instance->irq = IRQ_AMIGA_PORTS;
-	instance->unique_id = z->slotaddr;
-	DMA(instance)->DAWR = DAWR_A2091;
-	regs.SASR = &(DMA(instance)->SASR);
-	regs.SCMD = &(DMA(instance)->SCMD);
-	HDATA(instance)->no_sync = 0xff;
-	HDATA(instance)->fast = 0;
-	HDATA(instance)->dma_mode = CTRL_DMA;
-	wd33c93_init(instance, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
-	if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED, "A2091 SCSI",
-			instance))
-	    goto unregister;
-	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
-	num_a2091++;
-	continue;
-
-unregister:
-	scsi_unregister(instance);
-	wd33c93_release();
-release:
-	release_mem_region(address, 256);
-    }
-
-    return num_a2091;
+	/* disable SCSI interrupts */
+	unsigned short cntr = CNTR_PDMD;
+
+	if (!hdata->dma_dir)
+		cntr |= CNTR_DDIR;
+
+	/* disable SCSI interrupts */
+	regs->CNTR = cntr;
+
+	/* flush if we were reading */
+	if (hdata->dma_dir) {
+		regs->FLUSH = 1;
+		while (!(regs->ISTR & ISTR_FE_FLG))
+			;
+	}
+
+	/* clear a possible interrupt */
+	regs->CINT = 1;
+
+	/* stop DMA */
+	regs->SP_DMA = 1;
+
+	/* restore the CONTROL bits (minus the direction flag) */
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && hdata->dma_bounce_buffer) {
+		if (hdata->dma_dir)
+			memcpy(SCpnt->SCp.ptr, hdata->dma_bounce_buffer,
+			       SCpnt->SCp.this_residual);
+		kfree(hdata->dma_bounce_buffer);
+		hdata->dma_bounce_buffer = NULL;
+		hdata->dma_bounce_len = 0;
+	}
 }

 static int a2091_bus_reset(struct scsi_cmnd *cmd)
@@ -214,13 +153,11 @@ static int a2091_bus_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }

-#define HOSTS_C
-
-static struct scsi_host_template driver_template = {
-	.proc_name		= "A2901",
+static struct scsi_host_template a2091_scsi_template = {
+	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
-	.detect			= a2091_detect,
-	.release		= a2091_release,
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "A2901",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= a2091_bus_reset,
@@ -233,17 +170,104 @@ static struct scsi_host_template driver_template = {
 };


-#include "scsi_module.c"
+static int __devinit a2091_init_one(struct zorro_dev *z,
+				    const struct zorro_device_id *ent)
+{
+	struct Scsi_Host *host;
+	struct WD33C93_hostdata *hdata;
+	int error;
+	wd33c93_regs wdregs;
+	a2091_scsiregs *regs;
+
+	if (!request_mem_region(z->resource.start, 256, "wd33c93"))
+		return -EBUSY;
+
+	host = scsi_host_alloc(&a2091_scsi_template,
+			       sizeof(struct WD33C93_hostdata));
+	if (!host) {
+		error = -ENOMEM;
+		goto fail_alloc;
+	}
+
+	host->base = ZTWO_VADDR(z->resource.start);
+	host->irq = IRQ_AMIGA_PORTS;
+	host->unique_id = z->slotaddr;
+
+	regs = (a2091_scsiregs *)(host->base);
+	regs->DAWR = DAWR_A2091;
+
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
+
+	hdata = shost_priv(host);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
+
+	wd33c93_init(host, wdregs, dma_setup, dma_stop, WD33C93_FS_8_10);
+	error = request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
+			    "A2091 SCSI", host);
+	if (error)
+		goto fail_irq;
+
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	error = scsi_add_host(host, NULL);
+	if (error)
+		goto fail_host;
+
+	zorro_set_drvdata(z, host);
+
+	scsi_scan_host(host);
+	return 0;
+
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, host);
+fail_irq:
+	scsi_host_put(host);
+fail_alloc:
+	release_mem_region(z->resource.start, 256);
+	return error;
+}
+
+static void __devexit a2091_remove_one(struct zorro_dev *z)
+{
+	struct Scsi_Host *host = zorro_get_drvdata(z);
+	a2091_scsiregs *regs = (a2091_scsiregs *)(host->base);
+
+	regs->CNTR = 0;
+	scsi_remove_host(host);
+	free_irq(IRQ_AMIGA_PORTS, host);
+	scsi_host_put(host);
+	release_mem_region(z->resource.start, 256);
+}
+
+static struct zorro_device_id a2091_zorro_tbl[] __devinitdata = {
+	{ ZORRO_PROD_CBM_A590_A2091_1 },
+	{ ZORRO_PROD_CBM_A590_A2091_2 },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(zorro, a2091_zorro_tbl);
+
+static struct zorro_driver a2091_driver = {
+	.name		= "a2091",
+	.id_table	= a2091_zorro_tbl,
+	.probe		= a2091_init_one,
+	.remove		= __devexit_p(a2091_remove_one),
+};
+
+static int __init a2091_init(void)
+{
+	return zorro_register_driver(&a2091_driver);
+}
+
+module_init(a2091_init);

-static int a2091_release(struct Scsi_Host *instance)
+static void __exit a2091_exit(void)
 {
-#ifdef MODULE
-	DMA(instance)->CNTR = 0;
-	release_mem_region(ZTWO_PADDR(instance->base), 256);
-	free_irq(IRQ_AMIGA_PORTS, instance);
-	wd33c93_release();
-#endif
-	return 1;
+	zorro_unregister_driver(&a2091_driver);
 }

+module_exit(a2091_exit);
+
+MODULE_DESCRIPTION("Commodore A2091/A590 SCSI");
 MODULE_LICENSE("GPL");
-- 
1.6.3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
