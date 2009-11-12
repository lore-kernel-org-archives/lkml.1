Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKLSsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKLSsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZKLSsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:05 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35093 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZKLSsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:02 -0500
Subject: [PATCH 04/11] cciss: Remove the "withirq" parameter from various
	functions where possible
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:30 -0600
Message-ID: <20091112184930.23389.16661.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss:  Remove the "withirq" parameter from various functions where possible

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   89 ++++++++++++++++---------------------------------
 1 files changed, 29 insertions(+), 60 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 429b9b6..4321c94 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -179,12 +179,12 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time, int via_ioctl);
 static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all, int via_ioctl);
 
-static void cciss_read_capacity(int ctlr, int logvol, int withirq,
+static void cciss_read_capacity(int ctlr, int logvol,
 			sector_t *total_size, unsigned int *block_size);
-static void cciss_read_capacity_16(int ctlr, int logvol, int withirq,
+static void cciss_read_capacity_16(int ctlr, int logvol,
 			sector_t *total_size, unsigned int *block_size);
 static void cciss_geometry_inquiry(int ctlr, int logvol,
-			int withirq, sector_t total_size,
+			sector_t total_size,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
 static void __devinit cciss_interrupt_mode(ctlr_info_t *, struct pci_dev *,
@@ -1701,7 +1701,7 @@ static inline void log_unit_to_scsi3addr(ctlr_info_t *h,
  * via the inquiry page 0.  Model, vendor, and rev are set to empty strings if
  * they cannot be read.
  */
-static void cciss_get_device_descr(int ctlr, int logvol, int withirq,
+static void cciss_get_device_descr(int ctlr, int logvol,
 				   char *vendor, char *model, char *rev)
 {
 	int rc;
@@ -1717,14 +1717,8 @@ static void cciss_get_device_descr(int ctlr, int logvol, int withirq,
 		return;
 
 	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	if (withirq)
-		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buf,
-			     sizeof(InquiryData_struct), 0,
-				scsi3addr, TYPE_CMD);
-	else
-		rc = sendcmd(CISS_INQUIRY, ctlr, inq_buf,
-			     sizeof(InquiryData_struct), 0,
-				scsi3addr, TYPE_CMD);
+	rc = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buf, sizeof(*inq_buf), 0,
+			scsi3addr, TYPE_CMD);
 	if (rc == IO_OK) {
 		memcpy(vendor, &inq_buf->data_byte[8], VENDOR_LEN);
 		vendor[VENDOR_LEN] = '\0';
@@ -1743,7 +1737,7 @@ static void cciss_get_device_descr(int ctlr, int logvol, int withirq,
  * number cannot be had, for whatever reason, 16 bytes of 0xff
  * are returned instead.
  */
-static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
+static void cciss_get_serial_no(int ctlr, int logvol,
 				unsigned char *serial_no, int buflen)
 {
 #define PAGE_83_INQ_BYTES 64
@@ -1759,12 +1753,8 @@ static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
 		return;
 	memset(serial_no, 0, buflen);
 	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	if (withirq)
-		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, buf,
-			PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
-	else
-		rc = sendcmd(CISS_INQUIRY, ctlr, buf,
-			PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
+	rc = sendcmd_withirq(CISS_INQUIRY, ctlr, buf,
+		PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
 	if (rc == IO_OK)
 		memcpy(serial_no, &buf[8], buflen);
 	kfree(buf);
@@ -1852,18 +1842,16 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 
 	/* testing to see if 16-byte CDBs are already being used */
 	if (h->cciss_read == CCISS_READ_16) {
-		cciss_read_capacity_16(h->ctlr, drv_index, 1,
+		cciss_read_capacity_16(h->ctlr, drv_index,
 			&total_size, &block_size);
 
 	} else {
-		cciss_read_capacity(ctlr, drv_index, 1,
-				    &total_size, &block_size);
-
+		cciss_read_capacity(ctlr, drv_index, &total_size, &block_size);
 		/* if read_capacity returns all F's this volume is >2TB */
 		/* in size so we switch to 16-byte CDB's for all */
 		/* read/write ops */
 		if (total_size == 0xFFFFFFFFULL) {
-			cciss_read_capacity_16(ctlr, drv_index, 1,
+			cciss_read_capacity_16(ctlr, drv_index,
 			&total_size, &block_size);
 			h->cciss_read = CCISS_READ_16;
 			h->cciss_write = CCISS_WRITE_16;
@@ -1873,14 +1861,14 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 		}
 	}
 
-	cciss_geometry_inquiry(ctlr, drv_index, 1, total_size, block_size,
+	cciss_geometry_inquiry(ctlr, drv_index, total_size, block_size,
 			       inq_buff, drvinfo);
 	drvinfo->block_size = block_size;
 	drvinfo->nr_blocks = total_size + 1;
 
-	cciss_get_device_descr(ctlr, drv_index, 1, drvinfo->vendor,
+	cciss_get_device_descr(ctlr, drv_index, drvinfo->vendor,
 				drvinfo->model, drvinfo->rev);
-	cciss_get_serial_no(ctlr, drv_index, 1, drvinfo->serial_no,
+	cciss_get_serial_no(ctlr, drv_index, drvinfo->serial_no,
 			sizeof(drvinfo->serial_no));
 	/* Save the lunid in case we deregister the disk, below. */
 	memcpy(drvinfo->LunID, h->drv[drv_index]->LunID,
@@ -2674,7 +2662,7 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 }
 
 static void cciss_geometry_inquiry(int ctlr, int logvol,
-				   int withirq, sector_t total_size,
+				   sector_t total_size,
 				   unsigned int block_size,
 				   InquiryData_struct *inq_buff,
 				   drive_info_struct *drv)
@@ -2685,14 +2673,8 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 
 	memset(inq_buff, 0, sizeof(InquiryData_struct));
 	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	if (withirq)
-		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
-					      inq_buff, sizeof(*inq_buff),
-					      0xC1, scsi3addr, TYPE_CMD);
-	else
-		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
-				      sizeof(*inq_buff), 0xC1, scsi3addr,
-				      TYPE_CMD);
+	return_code = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buff,
+			sizeof(*inq_buff), 0xC1, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		if (inq_buff->data_byte[8] == 0xFF) {
 			printk(KERN_WARNING
@@ -2725,7 +2707,7 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 }
 
 static void
-cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
+cciss_read_capacity(int ctlr, int logvol, sector_t *total_size,
 		    unsigned int *block_size)
 {
 	ReadCapdata_struct *buf;
@@ -2739,14 +2721,8 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 	}
 
 	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	if (withirq)
-		return_code = sendcmd_withirq(CCISS_READ_CAPACITY,
-				ctlr, buf, sizeof(ReadCapdata_struct),
-					0, scsi3addr, TYPE_CMD);
-	else
-		return_code = sendcmd(CCISS_READ_CAPACITY,
-				ctlr, buf, sizeof(ReadCapdata_struct),
-					0, scsi3addr, TYPE_CMD);
+	return_code = sendcmd_withirq(CCISS_READ_CAPACITY, ctlr, buf,
+		sizeof(ReadCapdata_struct), 0, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
@@ -2758,8 +2734,8 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 	kfree(buf);
 }
 
-static void
-cciss_read_capacity_16(int ctlr, int logvol, int withirq, sector_t *total_size, 				unsigned int *block_size)
+static void cciss_read_capacity_16(int ctlr, int logvol,
+	sector_t *total_size, unsigned int *block_size)
 {
 	ReadCapdata_struct_16 *buf;
 	int return_code;
@@ -2772,16 +2748,9 @@ cciss_read_capacity_16(int ctlr, int logvol, int withirq, sector_t *total_size,
 	}
 
 	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	if (withirq) {
-		return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
-			ctlr, buf, sizeof(ReadCapdata_struct_16),
-				0, scsi3addr, TYPE_CMD);
-	}
-	else {
-		return_code = sendcmd(CCISS_READ_CAPACITY_16,
-			ctlr, buf, sizeof(ReadCapdata_struct_16),
-				0, scsi3addr, TYPE_CMD);
-	}
+	return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
+		ctlr, buf, sizeof(ReadCapdata_struct_16),
+			0, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
@@ -2822,13 +2791,13 @@ static int cciss_revalidate(struct gendisk *disk)
 		return 1;
 	}
 	if (h->cciss_read == CCISS_READ_10) {
-		cciss_read_capacity(h->ctlr, logvol, 1,
+		cciss_read_capacity(h->ctlr, logvol,
 					&total_size, &block_size);
 	} else {
-		cciss_read_capacity_16(h->ctlr, logvol, 1,
+		cciss_read_capacity_16(h->ctlr, logvol,
 					&total_size, &block_size);
 	}
-	cciss_geometry_inquiry(h->ctlr, logvol, 1, total_size, block_size,
+	cciss_geometry_inquiry(h->ctlr, logvol, total_size, block_size,
 			       inq_buff, drv);
 
 	blk_queue_logical_block_size(drv->queue, drv->block_size);

