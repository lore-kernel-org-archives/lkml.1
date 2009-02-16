Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZBPTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZBPTX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZBPTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:23:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:63600 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZBPTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:23:14 -0500
Message-ID: <4999BD1A.1060101@gawab.com>
Date: Mon, 16 Feb 2009 11:23:06 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090213)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com> <499986D0.3000205@ru.mvista.com>
In-Reply-To: <499986D0.3000205@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:

> After referring to the SCSI command codes "cdb 0x1e" means ALLOW MEDIUM REMOVAL command -- which
> could hardly be addressed to an usual hard disk. So, it looks like we had a case of the confused bug report which
> has a lot of info on the hard disk while errors were most probably happening with a CD/DVD drive.
Yes, I originally thought it was my hard disk because the kernel logs showed ata2.

But, Tejun Heo figured out it was my DVD drive (ATAPI) that was on the ata2 link.

(see http://marc.info/?l=linux-kernel&m=122993014109646&w=2)

I tried to bisect it, but around .28-rc1 I began to get numerous compile errors, so couldn't continue.

I also tried patches that Tejun sent me, but non of them worked, it just slightly change the error message.

So, yes this is a regression that was introduced in the .28 merge window, and I still think that bug #12609 is a duplicate of my bug.

I don't see this bug on tip/master and this is the diff of origin and tip at the time I tested.

$ git diff origin/master..tip/master drivers/ata/

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c

index 54961c0..e004c25 100644

--- a/drivers/ata/ata_piix.c

+++ b/drivers/ata/ata_piix.c

@@ -310,7 +310,7 @@ static struct scsi_host_template piix_sht = {

};

static struct ata_port_operations piix_pata_ops = {

-    .inherits        = &ata_bmdma32_port_ops,

+    .inherits        = &ata_bmdma_port_ops,

    .cable_detect        = ata_cable_40wire,

    .set_piomode        = piix_set_piomode,

    .set_dmamode        = piix_set_dmamode,

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c

index 9fbf059..1ed3966 100644

--- a/drivers/ata/libata-core.c

+++ b/drivers/ata/libata-core.c

@@ -1482,7 +1482,7 @@ static int ata_hpa_resize(struct ata_device *dev)

    struct ata_eh_context *ehc = &dev->link->eh_context;

    int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;

    u64 sectors = ata_id_n_sectors(dev->id);

-    u64 native_sectors;

+    u64 uninitialized_var(native_sectors);

    int rc;

    /* do we need to do it? */

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c

index b9747fa..d65b9b2 100644

--- a/drivers/ata/libata-scsi.c

+++ b/drivers/ata/libata-scsi.c

@@ -3247,7 +3247,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)

    int tries = 5;

    struct ata_device *last_failed_dev = NULL;

    struct ata_link *link;

-    struct ata_device *dev;

+    struct ata_device *uninitialized_var(dev);

    if (ap->flags & ATA_FLAG_DISABLED)

        return;

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c

index 0b299b0..416e3e2 100644

--- a/drivers/ata/libata-sff.c

+++ b/drivers/ata/libata-sff.c

@@ -80,13 +80,6 @@ const struct ata_port_operations ata_bmdma_port_ops = {

};

EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);

-const struct ata_port_operations ata_bmdma32_port_ops = {

-    .inherits        = &ata_bmdma_port_ops,

-

-    .sff_data_xfer        = ata_sff_data_xfer32,

-};

-EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);

-

/**

 *    ata_fill_sg - Fill PCI IDE PRD table

 *    @qc: Metadata associated with taskfile to be transferred

@@ -743,52 +736,6 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,

EXPORT_SYMBOL_GPL(ata_sff_data_xfer);

/**

- *    ata_sff_data_xfer32 - Transfer data by PIO

- *    @dev: device to target

- *    @buf: data buffer

- *    @buflen: buffer length

- *    @rw: read/write

- *

- *    Transfer data from/to the device data register by PIO using 32bit

- *    I/O operations.

- *

- *    LOCKING:

- *    Inherited from caller.

- *

- *    RETURNS:

- *    Bytes consumed.

- */

-

-unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,

-                   unsigned int buflen, int rw)

-{

-    struct ata_port *ap = dev->link->ap;

-    void __iomem *data_addr = ap->ioaddr.data_addr;

-    unsigned int words = buflen >> 2;

-    int slop = buflen & 3;

-

-    /* Transfer multiple of 4 bytes */

-    if (rw == READ)

-        ioread32_rep(data_addr, buf, words);

-    else

-        iowrite32_rep(data_addr, buf, words);

-

-    if (unlikely(slop)) {

-        __le32 pad;

-        if (rw == READ) {

-            pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));

-            memcpy(buf + buflen - slop, &pad, slop);

-        } else {

-            memcpy(&pad, buf + buflen - slop, slop);

-            iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);

-        }

-        words++;

-    }

-    return words << 2;

-}

-EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);

-

-/**

 *    ata_sff_data_xfer_noirq - Transfer data by PIO

 *    @dev: device to target

 *    @buf: data buffer

diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c

index eb99dbe..7cd48ea 100644

--- a/drivers/ata/pata_ali.c

+++ b/drivers/ata/pata_ali.c

@@ -151,7 +151,8 @@ static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int o

    pci_read_config_byte(pdev, pio_fifo, &fifo);

    fifo &= ~(0x0F << shift);

-    fifo |= (on << shift);

+    if (on)

+        fifo |= (on << shift);

    pci_write_config_byte(pdev, pio_fifo, fifo);

}

@@ -369,11 +370,10 @@ static struct ata_port_operations ali_early_port_ops = {

    .inherits    = &ata_sff_port_ops,

    .cable_detect    = ata_cable_40wire,

    .set_piomode    = ali_set_piomode,

-    .sff_data_xfer  = ata_sff_data_xfer32,

};

static const struct ata_port_operations ali_dma_base_ops = {

-    .inherits    = &ata_bmdma32_port_ops,

+    .inherits    = &ata_bmdma_port_ops,

    .set_piomode    = ali_set_piomode,

    .set_dmamode    = ali_set_dmamode,

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

 *    timing_setup        -    shared timing computation and load

@@ -345,7 +345,7 @@ static struct scsi_host_template amd_sht = {

};

static const struct ata_port_operations amd_base_port_ops = {

-    .inherits    = &ata_bmdma32_port_ops,

+    .inherits    = &ata_bmdma_port_ops,

    .prereset    = amd_pre_reset,

};

diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c

index 506adde..115eb00 100644

--- a/drivers/ata/pata_atiixp.c

+++ b/drivers/ata/pata_atiixp.c

@@ -140,7 +140,7 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)

        wanted_pio = 3;

    else if (adev->dma_mode == XFER_MW_DMA_0)

        wanted_pio = 0;

-    else BUG();

+    else panic("atiixp_set_dmamode: unknown DMA mode!");

    if (adev->pio_mode != wanted_pio)

        atiixp_set_pio_timing(ap, adev, wanted_pio);

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

    IDETIM = 0x6C,        /* IDE control register */

@@ -146,7 +146,6 @@ static struct ata_port_operations mpiix_port_ops = {

    .cable_detect    = ata_cable_40wire,

    .set_piomode    = mpiix_set_piomode,

    .prereset    = mpiix_pre_reset,

-    .sff_data_xfer    = ata_sff_data_xfer32,

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

#define SIL680_MMIO_BAR        5

@@ -195,7 +195,7 @@ static struct scsi_host_template sil680_sht = {

};

static struct ata_port_operations sil680_port_ops = {

-    .inherits    = &ata_bmdma32_port_ops,

+    .inherits    = &ata_bmdma_port_ops,

    .cable_detect    = sil680_cable_detect,

    .set_piomode    = sil680_set_piomode,

    .set_dmamode    = sil680_set_dmamode,

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c

index 5c62da9..f9803a2 100644

--- a/drivers/ata/sata_via.c

+++ b/drivers/ata/sata_via.c

@@ -566,7 +566,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)

    static int printed_version;

    unsigned int i;

    int rc;

-    struct ata_host *host;

+    struct ata_host *uninitialized_var(host);

    int board_id = (int) ent->driver_data;

    const unsigned *bar_sizes;

Justin Madru

