Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXHXSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXHXSHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761463AbXHXSGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:06:52 -0400
Received: from palrel11.hp.com ([156.153.255.246]:35155 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbXHXSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:06:51 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 14:06:51 EDT
Date: Fri, 24 Aug 2007 12:53:54 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: jens.axboe@oracle.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.linux.org, hch@infradead.org,
       james.bottomley@steeleye.com
Subject: [PATCH 1/1] cciss: fix error reporting for SG_IO
Message-ID: <20070824175354.GA14125@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Forwarded message from Steve Cameron <scameron@quandary.americas.cpqcorp.net> -----

Date: Fri, 24 Aug 2007 11:10:44 -0500
From: Steve Cameron <scameron@quandary.americas.cpqcorp.net>
To: mikem@beardog.cca.cpqcorp.net
Reply-To: steve.cameron@hp.com
Cc: steve.cameron@hp.com
Subject: Re: [PATCH 1/1] cciss: fix error reporting for SG_IO



This fixes a problem with the way cciss was filling out the "errors"
field of the request structure upon completion of requests. 
Previously, it just put a 1 or a 0 in there and used the negation
of this as the uptodate parameter to one of the functions in the
block layer, being a block device.  For the SG_IO ioctl, this was not
sufficient, and we noticed that, for example, sg_turs from sg3_utils 
did not correctly detect problems due to cciss having set rq->errors 
incorrectly.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>

 drivers/block/cciss.c |   79 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 18 deletions(-)

diff -puN drivers/block/cciss.c~sg_io_fix_error_reporting drivers/block/cciss.c
--- linux-2.6.23-rc2/drivers/block/cciss.c~sg_io_fix_error_reporting	2007-08-13 09:44:58.000000000 -0500
+++ linux-2.6.23-rc2-scameron/drivers/block/cciss.c	2007-08-24 10:56:56.000000000 -0500
@@ -2366,30 +2366,55 @@ static inline void resend_cciss_cmd(ctlr
 	start_io(h);
 }
 
+static inline unsigned int make_status_bytes(unsigned int scsi_status_byte,
+	unsigned int msg_byte, unsigned int host_byte,
+	unsigned int driver_byte)
+{
+	/* inverse of macros in scsi.h */
+	return (scsi_status_byte & 0xff) |
+		((msg_byte & 0xff) << 8) |
+		((host_byte & 0xff) << 16) |
+		((driver_byte & 0xff) << 24);
+}
+
 static inline int evaluate_target_status(CommandList_struct *cmd)
 {
 	unsigned char sense_key;
-	int error_count = 1;
+	unsigned char status_byte, msg_byte, host_byte, driver_byte;
+	int error_value;
+
+	/* If we get in here, it means we got "target status", that is, scsi status */
+	status_byte = cmd->err_info->ScsiStatus;
+	driver_byte = DRIVER_OK;
+	msg_byte = cmd->err_info->CommandStatus; /* correct?  seems too device specific */
+
+	if (blk_pc_request(cmd->rq))
+		host_byte = DID_PASSTHROUGH;
+	else
+		host_byte = DID_OK;
+
+	error_value = make_status_bytes(status_byte, msg_byte,
+		host_byte, driver_byte);
 
-	if (cmd->err_info->ScsiStatus != 0x02) { /* not check condition? */
+	if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
 		if (!blk_pc_request(cmd->rq))
 			printk(KERN_WARNING "cciss: cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
-		return error_count;
+		return error_value;
 	}
 
 	/* check the sense key */
 	sense_key = 0xf & cmd->err_info->SenseInfo[2];
 	/* no status or recovered error */
-	if ((sense_key == 0x0) || (sense_key == 0x1))
-		error_count = 0;
+	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
+		error_value = 0;
 
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
-		if (error_count != 0)
+		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
-		return error_count;
+		return error_value;
 	}
 
 	/* SG_IO or similar, copy sense data back */
@@ -2401,7 +2426,7 @@ static inline int evaluate_target_status
 	} else
 		cmd->rq->sense_len = 0;
 
-	return error_count;
+	return error_value;
 }
 
 /* checks the status of the job and calls complete buffers to mark all
@@ -2417,7 +2442,7 @@ static inline void complete_command(ctlr
 	rq->errors = 0;
 
 	if (timeout)
-		rq->errors = 1;
+		rq->errors = make_status_bytes(0, 0, 0, DRIVER_TIMEOUT);
 
 	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
 		goto after_error_processing;
@@ -2443,32 +2468,44 @@ static inline void complete_command(ctlr
 	case CMD_INVALID:
 		printk(KERN_WARNING "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_PROTOCOL_ERR:
 		printk(KERN_WARNING "cciss: cmd %p has "
 		       "protocol error \n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_HARDWARE_ERR:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       " hardware error\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_CONNECTION_LOST:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       "connection lost\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_ABORTED:
 		printk(KERN_WARNING "cciss: cmd %p was "
 		       "aborted\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
 		printk(KERN_WARNING "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNSOLICITED_ABORT:
 		printk(KERN_WARNING "cciss%d: unsolicited "
@@ -2482,17 +2519,23 @@ static inline void complete_command(ctlr
 			printk(KERN_WARNING
 			       "cciss%d: %p retried too "
 			       "many times\n", h->ctlr, cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
 		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	default:
 		printk(KERN_WARNING "cciss: cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 	}
 
 after_error_processing:
_

----- End forwarded message -----
