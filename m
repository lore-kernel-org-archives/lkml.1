Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXDFROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXDFROf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXDFROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:14:34 -0400
Received: from web33002.mail.mud.yahoo.com ([209.191.69.117]:44293 "HELO
	web33002.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933425AbXDFROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:14:33 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 13:14:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=QHUqg0n5NmHqgzxVwzBQfXiQQ7k5QVF0pK5/XciHkrbCLab2QGLeKBuYn196u/WnoZii5FZxsIo+rcDyAoNtpljW/SsRDVHIlhFWzy58/7pwd3DMLQ0mxwhsKn+maOnrWY689phkN8H/7WeZLcXurb8OkmXIkRoq5ZwkoaTRSpo=;
X-YMail-OSG: WWGKNnsVM1k9E.8t6MBOX8EIsFCJRfxvWs0zyq_TTXcG2ceLQHCiGNUolFYdQSIqCzQHucdheSyRoKzGvK5Hw2h.tDHDlGyoorfqc5xZ2MQJXNV.4KAbQd64RA--
Date: Fri, 6 Apr 2007 10:07:52 -0700 (PDT)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH] Perverting cciss
To: linux-kernel@vger.kernel.org
Cc: james.bottomley@steeleye.com, mike.miller@hp.com, steve.cameron@hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <438450.66991.qm@web33002.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Reinecke wrote:

> this patch adds the SG_IO ioctl to the cciss driver.
> As the driver is capable of sending SCSI CDBs to the controller there is
> no reason why we shouldn't exploit it.
> This way we get to use all the nice sg_utils for the cciss driver.
> And a persistent device name for free.

Christoph Hellwigg wrote:

> Instead of adding yet another implementation of SG_IO please implement
> support for REQ_TYPE_BLOCK_PC requests and add all the nice block layer
> passthrough ioctls to it. 

James Bottomley wrote:

> Actually, I happen to know that HP is in the process of implementing
> this correctly (via REQ_TYPE_BLOCK_PC).  I can't reveal the details but
> it has something to do with a well known Linux High Availability company
> needing SG_IO for sg_persist to work ... 

How about something like this:
(Since my mailer is sure to wreck the patch, it can be found intact here:
http://cciss.cvs.sourceforge.net/*checkout*/cciss/patches/kernel.org-2.6/cciss_sg_io_block_pc.patch?revision=1.1

-- steve

Add SG_IO to cciss driver.

Not completely sure all the error handling is correct.

---

 linux-2.6.21-rc6/drivers/block/cciss.c |   90 ++++++++++++++++++++-------------
 1 files changed, 56 insertions(+), 34 deletions(-)

diff -puN linux-2.6.21-rc6/drivers/block/cciss.c~cciss_sg_io_ioctl
linux-2.6.21-rc6/drivers/block/cciss.c
--- cciss_sg_io/linux-2.6.21-rc6/drivers/block/cciss.c~cciss_sg_io_ioctl	2007-04-06
08:11:59.000000000 -0500
+++ cciss_sg_io-scameron/linux-2.6.21-rc6/drivers/block/cciss.c	2007-04-06 11:38:40.000000000
-0500
@@ -45,7 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
-
+#include <scsi/sg.h>
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
 #define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
@@ -1152,6 +1152,7 @@ static int cciss_ioctl(struct inode *ino
 			kfree(ioc);
 			return status;
 		}
+	case SG_IO: return scsi_cmd_ioctl(filep, disk, cmd, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -2361,6 +2362,14 @@ static inline void complete_command(ctlr
 				       " byte 2 = 0x%x\n", cmd,
 				       cmd->err_info->SenseInfo[2]
 				    );
+				if (blk_pc_request(cmd->rq)) {
+					if (cmd->rq->sense) {
+						if (cmd->rq->sense_len > cmd->err_info->SenseLen)
+							cmd->rq->sense_len = cmd->err_info->SenseLen;
+						memcpy(cmd->rq->sense, cmd->err_info->SenseInfo, cmd->rq->sense_len);
+					} else
+						cmd->rq->sense_len = 0;
+				}
 				/* check the sense key */
 				sense_key = 0xf & cmd->err_info->SenseInfo[2];
 				/* no status or recovered error */
@@ -2374,14 +2383,16 @@ static inline void complete_command(ctlr
 			}
 			break;
 		case CMD_DATA_UNDERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data underrun "
-			       "reported\n", cmd);
+			if (blk_fs_request(cmd->rq))
+				printk(KERN_WARNING "cciss: cmd %p has"
+				       " completed with data underrun "
+				       "reported\n", cmd);
 			break;
 		case CMD_DATA_OVERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data overrun "
-			       "reported\n", cmd);
+			if (blk_fs_request(cmd->rq))
+				printk(KERN_WARNING "cciss: cmd %p has"
+				       " completed with data overrun "
+				       "reported\n", cmd);
 			break;
 		case CMD_INVALID:
 			printk(KERN_WARNING "cciss: cmd %p is "
@@ -2443,9 +2454,12 @@ static inline void complete_command(ctlr
 		resend_cciss_cmd(h, cmd);
 		return;
 	}
-
-	cmd->rq->completion_data = cmd;
 	cmd->rq->errors = status;
+	if (blk_pc_request(cmd->rq)) {
+		cmd->rq->errors |= 0xff & cmd->err_info->ScsiStatus;
+		cmd->rq->data_len = cmd->err_info->ResidualCnt;
+	}
+	cmd->rq->completion_data = cmd;
 	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
@@ -2539,32 +2553,40 @@ static void do_cciss_request(request_que
 #endif				/* CCISS_DEBUG */
 
 	c->Header.SGList = c->Header.SGTotal = seg;
-	if(h->cciss_read == CCISS_READ_10) {
-		c->Request.CDB[1] = 0;
-		c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
-		c->Request.CDB[3] = (start_blk >> 16) & 0xff;
-		c->Request.CDB[4] = (start_blk >> 8) & 0xff;
-		c->Request.CDB[5] = start_blk & 0xff;
-		c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
-		c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
-		c->Request.CDB[8] = creq->nr_sectors & 0xff;
-		c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
+	if (likely(blk_fs_request(creq))) {
+		if(h->cciss_read == CCISS_READ_10) {
+			c->Request.CDB[1] = 0;
+			c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
+			c->Request.CDB[3] = (start_blk >> 16) & 0xff;
+			c->Request.CDB[4] = (start_blk >> 8) & 0xff;
+			c->Request.CDB[5] = start_blk & 0xff;
+			c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
+			c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
+			c->Request.CDB[8] = creq->nr_sectors & 0xff;
+			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
+		} else {
+			c->Request.CDBLen = 16;
+			c->Request.CDB[1]= 0;
+			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
+			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
+			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
+			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
+			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
+			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
+			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
+			c->Request.CDB[9]= start_blk & 0xff;
+			c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
+			c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
+			c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
+			c->Request.CDB[13]= creq->nr_sectors & 0xff;
+			c->Request.CDB[14] = c->Request.CDB[15] = 0;
+		}
+	} else if (blk_pc_request(creq)) {
+		c->Request.CDBLen = creq->cmd_len;
+		memcpy(c->Request.CDB, creq->cmd, BLK_MAX_CDB);
 	} else {
-		c->Request.CDBLen = 16;
-		c->Request.CDB[1]= 0;
-		c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
-		c->Request.CDB[3]= (start_blk >> 48) & 0xff;
-		c->Request.CDB[4]= (start_blk >> 40) & 0xff;
-		c->Request.CDB[5]= (start_blk >> 32) & 0xff;
-		c->Request.CDB[6]= (start_blk >> 24) & 0xff;
-		c->Request.CDB[7]= (start_blk >> 16) & 0xff;
-		c->Request.CDB[8]= (start_blk >>  8) & 0xff;
-		c->Request.CDB[9]= start_blk & 0xff;
-		c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
-		c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
-		c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
-		c->Request.CDB[13]= creq->nr_sectors & 0xff;
-		c->Request.CDB[14] = c->Request.CDB[15] = 0;
+		printk(KERN_WARNING "cciss%d: bad request type %d\n", h->ctlr, creq->cmd_type);
+		BUG();
 	}
 
 	spin_lock_irq(q->queue_lock);
_



 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
