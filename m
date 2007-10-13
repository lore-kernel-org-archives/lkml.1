Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXJMBkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXJMBkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbXJMBkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:40:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:21239 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbXJMBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=pqBr8bP70wRGME+AIAn226yOE0e4hamqFAt9Ktj41/3hdWUx+80t1BJ3DxuY616pGUfpVAEuwsJhoRl8WWZJlwwz+NnF/rF8bCuwe8Zhe/qd0ND8g3mMtZbb3wbZVUnnZLd+kfqNsJu97lL48cFCqlZA4C1i7sr9Yr8/mtfXdKA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata update
Date: Sat, 13 Oct 2007 03:42:22 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Kristoffer Nyborg Gregertsen <kngregertsen@norway.atmel.com>
References: <20071012194002.GA1545@havoc.gtf.org>
In-Reply-To: <20071012194002.GA1545@havoc.gtf.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710130342.22217.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 12 October 2007, Jeff Garzik wrote:
> 
> [ I just sent this upstream to Andrew and Linus ]
> 
> Now that I have nailed down the corruption problem, I can attend to
> this...  Fun stuff:
> 
> * port multiplier support (like an ethernet hub, only dumber)

Great to see this here.

> * Asynchronous notification -- finally userspace CD-ROM polling can go away!

Is this AHCI specific or could be used by some other SATA hosts?

>   (NOTE: waiting on James B to apply the piece that actually makes this
>   work...)
> 
> * Alan continues to hammer out edge cases in generic ATA support.  An
>   amazing amount of ancient and/or obscure hardware works with libata   thanks to him :)

Worth to mention that this update also contains two new drivers from Alan,
pata_acpi and pata_ns87415. :)

> * Turn on ACPI by default (watch for bug reports!).  This should make
>   suspend/resume work a lot better.
> 
> * New drivers for embedded ATA chips.

Unfortunately both are broken ATM, details below.

[ added Sonic Zhang and Kristoffer Nyborg Gregertsen to cc: ]

> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

[ ... ]

> Alan Cox (22):
>       pata_cmd64x: Set up MWDMA modes properly

two minor things:

a.

@@ -88,14 +88,15 @@ static int cmd648_cable_detect(struct ata_port *ap)
 }
 
 /**
- *     cmd64x_set_piomode      -       set initial PIO mode data
+ *     cmd64x_set_piomode      -       set PIO and MWDMA timing
  *     @ap: ATA interface
  *     @adev: ATA device
+ *     @mode: mode
  *
- *     Called to do the PIO mode setup.
+ *     Called to do the PIO and MWDMA mode setup.
  */
 
-static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
        struct pci_dev *pdev = to_pci_dev(ap->host->dev);
        struct ata_timing t;

function name in the documentation needs fixing

b.

regD fiddling in cmd64x_set_dmamode() could be removed completly

>       libata: correct handling of SRST reset sequences

This potentially adds a regression for nVidia boxes (but ACPI cable
detection should compensate for it):

pata_amd's ->cable_detect checks UDMA timings to get the cable type
(cable detection is done before the SRST) but pata_amd's ->set_piomode
messes with UDMA timings.  It seems that both methods need fixing.

> Jeff Garzik (14):

>       [libata] Turn on ACPI by default

-MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in suspend/resume when set");
+MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in probe/suspend/resume when set");

Would be nice to have Documentation/kernel-parameters.txt updated as well.

> Kristoffer Nyborg Gregertsen (1):
>       AVR32 PATA driver

Won't build because this libata update removes ->irq_ack and ->port_disable
methods from struct ata_port.

> Sonic Zhang (1):
>       libata driver for bf548 on chip ATAPI controller.

Won't build, same problem as with AVR32 PATA driver + needs update to
accomodate for libata-link patches.

There are some other problems:

a.

+config PATA_BF54X_DMA
+       bool "DMA mode"
+       depends on PATA_BF54X
+       default y
+       help
+         Enable DMA mode for Blackfin ATAPI controller.

The preferred solution would be to use module parameter.

If this option is on by default it may be even possible to remove it
completly since this libata update also contains patch from Alan allowing
DMA disable per different classes of ATA devices.

b.

+static struct ata_port_info bfin_port_info[] = {
+       {
+               .sht            = &bfin_sht,
+               .flags          = ATA_FLAG_SLAVE_POSS
+                               | ATA_FLAG_MMIO
+                               | ATA_FLAG_NO_LEGACY,
+               .pio_mask       = 0x1f, /* pio0-4 */
+               .mwdma_mask     = 0,
+#ifdef CONFIG_PATA_BF54X_DMA
+               .udma_mask      = ATA_UDMA5,
+#else
+               .udma_mask      = 0,
+#endif
+               .port_ops       = &bfin_pata_ops,
+       },
+};

MWDMA is never enabled (even if CONFIG_PATA_BF54X_DMA=y) but the driver
contains MWDMA support...

c.

+/**
+ *
+ *    Function:       wait_complete
+ *
+ *    Description:    Waits the interrupt from device
+ *
+ */
+static inline void wait_complete(void __iomem *base, unsigned short mask)
+{
+       unsigned short status;
+       unsigned int i = 0;
+
+#define PATA_BF54X_WAIT_TIMEOUT                10000
+
+       for (i = 0; i < PATA_BF54X_WAIT_TIMEOUT; i++) {
+               status = ATAPI_GET_INT_STATUS(base) & mask;
+               if (status)
+                       break;
+       }
+
+       ATAPI_SET_INT_STATUS(base, mask);
+}

udelay() between retries?

d.

* write_atapi_register()
* read_atapi_register()
* write_atapi_data()
* read_atapi_data()

and

* wait_complete()

need a proper documentation (DocBook-ized etc).

Thanks,
Bart
