Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbXEPInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbXEPInN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762188AbXEPIeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6620 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762394AbXEPIeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 19/19] drivers: sg chaining support
Date: Wed, 16 May 2007 10:32:33 +0200
Message-Id: <11793043542383-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This converts SCSI/IDE/etc drivers to sg chaining support. The
patches exist as seperate entities in the #sglist branch of the
block git repo, but collated here to avoid a huge thread.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index bb87682..291e7f4 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -173,7 +173,7 @@ simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 			return;
 		}
 		offset +=  sl->length;
-		sl++;
+		sl = sg_next(sl);
 		list_len--;
 	}
 	sc->result = GOOD;
@@ -239,18 +239,23 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
 static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 {
 
-	int scatterlen = sc->use_sg;
-	struct scatterlist *slp;
+	int scatterlen = sc->use_sg, i;
+	struct scatterlist *slp, *sg;
 
 	if (scatterlen == 0)
 		memcpy(sc->request_buffer, buf, len);
-	else for (slp = (struct scatterlist *)sc->request_buffer;
-		  scatterlen-- > 0 && len > 0; slp++) {
-		unsigned thislen = min(len, slp->length);
+	else {
+		slp = sc->request_buffer;
+		for_each_sg(slp, sg, scatterlen, i) {
+			unsigned thislen;
 
-		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
-		slp++;
-		len -= thislen;
+			if (len <= 0)
+				break;
+
+			thislen = min(len, slp->length);
+			memcpy(page_address(sg->page) + sg->offset, buf, thislen);
+			len -= thislen;
+		}
 	}
 }
 
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index ca0341c..3565c76 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -951,7 +951,8 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 		/* group sequential buffers into one large buffer */
 		addr = page_to_phys(sg->page) + sg->offset;
 		size = sg_dma_len(sg);
-		while (sg++, --i) {
+		while (--i) {
+			sg = sg_next(sg);
 			if ((addr + size) != page_to_phys(sg->page) + sg->offset)
 				break;
 			size += sg_dma_len(sg);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index b77b7d1..aa13309 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -292,7 +292,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..412ba5e 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -259,6 +259,7 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *cursg = hwif->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
 	unsigned long flags;
@@ -266,8 +267,14 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	unsigned int offset;
 	u8 *buf;
 
-	page = sg[hwif->cursg].page;
-	offset = sg[hwif->cursg].offset + hwif->cursg_ofs * SECTOR_SIZE;
+	cursg = hwif->cursg;
+	if (!cursg) {
+		cursg = sg;
+		hwif->cursg = sg;
+	}
+
+	page = cursg->page;
+	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -281,8 +288,8 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	hwif->nleft--;
 	hwif->cursg_ofs++;
 
-	if ((hwif->cursg_ofs * SECTOR_SIZE) == sg[hwif->cursg].length) {
-		hwif->cursg++;
+	if ((hwif->cursg_ofs * SECTOR_SIZE) == cursg->length) {
+		hwif->cursg = sg_next(hwif->cursg);
 		hwif->cursg_ofs = 0;
 	}
 
@@ -363,6 +370,8 @@ static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 
 static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
+	HWIF(drive)->cursg = NULL;
+
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = rq->special;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index ca95e99..35b0d1e 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -324,7 +324,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 			cur_addr += tc;
 			cur_len -= tc;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index d3185e2..511e734 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -531,7 +531,7 @@ sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 45fc36f..2a7555d 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1648,7 +1648,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 			cur_len -= tc;
 			++table;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index f87f003..62c87e6 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -96,17 +96,18 @@ static void ipath_dma_unmap_page(struct ib_device *dev,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sg, int nents,
-			enum dma_data_direction direction)
+static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sgl,
+			int nents, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	u64 addr;
 	int i;
 	int ret = nents;
 
 	BUG_ON(!valid_dma_direction(direction));
 
-	for (i = 0; i < nents; i++) {
-		addr = (u64) page_address(sg[i].page);
+	for_each_sg(sgl, sg, nents, i) {
+		addr = (u64) page_address(sg->page);
 		/* TODO: handle highmem pages */
 		if (!addr) {
 			ret = 0;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index fc9f1fd..ff0c701 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -37,7 +37,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include "iscsi_iser.h"
@@ -126,17 +125,19 @@ int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task  *iser_ctask,
 
 	if (cmd_dir == ISER_DIR_OUT) {
 		/* copy the unaligned sg the buffer which is used for RDMA */
-		struct scatterlist *sg = (struct scatterlist *)data->buf;
+		struct scatterlist *sgl = (struct scatterlist *)data->buf;
+		struct scatterlist *sg;
 		int i;
 		char *p, *from;
 
-		for (p = mem, i = 0; i < data->size; i++) {
-			from = kmap_atomic(sg[i].page, KM_USER0);
+		p = mem;
+		for_each_sg(sgl, sg, data->size, i) {
+			from = kmap_atomic(sg->page, KM_USER0);
 			memcpy(p,
-			       from + sg[i].offset,
-			       sg[i].length);
+			       from + sg->offset,
+			       sg->length);
 			kunmap_atomic(from, KM_USER0);
-			p += sg[i].length;
+			p += sg->length;
 		}
 	}
 
@@ -178,7 +179,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 	if (cmd_dir == ISER_DIR_IN) {
 		char *mem;
-		struct scatterlist *sg;
+		struct scatterlist *sgl, *sg;
 		unsigned char *p, *to;
 		unsigned int sg_size;
 		int i;
@@ -186,16 +187,17 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 		/* copy back read RDMA to unaligned sg */
 		mem	= mem_copy->copy_buf;
 
-		sg	= (struct scatterlist *)iser_ctask->data[ISER_DIR_IN].buf;
+		sgl	= (struct scatterlist *)iser_ctask->data[ISER_DIR_IN].buf;
 		sg_size = iser_ctask->data[ISER_DIR_IN].size;
 
-		for (p = mem, i = 0; i < sg_size; i++){
-			to = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
-			memcpy(to + sg[i].offset,
+		p = mem;
+		for_each_sg(sgl, sg, sg_size, i) {
+			to = kmap_atomic(sg->page, KM_SOFTIRQ0);
+			memcpy(to + sg->offset,
 			       p,
-			       sg[i].length);
+			       sg->length);
 			kunmap_atomic(to, KM_SOFTIRQ0);
-			p += sg[i].length;
+			p += sg->length;
 		}
 	}
 
@@ -226,7 +228,8 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 			       struct iser_page_vec *page_vec,
 			       struct ib_device *ibdev)
 {
-	struct scatterlist *sg = (struct scatterlist *)data->buf;
+	struct scatterlist *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sg;
 	u64 first_addr, last_addr, page;
 	int end_aligned;
 	unsigned int cur_page = 0;
@@ -234,14 +237,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 	int i;
 
 	/* compute the offset of first element */
-	page_vec->offset = (u64) sg[0].offset & ~MASK_4K;
+	page_vec->offset = (u64) sgl[0].offset & ~MASK_4K;
 
-	for (i = 0; i < data->dma_nents; i++) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, &sg[i]);
+	for_each_sg(sgl, sg, data->dma_nents, i) {
+		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
 
 		total_sz += dma_len;
 
-		first_addr = ib_sg_dma_address(ibdev, &sg[i]);
+		first_addr = ib_sg_dma_address(ibdev, sg);
 		last_addr  = first_addr + dma_len;
 
 		end_aligned   = !(last_addr  & ~MASK_4K);
@@ -249,9 +252,9 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 		/* continue to collect page fragments till aligned or SG ends */
 		while (!end_aligned && (i + 1 < data->dma_nents)) {
 			i++;
-			dma_len = ib_sg_dma_len(ibdev, &sg[i]);
+			dma_len = ib_sg_dma_len(ibdev, sg);
 			total_sz += dma_len;
-			last_addr = ib_sg_dma_address(ibdev, &sg[i]) + dma_len;
+			last_addr = ib_sg_dma_address(ibdev, sg) + dma_len;
 			end_aligned = !(last_addr  & ~MASK_4K);
 		}
 
@@ -286,25 +289,26 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 					      struct ib_device *ibdev)
 {
-	struct scatterlist *sg;
+	struct scatterlist *sgl, *sg;
 	u64 end_addr, next_addr;
 	int i, cnt;
 	unsigned int ret_len = 0;
 
-	sg = (struct scatterlist *)data->buf;
+	sgl = (struct scatterlist *)data->buf;
 
-	for (cnt = 0, i = 0; i < data->dma_nents; i++, cnt++) {
+	cnt = 0;
+	for_each_sg(sgl, sg, data->dma_nents, i) {
 		/* iser_dbg("Checking sg iobuf [%d]: phys=0x%08lX "
 		   "offset: %ld sz: %ld\n", i,
-		   (unsigned long)page_to_phys(sg[i].page),
-		   (unsigned long)sg[i].offset,
-		   (unsigned long)sg[i].length); */
-		end_addr = ib_sg_dma_address(ibdev, &sg[i]) +
-			   ib_sg_dma_len(ibdev, &sg[i]);
+		   (unsigned long)page_to_phys(sg->page),
+		   (unsigned long)sg->offset,
+		   (unsigned long)sg->length); */
+		end_addr = ib_sg_dma_address(ibdev, sg) +
+			   ib_sg_dma_len(ibdev, sg);
 		/* iser_dbg("Checking sg iobuf end address "
 		       "0x%08lX\n", end_addr); */
 		if (i + 1 < data->dma_nents) {
-			next_addr = ib_sg_dma_address(ibdev, &sg[i+1]);
+			next_addr = ib_sg_dma_address(ibdev, sg_next(sg));
 			/* are i, i+1 fragments of the same page? */
 			if (end_addr == next_addr)
 				continue;
@@ -324,15 +328,16 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 static void iser_data_buf_dump(struct iser_data_buf *data,
 			       struct ib_device *ibdev)
 {
-	struct scatterlist *sg = (struct scatterlist *)data->buf;
+	struct scatterlist *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < data->dma_nents; i++)
+	for_each_sg(sgl, sg, data->dma_nents, i)
 		iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
-			 i, (unsigned long)ib_sg_dma_address(ibdev, &sg[i]),
-			 sg[i].page, sg[i].offset,
-			 sg[i].length, ib_sg_dma_len(ibdev, &sg[i]));
+			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
+			 sg->page, sg->offset,
+			 sg->length, ib_sg_dma_len(ibdev, sg));
 }
 
 static void iser_dump_page_vec(struct iser_page_vec *page_vec)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 39bf057..c31d50d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -595,6 +595,7 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 	int ret;
 	struct srp_device *dev = target->srp_host->dev;
 	struct ib_device *ibdev = dev->dev;
+	struct scatterlist *sg;
 
 	if (!dev->fmr_pool)
 		return -ENODEV;
@@ -604,16 +605,16 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 		return -EINVAL;
 
 	len = page_cnt = 0;
-	for (i = 0; i < sg_cnt; ++i) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, &scat[i]);
+	for_each_sg(scat, sg, sg_cnt, i) {
+		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
 
-		if (ib_sg_dma_address(ibdev, &scat[i]) & ~dev->fmr_page_mask) {
+		if (ib_sg_dma_address(ibdev, sg) & ~dev->fmr_page_mask) {
 			if (i > 0)
 				return -EINVAL;
 			else
 				++page_cnt;
 		}
-		if ((ib_sg_dma_address(ibdev, &scat[i]) + dma_len) &
+		if ((ib_sg_dma_address(ibdev, sg) + dma_len) &
 		    ~dev->fmr_page_mask) {
 			if (i < sg_cnt - 1)
 				return -EINVAL;
@@ -633,12 +634,12 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 		return -ENOMEM;
 
 	page_cnt = 0;
-	for (i = 0; i < sg_cnt; ++i) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, &scat[i]);
+	for_each_sg(scat, sg, sg_cnt, i) {
+		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
 
 		for (j = 0; j < dma_len; j += dev->fmr_page_size)
 			dma_pages[page_cnt++] =
-				(ib_sg_dma_address(ibdev, &scat[i]) &
+				(ib_sg_dma_address(ibdev, sg) &
 				 dev->fmr_page_mask) + j;
 	}
 
@@ -724,6 +725,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		 * descriptor.
 		 */
 		struct srp_indirect_buf *buf = (void *) cmd->add_data;
+		struct scatterlist *sg;
 		u32 datalen = 0;
 		int i;
 
@@ -732,11 +734,11 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 			sizeof (struct srp_indirect_buf) +
 			count * sizeof (struct srp_direct_buf);
 
-		for (i = 0; i < count; ++i) {
-			unsigned int dma_len = ib_sg_dma_len(ibdev, &scat[i]);
+		for_each_sg(scat, sg, count, i) {
+			unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
 
 			buf->desc_list[i].va  =
-				cpu_to_be64(ib_sg_dma_address(ibdev, &scat[i]));
+				cpu_to_be64(ib_sg_dma_address(ibdev, sg));
 			buf->desc_list[i].key =
 				cpu_to_be32(dev->mr->rkey);
 			buf->desc_list[i].len = cpu_to_be32(dma_len);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index fa0f776..8844167 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -315,7 +315,7 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
 
-		sg++;		/* Get next SG element from the OS */
+		sg = sg_next(sg);	/* Get next SG element from the OS */
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
 		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
 		sg_done++;
@@ -336,7 +336,7 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
 		/*
-		sg++;
+		sg = sg_next(sg);
 		psge += (sizeof(u32) + sizeof(dma_addr_t));
 		*/
 		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index eb766c3..293cfd2 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1815,7 +1815,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	u32 num_sectors = 0x0;
 	int i, sg_count;
 	struct scsi_cmnd *srb = NULL;
-	struct scatterlist *sglist = NULL;
+	struct scatterlist *sglist = NULL, *sg;
 	dma_addr_t buffaddr = 0x0;
 	int retval = 1;
 
@@ -1893,9 +1893,9 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 				if (sg_count == 0)
 					goto out;
 
-				for (i = 0; i < sg_count; i++) {
-					command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(&sglist[i]));
-					command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(&sglist[i]));
+				for_each_sg(sglist, sg, sg_count, i) {
+					command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(sg));
+					command_packet->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
 					if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2e, "Found unaligned sgl address during execute scsi");
 						goto out;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 656bdb1..3d005cf 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1767,7 +1767,7 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 	u32 lba = 0x0, num_sectors = 0x0, buffaddr = 0x0;
 	int i, use_sg;
 	struct scsi_cmnd *srb;
-	struct scatterlist *sglist;
+	struct scatterlist *sglist, *sg;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_write()\n");
 
@@ -1837,9 +1837,9 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 		if (use_sg == 0)
 			return 1;
 
-		for (i=0;i<use_sg; i++) {
-			command_packet->byte8.io.sgl[i].address = sg_dma_address(&sglist[i]);
-			command_packet->byte8.io.sgl[i].length = sg_dma_len(&sglist[i]);
+		for_each_sg(sglist, sg, use_sg, i) {
+			command_packet->byte8.io.sgl[i].address = sg_dma_address(sg);
+			command_packet->byte8.io.sgl[i].length = sg_dma_len(sg);
 			command_packet->size+=2;
 		}
 	}
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index cb02656..821163d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1887,6 +1887,7 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 		int i;
 		int sg_count;
 		dma_addr_t vPtr = 0;
+		struct scatterlist *sgl, *sg;
 		__u32 count = 0;
 
 		if(SCp->use_sg) {
@@ -1902,15 +1903,12 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 			slot->dma_handle = vPtr;
 			sg_count = 1;
 		}
-			
-
-		for(i = 0; i < sg_count; i++) {
-
-			if(SCp->use_sg) {
-				struct scatterlist *sg = SCp->request_buffer;
-
-				vPtr = sg_dma_address(&sg[i]);
-				count = sg_dma_len(&sg[i]);
+	
+		sgl = SCp->request_buffer;
+		for_each_sg(sgl, sg, sg_count, i) {
+			if (SCp->use_sg) {
+				vPtr = sg_dma_address(sg);
+				count = sg_dma_len(sg);
 			}
 
 			slot->SG[i].ins = bS_to_host(move_ins | count);
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 96f4cab..7fd1cca 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2862,6 +2862,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 				Command->sc_data_direction);
 	} else if (SegmentCount != 0) {
 		struct scatterlist *ScatterList = (struct scatterlist *) BufferPointer;
+		struct scatterlist *sg;
 		int Segment, Count;
 
 		Count = pci_map_sg(HostAdapter->PCI_Device, ScatterList, SegmentCount,
@@ -2872,9 +2873,9 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 			CCB->DataPointer = (unsigned int) CCB->DMA_Handle + ((unsigned long) &CCB->ScatterGatherList - (unsigned long) CCB);
 		else
 			CCB->DataPointer = Virtual_to_32Bit_Virtual(CCB->ScatterGatherList);
-		for (Segment = 0; Segment < Count; Segment++) {
-			CCB->ScatterGatherList[Segment].SegmentByteCount = sg_dma_len(ScatterList + Segment);
-			CCB->ScatterGatherList[Segment].SegmentDataPointer = sg_dma_address(ScatterList + Segment);
+		for_each_sg(ScatterList, sg, Count, Segment) {
+			CCB->ScatterGatherList[Segment].SegmentByteCount = sg_dma_len(sg);
+			CCB->ScatterGatherList[Segment].SegmentDataPointer = sg_dma_address(sg);
 		}
 	} else {
 		CCB->Opcode = BusLogic_InitiatorCCB;
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 7c0b17f..9402dd9 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -875,12 +875,13 @@ static void NCR53c406a_intr(void *dev_id)
 			if (!current_SC->use_sg)	/* Don't use scatter-gather */
 				NCR53c406a_pio_write(current_SC->request_buffer, current_SC->request_bufflen);
 			else {	/* use scatter-gather */
+				struct scatterlist *sg;
+				int i;
+				
 				sgcount = current_SC->use_sg;
 				sglist = current_SC->request_buffer;
-				while (sgcount--) {
-					NCR53c406a_pio_write(page_address(sglist->page) + sglist->offset, sglist->length);
-					sglist++;
-				}
+				for_each_sg(sglist, sg, sgcount, i)
+					NCR53c406a_pio_write(page_address(sg->page) + sg->offset, sg->length);
 			}
 			REG0;
 #endif				/* USE_PIO */
@@ -902,12 +903,13 @@ static void NCR53c406a_intr(void *dev_id)
 			if (!current_SC->use_sg)	/* Don't use scatter-gather */
 				NCR53c406a_pio_read(current_SC->request_buffer, current_SC->request_bufflen);
 			else {	/* Use scatter-gather */
+				struct scatterlist *sg;
+				int i;
+
 				sgcount = current_SC->use_sg;
 				sglist = current_SC->request_buffer;
-				while (sgcount--) {
-					NCR53c406a_pio_read(page_address(sglist->page) + sglist->offset, sglist->length);
-					sglist++;
-				}
+				for_each_sg(sglist, sg, sgcount, i)
+					NCR53c406a_pio_read(page_address(sg->page) + sg->offset, sg->length);
 			}
 			REG0;
 #endif				/* USE_PIO */
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 7f4241b..1353900 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -796,7 +796,7 @@ static void orc_interrupt(
 *****************************************************************************/
 static void inia100BuildSCB(ORC_HCS * pHCB, ORC_SCB * pSCB, struct scsi_cmnd * SCpnt)
 {				/* Create corresponding SCB     */
-	struct scatterlist *pSrbSG;
+	struct scatterlist *pSrbSG, *sg;
 	ORC_SG *pSG;		/* Pointer to SG list           */
 	int i, count_sg;
 	ESCB *pEScb;
@@ -820,9 +820,10 @@ static void inia100BuildSCB(ORC_HCS * pHCB, ORC_SCB * pSCB, struct scsi_cmnd * S
 			count_sg = pci_map_sg(pHCB->pdev, pSrbSG, SCpnt->use_sg,
 					SCpnt->sc_data_direction);
 			pSCB->SCB_SGLen = (U32) (count_sg * 8);
-			for (i = 0; i < count_sg; i++, pSG++, pSrbSG++) {
-				pSG->SG_Ptr = (U32) sg_dma_address(pSrbSG);
-				pSG->SG_Len = (U32) sg_dma_len(pSrbSG);
+			for_each_sg(pSrbSG, sg, count_sg, i) {
+				pSG->SG_Ptr = (U32) sg_dma_address(sg);
+				pSG->SG_Len = (U32) sg_dma_len(sg);
+				pSG++;
 			}
 		} else if (SCpnt->request_bufflen != 0) {/* Non SG */
 			pSCB->SCB_SGLen = 0x8;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 1e82c69..7fcac4e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2347,7 +2347,7 @@ static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
 	psg->sg[0].addr = 0;
 	psg->sg[0].count = 0;  
 	if (scsicmd->use_sg) {
-		struct scatterlist *sg;
+		struct scatterlist *sg, *s;
 		int i;
 		int sg_count;
 		sg = (struct scatterlist *) scsicmd->request_buffer;
@@ -2356,11 +2356,10 @@ static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
 			scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(sg_count);
 
-		for (i = 0; i < sg_count; i++) {
-			psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
-			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
-			byte_count += sg_dma_len(sg);
-			sg++;
+		for_each_sg(sg, s, sg_count, i) {
+			psg->sg[i].addr = cpu_to_le32(sg_dma_address(s));
+			psg->sg[i].count = cpu_to_le32(sg_dma_len(s));
+			byte_count += sg_dma_len(s);
 		}
 		/* hba wants the size to be exact */
 		if(byte_count > scsicmd->request_bufflen){
@@ -2404,7 +2403,7 @@ static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* p
 	psg->sg[0].addr[1] = 0;
 	psg->sg[0].count = 0;
 	if (scsicmd->use_sg) {
-		struct scatterlist *sg;
+		struct scatterlist *sg, *s;
 		int i;
 		int sg_count;
 		sg = (struct scatterlist *) scsicmd->request_buffer;
@@ -2412,14 +2411,13 @@ static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* p
 		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 
-		for (i = 0; i < sg_count; i++) {
-			int count = sg_dma_len(sg);
-			addr = sg_dma_address(sg);
+		for_each_sg(sg, s, sg_count, i) {
+			int count = sg_dma_len(s);
+			addr = sg_dma_address(s);
 			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 			psg->sg[i].count = cpu_to_le32(count);
 			byte_count += count;
-			sg++;
 		}
 		psg->count = cpu_to_le32(sg_count);
 		/* hba wants the size to be exact */
@@ -2465,7 +2463,7 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
 	psg->sg[0].count = 0;
 	psg->sg[0].flags = 0;
 	if (scsicmd->use_sg) {
-		struct scatterlist *sg;
+		struct scatterlist *sg, *s;
 		int i;
 		int sg_count;
 		sg = (struct scatterlist *) scsicmd->request_buffer;
@@ -2473,9 +2471,9 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
 		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 
-		for (i = 0; i < sg_count; i++) {
-			int count = sg_dma_len(sg);
-			u64 addr = sg_dma_address(sg);
+		for_each_sg(sg, s, sg_count, i) {
+			int count = sg_dma_len(s);
+			u64 addr = sg_dma_address(s);
 			psg->sg[i].next = 0;
 			psg->sg[i].prev = 0;
 			psg->sg[i].addr[1] = cpu_to_le32((u32)(addr>>32));
@@ -2483,7 +2481,6 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
 			psg->sg[i].count = cpu_to_le32(count);
 			psg->sg[i].flags = 0;
 			byte_count += count;
-			sg++;
 		}
 		psg->count = cpu_to_le32(sg_count);
 		/* hba wants the size to be exact */
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9b3303b..06bf40c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6468,7 +6468,7 @@ asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
          */
         int                     sgcnt;
 	int			use_sg;
-        struct scatterlist      *slp;
+        struct scatterlist      *slp, *sg;
 
 	slp = (struct scatterlist *)scp->request_buffer;
 	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
@@ -6502,10 +6502,10 @@ asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
         /*
          * Convert scatter-gather list into ASC_SG_HEAD list.
          */
-	for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
-	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(slp));
-	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(slp));
-	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
+	for_each_sg(slp, sg, use_sg, sgcnt) {
+	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(sg));
+	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(sg));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(sg), 512));
         }
     }
 
@@ -6700,7 +6700,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
 {
     adv_sgblk_t         *sgblkp;
     ADV_SCSI_REQ_Q      *scsiqp;
-    struct scatterlist  *slp;
+    struct scatterlist  *slp, *sg;
     int                 sg_elem_cnt;
     ADV_SG_BLOCK        *sg_block, *prev_sg_block;
     ADV_PADDR           sg_block_paddr;
@@ -6778,11 +6778,11 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
             }
         }
 
-        for (i = 0; i < NO_OF_SG_PER_BLOCK; i++)
+	for_each_sg(slp, sg, NO_OF_SG_PER_BLOCK, i)
         {
-	    sg_block->sg_list[i].sg_addr = cpu_to_le32(sg_dma_address(slp));
-	    sg_block->sg_list[i].sg_count = cpu_to_le32(sg_dma_len(slp));
-	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
+	    sg_block->sg_list[i].sg_addr = cpu_to_le32(sg_dma_address(sg));
+	    sg_block->sg_list[i].sg_count = cpu_to_le32(sg_dma_len(sg));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(sg), 512));
 
             if (--sg_elem_cnt == 0)
             {   /* Last ADV_SG_BLOCK and scatter-gather entry. */
@@ -6790,7 +6790,6 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
                 sg_block->sg_ptr = 0L;    /* Last ADV_SG_BLOCK in list. */
                 return ADV_SUCCESS;
             }
-            slp++;
         }
         sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
         prev_sg_block = sg_block;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index cbbfbc9..0a4d34b 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -691,7 +691,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	memcpy(ccb[mbo].cdb, cmd, ccb[mbo].cdblen);
 
 	if (SCpnt->use_sg) {
-		struct scatterlist *sgpnt;
+		struct scatterlist *sgpnt, *sg;
 		struct chain *cptr;
 #ifdef DEBUG
 		unsigned char *ptr;
@@ -706,16 +706,15 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-		for (i = 0; i < SCpnt->use_sg; i++) {
-			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||
-			    (((int) sgpnt[i].offset) & 1) || (sgpnt[i].length & 1)) {
+		for_each_sg(sgpnt, sg, SCpnt->use_sg, i) {
+			if (sg->length == 0 || SCpnt->use_sg > 16 ||
+			    (((int) sg->offset) & 1) || (sg->length & 1)) {
 				unsigned char *ptr;
 				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
-				for (i = 0; i < SCpnt->use_sg; i++) {
+				for_each_sg(sgpnt, sg, SCpnt->use_sg, i) {
 					printk(KERN_CRIT "%d: %p %d\n", i,
-					       (page_address(sgpnt[i].page) +
-						sgpnt[i].offset),
-					       sgpnt[i].length);
+					       (page_address(sg->page) +
+						sg->offset), sg->length);
 				};
 				printk(KERN_CRIT "cptr %x: ", (unsigned int) cptr);
 				ptr = (unsigned char *) &cptr[i];
@@ -723,10 +722,10 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 					printk("%02x ", ptr[i]);
 				panic("Foooooooood fight!");
 			};
-			any2scsi(cptr[i].dataptr, SCSI_SG_PA(&sgpnt[i]));
-			if (SCSI_SG_PA(&sgpnt[i]) + sgpnt[i].length - 1 > ISA_DMA_THRESHOLD)
+			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
+			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
 				BAD_SG_DMA(SCpnt, sgpnt, SCpnt->use_sg, i);
-			any2scsi(cptr[i].datalen, sgpnt[i].length);
+			any2scsi(cptr[i].datalen, sg->length);
 		};
 		any2scsi(ccb[mbo].datalen, SCpnt->use_sg * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(cptr));
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index d7af9c6..2641c24 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -425,7 +425,7 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 	sgptr->sg_dma_addr = sg_dma;
     
 	if (SCpnt->use_sg) {
-		struct scatterlist * sgpnt;
+		struct scatterlist * sgpnt, * sg;
 		struct aha1740_chain * cptr;
 		int i, count;
 		DEB(unsigned char * ptr);
@@ -436,9 +436,9 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 		cptr = sgptr->sg_chain;
 		count = dma_map_sg (&host->edev->dev, sgpnt, SCpnt->use_sg,
 				    SCpnt->sc_data_direction);
-		for(i=0; i < count; i++) {
-			cptr[i].datalen = sg_dma_len (sgpnt + i);
-			cptr[i].dataptr = sg_dma_address (sgpnt + i);
+		for_each_sg(sgpnt, sg, count, i) {
+			cptr[i].datalen = sg_dma_len (sg);
+			cptr[i].dataptr = sg_dma_address (sg);
 		}
 		host->ecb[ecbno].datalen = count*sizeof(struct aha1740_chain);
 		host->ecb[ecbno].dataptr = sg_dma;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 6054881..e7ab15b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1505,7 +1505,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 		nseg = pci_map_sg(ahd->dev_softc, cur_seg,
 				  cmd->use_sg, dir);
 		scb->platform_data->xfer_len = 0;
-		for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
+		for (sg = scb->sg_list; nseg > 0; nseg--) {
 			dma_addr_t addr;
 			bus_size_t len;
 
@@ -1514,6 +1514,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 			scb->platform_data->xfer_len += len;
 			sg = ahd_sg_setup(ahd, scb, sg, addr, len,
 					  /*last*/nseg == 1);
+			cur_seg = sg_next(cur_seg);
 		}
 	} else if (cmd->request_bufflen != 0) {
 		void *sg;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 660f26e..bf85297 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1475,20 +1475,19 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	if (cmd->use_sg != 0) {
 		struct	ahc_dma_seg *sg;
 		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
-		int	nseg;
+		struct	scatterlist *sgl;
+		int	nseg, i;
 
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
+		sgl = (struct scatterlist *)cmd->request_buffer;
+		nseg = pci_map_sg(ahc->dev_softc, sgl, cmd->use_sg,
 				  cmd->sc_data_direction);
-		end_seg = cur_seg + nseg;
 		/* Copy the segments into the SG list. */
 		sg = scb->sg_list;
 		/*
 		 * The sg_count may be larger than nseg if
 		 * a transfer crosses a 32bit page.
 		 */ 
-		while (cur_seg < end_seg) {
+		for_each_sg(sgl, cur_seg, nseg, i) {
 			dma_addr_t addr;
 			bus_size_t len;
 			int consumed;
@@ -1499,7 +1498,6 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 						     sg, addr, len);
 			sg += consumed;
 			scb->sg_count += consumed;
-			cur_seg++;
 		}
 		sg--;
 		sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index e2ad5be..1327281 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -89,7 +89,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 			res = -ENOMEM;
 			goto err_unmap;
 		}
-		for (sc = task->scatter, i = 0; i < num_sg; i++, sc++) {
+		for_each_sg(task->scatter, sc, num_sg, i) {
 			struct sg_el *sg =
 				&((struct sg_el *)ascb->sg_arr->vaddr)[i];
 			sg->bus_addr = cpu_to_le64((u64)sg_dma_address(sc));
@@ -98,7 +98,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 				sg->flags |= ASD_SG_EL_LIST_EOL;
 		}
 
-		for (sc = task->scatter, i = 0; i < 2; i++, sc++) {
+		for_each_sg(task->scatter, sc, 2, i) {
 			sg_arr[i].bus_addr =
 				cpu_to_le64((u64)sg_dma_address(sc));
 			sg_arr[i].size = cpu_to_le32((u32)sg_dma_len(sc));
@@ -110,7 +110,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 		sg_arr[2].bus_addr=cpu_to_le64((u64)ascb->sg_arr->dma_handle);
 	} else {
 		int i;
-		for (sc = task->scatter, i = 0; i < num_sg; i++, sc++) {
+		for_each_sg(task->scatter, sc, num_sg, i) {
 			sg_arr[i].bus_addr =
 				cpu_to_le64((u64)sg_dma_address(sc));
 			sg_arr[i].size = cpu_to_le32((u32)sg_dma_len(sc));
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8b46158..c2e2e95 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -563,18 +563,18 @@ static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 	if (pcmd->use_sg) {
 		int length, sgcount, i, cdb_sgcount = 0;
-		struct scatterlist *sl;
+		struct scatterlist *sl, *sg;
 
 		/* Get Scatter Gather List from scsiport. */
 		sl = (struct scatterlist *) pcmd->request_buffer;
 		sgcount = pci_map_sg(acb->pdev, sl, pcmd->use_sg,
 				pcmd->sc_data_direction);
 		/* map stor port SG list to our iop SG List. */
-		for (i = 0; i < sgcount; i++) {
+		for_each_sg(sl, sg, sgcount, i) {
 			/* Get the physical address of the current data pointer */
-			length = cpu_to_le32(sg_dma_len(sl));
-			address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sl)));
-			address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sl)));
+			length = cpu_to_le32(sg_dma_len(sg));
+			address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
+			address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
 			if (address_hi == 0) {
 				struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
 
@@ -591,7 +591,6 @@ static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
 				psge += sizeof (struct SG64ENTRY);
 				arccdbsize += sizeof (struct SG64ENTRY);
 			}
-			sl++;
 			cdb_sgcount++;
 		}
 		arcmsr_cdb->sgcount = (uint8_t)cdb_sgcount;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 564ea90..4e0f073 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1010,6 +1010,7 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 		u32 reqlen = cmd->request_bufflen;
 		struct scatterlist *sl = (struct scatterlist *)
 					 cmd->request_buffer;
+		struct scatterlist *sg;
 		struct SGentry *sgp = srb->segment_x;
 		srb->sg_count = pci_map_sg(dcb->acb->dev, sl, cmd->use_sg,
 					   dir);
@@ -1018,9 +1019,9 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		for (i = 0; i < srb->sg_count; i++) {
-			u32 busaddr = (u32)sg_dma_address(&sl[i]);
-			u32 seglen = (u32)sl[i].length;
+		for_each_sg(sl, sg, srb->sg_count, i) {
+			u32 busaddr = (u32)sg_dma_address(sg);
+			u32 seglen = (u32)sg->length;
 			sgp[i].address = busaddr;
 			sgp[i].length = seglen;
 			srb->total_xfer_length += seglen;
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8c7d2bb..b63d4b2 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2141,20 +2141,21 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 	reqlen = 14;		// SINGLE SGE
 	/* Now fill in the SGList and command */
 	if(cmd->use_sg) {
-		struct scatterlist *sg = (struct scatterlist *)cmd->request_buffer;
-		int sg_count = pci_map_sg(pHba->pDev, sg, cmd->use_sg,
+		struct scatterlist *sgl = (struct scatterlist *)cmd->request_buffer;
+		struct scatterlist *sg;
+		int sg_count = pci_map_sg(pHba->pDev, sgl, cmd->use_sg,
 				cmd->sc_data_direction);
 
 
 		len = 0;
-		for(i = 0 ; i < sg_count; i++) {
+		for_each_sg(sgl, sg, sg_count, i) {
 			*mptr++ = direction|0x10000000|sg_dma_len(sg);
 			len+=sg_dma_len(sg);
 			*mptr++ = sg_dma_address(sg);
-			sg++;
+			/* Make this an end of list */
+			if (i == sg_count - 1)
+				mptr[-2] = direction|0xD0000000|sg_dma_len(sg);
 		}
-		/* Make this an end of list */
-		mptr[-2] = direction|0xD0000000|sg_dma_len(sg-1);
 		reqlen = mptr - msg;
 		*lenptr = len;
 		
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 2d38025..9526fa9 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1610,7 +1610,7 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 static void map_dma(unsigned int i, struct hostdata *ha)
 {
 	unsigned int k, count, pci_dir;
-	struct scatterlist *sgpnt;
+	struct scatterlist *sgpnt, *sg;
 	struct mscp *cpp;
 	struct scsi_cmnd *SCpnt;
 
@@ -1646,9 +1646,9 @@ static void map_dma(unsigned int i, struct hostdata *ha)
 	sgpnt = (struct scatterlist *)SCpnt->request_buffer;
 	count = pci_map_sg(ha->pdev, sgpnt, SCpnt->use_sg, pci_dir);
 
-	for (k = 0; k < count; k++) {
-		cpp->sglist[k].address = H2DEV(sg_dma_address(&sgpnt[k]));
-		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(&sgpnt[k]));
+	for_each_sg(sgpnt, sg, count, k) {
+		cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
+		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
 	}
 
 	cpp->sg = 1;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index ec71061..4c29d29 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -325,6 +325,7 @@ static void esp_map_dma(struct esp *esp, struct scsi_cmnd *cmd)
 {
 	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
 	struct scatterlist *sg = cmd->request_buffer;
+	struct scatterlist *s;
 	int dir = cmd->sc_data_direction;
 	int total, i;
 
@@ -339,8 +340,8 @@ static void esp_map_dma(struct esp *esp, struct scsi_cmnd *cmd)
 	spriv->cur_sg = sg;
 
 	total = 0;
-	for (i = 0; i < spriv->u.num_sg; i++)
-		total += sg_dma_len(&sg[i]);
+	for_each_sg(sg, s, spriv->u.num_sg, i)
+		total += sg_dma_len(s);
 	spriv->tot_residue = total;
 }
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 60446b8..3efc084 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2656,7 +2656,7 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
 {
     ushort cpcount,i;
     ushort cpsum,cpnow;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     gdth_ha_str *ha;
     char *address;
 
@@ -2665,29 +2665,30 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
 
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
-        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
+	cpsum = 0;
+	for_each_sg(sl, sg, scp->use_sg, i) {
             unsigned long flags;
-            cpnow = (ushort)sl->length;
+            cpnow = (ushort)sg->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow,cpsum,cpcount,(ushort)scp->bufflen));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
-            if (!sl->page) {
+            if (!sg->page) {
                 printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
                        hanum);
                 return;
             }
             local_irq_save(flags);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
             memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
+            flush_dcache_page(sg->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
 #else
-            address = kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
+            address = kmap_atomic(sg->page, KM_BH_IRQ) + sg->offset;
             memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
+            flush_dcache_page(sg->page);
             kunmap_atomic(address, KM_BH_IRQ);
 #endif
             local_irq_restore(flags);
@@ -2807,7 +2808,7 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
 {
     register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     ulong32 cnt, blockcnt;
     ulong64 no, blockno;
     dma_addr_t phys_addr;
@@ -2913,25 +2914,25 @@ static int gdth_fill_cache_cmd(int hanum,Scsi_Cmnd *scp,ushort hdrive)
             if (mode64) {
                 cmdp->u.cache64.DestAddr= (ulong64)-1;
                 cmdp->u.cache64.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.cache64.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.cache64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
 #endif
-                    cmdp->u.cache64.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.cache64.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             } else {
                 cmdp->u.cache.DestAddr= 0xffffffff;
                 cmdp->u.cache.sg_canz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.cache.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.cache.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
 #endif
-                    cmdp->u.cache.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.cache.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             }
 
@@ -3017,7 +3018,7 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
 {
     register gdth_ha_str *ha;
     register gdth_cmd_str *cmdp;
-    struct scatterlist *sl;
+    struct scatterlist *sl, *sg;
     ushort i;
     dma_addr_t phys_addr, sense_paddr;
     int cmd_index, sgcnt, mode64;
@@ -3120,25 +3121,25 @@ static int gdth_fill_raw_cmd(int hanum,Scsi_Cmnd *scp,unchar b)
             if (mode64) {
                 cmdp->u.raw64.sdata = (ulong64)-1;
                 cmdp->u.raw64.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.raw64.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     if (cmdp->u.raw64.sg_lst[i].sg_ptr > (ulong64)0xffffffff)
                         ha->dma64_cnt++;
                     else
                         ha->dma32_cnt++;
 #endif
-                    cmdp->u.raw64.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.raw64.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             } else {
                 cmdp->u.raw.sdata = 0xffffffff;
                 cmdp->u.raw.sg_ranz = sgcnt;
-                for (i=0; i<sgcnt; ++i,++sl) {
-                    cmdp->u.raw.sg_lst[i].sg_ptr = sg_dma_address(sl);
+		for_each_sg(sl, sg, sgcnt, i) {
+                    cmdp->u.raw.sg_lst[i].sg_ptr = sg_dma_address(sg);
 #ifdef GDTH_DMA_STATISTICS
                     ha->dma32_cnt++;
 #endif
-                    cmdp->u.raw.sg_lst[i].sg_len = sg_dma_len(sl);
+                    cmdp->u.raw.sg_lst[i].sg_len = sg_dma_len(sg);
                 }
             }
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index bec83cb..5b1c210 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -449,6 +449,7 @@ static int hptiop_buildsgl(struct scsi_cmnd *scp, struct hpt_iopsg *psg)
 	struct Scsi_Host *host = scp->device->host;
 	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
 	struct scatterlist *sglist = (struct scatterlist *)scp->request_buffer;
+	struct scatterlist *sg;
 
 	/*
 	 * though we'll not get non-use_sg fields anymore,
@@ -463,10 +464,9 @@ static int hptiop_buildsgl(struct scsi_cmnd *scp, struct hpt_iopsg *psg)
 		HPT_SCP(scp)->mapped = 1;
 		BUG_ON(HPT_SCP(scp)->sgcnt > hba->max_sg_descriptors);
 
-		for (idx = 0; idx < HPT_SCP(scp)->sgcnt; idx++) {
-			psg[idx].pci_address =
-				cpu_to_le64(sg_dma_address(&sglist[idx]));
-			psg[idx].size = cpu_to_le32(sg_dma_len(&sglist[idx]));
+		for_each_sg(sglist, sg, HPT_SCP(scp)->sgcnt, idx) {
+			psg[idx].pci_address = cpu_to_le64(sg_dma_address(sg));
+			psg[idx].size = cpu_to_le32(sg_dma_len(sg));
 			psg[idx].eot = (idx == HPT_SCP(scp)->sgcnt - 1) ?
 				cpu_to_le32(1) : 0;
 		}
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 0e57fb6..f6c2581 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1808,7 +1808,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	int host_index;
 	int max_pun;
 	int i;
-	struct scatterlist *sl;
+	struct scatterlist *sl, *sg;
 
 	shpnt = cmd->device->host;
 	/* search for the right hostadapter */
@@ -1938,13 +1938,12 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	scsi_cmd = cmd->cmnd[0];
 
 	if (cmd->use_sg) {
-		i = cmd->use_sg;
 		sl = (struct scatterlist *) (cmd->request_buffer);
-		if (i > 16)
+		if (cmd->use_sg > 16)
 			panic("IBM MCA SCSI: scatter-gather list too long.\n");
-		while (--i >= 0) {
-			ld(host_index)[ldn].sge[i].address = (void *) (isa_page_to_bus(sl[i].page) + sl[i].offset);
-			ld(host_index)[ldn].sge[i].byte_length = sl[i].length;
+		for_each_sg(sl, sg, cmd->use_sg, i) {
+			ld(host_index)[ldn].sge[i].address = (void *) (isa_page_to_bus(sg->page) + sg->offset);
+			ld(host_index)[ldn].sge[i].byte_length = sg->length;
 		}
 		scb->enable |= IM_POINTER_TO_LIST;
 		scb->sys_buf_adr = isa_virt_to_bus(&(ld(host_index)[ldn].sge[0]));
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b10eefe..943a01e 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -359,10 +359,10 @@ static int map_sg_list(int num_entries,
 {
 	int i;
 	u64 total_length = 0;
+	struct scatterlist *sg_entry;
 
-	for (i = 0; i < num_entries; ++i) {
+	for_each_sg(sg, sg_entry, num_entries, i) {
 		struct srp_direct_buf *descr = md + i;
-		struct scatterlist *sg_entry = &sg[i];
 		descr->va = sg_dma_address(sg_entry);
 		descr->len = sg_dma_len(sg_entry);
 		descr->key = 0;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 8263f75..9101928 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -70,6 +70,7 @@ typedef struct idescsi_pc_s {
 	u8 *buffer;				/* Data buffer */
 	u8 *current_position;			/* Pointer into the above buffer */
 	struct scatterlist *sg;			/* Scatter gather table */
+	struct scatterlist *last_sg;		/* Last sg element */
 	int b_count;				/* Bytes transferred from current entry */
 	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
 	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
@@ -175,11 +176,6 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-			idescsi_discard_data (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -198,10 +194,17 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			pc->sg++;
+			if (pc->sg == pc->last_sg)
+				break;
+			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
 		}
 	}
+
+	if (bcount) {
+		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
+		idescsi_discard_data (drive, bcount);
+	}
 }
 
 static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
@@ -210,11 +213,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-			idescsi_output_zeros (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -233,10 +231,17 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			pc->sg++;
+			if (pc->sg == pc->last_sg)
+				break;
+			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
 		}
 	}
+
+	if (bcount) {
+		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
+		idescsi_output_zeros (drive, bcount);
+	}
 }
 
 /*
@@ -910,9 +915,11 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	if (cmd->use_sg) {
 		pc->buffer = NULL;
 		pc->sg = cmd->request_buffer;
+		pc->last_sg = sg_last(pc->sg, cmd->use_sg);
 	} else {
 		pc->buffer = cmd->request_buffer;
 		pc->sg = NULL;
+		pc->last_sg = NULL;
 	}
 	pc->b_count = 0;
 	pc->request_transfer = pc->buffer_size = cmd->request_bufflen;
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 7e7635c..300d33d 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2882,7 +2882,7 @@ static int i91u_detect(struct scsi_host_template * tpnt)
 
 static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, struct scsi_cmnd * SCpnt)
 {				/* Create corresponding SCB     */
-	struct scatterlist *pSrbSG;
+	struct scatterlist *pSrbSG, *sg;
 	SG *pSG;		/* Pointer to SG list           */
 	int i;
 	long TotalLen;
@@ -2926,10 +2926,12 @@ static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, struct scsi_cmnd * SCpnt)
 					     SCpnt->use_sg, SCpnt->sc_data_direction);
 
 		pSCB->SCB_Flags |= SCF_SG;	/* Turn on SG list flag       */
-		for (i = 0, TotalLen = 0, pSG = &pSCB->SCB_SGList[0];	/* 1.01g */
-		     i < pSCB->SCB_SGLen; i++, pSG++, pSrbSG++) {
-			pSG->SG_Ptr = cpu_to_le32((u32)sg_dma_address(pSrbSG));
-			TotalLen += pSG->SG_Len = cpu_to_le32((u32)sg_dma_len(pSrbSG));
+		pSG = &pSCB->SCB_SGList[0];
+		TotalLen = 0;
+		for_each_sg(pSrbSG, sg, pSCB->SCB_SGLen, i) {
+			pSG->SG_Ptr = cpu_to_le32((u32)sg_dma_address(sg));
+			TotalLen += pSG->SG_Len = cpu_to_le32((u32)sg_dma_len(sg));
+			pSG++;
 		}
 
 		pSCB->SCB_BufLen = (SCpnt->request_bufflen > TotalLen) ?
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4baa79e..01b0476 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4286,7 +4286,7 @@ static int ipr_build_ioadl(struct ipr_ioa_cfg *ioa_cfg,
 			   struct ipr_cmnd *ipr_cmd)
 {
 	int i;
-	struct scatterlist *sglist;
+	struct scatterlist *sglist, *sg;
 	u32 length;
 	u32 ioadl_flags = 0;
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
@@ -4327,11 +4327,10 @@ static int ipr_build_ioadl(struct ipr_ioa_cfg *ioa_cfg,
 			ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 		}
 
-		for (i = 0; i < ipr_cmd->dma_use_sg; i++) {
+		for_each_sg(sglist, sg, ipr_cmd->dma_use_sg, i) {
 			ioadl[i].flags_and_data_len =
-				cpu_to_be32(ioadl_flags | sg_dma_len(&sglist[i]));
-			ioadl[i].address =
-				cpu_to_be32(sg_dma_address(&sglist[i]));
+				cpu_to_be32(ioadl_flags | sg_dma_len(sg));
+			ioadl[i].address = cpu_to_be32(sg_dma_address(sg));
 		}
 
 		if (likely(ipr_cmd->dma_use_sg)) {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8b704f7..ba1957a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1687,10 +1687,11 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	if (!SC->use_sg) {
 		length = SC->request_bufflen;
 	} else {
-		struct scatterlist *sg = SC->request_buffer;
+		struct scatterlist *sgl = SC->request_buffer;
+		struct scatterlist *sg;
 		int i;
-		for (i = 0; i < SC->use_sg; i++)
-			length += sg[i].length;
+		for_each_sg(sgl, sg, SC->use_sg, i)
+			length += sg->length;
 	}
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */
@@ -2868,17 +2869,17 @@ ips_next(ips_ha_t * ha, int intr)
 
 		/* Now handle the data buffer */
 		if (SC->use_sg) {
-			struct scatterlist *sg;
+			struct scatterlist *sg, *sgl;
 			int i;
 
-			sg = SC->request_buffer;
-			scb->sg_count = pci_map_sg(ha->pcidev, sg, SC->use_sg,
+			sgl = SC->request_buffer;
+			scb->sg_count = pci_map_sg(ha->pcidev, sgl, SC->use_sg,
 						   SC->sc_data_direction);
 			scb->flags |= IPS_SCB_MAP_SG;
-			for (i = 0; i < scb->sg_count; i++) {
+			for_each_sg(sgl, sg, scb->sg_count, i) {
 				if (ips_fill_scb_sg_single
-				    (ha, sg_dma_address(&sg[i]), scb, i,
-				     sg_dma_len(&sg[i])) < 0)
+				    (ha, sg_dma_address(sg), scb, i,
+				     sg_dma_len(sg)) < 0)
 					break;
 			}
 			scb->dcdb.transfer_length = scb->data_len;
@@ -3382,32 +3383,31 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 
 			if (scb->sg_count) {
 				/* S/G request */
-				struct scatterlist *sg;
+				struct scatterlist *sg, *sgl;
 				int ips_sg_index = 0;
-				int sg_dma_index;
+				int sg_dma_index, left, i;
 
-				sg = scb->scsi_cmd->request_buffer;
+				sgl = scb->scsi_cmd->request_buffer;
 
 				/* Spin forward to last dma chunk */
 				sg_dma_index = scb->breakup;
+				sg = sg_last(sgl, sg_dma_index);
 
 				/* Take care of possible partial on last chunk */
 				ips_fill_scb_sg_single(ha,
-						       sg_dma_address(&sg
-								      [sg_dma_index]),
+						       sg_dma_address(sg),
 						       scb, ips_sg_index++,
-						       sg_dma_len(&sg
-								  [sg_dma_index]));
+						       sg_dma_len(sg));
 
-				for (; sg_dma_index < scb->sg_count;
-				     sg_dma_index++) {
+				sgl = sg;
+				left = scb->sg_count - sg_dma_index;
+				for_each_sg(sgl, sg, left, i) {
 					if (ips_fill_scb_sg_single
 					    (ha,
-					     sg_dma_address(&sg[sg_dma_index]),
+					     sg_dma_address(sg),
 					     scb, ips_sg_index++,
-					     sg_dma_len(&sg[sg_dma_index])) < 0)
+					     sg_dma_len(sg)) < 0)
 						break;
-
 				}
 
 			} else {
@@ -3659,17 +3659,21 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 		char *cdata = (char *) data;
 		unsigned char *buffer;
 		unsigned long flags;
-		struct scatterlist *sg = scmd->request_buffer;
-		for (i = 0, xfer_cnt = 0;
-		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			min_cnt = min(count - xfer_cnt, sg[i].length);
+		struct scatterlist *sgl = scmd->request_buffer;
+		struct scatterlist *sg;
+
+		xfer_cnt = 0;
+		for_each_sg(sgl, sg, scmd->use_sg, i) {
+			if (xfer_cnt >= count)
+				break;
+			min_cnt = min(count - xfer_cnt, sg->length);
 
 			/* kmap_atomic() ensures addressability of the data buffer.*/
 			/* local_irq_save() protects the KM_IRQ0 address slot.     */
 			local_irq_save(flags);
-			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+			buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 			memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+			kunmap_atomic(buffer - sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 
 			xfer_cnt += min_cnt;
@@ -3697,17 +3701,21 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
 		char *cdata = (char *) data;
 		unsigned char *buffer;
 		unsigned long flags;
-		struct scatterlist *sg = scmd->request_buffer;
-		for (i = 0, xfer_cnt = 0;
-		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			min_cnt = min(count - xfer_cnt, sg[i].length);
+		struct scatterlist *sgl = scmd->request_buffer;
+		struct scatterlist *sg;
+
+		xfer_cnt = 0;
+		for_each_sg(sgl, sg, scmd->use_sg, i) {
+			if (xfer_cnt >= count)
+				break;
+			min_cnt = min(count - xfer_cnt, sg->length);
 
 			/* kmap_atomic() ensures addressability of the data buffer.*/
 			/* local_irq_save() protects the KM_IRQ0 address slot.     */
 			local_irq_save(flags);
-			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+			buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 			memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+			kunmap_atomic(buffer - sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 
 			xfer_cnt += min_cnt;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c9a3abf..8f709fa 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -310,10 +310,11 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 
 	if (sc->use_sg) {
 		int i, sg_count = 0;
-		struct scatterlist *sg = sc->request_buffer;
+		struct scatterlist *sgl = sc->request_buffer;
+		struct scatterlist *sg;
 
 		r2t->sg = NULL;
-		for (i = 0; i < sc->use_sg; i++, sg += 1) {
+		for_each_sg(sgl, sg, sc->use_sg, i) {
 			/* FIXME: prefetch ? */
 			if (sg_count + sg->length > r2t->data_offset) {
 				int page_offset;
@@ -329,7 +330,7 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 				r2t->sendbuf.sg.length -= page_offset;
 
 				/* xmit logic will continue with next one */
-				r2t->sg = sg + 1;
+				r2t->sg = sg_next(sg);
 				break;
 			}
 			sg_count += sg->length;
@@ -702,7 +703,7 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	struct iscsi_cmd_task *ctask = tcp_conn->in.ctask;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct scsi_cmnd *sc = ctask->sc;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *sgl;
 	int i, offset, rc = 0;
 
 	BUG_ON((void*)ctask != sc->SCp.ptr);
@@ -725,21 +726,21 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	}
 
 	offset = tcp_ctask->data_offset;
-	sg = sc->request_buffer;
+	sgl = sc->request_buffer;
 
 	if (tcp_ctask->data_offset)
-		for (i = 0; i < tcp_ctask->sg_count; i++)
-			offset -= sg[i].length;
+		for_each_sg(sgl, sg, tcp_ctask->sg_count, i)
+			offset -= sg->length;
 	/* we've passed through partial sg*/
 	if (offset < 0)
 		offset = 0;
 
-	for (i = tcp_ctask->sg_count; i < sc->use_sg; i++) {
+	for_each_sg(sgl, sg, tcp_ctask->sg_count, i) {
 		char *dest;
 
-		dest = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
-		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg[i].offset,
-				      sg[i].length, offset);
+		dest = kmap_atomic(sg->page, KM_SOFTIRQ0);
+		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg->offset,
+				      sg->length, offset);
 		kunmap_atomic(dest, KM_SOFTIRQ0);
 		if (rc == -EAGAIN)
 			/* continue with the next SKB/PDU */
@@ -749,13 +750,13 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 				if (!offset)
 					crypto_hash_update(
 							&tcp_conn->rx_hash,
-							&sg[i], sg[i].length);
+							sg, sg->length);
 				else
 					partial_sg_digest_update(
 							&tcp_conn->rx_hash,
-							&sg[i],
-							sg[i].offset + offset,
-							sg[i].length - offset);
+							sg,
+							sg->offset + offset,
+							sg->length - offset);
 			}
 			offset = 0;
 			tcp_ctask->sg_count++;
@@ -767,9 +768,9 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 				 * data-in is complete, but buffer not...
 				 */
 				partial_sg_digest_update(&tcp_conn->rx_hash,
-							 &sg[i],
-							 sg[i].offset,
-							 sg[i].length-rc);
+							 sg,
+							 sg->offset,
+							 sg->length-rc);
 			rc = 0;
 			break;
 		}
@@ -1294,8 +1295,8 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task *ctask)
 			struct scatterlist *sg = sc->request_buffer;
 
 			iscsi_buf_init_sg(&tcp_ctask->sendbuf, sg);
-			tcp_ctask->sg = sg + 1;
-			tcp_ctask->bad_sg = sg + sc->use_sg;
+			tcp_ctask->sg = sg_next(sg);
+			tcp_ctask->bad_sg = sg_last(sg, sc->use_sg);
 		} else {
 			iscsi_buf_init_iov(&tcp_ctask->sendbuf,
 					   sc->request_buffer,
@@ -1522,7 +1523,7 @@ iscsi_send_data(struct iscsi_cmd_task *ctask, struct iscsi_buf *sendbuf,
 				buf_sent);
 		if (!iscsi_buf_left(sendbuf) && *sg != tcp_ctask->bad_sg) {
 			iscsi_buf_init_sg(sendbuf, *sg);
-			*sg = *sg + 1;
+			*sg = sg_next(*sg);
 		}
 
 		if (rc)
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 19dd4b9..d742c73 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -15,6 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
+#include <linux/dma-mapping.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -240,12 +241,13 @@ static void dma_mmu_get_scsi_one (struct NCR_ESP *esp, struct scsi_cmnd *sp)
 static void dma_mmu_get_scsi_sgl (struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
     int sz = sp->SCp.buffers_residual;
-    struct scatterlist *sg = (struct scatterlist *) sp->SCp.buffer;
-    
-    while (sz >= 0) {
-	sg[sz].dma_address = vdma_alloc(CPHYSADDR(page_address(sg[sz].page) + sg[sz].offset), sg[sz].length);
-	sz--;
-    }
+    struct scatterlist *sgl = (struct scatterlist *) sp->SCp.buffer;
+    struct scatterlist *sg;
+    int i;
+
+    for_each_sg(sgl, sg, sz, i)
+	sg->dma_address = vdma_alloc(CPHYSADDR(page_address(sg->page) + sg->offset), sg->length);
+
     sp->SCp.ptr=(char *)(sp->SCp.buffer->dma_address);
 }    
 
@@ -256,13 +258,12 @@ static void dma_mmu_release_scsi_one (struct NCR_ESP *esp, struct scsi_cmnd *sp)
 
 static void dma_mmu_release_scsi_sgl (struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
-    int sz = sp->use_sg - 1;
-    struct scatterlist *sg = (struct scatterlist *)sp->request_buffer;
-			
-    while(sz >= 0) {
-	vdma_free(sg[sz].dma_address);
-	sz--;
-    }
+    struct scatterlist *sgl = (struct scatterlist *)sp->request_buffer;
+    struct scatterlist *sg;
+    int i;
+
+    for_each_sg(sgl, sg, sp->use_sg, i)
+	vdma_free(sg->dma_address);
 }
 
 static void dma_advance_sg (struct scsi_cmnd *sp)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9a12d05..d1f6654 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -169,7 +169,7 @@ static int
 lpfc_scsi_prep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * lpfc_cmd)
 {
 	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
-	struct scatterlist *sgel = NULL;
+	struct scatterlist *sgel = NULL, *sg;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct ulp_bde64 *bpl = lpfc_cmd->fcp_bpl;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
@@ -214,18 +214,17 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * lpfc_cmd)
 		 * single scsi command.  Just run through the seg_cnt and format
 		 * the bde's.
 		 */
-		for (i = 0; i < lpfc_cmd->seg_cnt; i++) {
-			physaddr = sg_dma_address(sgel);
+		for_each_sg(sgel, sg, lpfc_cmd->seg_cnt, i) {
+			physaddr = sg_dma_address(sg);
 			bpl->addrLow = le32_to_cpu(putPaddrLow(physaddr));
 			bpl->addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
-			bpl->tus.f.bdeSize = sg_dma_len(sgel);
+			bpl->tus.f.bdeSize = sg_dma_len(sg);
 			if (datadir == DMA_TO_DEVICE)
 				bpl->tus.f.bdeFlags = 0;
 			else
 				bpl->tus.f.bdeFlags = BUFF_USE_RCV;
 			bpl->tus.w = le32_to_cpu(bpl->tus.w);
 			bpl++;
-			sgel++;
 			num_bde++;
 		}
 	} else if (scsi_cmnd->request_buffer && scsi_cmnd->request_bufflen) {
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 5806ede..cb569c6 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -366,7 +366,7 @@ static void cmd_done(struct fsc_state *state, int result)
 static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 {
 	int i, dma_cmd, total;
-	struct scatterlist *scl;
+	struct scatterlist *scl, *sg;
 	struct dbdma_cmd *dcmds;
 	dma_addr_t dma_addr;
 	u32 dma_len;
@@ -381,9 +381,9 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 		scl = (struct scatterlist *) cmd->request_buffer;
 		nseg = pci_map_sg(state->pdev, scl, cmd->use_sg,
 				cmd->sc_data_direction);
-		for (i = 0; i < nseg; ++i) {
-			dma_addr = sg_dma_address(scl);
-			dma_len = sg_dma_len(scl);
+		for_each_sg(scl, sg, nseg, i) {
+			dma_addr = sg_dma_address(sg);
+			dma_len = sg_dma_len(sg);
 			if (dma_len > 0xffff)
 				panic("mac53c94: scatterlist element >= 64k");
 			total += dma_len;
@@ -391,7 +391,6 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 			st_le16(&dcmds->command, dma_cmd);
 			st_le32(&dcmds->phy_addr, dma_addr);
 			dcmds->xfer_status = 0;
-			++scl;
 			++dcmds;
 		}
 	} else {
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3cce75d..0ea9ef4 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1767,7 +1767,7 @@ __mega_busywait_mbox (adapter_t *adapter)
 static int
 mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 {
-	struct scatterlist	*sgl;
+	struct scatterlist	*sgl, *sg;
 	struct page	*page;
 	unsigned long	offset;
 	unsigned int	length;
@@ -1832,15 +1832,14 @@ mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 
 	*len = 0;
 
-	for( idx = 0; idx < sgcnt; idx++, sgl++ ) {
-
+	for_each_sg(sgl, sg, sgcnt, idx) {
 		if( adapter->has_64bit_addr ) {
-			scb->sgl64[idx].address = sg_dma_address(sgl);
-			*len += scb->sgl64[idx].length = sg_dma_len(sgl);
+			scb->sgl64[idx].address = sg_dma_address(sg);
+			*len += scb->sgl64[idx].length = sg_dma_len(sg);
 		}
 		else {
-			scb->sgl[idx].address = sg_dma_address(sgl);
-			*len += scb->sgl[idx].length = sg_dma_len(sgl);
+			scb->sgl[idx].address = sg_dma_address(sg);
+			*len += scb->sgl[idx].length = sg_dma_len(sg);
 		}
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 04d0b69..6b1ee7f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1377,6 +1377,7 @@ static int
 megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb)
 {
 	struct scatterlist	*sgl;
+	struct scatterlist	*sg;
 	mbox_ccb_t		*ccb;
 	struct page		*page;
 	unsigned long		offset;
@@ -1429,9 +1430,9 @@ megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb)
 
 	scb->dma_type = MRAID_DMA_WSG;
 
-	for (i = 0; i < sgcnt; i++, sgl++) {
-		ccb->sgl64[i].address	= sg_dma_address(sgl);
-		ccb->sgl64[i].length	= sg_dma_len(sgl);
+	for_each_sg(sgl, sg, sgcnt, i) {
+		ccb->sgl64[i].address	= sg_dma_address(sg);
+		ccb->sgl64[i].length	= sg_dma_len(sg);
 	}
 
 	// Return count of SG nodes
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7a81267..5260bc6 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -431,7 +431,7 @@ megasas_make_sgl32(struct megasas_instance *instance, struct scsi_cmnd *scp,
 {
 	int i;
 	int sge_count;
-	struct scatterlist *os_sgl;
+	struct scatterlist *os_sgl, *sg;
 
 	/*
 	 * Return 0 if there is no data transfer
@@ -456,9 +456,9 @@ megasas_make_sgl32(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	sge_count = pci_map_sg(instance->pdev, os_sgl, scp->use_sg,
 			       scp->sc_data_direction);
 
-	for (i = 0; i < sge_count; i++, os_sgl++) {
-		mfi_sgl->sge32[i].length = sg_dma_len(os_sgl);
-		mfi_sgl->sge32[i].phys_addr = sg_dma_address(os_sgl);
+	for_each_sg(os_sgl, sg, sge_count, i) {
+		mfi_sgl->sge32[i].length = sg_dma_len(sg);
+		mfi_sgl->sge32[i].phys_addr = sg_dma_address(sg);
 	}
 
 	return sge_count;
@@ -479,7 +479,7 @@ megasas_make_sgl64(struct megasas_instance *instance, struct scsi_cmnd *scp,
 {
 	int i;
 	int sge_count;
-	struct scatterlist *os_sgl;
+	struct scatterlist *os_sgl, *sg;
 
 	/*
 	 * Return 0 if there is no data transfer
@@ -505,9 +505,9 @@ megasas_make_sgl64(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	sge_count = pci_map_sg(instance->pdev, os_sgl, scp->use_sg,
 			       scp->sc_data_direction);
 
-	for (i = 0; i < sge_count; i++, os_sgl++) {
-		mfi_sgl->sge64[i].length = sg_dma_len(os_sgl);
-		mfi_sgl->sge64[i].phys_addr = sg_dma_address(os_sgl);
+	for_each_sg(os_sgl, sg, sge_count, i) {
+		mfi_sgl->sge64[i].length = sg_dma_len(sg);
+		mfi_sgl->sge64[i].phys_addr = sg_dma_address(sg);
 	}
 
 	return sge_count;
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e64d1a1..66519aa 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1257,7 +1257,7 @@ static void handle_msgin(struct mesh_state *ms)
 static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd)
 {
 	int i, dma_cmd, total, off, dtot;
-	struct scatterlist *scl;
+	struct scatterlist *scl, *sg;
 	struct dbdma_cmd *dcmds;
 
 	dma_cmd = ms->tgts[ms->conn_tgt].data_goes_out?
@@ -1267,17 +1267,17 @@ static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd)
 	if (cmd) {
 		cmd->SCp.this_residual = cmd->request_bufflen;
 		if (cmd->use_sg > 0) {
-			int nseg;
+			int nseg, i;
 			total = 0;
 			scl = (struct scatterlist *) cmd->request_buffer;
 			off = ms->data_ptr;
 			nseg = pci_map_sg(ms->pdev, scl, cmd->use_sg,
 					  cmd->sc_data_direction);
-			for (i = 0; i <nseg; ++i, ++scl) {
-				u32 dma_addr = sg_dma_address(scl);
-				u32 dma_len = sg_dma_len(scl);
+			for_each_sg(scl, sg, nseg, i) {
+				u32 dma_addr = sg_dma_address(sg);
+				u32 dma_len = sg_dma_len(sg);
 				
-				total += scl->length;
+				total += sg->length;
 				if (off >= dma_len) {
 					off -= dma_len;
 					continue;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index bbf521c..e6210c6 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7700,6 +7700,7 @@ static int ncr_scatter(struct ncb *np, struct ccb *cp, struct scsi_cmnd *cmd)
 		segment = ncr_scatter_no_sglist(np, cp, cmd);
 	else if ((use_sg = map_scsi_sg_data(np, cmd)) > 0) {
 		struct scatterlist *scatter = (struct scatterlist *)cmd->request_buffer;
+		struct scatterlist *sg;
 		struct scr_tblmove *data;
 
 		if (use_sg > MAX_SCATTER) {
@@ -7709,9 +7710,9 @@ static int ncr_scatter(struct ncb *np, struct ccb *cp, struct scsi_cmnd *cmd)
 
 		data = &cp->phys.data[MAX_SCATTER - use_sg];
 
-		for (segment = 0; segment < use_sg; segment++) {
-			dma_addr_t baddr = sg_dma_address(&scatter[segment]);
-			unsigned int len = sg_dma_len(&scatter[segment]);
+		for_each_sg(scatter, sg, use_sg, segment) {
+			dma_addr_t baddr = sg_dma_address(sg);
+			unsigned int len = sg_dma_len(sg);
 
 			ncr_build_sge(np, &data[segment], baddr, len);
 			cp->data_len += len;
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index f6f561d..32426a9 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -888,7 +888,7 @@ static int nsp32_reselection(struct scsi_cmnd *SCpnt, unsigned char newlun)
 static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	struct scatterlist   *sgl;
+	struct scatterlist   *sgl, *sg;
 	nsp32_sgtable *sgt = data->cur_lunt->sglun->sgt;
 	int num, i;
 	u32_le l;
@@ -906,13 +906,12 @@ static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 		sgl = (struct scatterlist *)SCpnt->request_buffer;
 		num = pci_map_sg(data->Pci, sgl, SCpnt->use_sg,
 				 SCpnt->sc_data_direction);
-		for (i = 0; i < num; i++) {
+		for_each_sg(sgl, sg, num, i) {
 			/*
 			 * Build nsp32_sglist, substitute sg dma addresses.
 			 */
-			sgt[i].addr = cpu_to_le32(sg_dma_address(sgl));
-			sgt[i].len  = cpu_to_le32(sg_dma_len(sgl));
-			sgl++;
+			sgt[i].addr = cpu_to_le32(sg_dma_address(sg));
+			sgt[i].len  = cpu_to_le32(sg_dma_len(sg));
 
 			if (le32_to_cpu(sgt[i].len) > 0x10000) {
 				nsp32_msg(KERN_ERR,
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index ffe75c4..b1e9270 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -442,12 +442,13 @@ SYM53C500_intr(int irq, void *dev_id)
 			if (!curSC->use_sg)	/* Don't use scatter-gather */
 				SYM53C500_pio_write(fast_pio, port_base, curSC->request_buffer, curSC->request_bufflen);
 			else {	/* use scatter-gather */
+				struct scatterlist *sg;
+				int i;
+
 				sgcount = curSC->use_sg;
 				sglist = curSC->request_buffer;
-				while (sgcount--) {
-					SYM53C500_pio_write(fast_pio, port_base, page_address(sglist->page) + sglist->offset, sglist->length);
-					sglist++;
-				}
+				for_each_sg(sglist, sg, sgcount, i)
+					SYM53C500_pio_write(fast_pio, port_base, page_address(sg->page) + sg->offset, sg->length);
 			}
 			REG0(port_base);
 		}
@@ -463,12 +464,13 @@ SYM53C500_intr(int irq, void *dev_id)
 			if (!curSC->use_sg)	/* Don't use scatter-gather */
 				SYM53C500_pio_read(fast_pio, port_base, curSC->request_buffer, curSC->request_bufflen);
 			else {	/* Use scatter-gather */
+				struct scatterlist *sg;
+				int i;
+
 				sgcount = curSC->use_sg;
 				sglist = curSC->request_buffer;
-				while (sgcount--) {
-					SYM53C500_pio_read(fast_pio, port_base, page_address(sglist->page) + sglist->offset, sglist->length);
-					sglist++;
-				}
+				for_each_sg(sglist, sg, sgcount, i)
+					SYM53C500_pio_read(fast_pio, port_base, page_address(sg->page) + sg->offset, sg->length);
 			}
 			REG0(port_base);
 		}
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 54d8bdf..bd805ec 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2775,7 +2775,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
-	struct scatterlist *sg = NULL;
+	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	dma_addr_t dma_handle;
 	int status = 0;
@@ -2889,13 +2889,16 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {	/* If data transfer. */
+		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
 		if (cmd->use_sg) {	/* If scatter gather */
 			/* Load command entry data segments. */
-			for (cnt = 0; cnt < 2 && seg_cnt; cnt++, seg_cnt--) {
-				dma_handle = sg_dma_address(sg);
+			for_each_sg(sg, s, seg_cnt, cnt) {
+				if (cnt == 2)
+					break;
+				dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev,
@@ -2906,12 +2909,12 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					cpu_to_le32(pci_dma_lo32(dma_handle));
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_hi32(dma_handle));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(sg));
-				sg++;
+				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
 				dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 					cpu_to_le32(pci_dma_hi32(dma_handle)),
 					cpu_to_le32(pci_dma_lo32(dma_handle)),
-					cpu_to_le32(sg_dma_len(sg)));
+					cpu_to_le32(sg_dma_len(sg_next(s))));
+				remseg--;
 			}
 			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
 				"command packet data - b %i, t %i, l %i \n",
@@ -2926,7 +2929,9 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
 				"remains\n", seg_cnt);
 
-			while (seg_cnt > 0) {
+			while (remseg > 0) {
+				/* Update sg start */
+				sg = s;
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -2952,9 +2957,10 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for (cnt = 0; cnt < 5 && seg_cnt;
-				     cnt++, seg_cnt--) {
-					dma_handle = sg_dma_address(sg);
+				for_each_sg(sg, s, remseg, cnt) {
+					if (cnt == 5)
+						break;
+					dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev, 
@@ -2966,12 +2972,12 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					*dword_ptr++ =
 						cpu_to_le32(pci_dma_hi32(dma_handle));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(sg));
+						cpu_to_le32(sg_dma_len(s));
 					dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
 						cpu_to_le32(pci_dma_hi32(dma_handle)),
 						cpu_to_le32(pci_dma_lo32(dma_handle)),
-						cpu_to_le32(sg_dma_len(sg)));
-					sg++;
+						cpu_to_le32(sg_dma_len(s)));
+					remseg--;
 				}
 				dprintk(5, "qla1280_64bit_start_scsi: "
 					"continuation packet data - b %i, t "
@@ -3062,7 +3068,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
-	struct scatterlist *sg = NULL;
+	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	int status = 0;
 	int cnt;
@@ -3188,6 +3194,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {
+		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
@@ -3196,22 +3203,25 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
 
 			/* Load command entry data segments. */
-			for (cnt = 0; cnt < 4 && seg_cnt; cnt++, seg_cnt--) {
+			for_each_sg(sg, s, seg_cnt, cnt) {
+				if (cnt == 4)
+					break;
 				*dword_ptr++ =
-					cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
-				*dword_ptr++ =
-					cpu_to_le32(sg_dma_len(sg));
+					cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
+				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
 				dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
-					(pci_dma_lo32(sg_dma_address(sg))),
-					(sg_dma_len(sg)));
-				sg++;
+					(pci_dma_lo32(sg_dma_address(s))),
+					(sg_dma_len(s)));
+				remseg--;
 			}
 			/*
 			 * Build continuation packets.
 			 */
 			dprintk(3, "S/G Building Continuation"
 				"...seg_cnt=0x%x remains\n", seg_cnt);
-			while (seg_cnt > 0) {
+			while (remseg > 0) {
+				/* Continue from end point */
+				sg = s;
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -3239,18 +3249,16 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					&((struct cont_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for (cnt = 0; cnt < 7 && seg_cnt;
-				     cnt++, seg_cnt--) {
+				for_each_sg(sg, s, remseg, cnt) {
 					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(sg));
+						cpu_to_le32(sg_dma_len(s));
 					dprintk(1,
 						"S/G Segment Cont. phys_addr=0x%x, "
 						"len=0x%x\n",
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg))),
-						cpu_to_le32(sg_dma_len(sg)));
-					sg++;
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
+						cpu_to_le32(sg_dma_len(s)));
 				}
 				dprintk(5, "qla1280_32bit_start_scsi: "
 					"continuation packet data - "
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c5b3c61..10251bf 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -671,12 +671,11 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 
 	/* Load data segments */
 	if (cmd->use_sg != 0) {
+		struct	scatterlist *sgl = cmd->request_buffer;
 		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
+		int i;
 
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		end_seg = cur_seg + tot_dsds;
-		while (cur_seg < end_seg) {
+		for_each_sg(sgl, cur_seg, tot_dsds, i) {
 			dma_addr_t	sle_dma;
 			cont_a64_entry_t *cont_pkt;
 
@@ -696,8 +695,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
 			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
 			avail_dsds--;
-
-			cur_seg++;
 		}
 	} else {
 		*cur_dsd++ = cpu_to_le32(LSD(sp->dma_handle));
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index a216a17..82a894b 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -156,12 +156,11 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 
 	/* Load data segments */
 	if (cmd->use_sg) {
+		struct scatterlist *sgl = cmd->request_buffer;
 		struct scatterlist *cur_seg;
-		struct scatterlist *end_seg;
+		int i;
 
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		end_seg = cur_seg + tot_dsds;
-		while (cur_seg < end_seg) {
+		for_each_sg(sgl, cur_seg, tot_dsds, i) {
 			dma_addr_t sle_dma;
 
 			/* Allocate additional continuation packets? */
@@ -182,7 +181,6 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 			avail_dsds--;
 
 			cur_dsd++;
-			cur_seg++;
 		}
 	} else {
 		cur_dsd->base.addrLow = cpu_to_le32(LSDW(srb->dma_handle));
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 2e7db18..ccc7d3f 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -315,18 +315,19 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 			ql_pdma(priv, phase, cmd->request_buffer,
 				cmd->request_bufflen);
 		else {
+			struct scatterlist *sg;
+
 			sgcount = cmd->use_sg;
 			sglist = cmd->request_buffer;
-			while (sgcount--) {
+			for_each_sg(sglist, sg, sgcount, i) {
 				if (priv->qabort) {
 					REG0;
 					return ((priv->qabort == 1 ?
 						DID_ABORT : DID_RESET) << 16);
 				}
-				buf = page_address(sglist->page) + sglist->offset;
-				if (ql_pdma(priv, phase, buf, sglist->length))
+				buf = page_address(sg->page) + sg->offset;
+				if (ql_pdma(priv, phase, buf, sg->length))
 					break;
-				sglist++;
 			}
 		}
 		REG0;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index c4195ea..e36e6cd 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -868,7 +868,7 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 			   struct qlogicpti *qpti, u_int in_ptr, u_int out_ptr)
 {
 	struct dataseg *ds;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *s;
 	int i, n;
 
 	if (Cmnd->use_sg) {
@@ -884,11 +884,12 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 		n = sg_count;
 		if (n > 4)
 			n = 4;
-		for (i = 0; i < n; i++, sg++) {
-			ds[i].d_base = sg_dma_address(sg);
-			ds[i].d_count = sg_dma_len(sg);
+		for_each_sg(sg, s, n, i) {
+			ds[i].d_base = sg_dma_address(s);
+			ds[i].d_count = sg_dma_len(g);
 		}
 		sg_count -= 4;
+		sg = s;
 		while (sg_count > 0) {
 			struct Continuation_Entry *cont;
 
@@ -907,9 +908,9 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 			n = sg_count;
 			if (n > 7)
 				n = 7;
-			for (i = 0; i < n; i++, sg++) {
-				ds[i].d_base = sg_dma_address(sg);
-				ds[i].d_count = sg_dma_len(sg);
+			for_each_sg(sg, s, n, i) {
+				ds[i].d_base = sg_dma_address(s);
+				ds[i].d_count = sg_dma_len(s);
 			}
 			sg_count -= n;
 		}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 06229f2..0ef1310 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -38,6 +38,7 @@
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
+#include <linux/scatterlist.h>
 
 #include <linux/blkdev.h>
 #include "scsi.h"
@@ -600,7 +601,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	int k, req_len, act_len, len, active;
 	void * kaddr;
 	void * kaddr_off;
-	struct scatterlist * sgpnt;
+	struct scatterlist * sgpnt, * sg;
 
 	if (0 == scp->request_bufflen)
 		return 0;
@@ -621,14 +622,15 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	}
 	sgpnt = (struct scatterlist *)scp->request_buffer;
 	active = 1;
-	for (k = 0, req_len = 0, act_len = 0; k < scp->use_sg; ++k, ++sgpnt) {
+	req_len = act_len = 0;
+	for_each_sg(sgpnt, sg, scp->use_sg, k) {
 		if (active) {
 			kaddr = (unsigned char *)
-				kmap_atomic(sgpnt->page, KM_USER0);
+				kmap_atomic(sg->page, KM_USER0);
 			if (NULL == kaddr)
 				return (DID_ERROR << 16);
-			kaddr_off = (unsigned char *)kaddr + sgpnt->offset;
-			len = sgpnt->length;
+			kaddr_off = (unsigned char *)kaddr + sg->offset;
+			len = sg->length;
 			if ((req_len + len) > arr_len) {
 				active = 0;
 				len = arr_len - req_len;
@@ -637,7 +639,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 			kunmap_atomic(kaddr, KM_USER0);
 			act_len += len;
 		}
-		req_len += sgpnt->length;
+		req_len += sg->length;
 	}
 	if (scp->resid)
 		scp->resid -= act_len;
@@ -653,7 +655,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	int k, req_len, len, fin;
 	void * kaddr;
 	void * kaddr_off;
-	struct scatterlist * sgpnt;
+	struct scatterlist * sg;
 
 	if (0 == scp->request_bufflen)
 		return 0;
@@ -668,13 +670,14 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 		memcpy(arr, scp->request_buffer, len);
 		return len;
 	}
-	sgpnt = (struct scatterlist *)scp->request_buffer;
-	for (k = 0, req_len = 0, fin = 0; k < scp->use_sg; ++k, ++sgpnt) {
-		kaddr = (unsigned char *)kmap_atomic(sgpnt->page, KM_USER0);
+	sg = (struct scatterlist *)scp->request_buffer;
+	req_len = fin = 0;
+	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
+		kaddr = (unsigned char *)kmap_atomic(sg->page, KM_USER0);
 		if (NULL == kaddr)
 			return -1;
-		kaddr_off = (unsigned char *)kaddr + sgpnt->offset;
-		len = sgpnt->length;
+		kaddr_off = (unsigned char *)kaddr + sg->offset;
+		len = sg->length;
 		if ((req_len + len) > max_arr_len) {
 			len = max_arr_len - req_len;
 			fin = 1;
@@ -683,7 +686,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 		kunmap_atomic(kaddr, KM_USER0);
 		if (fin)
 			return req_len + len;
-		req_len += sgpnt->length;
+		req_len += sg->length;
 	}
 	return req_len;
 }
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0c691a6..0d67fa2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1168,7 +1168,7 @@ sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
 	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, ++sg) {
+	     ++k, sg = sg_next(sg)) {
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
@@ -1212,7 +1212,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	sa = vma->vm_start;
 	sg = rsv_schp->buffer;
 	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, ++sg) {
+	     ++k, sg = sg_next(sg)) {
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		sa += len;
@@ -1866,7 +1866,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	}
 	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
 	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, ++sg) {
+	     ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
 		
 		num = (rem_sz > scatter_elem_sz_prev) ?
 		      scatter_elem_sz_prev : rem_sz;
@@ -1939,7 +1939,7 @@ sg_write_xfer(Sg_request * srp)
 		if (res)
 			return res;
 
-		for (; p; ++sg, ksglen = sg->length,
+		for (; p; sg = sg_next(sg), ksglen = sg->length,
 		     p = page_address(sg->page)) {
 			if (usglen <= 0)
 				break;
@@ -2018,7 +2018,7 @@ sg_remove_scat(Sg_scatter_hold * schp)
 			int k;
 
 			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, ++sg) {
+			     ++k, sg = sg_next(sg)) {
 				SCSI_LOG_TIMEOUT(5, printk(
 				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
 				    k, sg->page, sg->length));
@@ -2071,7 +2071,7 @@ sg_read_xfer(Sg_request * srp)
 		if (res)
 			return res;
 
-		for (; p; ++sg, ksglen = sg->length,
+		for (; p; sg = sg_next(sg), ksglen = sg->length,
 		     p = page_address(sg->page)) {
 			if (usglen <= 0)
 				break;
@@ -2118,7 +2118,7 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, ++sg) {
+	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (num > num_read_xfer) {
 			if (__copy_to_user(outp, page_address(sg->page),
@@ -2168,7 +2168,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
 	rem = size;
 
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
+	for (k = 0; k < rsv_schp->k_use_sg; ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (rem <= num) {
 			sfp->save_scat_len = num;
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 2ca9505..06c765c 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -332,7 +332,7 @@ static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 	int i;
 	unsigned long flags = 0;
 	unsigned char status_reg, pio_int_reg, int_reg;
-	struct scatterlist *sglist;
+	struct scatterlist *sglist, *sg;
 	unsigned int sgcount;
 	unsigned int tot_trans = 0;
 
@@ -437,11 +437,8 @@ static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 				{
 					sgcount = current_command->use_sg;
 					sglist = current_command->request_buffer;
-					while(sgcount--)
-					{
-						tot_trans += sym53c416_write(base, SG_ADDRESS(sglist), sglist->length);
-						sglist++;
-					}
+					for_each_sg(sglist, sg, sgcount, i)
+						tot_trans += sym53c416_write(base, SG_ADDRESS(sg), sg->length);
 				}
 				if(tot_trans < current_command->underflow)
 					printk(KERN_WARNING "sym53c416: Underflow, wrote %d bytes, request for %d bytes.\n", tot_trans, current_command->underflow);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4d78c7e..f39e3ec 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -371,6 +371,7 @@ static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd
 		segment = sym_scatter_no_sglist(np, cp, cmd);
 	else if ((use_sg = map_scsi_sg_data(np, cmd)) > 0) {
 		struct scatterlist *scatter = (struct scatterlist *)cmd->request_buffer;
+		struct scatterlist *sg;
 		struct sym_tcb *tp = &np->target[cp->target];
 		struct sym_tblmove *data;
 
@@ -381,9 +382,9 @@ static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd
 
 		data = &cp->phys.data[SYM_CONF_MAX_SG - use_sg];
 
-		for (segment = 0; segment < use_sg; segment++) {
-			dma_addr_t baddr = sg_dma_address(&scatter[segment]);
-			unsigned int len = sg_dma_len(&scatter[segment]);
+		for_each_sg(scatter, sg, use_sg, segment) {
+			dma_addr_t baddr = sg_dma_address(sg);
+			unsigned int len = sg_dma_len(sg);
 
 			if ((len & 1) && (tp->head.wval & EWS)) {
 				len++;
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 3de08a1..db17ba4 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1111,7 +1111,7 @@ static int u14_34f_detect(struct scsi_host_template *tpnt) {
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
    unsigned int k, count, pci_dir;
-   struct scatterlist *sgpnt;
+   struct scatterlist *sgpnt, *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
 
@@ -1140,10 +1140,10 @@ static void map_dma(unsigned int i, unsigned int j) {
    sgpnt = (struct scatterlist *) SCpnt->request_buffer;
    count = pci_map_sg(HD(j)->pdev, sgpnt, SCpnt->use_sg, pci_dir);
 
-   for (k = 0; k < count; k++) {
-      cpp->sglist[k].address = H2DEV(sg_dma_address(&sgpnt[k]));
-      cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(&sgpnt[k]));
-      data_len += sgpnt[k].length;
+   for_each_sg(sgpnt, sg, count, k) {
+      cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
+      cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
+      data_len += sg->length;
       }
 
    cpp->sg = TRUE;
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 56906ab..1b721ec 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -675,16 +675,16 @@ static const char *ultrastor_info(struct Scsi_Host * shpnt)
 
 static inline void build_sg_list(struct mscp *mscp, struct scsi_cmnd *SCpnt)
 {
-	struct scatterlist *sl;
+	struct scatterlist *sl, *sg;
 	long transfer_length = 0;
 	int i, max;
 
 	sl = (struct scatterlist *) SCpnt->request_buffer;
 	max = SCpnt->use_sg;
-	for (i = 0; i < max; i++) {
-		mscp->sglist[i].address = isa_page_to_bus(sl[i].page) + sl[i].offset;
-		mscp->sglist[i].num_bytes = sl[i].length;
-		transfer_length += sl[i].length;
+	for_each_sg(sl, sg, max, i) {
+		mscp->sglist[i].address = isa_page_to_bus(sg->page) + sg->offset;
+		mscp->sglist[i].num_bytes = sg->length;
+		transfer_length += sg->length;
 	}
 	mscp->number_of_sg_list = max;
 	mscp->transfer_data = isa_virt_to_bus(mscp->sglist);
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 30be765..85aaa5e 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1108,6 +1108,7 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 
 	if (SCpnt->use_sg) {
 		struct scatterlist *sg = (struct scatterlist *) SCpnt->request_buffer;
+		struct scatterlist *s;
 		unsigned i;
 
 		if (SCpnt->device->host->sg_tablesize == SG_NONE) {
@@ -1120,9 +1121,9 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 		any2scsi(scb->dataptr, (int) sgb);
 		any2scsi(scb->maxlen, SCpnt->use_sg * sizeof(Sgb));
 
-		for (i = 0; i < SCpnt->use_sg; i++) {
-			any2scsi(sgb[i].ptr, isa_page_to_bus(sg[i].page) + sg[i].offset);
-			any2scsi(sgb[i].len, sg[i].length);
+		for_each_sg(sg, s, SCpnt->use_sg, i) {
+			any2scsi(sgb[i].ptr, isa_page_to_bus(s->page) + s->offset);
+			any2scsi(sgb[i].len, s->length);
 		}
 	} else {
 		scb->op = 0;
diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 4d3cbb1..8d3711a 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -798,12 +798,13 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 {
 	unsigned char *buffer;
 	u16 lba, max_lba;
-	unsigned int page, len, index, offset;
+	unsigned int page, len, offset;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
 	unsigned int uzonesize = MEDIA_INFO(us).uzonesize;
+	struct scatterlist *sg;
 	int result;
 
 	/*
@@ -827,7 +828,8 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	max_lba = MEDIA_INFO(us).capacity >> (blockshift + pageshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 		unsigned int zone = lba / uzonesize; /* integer division */
@@ -873,7 +875,7 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -891,11 +893,12 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 		unsigned int sectors)
 {
 	unsigned char *buffer, *blockbuffer;
-	unsigned int page, len, index, offset;
+	unsigned int page, len, offset;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
+	struct scatterlist *sg;
 	u16 lba, max_lba;
 	int result;
 
@@ -929,7 +932,8 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 	max_lba = MEDIA_INFO(us).capacity >> (pageshift + blockshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 		/* Write as many sectors as possible in this block */
@@ -946,7 +950,7 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 
 		/* Get the data from the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		result = alauda_write_lba(us, lba, page, pages, buffer,
 			blockbuffer);
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index c87ad1b..579e9f5 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -98,7 +98,8 @@ static int datafab_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -155,7 +156,7 @@ static int datafab_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg_idx, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -181,7 +182,8 @@ static int datafab_write_data(struct us_data *us,
 	unsigned char thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -217,7 +219,7 @@ static int datafab_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg_idx, &sg_offset, FROM_XFER_BUF);
+				&sg, &sg_offset, FROM_XFER_BUF);
 
 		command[0] = 0;
 		command[1] = thistime;
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 003fcf5..61097cb 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -119,7 +119,8 @@ static int jumpshot_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -170,7 +171,7 @@ static int jumpshot_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg_idx, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -195,7 +196,8 @@ static int jumpshot_write_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result, waitcount;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -225,7 +227,7 @@ static int jumpshot_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg_idx, &sg_offset, FROM_XFER_BUF);
+				&sg, &sg_offset, FROM_XFER_BUF);
 
 		command[0] = 0;
 		command[1] = thistime;
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 9ad3042..cc8f7c5 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -157,7 +157,7 @@ void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
  * pick up from where this one left off. */
 
 unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, unsigned int *index,
+	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
 	unsigned int *offset, enum xfer_buf_dir dir)
 {
 	unsigned int cnt;
@@ -184,16 +184,17 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 	 * located in high memory -- then kmap() will map it to a temporary
 	 * position in the kernel's virtual address space. */
 	} else {
-		struct scatterlist *sg =
-				(struct scatterlist *) srb->request_buffer
-				+ *index;
+		struct scatterlist *sg = *sgptr;
+
+		if (!sg)
+			sg = (struct scatterlist *) srb->request_buffer;
 
 		/* This loop handles a single s-g list entry, which may
 		 * include multiple pages.  Find the initial page structure
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen && *index < srb->use_sg) {
+		while (cnt < buflen) {
 			struct page *page = sg->page +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
@@ -209,8 +210,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 
 				/* Transfer continues to next s-g entry */
 				*offset = 0;
-				++*index;
-				++sg;
+				sg = sg_next(sg);
 			}
 
 			/* Transfer the data for all the pages in this
@@ -234,6 +234,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 				sglen -= plen;
 			}
 		}
+		*sgptr = sg;
 	}
 
 	/* Return the amount actually transferred */
@@ -245,9 +246,10 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 void usb_stor_set_xfer_buf(unsigned char *buffer,
 	unsigned int buflen, struct scsi_cmnd *srb)
 {
-	unsigned int index = 0, offset = 0;
+	unsigned int offset = 0;
+	struct scatterlist *sg = NULL;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &index, &offset,
+	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
 	if (buflen < srb->request_bufflen)
 		srb->resid = srb->request_bufflen - buflen;
diff --git a/drivers/usb/storage/protocol.h b/drivers/usb/storage/protocol.h
index 845bed4..8737a36 100644
--- a/drivers/usb/storage/protocol.h
+++ b/drivers/usb/storage/protocol.h
@@ -52,7 +52,7 @@ extern void usb_stor_transparent_scsi_command(struct scsi_cmnd*,
 enum xfer_buf_dir	{TO_XFER_BUF, FROM_XFER_BUF};
 
 extern unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, unsigned int *index,
+	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **,
 	unsigned int *offset, enum xfer_buf_dir dir);
 
 extern void usb_stor_set_xfer_buf(unsigned char *buffer,
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index b2ed2a3..b12202c 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -705,7 +705,8 @@ sddr09_read_data(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int lba, maxlba, pba;
 	unsigned int page, pages;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 	int result;
 
 	// Figure out the initial LBA and page
@@ -730,7 +731,8 @@ sddr09_read_data(struct us_data *us,
 	// contiguous LBA's. Another exercise left to the student.
 
 	result = 0;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -777,7 +779,7 @@ sddr09_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -931,7 +933,8 @@ sddr09_write_data(struct us_data *us,
 	unsigned int pagelen, blocklen;
 	unsigned char *blockbuffer;
 	unsigned char *buffer;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 	int result;
 
 	// Figure out the initial LBA and page
@@ -968,7 +971,8 @@ sddr09_write_data(struct us_data *us,
 	}
 
 	result = 0;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -987,7 +991,7 @@ sddr09_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		result = sddr09_write_lba(us, lba, page, pages,
 				buffer, blockbuffer);
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 0b1b5b5..d43a341 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -167,7 +167,8 @@ static int sddr55_read_data(struct us_data *us,
 	unsigned long address;
 
 	unsigned short pages;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 
 	// Since we only read in one block at a time, we have to create
 	// a bounce buffer and move the data a piece at a time between the
@@ -178,7 +179,8 @@ static int sddr55_read_data(struct us_data *us,
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR; /* out of memory */
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors>0) {
 
@@ -255,7 +257,7 @@ static int sddr55_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -287,7 +289,8 @@ static int sddr55_write_data(struct us_data *us,
 
 	unsigned short pages;
 	int i;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 
 	/* check if we are allowed to write */
 	if (info->read_only || info->force_read_only) {
@@ -304,7 +307,8 @@ static int sddr55_write_data(struct us_data *us,
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -322,7 +326,7 @@ static int sddr55_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		US_DEBUGP("Write %02X pages, to PBA %04X"
 			" (LBA %04X) page %02X\n",
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 5e27297..a0ff394 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -996,7 +996,8 @@ static int usbat_flash_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1050,7 +1051,7 @@ static int usbat_flash_read_data(struct us_data *us,
 	
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg_idx, &sg_offset, TO_XFER_BUF);
+					 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -1086,7 +1087,8 @@ static int usbat_flash_write_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1125,7 +1127,7 @@ static int usbat_flash_write_data(struct us_data *us,
 
 		/* Get the data from the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg_idx, &sg_offset, FROM_XFER_BUF);
+					 &sg, &sg_offset, FROM_XFER_BUF);
 
 		/* ATA command 0x30 (WRITE SECTORS) */
 		usbat_pack_ata_sector_cmd(command, thistime, sector, 0x30);
@@ -1165,8 +1167,8 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int len;
 	unsigned int sector;
-	unsigned int sg_segment = 0;
 	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	US_DEBUGP("handle_read10: transfersize %d\n",
 		srb->transfersize);
@@ -1223,9 +1225,6 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	sector |= short_pack(data[7+5], data[7+4]);
 	transferred = 0;
 
-	sg_segment = 0; /* for keeping track of where we are in */
-	sg_offset = 0;  /* the scatter/gather list */
-
 	while (transferred != srb->request_bufflen) {
 
 		if (len > srb->request_bufflen - transferred)
@@ -1258,7 +1257,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, srb,
-				 &sg_segment, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		/* Update the amount transferred and the sector number */
 
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 52f53e2..0ae1dcf 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -836,7 +836,7 @@ static inline int i2o_dma_map_sg(struct i2o_controller *c,
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
 			*mptr++ = cpu_to_le32(i2o_dma_high(sg_dma_address(sg)));
 #endif
-		sg++;
+		sg = sg_next(sg);
 	}
 	*sg_ptr = mptr;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 07aba87..fe81b05 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -764,7 +764,7 @@ typedef struct hwif_s {
 
 	unsigned int nsect;
 	unsigned int nleft;
-	unsigned int cursg;
+	struct scatterlist *cursg;
 	unsigned int cursg_ofs;
 
 	int		rqsize;		/* max sectors per request */
