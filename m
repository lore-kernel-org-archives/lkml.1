Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966428Ab0BZV6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:58:44 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20447 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966401Ab0BZV6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:58:37 -0500
Subject: [PATCH 8/9] cciss: eliminate unnecessary pointer use in cciss scsi
	code
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
Date: Fri, 26 Feb 2010 16:01:47 -0600
Message-ID: <20100226220147.11979.65187.stgit@beardog.cce.hp.com>
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: eliminate unnecessary pointer use in cciss scsi code
An extra level of indirection was being used in some places
for no real reason.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index c458232..6dc15b6 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1400,7 +1400,7 @@ cciss_scatter_gather(struct pci_dev *pdev,
 static int
 cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 {
-	ctlr_info_t **c;
+	ctlr_info_t *c;
 	int ctlr, rc;
 	unsigned char scsi3addr[8];
 	CommandList_struct *cp;
@@ -1408,8 +1408,8 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 
 	// Get the ptr to our adapter structure (hba[i]) out of cmd->host.
 	// We violate cmd->host privacy here.  (Is there another way?)
-	c = (ctlr_info_t **) &cmd->device->host->hostdata[0];	
-	ctlr = (*c)->ctlr;
+	c = (ctlr_info_t *) cmd->device->host->hostdata[0];
+	ctlr = c->ctlr;
 
 	rc = lookup_scsi3addr(ctlr, cmd->device->channel, cmd->device->id, 
 			cmd->device->lun, scsi3addr);
@@ -1432,7 +1432,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
            see what the device thinks of it. */
 
 	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	cp = scsi_cmd_alloc(*c);
+	cp = scsi_cmd_alloc(c);
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	if (cp == NULL) {			/* trouble... */
 		printk("scsi_cmd_alloc returned NULL!\n");
@@ -1490,15 +1490,14 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		BUG();
 		break;
 	}
-
-	cciss_scatter_gather((*c)->pdev, cp, cmd); // Fill the SG list
+	cciss_scatter_gather(c->pdev, cp, cmd);
 
 	/* Put the request on the tail of the request queue */
 
 	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	addQ(&(*c)->reqQ, cp);
-	(*c)->Qdepth++;
-	start_io(*c);
+	addQ(&c->reqQ, cp);
+	c->Qdepth++;
+	start_io(c);
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
@@ -1655,14 +1654,14 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	int rc;
 	CommandList_struct *cmd_in_trouble;
 	unsigned char lunaddr[8];
-	ctlr_info_t **c;
+	ctlr_info_t *c;
 	int ctlr;
 
 	/* find the controller to which the command to be aborted was sent */
-	c = (ctlr_info_t **) &scsicmd->device->host->hostdata[0];	
+	c = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
 	if (c == NULL) /* paranoia */
 		return FAILED;
-	ctlr = (*c)->ctlr;
+	ctlr = c->ctlr;
 	printk(KERN_WARNING "cciss%d: resetting tape drive or medium changer.\n", ctlr);
 	/* find the command that's giving us trouble */
 	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
@@ -1672,7 +1671,7 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = sendcmd_withirq(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
-	if (rc == 0 && wait_for_device_to_become_ready(*c, lunaddr) == 0)
+	if (rc == 0 && wait_for_device_to_become_ready(c, lunaddr) == 0)
 		return SUCCESS;
 	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
 	return FAILED;
@@ -1683,14 +1682,14 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 	int rc;
 	CommandList_struct *cmd_to_abort;
 	unsigned char lunaddr[8];
-	ctlr_info_t **c;
+	ctlr_info_t *c;
 	int ctlr;
 
 	/* find the controller to which the command to be aborted was sent */
-	c = (ctlr_info_t **) &scsicmd->device->host->hostdata[0];	
+	c = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
 	if (c == NULL) /* paranoia */
 		return FAILED;
-	ctlr = (*c)->ctlr;
+	ctlr = c->ctlr;
 	printk(KERN_WARNING "cciss%d: aborting tardy SCSI cmd\n", ctlr);
 
 	/* find the command to be aborted */

