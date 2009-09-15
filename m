Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZIOTRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZIOTRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZIOTRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:17:37 -0400
Received: from kroah.org ([198.145.64.141]:33071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbZIOTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/20] hpilo: staging for interrupt handling
Date: Tue, 15 Sep 2009 12:12:48 -0700
Message-Id: <1253041976-1111-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Altobelli <david.altobelli@hp.com>

Refactor some hpilo routines in order to allow for locking changes in
interrupt handling.  Should not be functionally different.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/hpilo.c |  120 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 73 insertions(+), 47 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 880ccf3..35ed123 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -151,6 +151,7 @@ static inline void doorbell_clr(struct ccb *ccb)
 {
 	iowrite8(2, ccb->ccb_u5.db_base);
 }
+
 static inline int ctrl_set(int l2sz, int idxmask, int desclim)
 {
 	int active = 0, go = 1;
@@ -160,6 +161,7 @@ static inline int ctrl_set(int l2sz, int idxmask, int desclim)
 	       active << CTRL_BITPOS_A |
 	       go << CTRL_BITPOS_G;
 }
+
 static void ctrl_setup(struct ccb *ccb, int nr_desc, int l2desc_sz)
 {
 	/* for simplicity, use the same parameters for send and recv ctrls */
@@ -192,13 +194,10 @@ static void fifo_setup(void *base_addr, int nr_entry)
 
 static void ilo_ccb_close(struct pci_dev *pdev, struct ccb_data *data)
 {
-	struct ccb *driver_ccb;
-	struct ccb __iomem *device_ccb;
+	struct ccb *driver_ccb = &data->driver_ccb;
+	struct ccb __iomem *device_ccb = data->mapped_ccb;
 	int retries;
 
-	driver_ccb = &data->driver_ccb;
-	device_ccb = data->mapped_ccb;
-
 	/* complicated dance to tell the hw we are stopping */
 	doorbell_clr(driver_ccb);
 	iowrite32(ioread32(&device_ccb->send_ctrl) & ~(1 << CTRL_BITPOS_G),
@@ -225,26 +224,22 @@ static void ilo_ccb_close(struct pci_dev *pdev, struct ccb_data *data)
 	pci_free_consistent(pdev, data->dma_size, data->dma_va, data->dma_pa);
 }
 
-static int ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
+static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 {
 	char *dma_va, *dma_pa;
-	int pkt_id, pkt_sz, i, error;
 	struct ccb *driver_ccb, *ilo_ccb;
-	struct pci_dev *pdev;
 
 	driver_ccb = &data->driver_ccb;
 	ilo_ccb = &data->ilo_ccb;
-	pdev = hw->ilo_dev;
 
 	data->dma_size = 2 * fifo_sz(NR_QENTRY) +
 			 2 * desc_mem_sz(NR_QENTRY) +
 			 ILO_START_ALIGN + ILO_CACHE_SZ;
 
-	error = -ENOMEM;
-	data->dma_va = pci_alloc_consistent(pdev, data->dma_size,
+	data->dma_va = pci_alloc_consistent(hw->ilo_dev, data->dma_size,
 					    &data->dma_pa);
 	if (!data->dma_va)
-		goto out;
+		return -ENOMEM;
 
 	dma_va = (char *)data->dma_va;
 	dma_pa = (char *)data->dma_pa;
@@ -290,10 +285,18 @@ static int ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 	driver_ccb->ccb_u5.db_base = hw->db_vaddr + (slot << L2_DB_SIZE);
 	ilo_ccb->ccb_u5.db_base = NULL; /* hw ccb's doorbell is not used */
 
+	return 0;
+}
+
+static void ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
+{
+	int pkt_id, pkt_sz;
+	struct ccb *driver_ccb = &data->driver_ccb;
+
 	/* copy the ccb with physical addrs to device memory */
 	data->mapped_ccb = (struct ccb __iomem *)
 				(hw->ram_vaddr + (slot * ILOHW_CCB_SZ));
-	memcpy_toio(data->mapped_ccb, ilo_ccb, sizeof(struct ccb));
+	memcpy_toio(data->mapped_ccb, &data->ilo_ccb, sizeof(struct ccb));
 
 	/* put packets on the send and receive queues */
 	pkt_sz = 0;
@@ -306,7 +309,14 @@ static int ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 	for (pkt_id = 0; pkt_id < NR_QENTRY; pkt_id++)
 		ilo_pkt_enqueue(hw, driver_ccb, RECVQ, pkt_id, pkt_sz);
 
+	/* the ccb is ready to use */
 	doorbell_clr(driver_ccb);
+}
+
+static int ilo_ccb_verify(struct ilo_hwinfo *hw, struct ccb_data *data)
+{
+	int pkt_id, i;
+	struct ccb *driver_ccb = &data->driver_ccb;
 
 	/* make sure iLO is really handling requests */
 	for (i = MAX_WAIT; i > 0; i--) {
@@ -315,20 +325,14 @@ static int ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 		udelay(WAIT_TIME);
 	}
 
-	if (i) {
-		ilo_pkt_enqueue(hw, driver_ccb, SENDQ, pkt_id, 0);
-		doorbell_set(driver_ccb);
-	} else {
-		dev_err(&pdev->dev, "Open could not dequeue a packet\n");
-		error = -EBUSY;
-		goto free;
+	if (i == 0) {
+		dev_err(&hw->ilo_dev->dev, "Open could not dequeue a packet\n");
+		return -EBUSY;
 	}
 
+	ilo_pkt_enqueue(hw, driver_ccb, SENDQ, pkt_id, 0);
+	doorbell_set(driver_ccb);
 	return 0;
-free:
-	ilo_ccb_close(pdev, data);
-out:
-	return error;
 }
 
 static inline int is_channel_reset(struct ccb *ccb)
@@ -343,16 +347,31 @@ static inline void set_channel_reset(struct ccb *ccb)
 	FIFOBARTOHANDLE(ccb->ccb_u1.send_fifobar)->reset = 1;
 }
 
+static inline int get_device_outbound(struct ilo_hwinfo *hw)
+{
+	return ioread32(&hw->mmio_vaddr[DB_OUT]);
+}
+
+static inline int is_db_reset(int db_out)
+{
+	return db_out & (1 << DB_RESET);
+}
+
 static inline int is_device_reset(struct ilo_hwinfo *hw)
 {
 	/* check for global reset condition */
-	return ioread32(&hw->mmio_vaddr[DB_OUT]) & (1 << DB_RESET);
+	return is_db_reset(get_device_outbound(hw));
+}
+
+static inline void clear_pending_db(struct ilo_hwinfo *hw, int clr)
+{
+	iowrite32(clr, &hw->mmio_vaddr[DB_OUT]);
 }
 
 static inline void clear_device(struct ilo_hwinfo *hw)
 {
 	/* clear the device (reset bits, pending channel entries) */
-	iowrite32(-1, &hw->mmio_vaddr[DB_OUT]);
+	clear_pending_db(hw, -1);
 }
 
 static void ilo_locked_reset(struct ilo_hwinfo *hw)
@@ -387,15 +406,11 @@ static ssize_t ilo_read(struct file *fp, char __user *buf,
 			size_t len, loff_t *off)
 {
 	int err, found, cnt, pkt_id, pkt_len;
-	struct ccb_data *data;
-	struct ccb *driver_ccb;
-	struct ilo_hwinfo *hw;
+	struct ccb_data *data = fp->private_data;
+	struct ccb *driver_ccb = &data->driver_ccb;
+	struct ilo_hwinfo *hw = data->ilo_hw;
 	void *pkt;
 
-	data = fp->private_data;
-	driver_ccb = &data->driver_ccb;
-	hw = data->ilo_hw;
-
 	if (is_device_reset(hw) || is_channel_reset(driver_ccb)) {
 		/*
 		 * If the device has been reset, applications
@@ -442,15 +457,11 @@ static ssize_t ilo_write(struct file *fp, const char __user *buf,
 			 size_t len, loff_t *off)
 {
 	int err, pkt_id, pkt_len;
-	struct ccb_data *data;
-	struct ccb *driver_ccb;
-	struct ilo_hwinfo *hw;
+	struct ccb_data *data = fp->private_data;
+	struct ccb *driver_ccb = &data->driver_ccb;
+	struct ilo_hwinfo *hw = data->ilo_hw;
 	void *pkt;
 
-	data = fp->private_data;
-	driver_ccb = &data->driver_ccb;
-	hw = data->ilo_hw;
-
 	if (is_device_reset(hw) || is_channel_reset(driver_ccb)) {
 		/*
 		 * If the device has been reset, applications
@@ -532,14 +543,28 @@ static int ilo_open(struct inode *ip, struct file *fp)
 	/* each fd private_data holds sw/hw view of ccb */
 	if (hw->ccb_alloc[slot] == NULL) {
 		/* create a channel control block for this minor */
-		error = ilo_ccb_open(hw, data, slot);
-		if (!error) {
-			hw->ccb_alloc[slot] = data;
-			hw->ccb_alloc[slot]->ccb_cnt = 1;
-			hw->ccb_alloc[slot]->ccb_excl = fp->f_flags & O_EXCL;
-			hw->ccb_alloc[slot]->ilo_hw = hw;
-		} else
+		error = ilo_ccb_setup(hw, data, slot);
+		if (error) {
+			kfree(data);
+			goto out;
+		}
+
+		/* write the ccb to hw */
+		ilo_ccb_open(hw, data, slot);
+
+		/* make sure the channel is functional */
+		error = ilo_ccb_verify(hw, data);
+		if (error) {
+			ilo_ccb_close(hw->ilo_dev, data);
 			kfree(data);
+			goto out;
+		}
+
+		data->ccb_cnt = 1;
+		data->ccb_excl = fp->f_flags & O_EXCL;
+		data->ilo_hw = hw;
+		hw->ccb_alloc[slot] = data;
+
 	} else {
 		kfree(data);
 		if (fp->f_flags & O_EXCL || hw->ccb_alloc[slot]->ccb_excl) {
@@ -554,6 +579,7 @@ static int ilo_open(struct inode *ip, struct file *fp)
 			error = 0;
 		}
 	}
+out:
 	spin_unlock(&hw->alloc_lock);
 
 	if (!error)
-- 
1.6.4.2

