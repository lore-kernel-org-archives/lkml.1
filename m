Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYABQ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYABQ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYABQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:25:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYABQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:25:54 -0500
Date: Wed, 2 Jan 2008 17:25:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080102162534.GA4041@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revert commit:

  commit 6f5391c283d7fdcf24bf40786ea79061919d1e1d
  Author: Matthew Wilcox <matthew@wil.cx>
  Date:   Tue Sep 25 12:42:04 2007 -0400

      [SCSI] Get rid of scsi_cmnd->done

this is a supposed-to-be-cleanup commit, but apparently it causes
regressions:

  Bug 9370 - v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
  http://bugzilla.kernel.org/show_bug.cgi?id=9370

this patch should be reintroduced in a more split-up form to make
testing of it easier.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/scsi.c        |   20 +++-----------------
 drivers/scsi/scsi_error.c  |    1 +
 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 drivers/scsi/scsi_priv.h   |    1 -
 drivers/scsi/sd.c          |   28 ++++++++++------------------
 drivers/scsi/sr.c          |   21 +++++++++++++++------
 include/scsi/scsi_cmnd.h   |    2 ++
 include/scsi/scsi_driver.h |    1 -
 include/scsi/sd.h          |   13 +++++++++++++
 9 files changed, 58 insertions(+), 43 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -59,7 +59,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
@@ -368,8 +367,9 @@ void scsi_log_send(struct scsi_cmnd *cmd
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
+				       " done = 0x%p, queuecommand 0x%p\n",
 					scsi_sglist(cmd), scsi_bufflen(cmd),
+					cmd->done,
 					cmd->device->host->hostt->queuecommand);
 
 			}
@@ -654,12 +654,6 @@ void __scsi_done(struct scsi_cmnd *cmd)
 	blk_complete_request(rq);
 }
 
-/* Move this to a header if it becomes more generally useful */
-static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
-{
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
-}
-
 /*
  * Function:    scsi_finish_command
  *
@@ -671,8 +665,6 @@ void scsi_finish_command(struct scsi_cmn
 {
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
-	struct scsi_driver *drv;
-	unsigned int good_bytes;
 
 	scsi_device_unbusy(sdev);
 
@@ -698,13 +690,7 @@ void scsi_finish_command(struct scsi_cmn
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = cmd->request_bufflen;
-        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
-			good_bytes = drv->done(cmd);
-	}
-	scsi_io_completion(cmd, good_bytes);
+	cmd->done(cmd);
 }
 EXPORT_SYMBOL(scsi_finish_command);
 
Index: linux/drivers/scsi/scsi_error.c
===================================================================
--- linux.orig/drivers/scsi/scsi_error.c
+++ linux/drivers/scsi/scsi_error.c
@@ -1699,6 +1699,7 @@ scsi_reset_provider(struct scsi_device *
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
+	scmd->done			= NULL;
 	scmd->request_buffer		= NULL;
 	scmd->request_bufflen		= 0;
 
Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c
+++ linux/drivers/scsi/scsi_lib.c
@@ -1092,6 +1092,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 	scsi_end_request(cmd, 0, this_count, !result);
 }
+EXPORT_SYMBOL(scsi_io_completion);
 
 /*
  * Function:    scsi_init_io()
@@ -1170,6 +1171,18 @@ static struct scsi_cmnd *scsi_get_cmd_fr
 	return cmd;
 }
 
+static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
+{
+	BUG_ON(!blk_pc_request(cmd->request));
+	/*
+	 * This will complete the whole command with uptodate=1 so
+	 * as far as the block layer is concerned the command completed
+	 * successfully. Since this is a REQ_BLOCK_PC command the
+	 * caller should check the request's errors value
+	 */
+	scsi_io_completion(cmd, cmd->request_bufflen);
+}
+
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
@@ -1219,6 +1232,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
+	cmd->done = scsi_blk_pc_done;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
Index: linux/drivers/scsi/scsi_priv.h
===================================================================
--- linux.orig/drivers/scsi/scsi_priv.h
+++ linux/drivers/scsi/scsi_priv.h
@@ -68,7 +68,6 @@ extern int scsi_maybe_unblock_host(struc
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
-extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(struct request_queue *q);
Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c
+++ linux/drivers/scsi/sd.c
@@ -86,19 +86,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
-static int  sd_revalidate_disk(struct gendisk *);
-static int  sd_probe(struct device *);
-static int  sd_remove(struct device *);
-static void sd_shutdown(struct device *);
-static int sd_suspend(struct device *, pm_message_t state);
-static int sd_resume(struct device *);
-static void sd_rescan(struct device *);
-static int sd_done(struct scsi_cmnd *);
-static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
-static void scsi_disk_release(struct class_device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(struct scsi_disk *, int);
-
 static DEFINE_IDR(sd_index_idr);
 static DEFINE_SPINLOCK(sd_index_lock);
 
@@ -253,7 +240,6 @@ static struct scsi_driver sd_template = 
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
-	.done			= sd_done,
 };
 
 /*
@@ -523,6 +509,12 @@ static int sd_prep_fn(struct request_que
 	SCpnt->timeout_per_command = timeout;
 
 	/*
+	 * This is the completion routine we use.  This is matched in terms
+	 * of capability to this function.
+	 */
+	SCpnt->done = sd_rw_intr;
+
+	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
@@ -895,13 +887,13 @@ static struct block_device_operations sd
 };
 
 /**
- *	sd_done - bottom half handler: called when the lower level
+ *	sd_rw_intr - bottom half handler: called when the lower level
  *	driver has completed (successfully or otherwise) a scsi command.
  *	@SCpnt: mid-level's per command structure.
  *
  *	Note: potentially run from within an ISR. Must not block.
  **/
-static int sd_done(struct scsi_cmnd *SCpnt)
+static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
  	unsigned int xfer_size = SCpnt->request_bufflen;
@@ -922,7 +914,7 @@ static int sd_done(struct scsi_cmnd *SCp
 	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
 	if (sense_valid) {
 		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
-						   "sd_done: sb[respc,sk,asc,"
+						   "sd_rw_intr: sb[respc,sk,asc,"
 						   "ascq]=%x,%x,%x,%x\n",
 						   sshdr.response_code,
 						   sshdr.sense_key, sshdr.asc,
@@ -994,7 +986,7 @@ static int sd_done(struct scsi_cmnd *SCp
 		break;
 	}
  out:
-	return good_bytes;
+	scsi_io_completion(SCpnt, good_bytes);
 }
 
 static int media_not_present(struct scsi_disk *sdkp,
Index: linux/drivers/scsi/sr.c
===================================================================
--- linux.orig/drivers/scsi/sr.c
+++ linux/drivers/scsi/sr.c
@@ -78,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
-static int sr_done(struct scsi_cmnd *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -87,7 +86,6 @@ static struct scsi_driver sr_template = 
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 	},
-	.done			= sr_done,
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
@@ -210,12 +208,12 @@ static int sr_media_change(struct cdrom_
 }
  
 /*
- * sr_done is the interrupt routine for the device driver.
+ * rw_intr is the interrupt routine for the device driver.
  *
- * It will be notified on the end of a SCSI read / write, and will take one
+ * It will be notified on the end of a SCSI read / write, and will take on
  * of several actions based on success or failure.
  */
-static int sr_done(struct scsi_cmnd *SCpnt)
+static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
 	int this_count = SCpnt->request_bufflen;
@@ -288,7 +286,12 @@ static int sr_done(struct scsi_cmnd *SCp
 		}
 	}
 
-	return good_bytes;
+	/*
+	 * This calls the generic completion function, now that we know
+	 * how many actual sectors finished, and how many sectors we need
+	 * to say have failed.
+	 */
+	scsi_io_completion(SCpnt, good_bytes);
 }
 
 static int sr_prep_fn(struct request_queue *q, struct request *rq)
@@ -425,6 +428,12 @@ static int sr_prep_fn(struct request_que
 	SCpnt->timeout_per_command = timeout;
 
 	/*
+	 * This is the completion routine we use.  This is matched in terms
+	 * of capability to this function.
+	 */
+	SCpnt->done = rw_intr;
+
+	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
Index: linux/include/scsi/scsi_cmnd.h
===================================================================
--- linux.orig/include/scsi/scsi_cmnd.h
+++ linux/include/scsi/scsi_cmnd.h
@@ -34,6 +34,7 @@ struct scsi_cmnd {
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	int eh_eflags;		/* Used by error handlr */
+	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
 
 	/*
 	 * A SCSI Command is assigned a nonzero serial_number before passed
@@ -121,6 +122,7 @@ extern struct scsi_cmnd *__scsi_get_comm
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
+extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
Index: linux/include/scsi/scsi_driver.h
===================================================================
--- linux.orig/include/scsi/scsi_driver.h
+++ linux/include/scsi/scsi_driver.h
@@ -15,7 +15,6 @@ struct scsi_driver {
 	struct device_driver	gendrv;
 
 	void (*rescan)(struct device *);
-	int (*done)(struct scsi_cmnd *);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
Index: linux/include/scsi/sd.h
===================================================================
--- linux.orig/include/scsi/sd.h
+++ linux/include/scsi/sd.h
@@ -47,6 +47,19 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
+static int  sd_revalidate_disk(struct gendisk *disk);
+static void sd_rw_intr(struct scsi_cmnd * SCpnt);
+static int  sd_probe(struct device *);
+static int  sd_remove(struct device *);
+static void sd_shutdown(struct device *dev);
+static int sd_suspend(struct device *dev, pm_message_t state);
+static int sd_resume(struct device *dev);
+static void sd_rescan(struct device *);
+static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
+static void scsi_disk_release(struct class_device *cdev);
+static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+static void sd_print_result(struct scsi_disk *, int);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\

