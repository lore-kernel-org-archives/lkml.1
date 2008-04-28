Return-Path: <linux-kernel-owner+w=401wt.eu-S935941AbYD1XuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935941AbYD1XuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934871AbYD1Xt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:49:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:25522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYD1Xtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Wq9sDebrbXqgbhBhkbZwNFYCroZKC8Vz6sDV2tL5yVAwnn3RTfxz9SEBFL0Jx+oKiOt1tZLb62ZhKn2R5JcxEgLcnTgFSl/h6kja2ME6frUzTZ9b8zB43NWYrQV0b+vLskBppCp+9YC+R1tGooLcKVmrI01QsOG7EiYMlYxR0vI=
Subject: [PATCH 1/3] scsi: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 16:50:03 -0700
Message-Id: <1209426603.24729.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/aic7xxx/aic7770_osm.c:53:58: warning: Using plain integer as NULL pointer
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:355:47: warning: Using plain integer as NULL pointer
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:372:55: warning: Using plain integer as NULL pointer
drivers/scsi/aha152x.c:997:28: warning: Using plain integer as NULL pointer
drivers/scsi/aha152x.c:1003:28: warning: Using plain integer as NULL pointer
drivers/scsi/aha152x.c:1165:46: warning: Using plain integer as NULL pointer
drivers/scsi/fdomain.c:1446:40: warning: Using plain integer as NULL pointer
drivers/scsi/sym53c8xx_2/sym_hipd.c:1650:51: warning: Using plain integer as NULL pointer
drivers/scsi/sym53c8xx_2/sym_hipd.c:3171:42: warning: Using plain integer as NULL pointer
drivers/scsi/sym53c8xx_2/sym_hipd.c:5732:52: warning: Using plain integer as NULL pointer
drivers/scsi/ncr53c8xx.c:8189:31: warning: Using plain integer as NULL pointer
drivers/scsi/ncr53c8xx.c:8225:34: warning: Using plain integer as NULL pointer
drivers/scsi/dpt_i2o.c:156:32: warning: Using plain integer as NULL pointer
drivers/scsi/ultrastor.c:954:42: warning: Using plain integer as NULL pointer
drivers/scsi/ultrastor.c:1104:18: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/aha152x.c                 |    6 +++---
 drivers/scsi/aic7xxx/aic7770_osm.c     |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    4 ++--
 drivers/scsi/dpt_i2o.c                 |    2 +-
 drivers/scsi/fdomain.c                 |    2 +-
 drivers/scsi/ncr53c8xx.c               |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_hipd.c    |    6 +++---
 drivers/scsi/ultrastor.c               |    4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index a09b2d3..f5215fd 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -994,13 +994,13 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	SCpnt->SCp.sent_command	= 0;
 
 	if(SCpnt->SCp.phase & (resetting|check_condition)) {
-		if(SCpnt->host_scribble==0 || SCSEM(SCpnt) || SCNEXT(SCpnt)) {
+		if (!SCpnt->host_scribble || SCSEM(SCpnt) || SCNEXT(SCpnt)) {
 			printk(ERR_LEAD "cannot reuse command\n", CMDINFO(SCpnt));
 			return FAILED;
 		}
 	} else {
 		SCpnt->host_scribble = kmalloc(sizeof(struct aha152x_scdata), GFP_ATOMIC);
-		if(SCpnt->host_scribble==0) {
+		if(!SCpnt->host_scribble) {
 			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
 			return FAILED;
 		}
@@ -1162,7 +1162,7 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	}
 
 	DO_LOCK(flags);
-	issued       = remove_SC(&ISSUE_SC, SCpnt)==0;
+	issued       = remove_SC(&ISSUE_SC, SCpnt) == NULL;
 	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
 	DO_UNLOCK(flags);
 
diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
index 1ac1197..f220e5e 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -50,7 +50,7 @@ aic7770_map_registers(struct ahc_softc *ahc, u_int port)
 	/*
 	 * Lock out other contenders for our i/o space.
 	 */
-	if (request_region(port, AHC_EISA_IOSIZE, "aic7xxx") == 0)
+	if (!request_region(port, AHC_EISA_IOSIZE, "aic7xxx"))
 		return (ENOMEM);
 	ahc->tag = BUS_SPACE_PIO;
 	ahc->bsh.ioport = port;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index 0d7628f..00f5b98 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -352,7 +352,7 @@ ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, resource_size_t *base)
 	*base = pci_resource_start(ahc->dev_softc, 0);
 	if (*base == 0)
 		return (ENOMEM);
-	if (request_region(*base, 256, "aic7xxx") == 0)
+	if (!request_region(*base, 256, "aic7xxx"))
 		return (ENOMEM);
 	return (0);
 }
@@ -369,7 +369,7 @@ ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 	start = pci_resource_start(ahc->dev_softc, 1);
 	if (start != 0) {
 		*bus_addr = start;
-		if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
+		if (!request_mem_region(start, 0x1000, "aic7xxx"))
 			error = ENOMEM;
 		if (error == 0) {
 			*maddr = ioremap_nocache(start, 256);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index c9dd839..ac92ac1 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -153,7 +153,7 @@ static DEFINE_SPINLOCK(adpt_post_wait_lock);
 
 static u8 adpt_read_blink_led(adpt_hba* host)
 {
-	if(host->FwDebugBLEDflag_P != 0) {
+	if (host->FwDebugBLEDflag_P) {
 		if( readb(host->FwDebugBLEDflag_P) == 0xbc ){
 			return readb(host->FwDebugBLEDvalue_P);
 		}
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 2cd6b49..c33bcb2 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1443,7 +1443,7 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
 	   current_SC->SCp.this_residual    = current_SC->SCp.buffer->length;
 	   current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
    } else {
-	   current_SC->SCp.ptr              = 0;
+	   current_SC->SCp.ptr              = NULL;
 	   current_SC->SCp.this_residual    = 0;
 	   current_SC->SCp.buffer           = NULL;
 	   current_SC->SCp.buffers_residual = 0;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index d892894..ceab4f7 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8186,7 +8186,7 @@ static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd)
 	cmd->next_wcmd = NULL;
 	if (!(wcmd = np->waiting_list)) np->waiting_list = cmd;
 	else {
-		while ((wcmd->next_wcmd) != 0)
+		while (wcmd->next_wcmd)
 			wcmd = (struct scsi_cmnd *) wcmd->next_wcmd;
 		wcmd->next_wcmd = (char *) cmd;
 	}
@@ -8222,7 +8222,7 @@ static void process_waiting_list(struct ncb *np, int sts)
 #ifdef DEBUG_WAITING_LIST
 	if (waiting_list) printk("%s: waiting_list=%lx processing sts=%d\n", ncr_name(np), (u_long) waiting_list, sts);
 #endif
-	while ((wcmd = waiting_list) != 0) {
+	while (wcmd = waiting_list) {
 		waiting_list = (struct scsi_cmnd *) wcmd->next_wcmd;
 		wcmd->next_wcmd = NULL;
 		if (sts == DID_OK) {
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 35142b5..22a6aae 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1647,7 +1647,7 @@ static void sym_flush_comp_queue(struct sym_hcb *np, int cam_status)
 	SYM_QUEHEAD *qp;
 	struct sym_ccb *cp;
 
-	while ((qp = sym_remque_head(&np->comp_ccbq)) != 0) {
+	while ((qp = sym_remque_head(&np->comp_ccbq)) != NULL) {
 		struct scsi_cmnd *cmd;
 		cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		sym_insque_tail(&cp->link_ccbq, &np->busy_ccbq);
@@ -3168,7 +3168,7 @@ int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int
 	 *  the COMP queue and put back other ones into 
 	 *  the BUSY queue.
 	 */
-	while ((qp = sym_remque_head(&qtmp)) != 0) {
+	while ((qp = sym_remque_head(&qtmp)) != NULL) {
 		struct scsi_cmnd *cmd;
 		cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		cmd = cp->cmd;
@@ -5729,7 +5729,7 @@ void sym_hcb_free(struct sym_hcb *np)
 		sym_mfree_dma(np->dqueue, sizeof(u32)*(MAX_QUEUE*2), "DQUEUE");
 
 	if (np->actccbs) {
-		while ((qp = sym_remque_head(&np->free_ccbq)) != 0) {
+		while ((qp = sym_remque_head(&np->free_ccbq)) != NULL) {
 			cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 			sym_mfree_dma(cp, sizeof(*cp), "CCB");
 		}
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index f385dce..27aa40f 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -951,7 +951,7 @@ static int ultrastor_abort(struct scsi_cmnd *SCpnt)
 	printk("abort: command mismatch, %p != %p\n",
 	       config.mscp[mscp_index].SCint, SCpnt);
 #endif
-    if (config.mscp[mscp_index].SCint == 0)
+    if (config.mscp[mscp_index].SCint == NULL)
 	return FAILED;
 
     if (config.mscp[mscp_index].SCint != SCpnt) panic("Bad abort");
@@ -1101,7 +1101,7 @@ static void ultrastor_interrupt(void *dev_id)
     SCtmp = mscp->SCint;
     mscp->SCint = NULL;
 
-    if (SCtmp == 0)
+    if (!SCtmp)
       {
 #if ULTRASTOR_DEBUG & (UD_ABORT|UD_INTERRUPT)
 	printk("MSCP %d (%x): no command\n", mscp_index, (unsigned int) mscp);
-- 
1.5.5.1.270.g89765


