Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYAQVKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYAQVKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYAQVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:09:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYAQVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:09:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 17 Jan 2008 22:09:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git? - drivers/ieee1394 queue
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.99a95666fea52a5e@s5r6.in-berlin.de>
Message-ID: <tkrat.ae8e390f4610e0f1@s5r6.in-berlin.de>
References: <tkrat.99a95666fea52a5e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 95d0449d39ec13c88b46e7f6d7f7e8862c186fbf
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Dec 16 20:53:13 2007 +0100

    ieee1394: ohci1394: don't schedule IT tasklets on IR events
    
    Bug noted by Pieter Palmers:  Isochronous transmit tasklets were
    scheduled on isochronous receive events, in addition to the proper
    isochronous receive tasklets.
    
    http://marc.info/?l=linux1394-devel&m=119783196222802
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 372c5c1..969de2a 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -2126,10 +2126,14 @@ static void ohci_schedule_iso_tasklets(struct ti_ohci *ohci,
 	list_for_each_entry(t, &ohci->iso_tasklet_list, link) {
 		mask = 1 << t->context;
 
-		if (t->type == OHCI_ISO_TRANSMIT && tx_event & mask)
-			tasklet_schedule(&t->tasklet);
-		else if (rx_event & mask)
-			tasklet_schedule(&t->tasklet);
+		if (t->type == OHCI_ISO_TRANSMIT) {
+			if (tx_event & mask)
+				tasklet_schedule(&t->tasklet);
+		} else {
+			/* OHCI_ISO_RECEIVE or OHCI_ISO_MULTICHANNEL_RECEIVE */
+			if (rx_event & mask)
+				tasklet_schedule(&t->tasklet);
+		}
 	}
 
 	spin_unlock_irqrestore(&ohci->iso_tasklet_list_lock, flags);

commit 35331124d1af257c546fa550dc00e111ed65790a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Dec 16 17:31:26 2007 +0100

    ieee1394: sbp2: raise default transfer size limit
    
    This patch speeds up sbp2 a little bit --- but more importantly, it
    brings the behavior of sbp2 and fw-sbp2 closer to each other.  Like
    fw-sbp2, sbp2 now does not limit the size of single transfers to 255
    sectors anymore, unless told so by a blacklist flag or by module load
    parameters.
    
    Only very old bridge chips have been known to need the 255 sectors
    limit, and we have got one such chip in our hardwired blacklist.  There
    certainly is a danger that more bridges need that limit; but I prefer to
    have this issue present in both fw-sbp2 and sbp2 rather than just one of
    them.
    
    An OXUF922 with 400GB 7200RPM disk on an S400 controller is sped up by
    this patch from 22.9 to 23.5 MB/s according to hdparm.  The same effect
    could be achieved before by setting a higher max_sectors module
    parameter.  On buses which use 1394b beta mode, sbp2 and fw-sbp2 will
    now achieve virtually the same bandwidth.  Fw-sbp2 only remains faster
    on 1394a buses due to fw-core's gap count optimization.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 2a7ceaf..273b6cb 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -51,6 +51,7 @@
  * Grep for inline FIXME comments below.
  */
 
+#include <linux/blkdev.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -127,17 +128,21 @@ MODULE_PARM_DESC(serialize_io, "Serialize requests coming from SCSI drivers "
 		 "(default = Y, faster but buggy = N)");
 
 /*
- * Bump up max_sectors if you'd like to support very large sized
- * transfers. Please note that some older sbp2 bridge chips are broken for
- * transfers greater or equal to 128KB.  Default is a value of 255
- * sectors, or just under 128KB (at 512 byte sector size). I can note that
- * the Oxsemi sbp2 chipsets have no problems supporting very large
- * transfer sizes.
+ * Adjust max_sectors if you'd like to influence how many sectors each SCSI
+ * command can transfer at most. Please note that some older SBP-2 bridge
+ * chips are broken for transfers greater or equal to 128KB, therefore
+ * max_sectors used to be a safe 255 sectors for many years. We now have a
+ * default of 0 here which means that we let the SCSI stack choose a limit.
+ *
+ * The SBP2_WORKAROUND_128K_MAX_TRANS flag, if set either in the workarounds
+ * module parameter or in the sbp2_workarounds_table[], will override the
+ * value of max_sectors. We should use sbp2_workarounds_table[] to cover any
+ * bridge chip which becomes known to need the 255 sectors limit.
  */
-static int sbp2_max_sectors = SBP2_MAX_SECTORS;
+static int sbp2_max_sectors;
 module_param_named(max_sectors, sbp2_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Change max sectors per I/O supported "
-		 "(default = " __stringify(SBP2_MAX_SECTORS) ")");
+		 "(default = 0 = use SCSI stack's default)");
 
 /*
  * Exclusive login to sbp2 device? In most cases, the sbp2 driver should
@@ -1979,6 +1984,8 @@ static int sbp2scsi_slave_configure(struct scsi_device *sdev)
 		sdev->skip_ms_page_8 = 1;
 	if (lu->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
+	if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
+		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 	return 0;
 }
 
@@ -2085,9 +2092,6 @@ static int sbp2_module_init(void)
 		sbp2_shost_template.cmd_per_lun = 1;
 	}
 
-	if (sbp2_default_workarounds & SBP2_WORKAROUND_128K_MAX_TRANS &&
-	    (sbp2_max_sectors * 512) > (128 * 1024))
-		sbp2_max_sectors = 128 * 1024 / 512;
 	sbp2_shost_template.max_sectors = sbp2_max_sectors;
 
 	hpsb_register_highlevel(&sbp2_highlevel);
diff --git a/drivers/ieee1394/sbp2.h b/drivers/ieee1394/sbp2.h
index 333a4bb..d2ecb0d 100644
--- a/drivers/ieee1394/sbp2.h
+++ b/drivers/ieee1394/sbp2.h
@@ -222,7 +222,6 @@ struct sbp2_status_block {
  */
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH		0xf000
-#define SBP2_MAX_SECTORS			255
 /* There is no real limitation of the queue depth (i.e. length of the linked
  * list of command ORBs) at the target. The chosen depth is merely an
  * implementation detail of the sbp2 driver. */

commit c0dc4201c05734c2af8b6667c361ee520290e341
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 15 14:11:41 2007 +0100

    ieee1394: remove unused code
    
    The code has been in "#if 0 - #endif" since Linux 2.6.12.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index 6779893..10c3d9f 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -570,71 +570,3 @@ int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
 
 	return retval;
 }
-
-#if 0
-
-int hpsb_lock(struct hpsb_host *host, nodeid_t node, unsigned int generation,
-	      u64 addr, int extcode, quadlet_t * data, quadlet_t arg)
-{
-	struct hpsb_packet *packet;
-	int retval = 0;
-
-	BUG_ON(in_interrupt());	// We can't be called in an interrupt, yet
-
-	packet = hpsb_make_lockpacket(host, node, addr, extcode, data, arg);
-	if (!packet)
-		return -ENOMEM;
-
-	packet->generation = generation;
-	retval = hpsb_send_packet_and_wait(packet);
-	if (retval < 0)
-		goto hpsb_lock_fail;
-
-	retval = hpsb_packet_success(packet);
-
-	if (retval == 0) {
-		*data = packet->data[0];
-	}
-
-      hpsb_lock_fail:
-	hpsb_free_tlabel(packet);
-	hpsb_free_packet(packet);
-
-	return retval;
-}
-
-int hpsb_send_gasp(struct hpsb_host *host, int channel, unsigned int generation,
-		   quadlet_t * buffer, size_t length, u32 specifier_id,
-		   unsigned int version)
-{
-	struct hpsb_packet *packet;
-	int retval = 0;
-	u16 specifier_id_hi = (specifier_id & 0x00ffff00) >> 8;
-	u8 specifier_id_lo = specifier_id & 0xff;
-
-	HPSB_VERBOSE("Send GASP: channel = %d, length = %Zd", channel, length);
-
-	length += 8;
-
-	packet = hpsb_make_streampacket(host, NULL, length, channel, 3, 0);
-	if (!packet)
-		return -ENOMEM;
-
-	packet->data[0] = cpu_to_be32((host->node_id << 16) | specifier_id_hi);
-	packet->data[1] =
-	    cpu_to_be32((specifier_id_lo << 24) | (version & 0x00ffffff));
-
-	memcpy(&(packet->data[2]), buffer, length - 8);
-
-	packet->generation = generation;
-
-	packet->no_waiter = 1;
-
-	retval = hpsb_send_packet(packet);
-	if (retval < 0)
-		hpsb_free_packet(packet);
-
-	return retval;
-}
-
-#endif				/*  0  */

commit 004a57d0931e171e5f70cd09d06ecbb266a94dd4
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 15 14:04:42 2007 +0100

    ieee1394: small cleanup after "nopage"
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index ec024b5..73685e7 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -231,28 +231,20 @@ void dma_region_sync_for_device(struct dma_region *dma, unsigned long offset,
 
 #ifdef CONFIG_MMU
 
-/* fault() handler for mmap access */
-
 static int dma_region_pagefault(struct vm_area_struct *vma,
-					struct vm_fault *vmf)
+				struct vm_fault *vmf)
 {
-	unsigned long kernel_virt_addr;
-
 	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
 	if (!dma->kvirt)
-		goto error;
+		return VM_FAULT_SIGBUS;
 
 	if (vmf->pgoff >= dma->n_pages)
-		goto error;
+		return VM_FAULT_SIGBUS;
 
-	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
-	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
+	vmf->page = vmalloc_to_page(dma->kvirt + (vmf->pgoff << PAGE_SHIFT));
 	get_page(vmf->page);
 	return 0;
-
-      error:
-	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct dma_region_vm_ops = {

commit d8f26b4379c5801be20ae073ef0ef8d3900a00c3
Author: Nick Piggin <npiggin@suse.de>
Date:   Wed Dec 5 18:15:53 2007 +1100

    ieee1394: nopage
    
    Convert ieee1394 from nopage to fault.
    Remove redundant vma range checks (correct resource range check is retained).
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index 7c4eb39..ec024b5 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -231,37 +231,32 @@ void dma_region_sync_for_device(struct dma_region *dma, unsigned long offset,
 
 #ifdef CONFIG_MMU
 
-/* nopage() handler for mmap access */
+/* fault() handler for mmap access */
 
-static struct page *dma_region_pagefault(struct vm_area_struct *area,
-					 unsigned long address, int *type)
+static int dma_region_pagefault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
-	unsigned long offset;
 	unsigned long kernel_virt_addr;
-	struct page *ret = NOPAGE_SIGBUS;
 
-	struct dma_region *dma = (struct dma_region *)area->vm_private_data;
+	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
 	if (!dma->kvirt)
-		goto out;
-
-	if ((address < (unsigned long)area->vm_start) ||
-	    (address >
-	     (unsigned long)area->vm_start + (dma->n_pages << PAGE_SHIFT)))
-		goto out;
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-	offset = address - area->vm_start;
-	kernel_virt_addr = (unsigned long)dma->kvirt + offset;
-	ret = vmalloc_to_page((void *)kernel_virt_addr);
-	get_page(ret);
-      out:
-	return ret;
+		goto error;
+
+	if (vmf->pgoff >= dma->n_pages)
+		goto error;
+
+	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
+	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
+	get_page(vmf->page);
+	return 0;
+
+      error:
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct dma_region_vm_ops = {
-	.nopage = dma_region_pagefault,
+	.fault = dma_region_pagefault,
 };
 
 /**
@@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *dma, struct file *file,
 	if (!dma->kvirt)
 		return -EINVAL;
 
-	/* must be page-aligned */
+	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
 

commit 09d0fee3e92fcf68335bbd24f9fd27ca299135a3
Author: Joe Perches <joe@perches.com>
Date:   Mon Nov 19 17:48:10 2007 -0800

    ieee1394: Add missing "space"
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index cadf047..37e7e10 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -858,7 +858,7 @@ static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
 	int found = 0, size = 0, rcode = -1;
 	struct arm_request_response *arm_req_resp = NULL;
 
-	DBGMSG("arm_read  called by node: %X"
+	DBGMSG("arm_read  called by node: %X "
 	       "addr: %4.4x %8.8x length: %Zu", nodeid,
 	       (u16) ((addr >> 32) & 0xFFFF), (u32) (addr & 0xFFFFFFFF),
 	       length);
@@ -1012,7 +1012,7 @@ static int arm_write(struct hpsb_host *host, int nodeid, int destid,
 	int found = 0, size = 0, rcode = -1, length_conflict = 0;
 	struct arm_request_response *arm_req_resp = NULL;
 
-	DBGMSG("arm_write called by node: %X"
+	DBGMSG("arm_write called by node: %X "
 	       "addr: %4.4x %8.8x length: %Zu", nodeid,
 	       (u16) ((addr >> 32) & 0xFFFF), (u32) (addr & 0xFFFFFFFF),
 	       length);

commit 9de7e0bcd8d6bf4ccdf1ecfafde5c435bd3f34d6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Nov 4 14:59:24 2007 +0100

    ieee1394: sbp2: s/g list access cosmetics
    
    Replace sg->length by sg_dma_len(sg).  Rename a variable for shorter
    line lengths and eliminate some superfluous local variables.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 08923dc..2a7ceaf 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1451,7 +1451,7 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 				     struct sbp2_fwhost_info *hi,
 				     struct sbp2_command_info *cmd,
 				     unsigned int scsi_use_sg,
-				     struct scatterlist *sgpnt,
+				     struct scatterlist *sg,
 				     u32 orb_direction,
 				     enum dma_data_direction dma_dir)
 {
@@ -1461,12 +1461,12 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 
 	/* special case if only one element (and less than 64KB in size) */
 	if ((scsi_use_sg == 1) &&
-	    (sgpnt[0].length <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
+	    (sg_dma_len(sg) <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
 
-		cmd->dma_size = sgpnt[0].length;
+		cmd->dma_size = sg_dma_len(sg);
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
-					    sg_page(&sgpnt[0]), sgpnt[0].offset,
+					    sg_page(sg), sg->offset,
 					    cmd->dma_size, cmd->dma_dir);
 
 		orb->data_descriptor_lo = cmd->cmd_dma;
@@ -1477,11 +1477,11 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 						&cmd->scatter_gather_element[0];
 		u32 sg_count, sg_len;
 		dma_addr_t sg_addr;
-		int i, count = dma_map_sg(hi->host->device.parent, sgpnt,
+		int i, count = dma_map_sg(hi->host->device.parent, sg,
 					  scsi_use_sg, dma_dir);
 
 		cmd->dma_size = scsi_use_sg;
-		cmd->sge_buffer = sgpnt;
+		cmd->sge_buffer = sg;
 
 		/* use page tables (s/g) */
 		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
@@ -1489,9 +1489,9 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
-			sg_len = sg_dma_len(sgpnt);
-			sg_addr = sg_dma_address(sgpnt);
+		for (i = 0, sg_count = 0; i < count; i++, sg = sg_next(sg)) {
+			sg_len = sg_dma_len(sg);
+			sg_addr = sg_dma_address(sg);
 			while (sg_len) {
 				sg_element[sg_count].segment_base_lo = sg_addr;
 				if (sg_len > SBP2_MAX_SG_ELEMENT_LENGTH) {
@@ -1521,11 +1521,10 @@ static void sbp2_create_command_orb(struct sbp2_lu *lu,
 				    unchar *scsi_cmd,
 				    unsigned int scsi_use_sg,
 				    unsigned int scsi_request_bufflen,
-				    void *scsi_request_buffer,
+				    struct scatterlist *sg,
 				    enum dma_data_direction dma_dir)
 {
 	struct sbp2_fwhost_info *hi = lu->hi;
-	struct scatterlist *sgpnt = (struct scatterlist *)scsi_request_buffer;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
 	u32 orb_direction;
 
@@ -1560,7 +1559,7 @@ static void sbp2_create_command_orb(struct sbp2_lu *lu,
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
 	} else
-		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sgpnt,
+		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sg,
 					 orb_direction, dma_dir);
 
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
@@ -1650,7 +1649,6 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *))
 {
 	unchar *scsi_cmd = (unchar *)SCpnt->cmnd;
-	unsigned int request_bufflen = scsi_bufflen(SCpnt);
 	struct sbp2_command_info *cmd;
 
 	cmd = sbp2util_allocate_command_orb(lu, SCpnt, done);
@@ -1658,7 +1656,7 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
 		return -EIO;
 
 	sbp2_create_command_orb(lu, cmd, scsi_cmd, scsi_sg_count(SCpnt),
-				request_bufflen, scsi_sglist(SCpnt),
+				scsi_bufflen(SCpnt), scsi_sglist(SCpnt),
 				SCpnt->sc_data_direction);
 	sbp2_link_orb_command(lu, cmd);
 

commit 3a498bf2fb8d411e5560b32aec532e74b4987b18
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Jan 15 21:11:28 2008 +0100

    ieee1394: sbp2: prepare for s/g chaining
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index b83d254..08923dc 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1489,7 +1489,7 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0 ; i < count; i++, sgpnt++) {
+		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
 			sg_len = sg_dma_len(sgpnt);
 			sg_addr = sg_dma_address(sgpnt);
 			while (sg_len) {

-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/

