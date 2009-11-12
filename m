Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZKLSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZKLSsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZKLSsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:38 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:6753 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZKLSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:33 -0500
Subject: [PATCH 10/11] cciss: Add enhanced scatter-gather support.
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:50:01 -0600
Message-ID: <20091112185000.23389.94929.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Brace <brace@beardog.cce.hp.com>

cciss: Add enhanced scatter-gather support.  For controllers which
supported, more than 512 scatter-gather elements per command may
be used, and the max transfer size can be increased to 8192 blocks.

Signed-off-by: Don Brace <brace@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |  183 +++++++++++++++++++++++++++++++++++++++++----
 drivers/block/cciss.h     |   18 ++++
 drivers/block/cciss_cmd.h |    7 +-
 3 files changed, 188 insertions(+), 20 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index bf2d1c8..1bd313d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1655,9 +1655,11 @@ static void cciss_softirq_done(struct request *rq)
 {
 	CommandList_struct *cmd = rq->completion_data;
 	ctlr_info_t *h = hba[cmd->ctlr];
+	SGDescriptor_struct *curr_sg = cmd->SG;
 	unsigned long flags;
 	u64bit temp64;
 	int i, ddir;
+	int sg_index = 0;
 
 	if (cmd->Request.Type.Direction == XFER_READ)
 		ddir = PCI_DMA_FROMDEVICE;
@@ -1667,9 +1669,22 @@ static void cciss_softirq_done(struct request *rq)
 	/* command did not need to be retried */
 	/* unmap the DMA mapping for all the scatter gather elements */
 	for (i = 0; i < cmd->Header.SGList; i++) {
-		temp64.val32.lower = cmd->SG[i].Addr.lower;
-		temp64.val32.upper = cmd->SG[i].Addr.upper;
-		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
+		if (curr_sg[sg_index].Ext == CCISS_SG_CHAIN) {
+			temp64.val32.lower = cmd->SG[i].Addr.lower;
+			temp64.val32.upper = cmd->SG[i].Addr.upper;
+			pci_dma_sync_single_for_cpu(h->pdev, temp64.val,
+						cmd->SG[i].Len, ddir);
+			pci_unmap_single(h->pdev, temp64.val,
+						cmd->SG[i].Len, ddir);
+			/* Point to the next block */
+			curr_sg = h->cmd_sg_list[cmd->cmdindex]->sgchain;
+			sg_index = 0;
+		}
+		temp64.val32.lower = curr_sg[sg_index].Addr.lower;
+		temp64.val32.upper = curr_sg[sg_index].Addr.upper;
+		pci_unmap_page(h->pdev, temp64.val, curr_sg[sg_index].Len,
+				ddir);
+		++sg_index;
 	}
 
 #ifdef CCISS_DEBUG
@@ -1781,10 +1796,10 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
 
 	/* This is a hardware imposed limit. */
-	blk_queue_max_hw_segments(disk->queue, MAXSGENTRIES);
+	blk_queue_max_hw_segments(disk->queue, h->maxsgentries);
 
 	/* This is a limit in the driver and could be eliminated. */
-	blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
+	blk_queue_max_phys_segments(disk->queue, h->maxsgentries);
 
 	blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
 
@@ -3063,9 +3078,13 @@ static void do_cciss_request(struct request_queue *q)
 	int seg;
 	struct request *creq;
 	u64bit temp64;
-	struct scatterlist tmp_sg[MAXSGENTRIES];
+	struct scatterlist *tmp_sg;
+	SGDescriptor_struct *curr_sg;
 	drive_info_struct *drv;
 	int i, dir;
+	int nseg = 0;
+	int sg_index = 0;
+	int chained = 0;
 
 	/* We call start_io here in case there is a command waiting on the
 	 * queue that has not been sent.
@@ -3078,13 +3097,14 @@ static void do_cciss_request(struct request_queue *q)
 	if (!creq)
 		goto startio;
 
-	BUG_ON(creq->nr_phys_segments > MAXSGENTRIES);
+	BUG_ON(creq->nr_phys_segments > h->maxsgentries);
 
 	if ((c = cmd_alloc(h, 1)) == NULL)
 		goto full;
 
 	blk_start_request(creq);
 
+	tmp_sg = h->scatter_list[c->cmdindex];
 	spin_unlock_irq(q->queue_lock);
 
 	c->cmd_type = CMD_RWREQ;
@@ -3113,7 +3133,7 @@ static void do_cciss_request(struct request_queue *q)
 	       (int)blk_rq_pos(creq), (int)blk_rq_sectors(creq));
 #endif				/* CCISS_DEBUG */
 
-	sg_init_table(tmp_sg, MAXSGENTRIES);
+	sg_init_table(tmp_sg, h->maxsgentries);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
 	/* get the DMA records for the setup */
@@ -3122,25 +3142,70 @@ static void do_cciss_request(struct request_queue *q)
 	else
 		dir = PCI_DMA_TODEVICE;
 
+	curr_sg = c->SG;
+	sg_index = 0;
+	chained = 0;
+
 	for (i = 0; i < seg; i++) {
-		c->SG[i].Len = tmp_sg[i].length;
+		if (((sg_index+1) == (h->max_cmd_sgentries)) &&
+			!chained && ((seg - i) > 1)) {
+			nseg = seg - i;
+			curr_sg[sg_index].Len = (nseg) *
+					sizeof(SGDescriptor_struct);
+			curr_sg[sg_index].Ext = CCISS_SG_CHAIN;
+
+			/* Point to next chain block. */
+			curr_sg = h->cmd_sg_list[c->cmdindex]->sgchain;
+			sg_index = 0;
+			chained = 1;
+		}
+		curr_sg[sg_index].Len = tmp_sg[i].length;
 		temp64.val = (__u64) pci_map_page(h->pdev, sg_page(&tmp_sg[i]),
-						  tmp_sg[i].offset,
-						  tmp_sg[i].length, dir);
-		c->SG[i].Addr.lower = temp64.val32.lower;
-		c->SG[i].Addr.upper = temp64.val32.upper;
-		c->SG[i].Ext = 0;	// we are not chaining
+						tmp_sg[i].offset,
+						tmp_sg[i].length, dir);
+		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
+		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
+		curr_sg[sg_index].Ext = 0;  /* we are not chaining */
+
+		++sg_index;
 	}
+
+	if (chained) {
+		int len;
+		curr_sg = c->SG;
+		sg_index = h->max_cmd_sgentries - 1;
+		len = curr_sg[sg_index].Len;
+		/* Setup pointer to next chain block.
+		 * Fill out last element in current chain
+		 * block with address of next chain block.
+		 */
+		temp64.val = pci_map_single(h->pdev,
+					h->cmd_sg_list[c->cmdindex]->sgchain,
+					len, dir);
+
+		h->cmd_sg_list[c->cmdindex]->sg_chain_dma = temp64.val;
+		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
+		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
+
+		pci_dma_sync_single_for_device(h->pdev,
+				h->cmd_sg_list[c->cmdindex]->sg_chain_dma,
+				len, dir);
+	}
+
 	/* track how many SG entries we are using */
 	if (seg > h->maxSG)
 		h->maxSG = seg;
 
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %u sectors in %d segments\n",
-	       blk_rq_sectors(creq), seg);
+	printk(KERN_DEBUG "cciss: Submitting %ld sectors in %d segments "
+			"chained[%d]\n",
+			blk_rq_sectors(creq), seg, chained);
 #endif				/* CCISS_DEBUG */
 
-	c->Header.SGList = c->Header.SGTotal = seg;
+	c->Header.SGList = c->Header.SGTotal = seg + chained;
+	if (seg > h->max_cmd_sgentries)
+		c->Header.SGList = h->max_cmd_sgentries;
+
 	if (likely(blk_fs_request(creq))) {
 		if(h->cciss_read == CCISS_READ_10) {
 			c->Request.CDB[1] = 0;
@@ -3713,6 +3778,23 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	 * leave a little room for ioctl calls.
 	 */
 	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
+	c->maxsgentries = readl(&(c->cfgtable->MaxSGElements));
+
+	/*
+	 * Limit native command to 32 s/g elements to save dma'able memory.
+	 * Howvever spec says if 0, use 31
+	 */
+
+	c->max_cmd_sgentries = 31;
+	if (c->maxsgentries > 512) {
+		c->max_cmd_sgentries = 32;
+		c->chainsize = c->maxsgentries - c->max_cmd_sgentries + 1;
+		c->maxsgentries -= 1;   /* account for chain pointer */
+	} else {
+		c->maxsgentries = 31;   /* Default to traditional value */
+		c->chainsize = 0;       /* traditional */
+	}
+
 	c->product_name = products[prod_index].product_name;
 	c->access = *(products[prod_index].access);
 	c->nr_cmds = c->max_commands - 4;
@@ -4039,6 +4121,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 {
 	int i;
 	int j = 0;
+	int k = 0;
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff;
@@ -4142,6 +4225,53 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		printk(KERN_ERR "cciss: out of memory");
 		goto clean4;
 	}
+
+	/* Need space for temp scatter list */
+	hba[i]->scatter_list = kmalloc(hba[i]->max_commands *
+						sizeof(struct scatterlist *),
+						GFP_KERNEL);
+	for (k = 0; k < hba[i]->nr_cmds; k++) {
+		hba[i]->scatter_list[k] = kmalloc(sizeof(struct scatterlist) *
+							hba[i]->maxsgentries,
+							GFP_KERNEL);
+		if (hba[i]->scatter_list[k] == NULL) {
+			printk(KERN_ERR "cciss%d: could not allocate "
+				"s/g lists\n", i);
+			goto clean4;
+		}
+	}
+	hba[i]->cmd_sg_list = kmalloc(sizeof(struct Cmd_sg_list *) *
+						hba[i]->nr_cmds,
+						GFP_KERNEL);
+	if (!hba[i]->cmd_sg_list) {
+		printk(KERN_ERR "cciss%d: Cannot get memory for "
+			"s/g chaining.\n", i);
+		goto clean4;
+	}
+	/* Build up chain blocks for each command */
+	if (hba[i]->chainsize > 0) {
+		for (j = 0; j < hba[i]->nr_cmds; j++) {
+			hba[i]->cmd_sg_list[j] =
+					kmalloc(sizeof(struct Cmd_sg_list),
+							GFP_KERNEL);
+			if (!hba[i]->cmd_sg_list[j]) {
+				printk(KERN_ERR "cciss%d: Cannot get memory "
+					"for chain block.\n", i);
+				goto clean4;
+			}
+			/* Need a block of chainsized s/g elements. */
+			hba[i]->cmd_sg_list[j]->sgchain =
+					kmalloc((hba[i]->chainsize *
+						sizeof(SGDescriptor_struct)),
+						GFP_KERNEL);
+			if (!hba[i]->cmd_sg_list[j]->sgchain) {
+				printk(KERN_ERR "cciss%d: Cannot get memory "
+					"for s/g chains\n", i);
+				goto clean4;
+			}
+		}
+	}
+
 	spin_lock_init(&hba[i]->lock);
 
 	/* Initialize the pdev driver private data.
@@ -4187,7 +4317,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	cciss_procinit(i);
 
-	hba[i]->cciss_max_sectors = 2048;
+	hba[i]->cciss_max_sectors = 8192;
 
 	rebuild_lun_table(hba[i], 1, 0);
 	hba[i]->busy_initializing = 0;
@@ -4195,6 +4325,15 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 clean4:
 	kfree(hba[i]->cmd_pool_bits);
+	/* Free up sg elements */
+	for (k = 0; k < hba[i]->nr_cmds; k++)
+		kfree(hba[i]->scatter_list[k]);
+	kfree(hba[i]->scatter_list);
+	for (j = 0; j < hba[i]->nr_cmds; j++) {
+		if (hba[i]->cmd_sg_list[j])
+			kfree(hba[i]->cmd_sg_list[j]->sgchain);
+		kfree(hba[i]->cmd_sg_list[j]);
+	}
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
 				    hba[i]->nr_cmds * sizeof(CommandList_struct),
@@ -4308,6 +4447,14 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
 			    hba[i]->errinfo_pool, hba[i]->errinfo_pool_dhandle);
 	kfree(hba[i]->cmd_pool_bits);
+	/* Free up sg elements */
+	for (j = 0; j < hba[i]->nr_cmds; j++)
+		kfree(hba[i]->scatter_list[j]);
+	kfree(hba[i]->scatter_list);
+	for (j = 0; j < hba[i]->nr_cmds; j++) {
+		kfree(hba[i]->cmd_sg_list[j]->sgchain);
+		kfree(hba[i]->cmd_sg_list[j]);
+	}
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 31524cf..e5c63e5 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -55,7 +55,13 @@ typedef struct _drive_info_struct
 	char device_initialized;     /* indicates whether dev is initialized */
 } drive_info_struct;
 
-struct ctlr_info 
+struct Cmd_sg_list {
+	SGDescriptor_struct	*sgchain;
+	dma64_addr_t		sg_chain_dma;
+	int			chain_block_size;
+};
+
+struct ctlr_info
 {
 	int	ctlr;
 	char	devname[8];
@@ -75,6 +81,16 @@ struct ctlr_info
 	int	num_luns;
 	int 	highest_lun;
 	int	usage_count;  /* number of opens all all minor devices */
+	/* Need space for temp sg list
+	 * number of scatter/gathers supported
+	 * number of scatter/gathers in chained block
+	 */
+	struct	scatterlist **scatter_list;
+	int	maxsgentries;
+	int	chainsize;
+	int	max_cmd_sgentries;
+	struct Cmd_sg_list **cmd_sg_list;
+
 #	define DOORBELL_INT	0
 #	define PERF_MODE_INT	1
 #	define SIMPLE_MODE_INT	2
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index dbaed1e..b50a9b2 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -7,7 +7,8 @@
 
 //general boundary defintions
 #define SENSEINFOBYTES          32//note that this value may vary between host implementations
-#define MAXSGENTRIES            31
+#define MAXSGENTRIES            32
+#define CCISS_SG_CHAIN          0x80000000
 #define MAXREPLYQS              256
 
 //Command Status value
@@ -319,6 +320,10 @@ typedef struct _CfgTable_struct {
   BYTE             ServerName[16];
   DWORD            HeartBeat;
   DWORD            SCSI_Prefetch;
+  DWORD            MaxSGElements;
+  DWORD            MaxLogicalUnits;
+  DWORD            MaxPhysicalDrives;
+  DWORD            MaxPhysicalDrivesPerLogicalUnit;
 } CfgTable_struct;
 #pragma pack()	 
 #endif // CCISS_CMD_H

