Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZKLStW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZKLStW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZKLStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:49:21 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5844 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZKLSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:12 -0500
Subject: [PATCH 06/11] cciss: remove sendcmd() as it is no longer used.
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:40 -0600
Message-ID: <20091112184940.23389.98902.stgit@beardog.cce.hp.com>
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

cciss: remove sendcmd() as it is no longer used.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |  163 -------------------------------------------------
 1 files changed, 0 insertions(+), 163 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f804542..23c2910 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -190,8 +190,6 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 static void __devinit cciss_interrupt_mode(ctlr_info_t *, struct pci_dev *,
 					   __u32);
 static void start_io(ctlr_info_t *h);
-static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
 			int cmd_type);
@@ -2808,167 +2806,6 @@ static int cciss_revalidate(struct gendisk *disk)
 }
 
 /*
- *   Wait polling for a command to complete.
- *   The memory mapped FIFO is polled for the completion.
- *   Used only at init time, interrupts from the HBA are disabled.
- */
-static unsigned long pollcomplete(int ctlr)
-{
-	unsigned long done;
-	int i;
-
-	/* Wait (up to 20 seconds) for a command to complete */
-
-	for (i = 20 * HZ; i > 0; i--) {
-		done = hba[ctlr]->access.command_completed(hba[ctlr]);
-		if (done == FIFO_EMPTY)
-			schedule_timeout_uninterruptible(1);
-		else
-			return done;
-	}
-	/* Invalid address to tell caller we ran out of time */
-	return 1;
-}
-
-/* Send command c to controller h and poll for it to complete.
- * Turns interrupts off on the board.  Used at driver init time
- * and during SCSI error recovery.
- */
-static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c)
-{
-	int i;
-	unsigned long complete;
-	int status = IO_ERROR;
-	u64bit buff_dma_handle;
-
-resend_cmd1:
-
-	/* Disable interrupt on the board. */
-	h->access.set_intr_mask(h, CCISS_INTR_OFF);
-
-	/* Make sure there is room in the command FIFO */
-	/* Actually it should be completely empty at this time */
-	/* unless we are in here doing error handling for the scsi */
-	/* tape side of the driver. */
-	for (i = 200000; i > 0; i--) {
-		/* if fifo isn't full go */
-		if (!(h->access.fifo_full(h)))
-			break;
-		udelay(10);
-		printk(KERN_WARNING "cciss cciss%d: SendCmd FIFO full,"
-		       " waiting!\n", h->ctlr);
-	}
-	h->access.submit_command(h, c); /* Send the cmd */
-	do {
-		complete = pollcomplete(h->ctlr);
-
-#ifdef CCISS_DEBUG
-		printk(KERN_DEBUG "cciss: command completed\n");
-#endif				/* CCISS_DEBUG */
-
-		if (complete == 1) {
-			printk(KERN_WARNING
-			       "cciss cciss%d: SendCmd Timeout out, "
-			       "No command list address returned!\n", h->ctlr);
-			status = IO_ERROR;
-			break;
-		}
-
-		/* Make sure it's the command we're expecting. */
-		if ((complete & ~CISS_ERROR_BIT) != c->busaddr) {
-			printk(KERN_WARNING "cciss%d: Unexpected command "
-				"completion.\n", h->ctlr);
-			continue;
-		}
-
-		/* It is our command.  If no error, we're done. */
-		if (!(complete & CISS_ERROR_BIT)) {
-			status = IO_OK;
-			break;
-		}
-
-		/* There is an error... */
-
-		/* if data overrun or underun on Report command ignore it */
-		if (((c->Request.CDB[0] == CISS_REPORT_LOG) ||
-		     (c->Request.CDB[0] == CISS_REPORT_PHYS) ||
-		     (c->Request.CDB[0] == CISS_INQUIRY)) &&
-			((c->err_info->CommandStatus == CMD_DATA_OVERRUN) ||
-			 (c->err_info->CommandStatus == CMD_DATA_UNDERRUN))) {
-			complete = c->busaddr;
-			status = IO_OK;
-			break;
-		}
-
-		if (c->err_info->CommandStatus == CMD_UNSOLICITED_ABORT) {
-			printk(KERN_WARNING "cciss%d: unsolicited abort %p\n",
-				h->ctlr, c);
-			if (c->retry_count < MAX_CMD_RETRIES) {
-				printk(KERN_WARNING "cciss%d: retrying %p\n",
-				   h->ctlr, c);
-				c->retry_count++;
-				/* erase the old error information */
-				memset(c->err_info, 0, sizeof(c->err_info));
-				goto resend_cmd1;
-			}
-			printk(KERN_WARNING "cciss%d: retried %p too many "
-				"times\n", h->ctlr, c);
-			status = IO_ERROR;
-			break;
-		}
-
-		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
-			printk(KERN_WARNING "cciss%d: command could not be "
-				"aborted.\n", h->ctlr);
-			status = IO_ERROR;
-			break;
-		}
-
-		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
-			status = check_target_status(h, c);
-			break;
-		}
-
-		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
-		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
-			c->Request.CDB[0], c->err_info->CommandStatus);
-		status = IO_ERROR;
-		break;
-
-	} while (1);
-
-	/* unlock the data buffer from DMA */
-	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
-	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
-			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
-	return status;
-}
-
-/*
- * Send a command to the controller, and wait for it to complete.
- * Used at init time, and during SCSI error recovery.
- */
-static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size,
-	__u8 page_code, unsigned char *scsi3addr, int cmd_type)
-{
-	CommandList_struct *c;
-	int status;
-
-	c = cmd_alloc(hba[ctlr], 1);
-	if (!c) {
-		printk(KERN_WARNING "cciss: unable to get memory");
-		return IO_ERROR;
-	}
-	status = fill_cmd(c, cmd, ctlr, buff, size, page_code,
-		scsi3addr, cmd_type);
-	if (status == IO_OK)
-		status = sendcmd_core(hba[ctlr], c);
-	cmd_free(hba[ctlr], c, 1);
-	return status;
-}
-
-/*
  * Map (physical) PCI mem into (virtual) kernel space
  */
 static void __iomem *remap_pci_mem(ulong base, ulong size)

