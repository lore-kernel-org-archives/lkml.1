Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZBROnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZBROnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZBROnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:43:33 -0500
Received: from brick.kernel.dk ([93.163.65.50]:29550 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZBROnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:43:31 -0500
Date: Wed, 18 Feb 2009 15:41:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090218144105.GZ30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One trivial patch, otherwise it's all bug fixes or regressions. Please
pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Boaz Harrosh (1):
      bsg: Fix sense buffer bug in SG_IO

Chip Coldwell (1):
      cciss: PCI power management reset for kexec

Hannes Reinecke (1):
      block: fix deadlock in blk_abort_queue() for drivers that readd to timeout list

Jens Axboe (2):
      block: fix bad definition of BIO_RW_SYNC
      block: revert part of 18ce3751ccd488c78d3827e9f6bf54e6322676fb

Neil Brown (1):
      block: fix booting from partitioned md array

Roel Kluin (1):
      paride/pg.c: xs(): &&/|| confusion

Subhash Peddamallu (1):
      fs/bio: bio_alloc_bioset: pass right object ptr to mempool_free

 block/blk-timeout.c          |    9 ++-
 block/blktrace.c             |    2 +-
 block/bsg.c                  |   17 ++--
 block/genhd.c                |    8 ++
 drivers/block/cciss.c        |  215 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/paride/pg.c    |    2 +-
 drivers/md/dm-io.c           |    2 +-
 drivers/md/dm-kcopyd.c       |    2 +-
 drivers/md/md.c              |    4 +-
 fs/bio.c                     |    5 +-
 fs/buffer.c                  |    2 +-
 include/linux/bio.h          |    2 -
 include/linux/blktrace_api.h |    1 +
 include/linux/fs.h           |    6 +-
 kernel/power/swap.c          |    5 +-
 mm/page_io.c                 |    2 +-
 16 files changed, 259 insertions(+), 25 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index a095353..bbbdc4b 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -209,12 +209,19 @@ void blk_abort_queue(struct request_queue *q)
 {
 	unsigned long flags;
 	struct request *rq, *tmp;
+	LIST_HEAD(list);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	elv_abort_queue(q);
 
-	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
+	/*
+	 * Splice entries to local list, to avoid deadlocking if entries
+	 * get readded to the timeout list by error handling
+	 */
+	list_splice_init(&q->timeout_list, &list);
+
+	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
 		blk_abort_request(rq);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/block/blktrace.c b/block/blktrace.c
index 39cc3bf..7cf9d1f 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -142,7 +142,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 	what |= ddir_act[rw & WRITE];
 	what |= MASK_TC_BIT(rw, BARRIER);
-	what |= MASK_TC_BIT(rw, SYNC);
+	what |= MASK_TC_BIT(rw, SYNCIO);
 	what |= MASK_TC_BIT(rw, AHEAD);
 	what |= MASK_TC_BIT(rw, META);
 	what |= MASK_TC_BIT(rw, DISCARD);
diff --git a/block/bsg.c b/block/bsg.c
index d414bb5..0ce8806 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -244,7 +244,8 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
  * map sg_io_v4 to a request.
  */
 static struct request *
-bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
+bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
+	    u8 *sense)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
@@ -306,6 +307,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 		if (ret)
 			goto out;
 	}
+
+	rq->sense = sense;
+	rq->sense_len = 0;
+
 	return rq;
 out:
 	if (rq->cmd != rq->__cmd)
@@ -348,9 +353,6 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
 static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 			    struct bsg_command *bc, struct request *rq)
 {
-	rq->sense = bc->sense;
-	rq->sense_len = 0;
-
 	/*
 	 * add bc command to busy queue and submit rq for io
 	 */
@@ -419,7 +421,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 {
 	int ret = 0;
 
-	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
+	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
 	/*
 	 * fill in all the output members
 	 */
@@ -635,7 +637,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
 		/*
 		 * get a request, fill in the blanks, and add to request queue
 		 */
-		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
+		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm, bc->sense);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			rq = NULL;
@@ -922,11 +924,12 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct request *rq;
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
+		u8 sense[SCSI_SENSE_BUFFERSIZE];
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 			return -EFAULT;
 
-		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
+		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
diff --git a/block/genhd.c b/block/genhd.c
index 397960c..e1eadcc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1087,6 +1087,14 @@ dev_t blk_lookup_devt(const char *name, int partno)
 		if (strcmp(dev_name(dev), name))
 			continue;
 
+		if (partno < disk->minors) {
+			/* We need to return the right devno, even
+			 * if the partition doesn't exist yet.
+			 */
+			devt = MKDEV(MAJOR(dev->devt),
+				     MINOR(dev->devt) + partno);
+			break;
+		}
 		part = disk_get_part(disk, partno);
 		if (part) {
 			devt = part_devt(part);
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 01e6938..d2cb67b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3390,6 +3390,203 @@ static void free_hba(int i)
 	kfree(p);
 }
 
+/* Send a message CDB to the firmware. */
+static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, unsigned char type)
+{
+	typedef struct {
+		CommandListHeader_struct CommandHeader;
+		RequestBlock_struct Request;
+		ErrDescriptor_struct ErrorDescriptor;
+	} Command;
+	static const size_t cmd_sz = sizeof(Command) + sizeof(ErrorInfo_struct);
+	Command *cmd;
+	dma_addr_t paddr64;
+	uint32_t paddr32, tag;
+	void __iomem *vaddr;
+	int i, err;
+
+	vaddr = ioremap_nocache(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+	if (vaddr == NULL)
+		return -ENOMEM;
+
+	/* The Inbound Post Queue only accepts 32-bit physical addresses for the
+	   CCISS commands, so they must be allocated from the lower 4GiB of
+	   memory. */
+	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err) {
+		iounmap(vaddr);
+		return -ENOMEM;
+	}
+
+	cmd = pci_alloc_consistent(pdev, cmd_sz, &paddr64);
+	if (cmd == NULL) {
+		iounmap(vaddr);
+		return -ENOMEM;
+	}
+
+	/* This must fit, because of the 32-bit consistent DMA mask.  Also,
+	   although there's no guarantee, we assume that the address is at
+	   least 4-byte aligned (most likely, it's page-aligned). */
+	paddr32 = paddr64;
+
+	cmd->CommandHeader.ReplyQueue = 0;
+	cmd->CommandHeader.SGList = 0;
+	cmd->CommandHeader.SGTotal = 0;
+	cmd->CommandHeader.Tag.lower = paddr32;
+	cmd->CommandHeader.Tag.upper = 0;
+	memset(&cmd->CommandHeader.LUN.LunAddrBytes, 0, 8);
+
+	cmd->Request.CDBLen = 16;
+	cmd->Request.Type.Type = TYPE_MSG;
+	cmd->Request.Type.Attribute = ATTR_HEADOFQUEUE;
+	cmd->Request.Type.Direction = XFER_NONE;
+	cmd->Request.Timeout = 0; /* Don't time out */
+	cmd->Request.CDB[0] = opcode;
+	cmd->Request.CDB[1] = type;
+	memset(&cmd->Request.CDB[2], 0, 14); /* the rest of the CDB is reserved */
+
+	cmd->ErrorDescriptor.Addr.lower = paddr32 + sizeof(Command);
+	cmd->ErrorDescriptor.Addr.upper = 0;
+	cmd->ErrorDescriptor.Len = sizeof(ErrorInfo_struct);
+
+	writel(paddr32, vaddr + SA5_REQUEST_PORT_OFFSET);
+
+	for (i = 0; i < 10; i++) {
+		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
+		if ((tag & ~3) == paddr32)
+			break;
+		schedule_timeout_uninterruptible(HZ);
+	}
+
+	iounmap(vaddr);
+
+	/* we leak the DMA buffer here ... no choice since the controller could
+	   still complete the command. */
+	if (i == 10) {
+		printk(KERN_ERR "cciss: controller message %02x:%02x timed out\n",
+			opcode, type);
+		return -ETIMEDOUT;
+	}
+
+	pci_free_consistent(pdev, cmd_sz, cmd, paddr64);
+
+	if (tag & 2) {
+		printk(KERN_ERR "cciss: controller message %02x:%02x failed\n",
+			opcode, type);
+		return -EIO;
+	}
+
+	printk(KERN_INFO "cciss: controller message %02x:%02x succeeded\n",
+		opcode, type);
+	return 0;
+}
+
+#define cciss_soft_reset_controller(p) cciss_message(p, 1, 0)
+#define cciss_noop(p) cciss_message(p, 3, 0)
+
+static __devinit int cciss_reset_msi(struct pci_dev *pdev)
+{
+/* the #defines are stolen from drivers/pci/msi.h. */
+#define msi_control_reg(base)		(base + PCI_MSI_FLAGS)
+#define PCI_MSIX_FLAGS_ENABLE		(1 << 15)
+
+	int pos;
+	u16 control = 0;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	if (pos) {
+		pci_read_config_word(pdev, msi_control_reg(pos), &control);
+		if (control & PCI_MSI_FLAGS_ENABLE) {
+			printk(KERN_INFO "cciss: resetting MSI\n");
+			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSI_FLAGS_ENABLE);
+		}
+	}
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (pos) {
+		pci_read_config_word(pdev, msi_control_reg(pos), &control);
+		if (control & PCI_MSIX_FLAGS_ENABLE) {
+			printk(KERN_INFO "cciss: resetting MSI-X\n");
+			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSIX_FLAGS_ENABLE);
+		}
+	}
+
+	return 0;
+}
+
+/* This does a hard reset of the controller using PCI power management
+ * states. */
+static __devinit int cciss_hard_reset_controller(struct pci_dev *pdev)
+{
+	u16 pmcsr, saved_config_space[32];
+	int i, pos;
+
+	printk(KERN_INFO "cciss: using PCI PM to reset controller\n");
+
+	/* This is very nearly the same thing as
+
+	   pci_save_state(pci_dev);
+	   pci_set_power_state(pci_dev, PCI_D3hot);
+	   pci_set_power_state(pci_dev, PCI_D0);
+	   pci_restore_state(pci_dev);
+
+	   but we can't use these nice canned kernel routines on
+	   kexec, because they also check the MSI/MSI-X state in PCI
+	   configuration space and do the wrong thing when it is
+	   set/cleared.  Also, the pci_save/restore_state functions
+	   violate the ordering requirements for restoring the
+	   configuration space from the CCISS document (see the
+	   comment below).  So we roll our own .... */
+
+	for (i = 0; i < 32; i++)
+		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
+	if (pos == 0) {
+		printk(KERN_ERR "cciss_reset_controller: PCI PM not supported\n");
+		return -ENODEV;
+	}
+
+	/* Quoting from the Open CISS Specification: "The Power
+	 * Management Control/Status Register (CSR) controls the power
+	 * state of the device.  The normal operating state is D0,
+	 * CSR=00h.  The software off state is D3, CSR=03h.  To reset
+	 * the controller, place the interface device in D3 then to
+	 * D0, this causes a secondary PCI reset which will reset the
+	 * controller." */
+
+	/* enter the D3hot power management state */
+	pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
+	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+	pmcsr |= PCI_D3hot;
+	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+
+	schedule_timeout_uninterruptible(HZ >> 1);
+
+	/* enter the D0 power management state */
+	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+	pmcsr |= PCI_D0;
+	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+
+	schedule_timeout_uninterruptible(HZ >> 1);
+
+	/* Restore the PCI configuration space.  The Open CISS
+	 * Specification says, "Restore the PCI Configuration
+	 * Registers, offsets 00h through 60h. It is important to
+	 * restore the command register, 16-bits at offset 04h,
+	 * last. Do not restore the configuration status register,
+	 * 16-bits at offset 06h."  Note that the offset is 2*i. */
+	for (i = 0; i < 32; i++) {
+		if (i == 2 || i == 3)
+			continue;
+		pci_write_config_word(pdev, 2*i, saved_config_space[i]);
+	}
+	wmb();
+	pci_write_config_word(pdev, 4, saved_config_space[2]);
+
+	return 0;
+}
+
 /*
  *  This is it.  Find all the controllers and register them.  I really hate
  *  stealing all these major device numbers.
@@ -3404,6 +3601,24 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int dac, return_code;
 	InquiryData_struct *inq_buff = NULL;
 
+	if (reset_devices) {
+		/* Reset the controller with a PCI power-cycle */
+		if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
+			return -ENODEV;
+
+		/* Some devices (notably the HP Smart Array 5i Controller)
+		   need a little pause here */
+		schedule_timeout_uninterruptible(30*HZ);
+
+		/* Now try to get the controller to respond to a no-op */
+		for (i=0; i<12; i++) {
+			if (cciss_noop(pdev) == 0)
+				break;
+			else
+				printk("cciss: no-op failed%s\n", (i < 11 ? "; re-trying" : ""));
+		}
+	}
+
 	i = alloc_cciss_hba();
 	if (i < 0)
 		return -1;
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 9dfa271..c397b3d 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -422,7 +422,7 @@ static void xs(char *buf, char *targ, int len)
 
 	for (k = 0; k < len; k++) {
 		char c = *buf++;
-		if (c != ' ' || c != l)
+		if (c != ' ' && c != l)
 			l = *targ++ = c;
 	}
 	if (l == ' ')
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index a343385..f14813b 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -328,7 +328,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	struct dpages old_pages = *dp;
 
 	if (sync)
-		rw |= (1 << BIO_RW_SYNC);
+		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 
 	/*
 	 * For multiple regions we need to be careful to rewind
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 3073618..0a225da 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -344,7 +344,7 @@ static int run_io_job(struct kcopyd_job *job)
 {
 	int r;
 	struct dm_io_request io_req = {
-		.bi_rw = job->rw | (1 << BIO_RW_SYNC),
+		.bi_rw = job->rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG),
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
 		.mem.offset = job->offset,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4495104..03b4cd0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -474,7 +474,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	 * causes ENOTSUPP, we allocate a spare bio...
 	 */
 	struct bio *bio = bio_alloc(GFP_NOIO, 1);
-	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNC);
+	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNCIO) | (1<<BIO_RW_UNPLUG);
 
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_sector = sector;
@@ -531,7 +531,7 @@ int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 	struct completion event;
 	int ret;
 
-	rw |= (1 << BIO_RW_SYNC);
+	rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = sector;
diff --git a/fs/bio.c b/fs/bio.c
index 062299a..72ab251 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -302,9 +302,10 @@ void bio_init(struct bio *bio)
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
 	struct bio *bio = NULL;
+	void *p;
 
 	if (bs) {
-		void *p = mempool_alloc(bs->bio_pool, gfp_mask);
+		p = mempool_alloc(bs->bio_pool, gfp_mask);
 
 		if (p)
 			bio = p + bs->front_pad;
@@ -329,7 +330,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 			}
 			if (unlikely(!bvl)) {
 				if (bs)
-					mempool_free(bio, bs->bio_pool);
+					mempool_free(p, bs->bio_pool);
 				else
 					kfree(bio);
 				bio = NULL;
diff --git a/fs/buffer.c b/fs/buffer.c
index 665d446..62b57e3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3108,7 +3108,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE_SYNC, bh);
+		ret = submit_bh(WRITE, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2aa283a..1b16108 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -171,8 +171,6 @@ struct bio {
 #define BIO_RW_FAILFAST_TRANSPORT	8
 #define BIO_RW_FAILFAST_DRIVER		9
 
-#define BIO_RW_SYNC	(BIO_RW_SYNCIO | BIO_RW_UNPLUG)
-
 #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
 
 /*
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 25379cb..6e91587 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -15,6 +15,7 @@ enum blktrace_cat {
 	BLK_TC_WRITE	= 1 << 1,	/* writes */
 	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
 	BLK_TC_SYNC	= 1 << 3,	/* sync IO */
+	BLK_TC_SYNCIO	= BLK_TC_SYNC,
 	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
 	BLK_TC_REQUEUE	= 1 << 5,	/* requeueing */
 	BLK_TC_ISSUE	= 1 << 6,	/* issue */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..67857dc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,10 +87,10 @@ struct inodes_stat_t {
 #define WRITE 1
 #define READA 2		/* read-ahead  - don't block if no resources */
 #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
-#define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
+#define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
-#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
-#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNC))
+#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
+#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 6da1435..505f319 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -60,6 +60,7 @@ static struct block_device *resume_bdev;
 static int submit(int rw, pgoff_t page_off, struct page *page,
 			struct bio **bio_chain)
 {
+	const int bio_rw = rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
@@ -80,7 +81,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	bio_get(bio);
 
 	if (bio_chain == NULL) {
-		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
+		submit_bio(bio_rw, bio);
 		wait_on_page_locked(page);
 		if (rw == READ)
 			bio_set_pages_dirty(bio);
@@ -90,7 +91,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 			get_page(page);	/* These pages are freed later */
 		bio->bi_private = *bio_chain;
 		*bio_chain = bio;
-		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
+		submit_bio(bio_rw, bio);
 	}
 	return 0;
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index dc6ce0a..3023c47 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -111,7 +111,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		goto out;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= (1 << BIO_RW_SYNC);
+		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);
-- 
Jens Axboe

