Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYEVWqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYEVWqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbYEVWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:45:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:61612 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYEVWpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sbydwziJkPKjTB5bWudNEQs89UR7Enf6FRH9aSEwBee+nFvryW3MrOWGaCsgslpGbMjXMXvbV6SoHanc0sUQmd6wWyKAHY/b2F4l2fwrTtueI4OEOoSbeBhfKsfrpeDiVESfjxOsCI5XLmTQbLQSdyXTAEN+XnhlzKDB02jYYyU=
Subject: [PATCH 4/5] scsi: fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:07 -0700
Message-Id: <1211496307.6888.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/aha152x.c:3585:60: warning: Using plain integer as NULL pointer
drivers/scsi/aha152x.c:3845:56: warning: Using plain integer as NULL pointer
drivers/scsi/qla1280.c:2814:37: warning: Using plain integer as NULL pointer
drivers/scsi/atp870u.c:750:47: warning: Using plain integer as NULL pointer
drivers/scsi/3w-9xxx.c:1281:36: warning: Using plain integer as NULL pointer
drivers/scsi/3w-9xxx.c:1293:36: warning: Using plain integer as NULL pointer
drivers/scsi/3w-9xxx.c:1301:35: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:447:10: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:457:10: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:479:24: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:483:22: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:1213:23: warning: Using plain integer as NULL pointer
drivers/scsi/hptiop.c:1214:23: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/3w-9xxx.c |    6 +++---
 drivers/scsi/aha152x.c |    4 ++--
 drivers/scsi/atp870u.c |    2 +-
 drivers/scsi/hptiop.c  |   12 ++++++------
 drivers/scsi/qla1280.c |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b31faec..867f6fd 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1278,7 +1278,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 			error = 0;
 			/* Check for command packet errors */
 			if (full_command_packet->command.newcommand.status != 0) {
-				if (tw_dev->srb[request_id] != 0) {
+				if (tw_dev->srb[request_id] != NULL) {
 					error = twa_fill_sense(tw_dev, request_id, 1, 1);
 				} else {
 					/* Skip ioctl error prints */
@@ -1290,7 +1290,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 
 			/* Check for correct state */
 			if (tw_dev->state[request_id] != TW_S_POSTED) {
-				if (tw_dev->srb[request_id] != 0) {
+				if (tw_dev->srb[request_id] != NULL) {
 					TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Received a request id that wasn't posted");
 					TW_CLEAR_ALL_INTERRUPTS(tw_dev);
 					goto twa_interrupt_bail;
@@ -1298,7 +1298,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 			}
 
 			/* Check for internal command completion */
-			if (tw_dev->srb[request_id] == 0) {
+			if (tw_dev->srb[request_id] == NULL) {
 				if (request_id != tw_dev->chrdev_request_id) {
 					if (twa_aen_complete(tw_dev, request_id))
 						TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Error completing AEN during attention interrupt");
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 1dca177..0899cb6 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3582,7 +3582,7 @@ static int checksetup(struct aha152x_setup *setup)
 	if (i == ARRAY_SIZE(ports))
 		return 0;
 
-	if ( request_region(setup->io_port, IO_RANGE, "aha152x")==0 ) {
+	if (!request_region(setup->io_port, IO_RANGE, "aha152x")) {
 		printk(KERN_ERR "aha152x: io port 0x%x busy.\n", setup->io_port);
 		return 0;
 	}
@@ -3842,7 +3842,7 @@ static int __init aha152x_init(void)
 			if ((setup_count == 1) && (setup[0].io_port == ports[i]))
 				continue;
 
-			if ( request_region(ports[i], IO_RANGE, "aha152x")==0 ) {
+			if (!request_region(ports[i], IO_RANGE, "aha152x")) {
 				printk(KERN_ERR "aha152x: io port 0x%x busy.\n", ports[i]);
 				continue;
 			}
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index db6de5e..7d31154 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -747,7 +747,7 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 		dev->quhd[c] = 0;
 	}
 	workreq = dev->quereq[c][dev->quhd[c]];
-	if (dev->id[c][scmd_id(workreq)].curr_req == 0) {	
+	if (dev->id[c][scmd_id(workreq)].curr_req == NULL) {
 		dev->id[c][scmd_id(workreq)].curr_req = workreq;
 		dev->last_cmd[c] = scmd_id(workreq);
 		goto cmd_subp;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index aaa48e0..da876d3 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -444,7 +444,7 @@ static void __iomem *hptiop_map_pci_bar(struct hptiop_hba *hba, int index)
 	if (!(pci_resource_flags(pcidev, index) & IORESOURCE_MEM)) {
 		printk(KERN_ERR "scsi%d: pci resource invalid\n",
 				hba->host->host_no);
-		return 0;
+		return NULL;
 	}
 
 	mem_base_phy = pci_resource_start(pcidev, index);
@@ -454,7 +454,7 @@ static void __iomem *hptiop_map_pci_bar(struct hptiop_hba *hba, int index)
 	if (!mem_base_virt) {
 		printk(KERN_ERR "scsi%d: Fail to ioremap memory space\n",
 				hba->host->host_no);
-		return 0;
+		return NULL;
 	}
 	return mem_base_virt;
 }
@@ -476,11 +476,11 @@ static void hptiop_unmap_pci_bar_itl(struct hptiop_hba *hba)
 static int hptiop_map_pci_bar_mv(struct hptiop_hba *hba)
 {
 	hba->u.mv.regs = hptiop_map_pci_bar(hba, 0);
-	if (hba->u.mv.regs == 0)
+	if (hba->u.mv.regs == NULL)
 		return -1;
 
 	hba->u.mv.mu = hptiop_map_pci_bar(hba, 2);
-	if (hba->u.mv.mu == 0) {
+	if (hba->u.mv.mu == NULL) {
 		iounmap(hba->u.mv.regs);
 		return -1;
 	}
@@ -1210,8 +1210,8 @@ static void hptiop_remove(struct pci_dev *pcidev)
 
 static struct hptiop_adapter_ops hptiop_itl_ops = {
 	.iop_wait_ready    = iop_wait_ready_itl,
-	.internal_memalloc = 0,
-	.internal_memfree  = 0,
+	.internal_memalloc = NULL,
+	.internal_memfree  = NULL,
 	.map_pci_bar       = hptiop_map_pci_bar_itl,
 	.unmap_pci_bar     = hptiop_unmap_pci_bar_itl,
 	.enable_intr       = hptiop_enable_intr_itl,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 51e2f29..3754ab8 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2811,7 +2811,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	/* Check for room in outstanding command list. */
 	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS &&
-		     ha->outstanding_cmds[cnt] != 0; cnt++);
+		     ha->outstanding_cmds[cnt] != NULL; cnt++);
 
 	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
 		status = 1;
-- 
1.5.5.1.579.g4e43


