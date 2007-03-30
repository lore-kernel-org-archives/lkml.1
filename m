Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXC3VJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXC3VJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXC3VJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:09:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbXC3VJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:12 -0400
Date: Fri, 30 Mar 2007 14:03:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Albert Lee <albertcc@tw.ibm.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "Adam W. Hawks" <awhawks@us.ibm.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 02/37] ide: remove clearing bmdma status from
	cdrom_decode_status() (rev #4)
Message-ID: <20070330210353.GC29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-remove-clearing-bmdma-status-from-cdrom_decode_status.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Albert Lee <albertcc@tw.ibm.com>

ide: remove clearing bmdma status from cdrom_decode_status() (rev #4)

patch 2/2:
  Remove clearing bmdma status from cdrom_decode_status() since ATA devices
  might need it as well.

  (http://lkml.org/lkml/2006/12/4/201 and http://lkml.org/lkml/2006/11/15/94)

Signed-off-by: Albert Lee <albertcc@tw.ibm.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Adam W. Hawks" <awhawks@us.ibm.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c   |    7 -------
 drivers/ide/pci/piix.c |    4 ----
 include/linux/ide.h    |    1 -
 3 files changed, 12 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -687,15 +687,8 @@ static void ide_dump_status_no_sense(ide
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	struct request *rq = HWGROUP(drive)->rq;
-	ide_hwif_t *hwif = HWIF(drive);
 	int stat, err, sense_key;
 	
-	/* We may have bogus DMA interrupts in PIO state here */
-	if (HWIF(drive)->dma_status && hwif->atapi_irq_bogon) {
-		stat = hwif->INB(hwif->dma_status);
-		/* Should we force the bit as well ? */
-		hwif->OUTB(stat, hwif->dma_status);
-	}
 	/* Check for errors. */
 	stat = HWIF(drive)->INB(IDE_STATUS_REG);
 	if (stat_ret)
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -502,10 +502,6 @@ static void __devinit init_hwif_piix(ide
 		/* This is a painful system best to let it self tune for now */
 		return;
 	}
-	/* ESB2 appears to generate spurious DMA interrupts in PIO mode
-	   when in native mode */
-	if (hwif->pci_dev->device == PCI_DEVICE_ID_INTEL_ESB2_18)
-		hwif->atapi_irq_bogon = 1;
 
 	hwif->autodma = 0;
 	hwif->tuneproc = &piix_tune_drive;
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -797,7 +797,6 @@ typedef struct hwif_s {
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	no_io_32bit : 1; /* 1 = can not do 32-bit IO ops */
 	unsigned	err_stops_fifo : 1; /* 1=data FIFO is cleared by an error */
-	unsigned	atapi_irq_bogon : 1; /* Generates spurious DMA interrupts in PIO mode */
 
 	struct device	gendev;
 	struct completion gendev_rel_comp; /* To deal with device release() */

-- 
