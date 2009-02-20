Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZBTINy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZBTINy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZBTINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:13:41 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:28370 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753107AbZBTINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:13:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:Content-Type:Date:Message-Id:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=hyIe+lcg87OCtTDxs4IzU1uN1+3d8yIgkKIttpk7hMr+6UMMdabwbnYhHmXzYgTRqioSvJfhhUK12W0R7IRzWbig8u53efThGaFWh5asIwX1Ld/4eFPsEFmAcACuFHtI83UvZw59uQQfwsVz6WtZZDBJrvgdo0weNZmbwSLbDYQ=  ;
X-YMail-OSG: bMIK2iYVM1kWGo7ghY04RGsJR0FItDX61do6gSjp.eokY6UYKlW6M.3EMj5c.RSvk.3qxm1s2W1sZjyyXT6bGcjtNI4xecIMMNaP25sTkUd7Lx5S45lRGhvLvsYlpAHUWw.tNMLT6E9G1l9RtH1yGM2NYT4HG2cA22djcpXpjVgYpVEdANUjU.FyGnSrbUSSUhnPCsGB55CftzbX9vdk.32f2OegFarpnxu7FEfxZhB0SeODKWU-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 6/7] [Target_Core_Mod/RAMDISK]: Add 4k sector/block size
	emulation support
From: "Nicholas A. Bellinger" <nicholas_bellinger@sbcglobal.net>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 00:05:53 -0800
Message-Id: <1235117153.12375.1048.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e534e9f02be94996536ce275da27734ba329572d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:43:20 -0800
Subject: [PATCH 6/7] [Target_Core_Mod/RAMDISK]: Add 4k sector/block size emulation support

This patch adds support for 4k (and all non 512 byte) sector sizes for the
Target_Core_Mod/ConfigFS interaction with RAMDISK_DR and RAMDISK_MCP objects.

This patch updates rd_emulate_read_cap(), rd_emulate_read_cap16() for control path
CDB emulation, and rd_MEMCPY_do_task() rd_DIRECT_do_se_mem_map() and rd_DIRECT_check_lba()
for LBA related ops.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_rd.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index 1c263cc..8c55c43 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -440,20 +440,23 @@ static int rd_emulate_inquiry (se_task_t *task)
 static int rd_emulate_read_cap (se_task_t *task)
 {
 	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
-	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;
+	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) /
+		       DEV_ATTRIB(task->se_dev)->block_size) - 1;
 
-	if ((((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1) > 0x00000000ffffffff)
+	if ((((rd_dev->rd_page_count * PAGE_SIZE) /
+	       DEV_ATTRIB(task->se_dev)->block_size) - 1) >= 0x00000000ffffffff)
 		blocks = 0xffffffff;
 
-	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks, RD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks));
 }
 
 static int rd_emulate_read_cap16 (se_task_t *task)
 {
 	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
-	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;	
+	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) /
+				   DEV_ATTRIB(task->se_dev)->block_size) - 1;	
 
-	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, RD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long));
 }
 
 /*	rd_emulate_scsi_cdb():
@@ -767,15 +770,17 @@ static int rd_MEMCPY_write (rd_request_t *req)
  */
 extern int rd_MEMCPY_do_task (se_task_t *task)
 {
-	int ret = 0;
+	se_device_t *dev = task->se_dev;
 	rd_request_t *req = (rd_request_t *) task->transport_req;
+	int ret;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return(rd_emulate_scsi_cdb(task));
 		
 	req->rd_lba = task->task_lba;
-	req->rd_page = (req->rd_lba * RD_BLOCKSIZE) / PAGE_SIZE;
-	req->rd_offset = (req->rd_lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE;
+	req->rd_page = (req->rd_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
+	req->rd_offset = (req->rd_lba % (PAGE_SIZE / DEV_ATTRIB(dev)->block_size)) *
+			  DEV_ATTRIB(dev)->block_size;
 	req->rd_size = task->task_size;
 
 	if (req->rd_data_direction == RD_DATA_READ)
@@ -979,8 +984,11 @@ extern int rd_DIRECT_do_se_mem_map (
 
 	req->rd_lba = task->task_lba;
 	req->rd_req_flags = RRF_GOT_LBA;
-	req->rd_page = ((req->rd_lba * RD_BLOCKSIZE) / PAGE_SIZE);
-	req->rd_offset = (req->rd_lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE;
+	req->rd_page = ((req->rd_lba * DEV_ATTRIB(task->se_dev)->block_size) /
+			PAGE_SIZE);
+	req->rd_offset = (req->rd_lba %
+			(PAGE_SIZE / DEV_ATTRIB(task->se_dev)->block_size)) *
+			DEV_ATTRIB(task->se_dev)->block_size;
 	req->rd_size = task->task_size;
 
 	if (req->rd_offset)
@@ -1301,7 +1309,8 @@ extern int rd_CDB_write_SG (se_task_t *task, u32 size)
  */
 extern int rd_DIRECT_check_lba (unsigned long long lba, se_device_t *dev)
 {
-	return(((lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE) ? 1 : 0);
+	return(((lba % (PAGE_SIZE / DEV_ATTRIB(dev)->block_size)) *
+		 DEV_ATTRIB(dev)->block_size) ? 1 : 0);
 }
 
 /*	rd_MEMCPY_check_lba():
-- 
1.5.4.1



