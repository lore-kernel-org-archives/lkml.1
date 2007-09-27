Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbXI0MOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbXI0MOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXI0MNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:13:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45033 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbXI0MNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:13:50 -0400
Date: Thu, 27 Sep 2007 08:13:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] umem driver cleanups
Message-ID: <20070927121349.GA32622@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'umem' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git umem

to receive the following updates:

 drivers/block/umem.c                    |  202 ++++++++++++++++---------------
 {include/linux => drivers/block}/umem.h |   19 +--
 include/linux/pci_ids.h                 |    5 +
 3 files changed, 119 insertions(+), 107 deletions(-)
 rename {include/linux => drivers/block}/umem.h (94%)

Jeff Garzik (5):
      drivers/block/umem: move private include away from include/linux
      drivers/block/umem: use dev_printk()
      drivers/block/umem: minor cleanups
      drivers/block/umem: trim trailing whitespace
      drivers/block/umem: use DRIVER_NAME where appropriate

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 6b7c02d..f327e25 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -52,7 +52,7 @@
 #include <linux/fcntl.h>        /* O_ACCMODE */
 #include <linux/hdreg.h>  /* HDIO_GETGEO */
 
-#include <linux/umem.h>
+#include "umem.h"
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -67,9 +67,10 @@
  * Version Information
  */
 
-#define DRIVER_VERSION "v2.3"
-#define DRIVER_AUTHOR "San Mehat, Johannes Erdfelt, NeilBrown"
-#define DRIVER_DESC "Micro Memory(tm) PCI memory board block driver"
+#define DRIVER_NAME	"umem"
+#define DRIVER_VERSION	"v2.3"
+#define DRIVER_AUTHOR	"San Mehat, Johannes Erdfelt, NeilBrown"
+#define DRIVER_DESC	"Micro Memory(tm) PCI memory board block driver"
 
 static int debug;
 /* #define HW_TRACE(x)     writeb(x,cards[0].csr_remap + MEMCTRLSTATUS_MAGIC) */
@@ -97,15 +98,9 @@ static int major_nr;
 #include <linux/blkpg.h>
 
 struct cardinfo {
-	int		card_number;
 	struct pci_dev	*dev;
 
-	int		irq;
-
-	unsigned long	csr_base;
 	unsigned char	__iomem *csr_remap;
-	unsigned long	csr_len;
-	unsigned int	win_size; /* PCI window size */
 	unsigned int	mm_size;  /* size in kbytes */
 
 	unsigned int	init_size; /* initial segment, in sectors,
@@ -233,7 +228,7 @@ static void dump_regs(struct cardinfo *card)
 */
 static void dump_dmastat(struct cardinfo *card, unsigned int dmastat)
 {
-	printk(KERN_DEBUG "MM%d*: DMAstat - ", card->card_number);
+	dev_printk(KERN_DEBUG, &card->dev->dev, "DMAstat - ");
 	if (dmastat & DMASCR_ANY_ERR)
 		printk("ANY_ERR ");
 	if (dmastat & DMASCR_MBE_ERR)
@@ -295,7 +290,7 @@ static void mm_start_io(struct cardinfo *card)
 	desc->control_bits &= ~cpu_to_le32(DMASCR_CHAIN_EN);
 	desc->sem_control_bits = desc->control_bits;
 
-			       
+
 	if (debug & DEBUG_LED_ON_TRANSFER)
 		set_led(card, LED_REMOVE, LED_ON);
 
@@ -329,7 +324,7 @@ static int add_bio(struct cardinfo *card);
 
 static void activate(struct cardinfo *card)
 {
-	/* if No page is Active, and Ready is 
+	/* if No page is Active, and Ready is
 	 * not empty, then switch Ready page
 	 * to active and start IO.
 	 * Then add any bh's that are available to Ready
@@ -368,7 +363,7 @@ static void mm_unplug_device(struct request_queue *q)
 	spin_unlock_irqrestore(&card->lock, flags);
 }
 
-/* 
+/*
  * If there is room on Ready page, take
  * one bh off list and add it.
  * return 1 if there was room, else 0.
@@ -400,7 +395,7 @@ static int add_bio(struct cardinfo *card)
 		return 0;
 
 	len = bio_iovec(bio)->bv_len;
-	dma_handle = pci_map_page(card->dev, 
+	dma_handle = pci_map_page(card->dev,
 				  bio_page(bio),
 				  bio_offset(bio),
 				  len,
@@ -438,7 +433,7 @@ static int add_bio(struct cardinfo *card)
 	bio->bi_sector += (len>>9);
 	bio->bi_size -= len;
 	bio->bi_idx++;
-	if (bio->bi_idx >= bio->bi_vcnt) 
+	if (bio->bi_idx >= bio->bi_vcnt)
 		card->currentbio = NULL;
 
 	return 1;
@@ -461,7 +456,7 @@ static void process_page(unsigned long data)
 	if (card->Active < 0)
 		goto out_unlock;
 	page = &card->mm_pages[card->Active];
-	
+
 	while (page->headcnt < page->cnt) {
 		struct bio *bio = page->bio;
 		struct mm_dma_desc *desc = &page->desc[page->headcnt];
@@ -471,7 +466,7 @@ static void process_page(unsigned long data)
 
 		if (!(control & DMASCR_DMA_COMPLETE)) {
 			control = dma_status;
-			last=1; 
+			last=1;
 		}
 		page->headcnt++;
 		idx = bio->bi_phys_segments;
@@ -479,24 +474,24 @@ static void process_page(unsigned long data)
 		if (bio->bi_phys_segments >= bio->bi_vcnt)
 			page->bio = bio->bi_next;
 
-		pci_unmap_page(card->dev, desc->data_dma_handle, 
+		pci_unmap_page(card->dev, desc->data_dma_handle,
 			       bio_iovec_idx(bio,idx)->bv_len,
 				 (control& DMASCR_TRANSFER_READ) ?
 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 		if (control & DMASCR_HARD_ERROR) {
 			/* error */
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-			printk(KERN_WARNING "MM%d: I/O error on sector %d/%d\n",
-			       card->card_number, 
-			       le32_to_cpu(desc->local_addr)>>9,
-			       le32_to_cpu(desc->transfer_size));
+			dev_printk(KERN_WARNING, &card->dev->dev,
+				"I/O error on sector %d/%d\n",
+				le32_to_cpu(desc->local_addr)>>9,
+				le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
 		} else if (test_bit(BIO_RW, &bio->bi_rw) &&
 			   le32_to_cpu(desc->local_addr)>>9 == card->init_size) {
 			card->init_size += le32_to_cpu(desc->transfer_size)>>9;
 			if (card->init_size>>1 >= card->mm_size) {
-				printk(KERN_INFO "MM%d: memory now initialised\n",
-				       card->card_number);
+				dev_printk(KERN_INFO, &card->dev->dev,
+					"memory now initialised\n");
 				set_userbit(card, MEMORY_INITIALIZED, 1);
 			}
 		}
@@ -585,7 +580,7 @@ HW_TRACE(0x30);
 	else
 		writeb((DMASCR_DMA_COMPLETE|DMASCR_CHAIN_COMPLETE) >> 16,
 		       card->csr_remap+ DMA_STATUS_CTRL + 2);
-	
+
 	/* log errors and clear interrupt status */
 	if (dma_status & DMASCR_ANY_ERR) {
 		unsigned int	data_log1, data_log2;
@@ -606,46 +601,51 @@ HW_TRACE(0x30);
 		dump_dmastat(card, dma_status);
 
 		if (stat & 0x01)
-			printk(KERN_ERR "MM%d*: Memory access error detected (err count %d)\n",
-				card->card_number, count);
+			dev_printk(KERN_ERR, &card->dev->dev,
+				"Memory access error detected (err count %d)\n",
+				count);
 		if (stat & 0x02)
-			printk(KERN_ERR "MM%d*: Multi-bit EDC error\n",
-				card->card_number);
+			dev_printk(KERN_ERR, &card->dev->dev,
+				"Multi-bit EDC error\n");
 
-		printk(KERN_ERR "MM%d*: Fault Address 0x%02x%08x, Fault Data 0x%08x%08x\n",
-			card->card_number, addr_log2, addr_log1, data_log2, data_log1);
-		printk(KERN_ERR "MM%d*: Fault Check 0x%02x, Fault Syndrome 0x%02x\n",
-			card->card_number, check, syndrome);
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Fault Address 0x%02x%08x, Fault Data 0x%08x%08x\n",
+			addr_log2, addr_log1, data_log2, data_log1);
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Fault Check 0x%02x, Fault Syndrome 0x%02x\n",
+			check, syndrome);
 
 		writeb(0, card->csr_remap + ERROR_COUNT);
 	}
 
 	if (dma_status & DMASCR_PARITY_ERR_REP) {
-		printk(KERN_ERR "MM%d*: PARITY ERROR REPORTED\n", card->card_number);
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"PARITY ERROR REPORTED\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_PARITY_ERR_DET) {
-		printk(KERN_ERR "MM%d*: PARITY ERROR DETECTED\n", card->card_number); 
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"PARITY ERROR DETECTED\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_SYSTEM_ERR_SIG) {
-		printk(KERN_ERR "MM%d*: SYSTEM ERROR\n", card->card_number); 
+		dev_printk(KERN_ERR, &card->dev->dev, "SYSTEM ERROR\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_TARGET_ABT) {
-		printk(KERN_ERR "MM%d*: TARGET ABORT\n", card->card_number); 
+		dev_printk(KERN_ERR, &card->dev->dev, "TARGET ABORT\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_MASTER_ABT) {
-		printk(KERN_ERR "MM%d*: MASTER ABORT\n", card->card_number); 
+		dev_printk(KERN_ERR, &card->dev->dev, "MASTER ABORT\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
@@ -656,7 +656,7 @@ HW_TRACE(0x30);
 
 HW_TRACE(0x36);
 
-	return IRQ_HANDLED; 
+	return IRQ_HANDLED;
 }
 /*
 -----------------------------------------------------------------------------------
@@ -696,20 +696,20 @@ static int check_battery(struct cardinfo *card, int battery, int status)
 		card->battery[battery].last_change = jiffies;
 
 		if (card->battery[battery].good) {
-			printk(KERN_ERR "MM%d: Battery %d now good\n",
-				card->card_number, battery + 1);
+			dev_printk(KERN_ERR, &card->dev->dev,
+				"Battery %d now good\n", battery + 1);
 			card->battery[battery].warned = 0;
 		} else
-			printk(KERN_ERR "MM%d: Battery %d now FAILED\n",
-				card->card_number, battery + 1);
+			dev_printk(KERN_ERR, &card->dev->dev,
+				"Battery %d now FAILED\n", battery + 1);
 
 		return 1;
 	} else if (!card->battery[battery].good &&
 		   !card->battery[battery].warned &&
 		   time_after_eq(jiffies, card->battery[battery].last_change +
 				 (HZ * 60 * 60 * 5))) {
-		printk(KERN_ERR "MM%d: Battery %d still FAILED after 5 hours\n",
-			card->card_number, battery + 1);
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Battery %d still FAILED after 5 hours\n", battery + 1);
 		card->battery[battery].warned = 1;
 
 		return 1;
@@ -733,8 +733,8 @@ static void check_batteries(struct cardinfo *card)
 
 	status = readb(card->csr_remap + MEMCTRLSTATUS_BATTERY);
 	if (debug & DEBUG_BATTERY_POLLING)
-		printk(KERN_DEBUG "MM%d: checking battery status, 1 = %s, 2 = %s\n",
-		       card->card_number,
+		dev_printk(KERN_DEBUG, &card->dev->dev,
+			"checking battery status, 1 = %s, 2 = %s\n",
 		       (status & BATTERY_1_FAILURE) ? "FAILURE" : "OK",
 		       (status & BATTERY_2_FAILURE) ? "FAILURE" : "OK");
 
@@ -749,7 +749,7 @@ static void check_all_batteries(unsigned long ptr)
 {
 	int i;
 
-	for (i = 0; i < num_cards; i++) 
+	for (i = 0; i < num_cards; i++)
 		if (!(cards[i].flags & UM_FLAG_NO_BATT)) {
 			struct cardinfo *card = &cards[i];
 			spin_lock_bh(&card->lock);
@@ -853,45 +853,56 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	unsigned char	mem_present;
 	unsigned char	batt_status;
 	unsigned int	saved_bar, data;
+	unsigned long	csr_base;
+	unsigned long	csr_len;
 	int		magic_number;
+	static int	printed_version;
 
-	if (pci_enable_device(dev) < 0)
-		return -ENODEV;
+	if (!printed_version++)
+		printk(KERN_INFO DRIVER_VERSION " : " DRIVER_DESC "\n");
+
+	ret = pci_enable_device(dev);
+	if (ret)
+		return ret;
 
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xF8);
 	pci_set_master(dev);
 
 	card->dev         = dev;
-	card->card_number = num_cards;
 
-	card->csr_base = pci_resource_start(dev, 0);
-	card->csr_len  = pci_resource_len(dev, 0);
+	csr_base = pci_resource_start(dev, 0);
+	csr_len  = pci_resource_len(dev, 0);
+	if (!csr_base || !csr_len)
+		return -ENODEV;
 
-	printk(KERN_INFO "Micro Memory(tm) controller #%d found at %02x:%02x (PCI Mem Module (Battery Backup))\n",
-	       card->card_number, dev->bus->number, dev->devfn);
+	dev_printk(KERN_INFO, &dev->dev,
+		"Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
 
 	if (pci_set_dma_mask(dev, DMA_64BIT_MASK) &&
 	    pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
-		printk(KERN_WARNING "MM%d: NO suitable DMA found\n",num_cards);
+		dev_printk(KERN_WARNING, &dev->dev, "NO suitable DMA found\n");
 		return  -ENOMEM;
 	}
-	if (!request_mem_region(card->csr_base, card->csr_len, "Micro Memory")) {
-		printk(KERN_ERR "MM%d: Unable to request memory region\n", card->card_number);
-		ret = -ENOMEM;
 
+	ret = pci_request_regions(dev, DRIVER_NAME);
+	if (ret) {
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Unable to request memory region\n");
 		goto failed_req_csr;
 	}
 
-	card->csr_remap = ioremap_nocache(card->csr_base, card->csr_len);
+	card->csr_remap = ioremap_nocache(csr_base, csr_len);
 	if (!card->csr_remap) {
-		printk(KERN_ERR "MM%d: Unable to remap memory region\n", card->card_number);
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Unable to remap memory region\n");
 		ret = -ENOMEM;
 
 		goto failed_remap_csr;
 	}
 
-	printk(KERN_INFO "MM%d: CSR 0x%08lx -> 0x%p (0x%lx)\n", card->card_number,
-	       card->csr_base, card->csr_remap, card->csr_len);
+	dev_printk(KERN_INFO, &card->dev->dev,
+		"CSR 0x%08lx -> 0x%p (0x%lx)\n",
+	       csr_base, card->csr_remap, csr_len);
 
 	switch(card->dev->device) {
 	case 0x5415:
@@ -915,7 +926,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	}
 
 	if (readb(card->csr_remap + MEMCTRLSTATUS_MAGIC) != magic_number) {
-		printk(KERN_ERR "MM%d: Magic number invalid\n", card->card_number);
+		dev_printk(KERN_ERR, &card->dev->dev, "Magic number invalid\n");
 		ret = -ENOMEM;
 		goto failed_magic;
 	}
@@ -928,7 +939,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 						      &card->mm_pages[1].page_dma);
 	if (card->mm_pages[0].desc == NULL ||
 	    card->mm_pages[1].desc == NULL) {
-		printk(KERN_ERR "MM%d: alloc failed\n", card->card_number);
+		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
 		goto failed_alloc;
 	}
 	reset_page(&card->mm_pages[0]);
@@ -949,7 +960,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
 	card->check_batteries = 0;
-	
+
 	mem_present = readb(card->csr_remap + MEMCTRLSTATUS_MEMORY);
 	switch (mem_present) {
 	case MEM_128_MB:
@@ -982,12 +993,13 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	card->battery[1].good = !(batt_status & BATTERY_2_FAILURE);
 	card->battery[0].last_change = card->battery[1].last_change = jiffies;
 
-	if (card->flags & UM_FLAG_NO_BATT) 
-		printk(KERN_INFO "MM%d: Size %d KB\n",
-		       card->card_number, card->mm_size);
+	if (card->flags & UM_FLAG_NO_BATT)
+		dev_printk(KERN_INFO, &card->dev->dev,
+			"Size %d KB\n", card->mm_size);
 	else {
-		printk(KERN_INFO "MM%d: Size %d KB, Battery 1 %s (%s), Battery 2 %s (%s)\n",
-		       card->card_number, card->mm_size,
+		dev_printk(KERN_INFO, &card->dev->dev,
+			"Size %d KB, Battery 1 %s (%s), Battery 2 %s (%s)\n",
+		       card->mm_size,
 		       (batt_status & BATTERY_1_DISABLED ? "Disabled" : "Enabled"),
 		       card->battery[0].good ? "OK" : "FAILURE",
 		       (batt_status & BATTERY_2_DISABLED ? "Disabled" : "Enabled"),
@@ -1005,19 +1017,16 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	data = ~data;
 	data += 1;
 
-	card->win_size = data;
-
-
-	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, "pci-umem", card)) {
-		printk(KERN_ERR "MM%d: Unable to allocate IRQ\n", card->card_number);
+	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME, card)) {
+		dev_printk(KERN_ERR, &card->dev->dev,
+			"Unable to allocate IRQ\n");
 		ret = -ENODEV;
 
 		goto failed_req_irq;
 	}
 
-	card->irq = dev->irq;
-	printk(KERN_INFO "MM%d: Window size %d bytes, IRQ %d\n", card->card_number,
-	       card->win_size, card->irq);
+	dev_printk(KERN_INFO, &card->dev->dev,
+		"Window size %d bytes, IRQ %d\n", data, dev->irq);
 
         spin_lock_init(&card->lock);
 
@@ -1037,10 +1046,12 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
 	num_cards++;
 
 	if (!get_userbit(card, MEMORY_INITIALIZED)) {
-		printk(KERN_INFO "MM%d: memory NOT initialized. Consider over-writing whole device.\n", card->card_number);
+		dev_printk(KERN_INFO, &card->dev->dev,
+			"memory NOT initialized. Consider over-writing whole device.\n");
 		card->init_size = 0;
 	} else {
-		printk(KERN_INFO "MM%d: memory already initialized\n", card->card_number);
+		dev_printk(KERN_INFO, &card->dev->dev,
+			"memory already initialized\n");
 		card->init_size = card->mm_size;
 	}
 
@@ -1062,7 +1073,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_i
  failed_magic:
 	iounmap(card->csr_remap);
  failed_remap_csr:
-	release_mem_region(card->csr_base, card->csr_len);
+	pci_release_regions(dev);
  failed_req_csr:
 
 	return ret;
@@ -1077,9 +1088,8 @@ static void mm_pci_remove(struct pci_dev *dev)
 	struct cardinfo *card = pci_get_drvdata(dev);
 
 	tasklet_kill(&card->tasklet);
+	free_irq(dev->irq, card);
 	iounmap(card->csr_remap);
-	release_mem_region(card->csr_base, card->csr_len);
-	free_irq(card->irq, card);
 
 	if (card->mm_pages[0].desc)
 		pci_free_consistent(card->dev, PAGE_SIZE*2,
@@ -1090,6 +1100,9 @@ static void mm_pci_remove(struct pci_dev *dev)
 				    card->mm_pages[1].desc,
 				    card->mm_pages[1].page_dma);
 	blk_cleanup_queue(card->queue);
+
+	pci_release_regions(dev);
+	pci_disable_device(dev);
 }
 
 static const struct pci_device_id mm_pci_ids[] = {
@@ -1109,11 +1122,12 @@ static const struct pci_device_id mm_pci_ids[] = {
 MODULE_DEVICE_TABLE(pci, mm_pci_ids);
 
 static struct pci_driver mm_pci_driver = {
-	.name =		"umem",
-	.id_table =	mm_pci_ids,
-	.probe =	mm_pci_probe,
-	.remove =	mm_pci_remove,
+	.name		= DRIVER_NAME,
+	.id_table	= mm_pci_ids,
+	.probe		= mm_pci_probe,
+	.remove		= mm_pci_remove,
 };
+
 /*
 -----------------------------------------------------------------------------------
 --                               mm_init
@@ -1125,13 +1139,11 @@ static int __init mm_init(void)
 	int retval, i;
 	int err;
 
-	printk(KERN_INFO DRIVER_VERSION " : " DRIVER_DESC "\n");
-
 	retval = pci_register_driver(&mm_pci_driver);
 	if (retval)
 		return -ENOMEM;
 
-	err = major_nr = register_blkdev(0, "umem");
+	err = major_nr = register_blkdev(0, DRIVER_NAME);
 	if (err < 0) {
 		pci_unregister_driver(&mm_pci_driver);
 		return -EIO;
@@ -1157,13 +1169,13 @@ static int __init mm_init(void)
 	}
 
 	init_battery_timer();
-	printk("MM: desc_per_page = %ld\n", DESC_PER_PAGE);
+	printk(KERN_INFO "MM: desc_per_page = %ld\n", DESC_PER_PAGE);
 /* printk("mm_init: Done. 10-19-01 9:00\n"); */
 	return 0;
 
 out:
 	pci_unregister_driver(&mm_pci_driver);
-	unregister_blkdev(major_nr, "umem");
+	unregister_blkdev(major_nr, DRIVER_NAME);
 	while (i--)
 		put_disk(mm_gendisk[i]);
 	return -ENOMEM;
@@ -1186,7 +1198,7 @@ static void __exit mm_cleanup(void)
 
 	pci_unregister_driver(&mm_pci_driver);
 
-	unregister_blkdev(major_nr, "umem");
+	unregister_blkdev(major_nr, DRIVER_NAME);
 }
 
 module_init(mm_init);
diff --git a/drivers/block/umem.h b/drivers/block/umem.h
new file mode 100644
index 0000000..375c689
--- /dev/null
+++ b/drivers/block/umem.h
@@ -0,0 +1,133 @@
+
+/*
+ * This file contains defines for the
+ *   Micro Memory MM5415
+ * family PCI Memory Module with Battery Backup.
+ *
+ * Copyright Micro Memory INC 2001.  All rights reserved.
+ * Release under the terms of the GNU GENERAL PUBLIC LICENSE version 2.
+ * See the file COPYING.
+ */
+
+#ifndef _DRIVERS_BLOCK_MM_H
+#define _DRIVERS_BLOCK_MM_H
+
+
+#define IRQ_TIMEOUT (1 * HZ)
+
+/* CSR register definition */
+#define MEMCTRLSTATUS_MAGIC	0x00
+#define  MM_MAGIC_VALUE		(unsigned char)0x59
+
+#define MEMCTRLSTATUS_BATTERY	0x04
+#define  BATTERY_1_DISABLED	0x01
+#define  BATTERY_1_FAILURE	0x02
+#define  BATTERY_2_DISABLED	0x04
+#define  BATTERY_2_FAILURE	0x08
+
+#define MEMCTRLSTATUS_MEMORY	0x07
+#define  MEM_128_MB		0xfe
+#define  MEM_256_MB		0xfc
+#define  MEM_512_MB		0xf8
+#define  MEM_1_GB		0xf0
+#define  MEM_2_GB		0xe0
+
+#define MEMCTRLCMD_LEDCTRL	0x08
+#define  LED_REMOVE		2
+#define  LED_FAULT		4
+#define  LED_POWER		6
+#define	 LED_FLIP		255
+#define  LED_OFF		0x00
+#define  LED_ON			0x01
+#define  LED_FLASH_3_5		0x02
+#define  LED_FLASH_7_0		0x03
+#define  LED_POWER_ON		0x00
+#define  LED_POWER_OFF		0x01
+#define  USER_BIT1		0x01
+#define  USER_BIT2		0x02
+
+#define MEMORY_INITIALIZED	USER_BIT1
+
+#define MEMCTRLCMD_ERRCTRL	0x0C
+#define  EDC_NONE_DEFAULT	0x00
+#define  EDC_NONE		0x01
+#define  EDC_STORE_READ		0x02
+#define  EDC_STORE_CORRECT	0x03
+
+#define MEMCTRLCMD_ERRCNT	0x0D
+#define MEMCTRLCMD_ERRSTATUS	0x0E
+
+#define ERROR_DATA_LOG		0x20
+#define ERROR_ADDR_LOG		0x28
+#define ERROR_COUNT		0x3D
+#define ERROR_SYNDROME		0x3E
+#define ERROR_CHECK		0x3F
+
+#define DMA_PCI_ADDR		0x40
+#define DMA_LOCAL_ADDR		0x48
+#define DMA_TRANSFER_SIZE	0x50
+#define DMA_DESCRIPTOR_ADDR	0x58
+#define DMA_SEMAPHORE_ADDR	0x60
+#define DMA_STATUS_CTRL		0x68
+#define  DMASCR_GO		0x00001
+#define  DMASCR_TRANSFER_READ	0x00002
+#define  DMASCR_CHAIN_EN	0x00004
+#define  DMASCR_SEM_EN		0x00010
+#define  DMASCR_DMA_COMP_EN	0x00020
+#define  DMASCR_CHAIN_COMP_EN	0x00040
+#define  DMASCR_ERR_INT_EN	0x00080
+#define  DMASCR_PARITY_INT_EN	0x00100
+#define  DMASCR_ANY_ERR		0x00800
+#define  DMASCR_MBE_ERR		0x01000
+#define  DMASCR_PARITY_ERR_REP	0x02000
+#define  DMASCR_PARITY_ERR_DET	0x04000
+#define  DMASCR_SYSTEM_ERR_SIG	0x08000
+#define  DMASCR_TARGET_ABT	0x10000
+#define  DMASCR_MASTER_ABT	0x20000
+#define  DMASCR_DMA_COMPLETE	0x40000
+#define  DMASCR_CHAIN_COMPLETE	0x80000
+
+/*
+3.SOME PCs HAVE HOST BRIDGES WHICH APPARENTLY DO NOT CORRECTLY HANDLE
+READ-LINE (0xE) OR READ-MULTIPLE (0xC) PCI COMMAND CODES DURING DMA
+TRANSFERS. IN OTHER SYSTEMS THESE COMMAND CODES WILL CAUSE THE HOST BRIDGE
+TO ALLOW LONGER BURSTS DURING DMA READ OPERATIONS. THE UPPER FOUR BITS
+(31..28) OF THE DMA CSR HAVE BEEN MADE PROGRAMMABLE, SO THAT EITHER A 0x6,
+AN 0xE OR A 0xC CAN BE WRITTEN TO THEM TO SET THE COMMAND CODE USED DURING
+DMA READ OPERATIONS.
+*/
+#define        DMASCR_READ   0x60000000
+#define        DMASCR_READLINE   0xE0000000
+#define        DMASCR_READMULTI   0xC0000000
+
+
+#define DMASCR_ERROR_MASK	(DMASCR_MASTER_ABT | DMASCR_TARGET_ABT | DMASCR_SYSTEM_ERR_SIG | DMASCR_PARITY_ERR_DET | DMASCR_MBE_ERR | DMASCR_ANY_ERR)
+#define DMASCR_HARD_ERROR	(DMASCR_MASTER_ABT | DMASCR_TARGET_ABT | DMASCR_SYSTEM_ERR_SIG | DMASCR_PARITY_ERR_DET | DMASCR_MBE_ERR)
+
+#define WINDOWMAP_WINNUM	0x7B
+
+#define DMA_READ_FROM_HOST 0
+#define DMA_WRITE_TO_HOST 1
+
+struct mm_dma_desc {
+	__le64	pci_addr;
+	__le64	local_addr;
+	__le32	transfer_size;
+	u32	zero1;
+	__le64	next_desc_addr;
+	__le64	sem_addr;
+	__le32	control_bits;
+	u32	zero2;
+
+	dma_addr_t data_dma_handle;
+
+	/* Copy of the bits */
+	__le64	sem_control_bits;
+} __attribute__((aligned(8)));
+
+/* bits for card->flags */
+#define UM_FLAG_DMA_IN_REGS		1
+#define UM_FLAG_NO_BYTE_STATUS		2
+#define UM_FLAG_NO_BATTREG		4
+#define	UM_FLAG_NO_BATT			8
+#endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 55f307f..506b9ae 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1736,6 +1736,11 @@
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 
+#define PCI_VENDOR_ID_MICRO_MEMORY		0x1332
+#define PCI_DEVICE_ID_MICRO_MEMORY_5415CN	0x5415
+#define PCI_DEVICE_ID_MICRO_MEMORY_5425CN	0x5425
+#define PCI_DEVICE_ID_MICRO_MEMORY_6155		0x6155
+
 #define PCI_VENDOR_ID_DOMEX		0x134a
 #define PCI_DEVICE_ID_DOMEX_DMX3191D	0x0001
 
diff --git a/include/linux/umem.h b/include/linux/umem.h
deleted file mode 100644
index f36ebfc..0000000
--- a/include/linux/umem.h
+++ /dev/null
@@ -1,138 +0,0 @@
-
-/*
- * This file contains defines for the
- *   Micro Memory MM5415
- * family PCI Memory Module with Battery Backup.
- *
- * Copyright Micro Memory INC 2001.  All rights reserved.
- * Release under the terms of the GNU GENERAL PUBLIC LICENSE version 2.
- * See the file COPYING.
- */
-
-#ifndef _DRIVERS_BLOCK_MM_H
-#define _DRIVERS_BLOCK_MM_H
-
-
-#define IRQ_TIMEOUT (1 * HZ)
-
-/* CSR register definition */
-#define MEMCTRLSTATUS_MAGIC	0x00
-#define  MM_MAGIC_VALUE		(unsigned char)0x59
-
-#define MEMCTRLSTATUS_BATTERY	0x04
-#define  BATTERY_1_DISABLED	0x01
-#define  BATTERY_1_FAILURE	0x02
-#define  BATTERY_2_DISABLED	0x04
-#define  BATTERY_2_FAILURE	0x08
-
-#define MEMCTRLSTATUS_MEMORY	0x07
-#define  MEM_128_MB		0xfe
-#define  MEM_256_MB		0xfc
-#define  MEM_512_MB		0xf8
-#define  MEM_1_GB		0xf0
-#define  MEM_2_GB		0xe0
-
-#define MEMCTRLCMD_LEDCTRL	0x08
-#define  LED_REMOVE		2
-#define  LED_FAULT		4
-#define  LED_POWER		6
-#define	 LED_FLIP		255
-#define  LED_OFF		0x00
-#define  LED_ON			0x01
-#define  LED_FLASH_3_5		0x02
-#define  LED_FLASH_7_0		0x03
-#define  LED_POWER_ON		0x00
-#define  LED_POWER_OFF		0x01
-#define  USER_BIT1		0x01
-#define  USER_BIT2		0x02
-
-#define MEMORY_INITIALIZED	USER_BIT1
-
-#define MEMCTRLCMD_ERRCTRL	0x0C
-#define  EDC_NONE_DEFAULT	0x00
-#define  EDC_NONE		0x01
-#define  EDC_STORE_READ		0x02
-#define  EDC_STORE_CORRECT	0x03
-
-#define MEMCTRLCMD_ERRCNT	0x0D
-#define MEMCTRLCMD_ERRSTATUS	0x0E
-
-#define ERROR_DATA_LOG		0x20
-#define ERROR_ADDR_LOG		0x28
-#define ERROR_COUNT		0x3D
-#define ERROR_SYNDROME		0x3E
-#define ERROR_CHECK		0x3F
-
-#define DMA_PCI_ADDR		0x40
-#define DMA_LOCAL_ADDR		0x48
-#define DMA_TRANSFER_SIZE	0x50
-#define DMA_DESCRIPTOR_ADDR	0x58
-#define DMA_SEMAPHORE_ADDR	0x60
-#define DMA_STATUS_CTRL		0x68
-#define  DMASCR_GO		0x00001
-#define  DMASCR_TRANSFER_READ	0x00002
-#define  DMASCR_CHAIN_EN	0x00004
-#define  DMASCR_SEM_EN		0x00010
-#define  DMASCR_DMA_COMP_EN	0x00020
-#define  DMASCR_CHAIN_COMP_EN	0x00040
-#define  DMASCR_ERR_INT_EN	0x00080
-#define  DMASCR_PARITY_INT_EN	0x00100
-#define  DMASCR_ANY_ERR		0x00800
-#define  DMASCR_MBE_ERR		0x01000
-#define  DMASCR_PARITY_ERR_REP	0x02000
-#define  DMASCR_PARITY_ERR_DET	0x04000
-#define  DMASCR_SYSTEM_ERR_SIG	0x08000
-#define  DMASCR_TARGET_ABT	0x10000
-#define  DMASCR_MASTER_ABT	0x20000
-#define  DMASCR_DMA_COMPLETE	0x40000
-#define  DMASCR_CHAIN_COMPLETE	0x80000
-
-/* 
-3.SOME PCs HAVE HOST BRIDGES WHICH APPARENTLY DO NOT CORRECTLY HANDLE 
-READ-LINE (0xE) OR READ-MULTIPLE (0xC) PCI COMMAND CODES DURING DMA 
-TRANSFERS. IN OTHER SYSTEMS THESE COMMAND CODES WILL CAUSE THE HOST BRIDGE 
-TO ALLOW LONGER BURSTS DURING DMA READ OPERATIONS. THE UPPER FOUR BITS 
-(31..28) OF THE DMA CSR HAVE BEEN MADE PROGRAMMABLE, SO THAT EITHER A 0x6, 
-AN 0xE OR A 0xC CAN BE WRITTEN TO THEM TO SET THE COMMAND CODE USED DURING 
-DMA READ OPERATIONS.
-*/
-#define        DMASCR_READ   0x60000000
-#define        DMASCR_READLINE   0xE0000000
-#define        DMASCR_READMULTI   0xC0000000
-
-
-#define DMASCR_ERROR_MASK	(DMASCR_MASTER_ABT | DMASCR_TARGET_ABT | DMASCR_SYSTEM_ERR_SIG | DMASCR_PARITY_ERR_DET | DMASCR_MBE_ERR | DMASCR_ANY_ERR)
-#define DMASCR_HARD_ERROR	(DMASCR_MASTER_ABT | DMASCR_TARGET_ABT | DMASCR_SYSTEM_ERR_SIG | DMASCR_PARITY_ERR_DET | DMASCR_MBE_ERR)
-
-#define WINDOWMAP_WINNUM	0x7B
-
-#define DMA_READ_FROM_HOST 0
-#define DMA_WRITE_TO_HOST 1
-
-struct mm_dma_desc {
-	__le64	pci_addr;
-	__le64	local_addr;
-	__le32	transfer_size;
-	u32	zero1;
-	__le64	next_desc_addr;
-	__le64	sem_addr;
-	__le32	control_bits;
-	u32	zero2;
-
-	dma_addr_t data_dma_handle;
-
-	/* Copy of the bits */
-	__le64	sem_control_bits;
-} __attribute__((aligned(8)));
-
-#define PCI_VENDOR_ID_MICRO_MEMORY		0x1332
-#define PCI_DEVICE_ID_MICRO_MEMORY_5415CN	0x5415
-#define PCI_DEVICE_ID_MICRO_MEMORY_5425CN	0x5425
-#define PCI_DEVICE_ID_MICRO_MEMORY_6155		0x6155
-
-/* bits for card->flags */
-#define UM_FLAG_DMA_IN_REGS		1
-#define UM_FLAG_NO_BYTE_STATUS		2
-#define UM_FLAG_NO_BATTREG		4
-#define	UM_FLAG_NO_BATT			8
-#endif
