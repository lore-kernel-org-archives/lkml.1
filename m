Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXLTGZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXLTGZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 01:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXLTGZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 01:25:46 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24792 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXLTGZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 01:25:44 -0500
Date: Wed, 19 Dec 2007 23:23:48 -0700
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] [RFC] Xilinx SystemACE: Add media hotplug support
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sr@denx.de, monstr@monstr.eu, jwilliams@itee.uq.edu.au,
       stephen.neuendorffer@xilinx.com
Message-id: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Please review and comment.  This patch works in my setup, but I haven't
tested exhaustively yet.  I also need to fixup the documentation to
reflect new states before I request this patch to be merged.

Question for the block layer experts:  I'm using add_disk()/del_gendisk()
functions to inform the kernel of media insertion and removal events.  Is
this the best way to do this?  I looked at the .media_changed and
.revalidate_disk hooks, but it doesn't seem like they offer the driver
any way to notify the kernel of media removal (as opposed to the kernel
asking the driver)

Cheers,
g.
---

 drivers/block/xsysace.c |  265 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 189 insertions(+), 76 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 0cdc868..9b3df96 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -53,7 +53,7 @@
  *    The request method in particular schedules the tasklet when a new
  *    request has been indicated by the block layer.  Once started, the
  *    FSM proceeds as far as it can processing the request until it
- *    needs on a hardware event.  At this point, it must yield execution.
+ *    needs a hardware event.  At this point, it must yield execution.
  *
  *    A state has two options when yielding execution:
  *    1. ace_fsm_yield()
@@ -71,7 +71,8 @@
  *    Additionally, the driver maintains a kernel timer which can process
  *    the FSM.  If the FSM gets stalled, typically due to a missed
  *    interrupt, then the kernel timer will expire and the driver can
- *    continue where it left off.
+ *    continue where it left off.  The stall timer is also used to watch
+ *    for media removal/insertion events.
  *
  * To Do:
  *    - Add FPGA configuration control interface.
@@ -90,6 +91,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #if defined(CONFIG_OF)
 #include <linux/of_device.h>
@@ -170,17 +172,18 @@ struct ace_reg_ops;
 struct ace_device {
 	/* driver state data */
 	int id;
-	int media_change;
 	int users;
 	struct list_head list;
 
 	/* finite state machine data */
 	struct tasklet_struct fsm_tasklet;
+	struct work_struct fsm_worker;
 	uint fsm_task;		/* Current activity (ACE_TASK_*) */
 	uint fsm_state;		/* Current state (ACE_FSM_STATE_*) */
 	uint fsm_continue_flag;	/* cleared to exit FSM mainloop */
 	uint fsm_iter_num;
 	struct timer_list stall_timer;
+	int stall_count;
 
 	/* Transfer state/result, use for both id and block request */
 	struct request *req;	/* request being processed */
@@ -189,7 +192,6 @@ struct ace_device {
 	int data_result;	/* Result of transfer; 0 := success */
 
 	int id_req_count;	/* count of id requests */
-	int id_result;
 	struct completion id_completion;	/* used when id req finishes */
 	int in_irq;
 
@@ -212,6 +214,7 @@ struct ace_device {
 };
 
 static int ace_major;
+struct workqueue_struct *ace_workqueue;
 
 /* ---------------------------------------------------------------------
  * Low level register access
@@ -429,21 +432,24 @@ void ace_fix_driveid(struct hd_driveid *id)
 #define ACE_TASK_IDENTIFY  1
 #define ACE_TASK_READ      2
 #define ACE_TASK_WRITE     3
-#define ACE_FSM_NUM_TASKS  4
+#define ACE_NUM_TASKS      4
 
 /* FSM state definitions */
-#define ACE_FSM_STATE_IDLE               0
-#define ACE_FSM_STATE_REQ_LOCK           1
-#define ACE_FSM_STATE_WAIT_LOCK          2
-#define ACE_FSM_STATE_WAIT_CFREADY       3
-#define ACE_FSM_STATE_IDENTIFY_PREPARE   4
-#define ACE_FSM_STATE_IDENTIFY_TRANSFER  5
-#define ACE_FSM_STATE_IDENTIFY_COMPLETE  6
-#define ACE_FSM_STATE_REQ_PREPARE        7
-#define ACE_FSM_STATE_REQ_TRANSFER       8
-#define ACE_FSM_STATE_REQ_COMPLETE       9
-#define ACE_FSM_STATE_ERROR             10
-#define ACE_FSM_NUM_STATES              11
+#define ACE_FSM_STATE_NO_MEDIA           0
+#define ACE_FSM_STATE_KICKSTART          1
+#define ACE_FSM_STATE_IDLE               2
+#define ACE_FSM_STATE_REQ_LOCK           3
+#define ACE_FSM_STATE_WAIT_LOCK          4
+#define ACE_FSM_STATE_WAIT_CFREADY       5
+#define ACE_FSM_STATE_IDENTIFY_PREPARE   6
+#define ACE_FSM_STATE_IDENTIFY_TRANSFER  7
+#define ACE_FSM_STATE_IDENTIFY_COMPLETE  8
+#define ACE_FSM_STATE_REQ_PREPARE        9
+#define ACE_FSM_STATE_REQ_TRANSFER      10
+#define ACE_FSM_STATE_REQ_COMPLETE      11
+#define ACE_FSM_STATE_INVALIDATE_MEDIA  12
+#define ACE_FSM_STATE_MEDIA_DISABLED    13
+#define ACE_FSM_NUM_STATES              14
 
 /* Set flag to exit FSM loop and reschedule tasklet */
 static inline void ace_fsm_yield(struct ace_device *ace)
@@ -490,18 +496,53 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		ace->fsm_state, ace->id_req_count);
 #endif
 
+	/* Before doing anything; check the CF detect bit.  If the card
+	 * is not present; then there are only a couple of states which
+	 * we can be in */
+	if ((ace_in(ace, ACE_STATUS) & ACE_STATUS_CFDETECT) == 0) {
+		/* Card is missing; short circuit to appropriate state */
+		switch (ace->fsm_state) {
+		  case ACE_FSM_STATE_NO_MEDIA:
+		  case ACE_FSM_STATE_MEDIA_DISABLED:
+			ace->fsm_state = ACE_FSM_STATE_NO_MEDIA;
+			break;
+
+		  default:
+			ace->fsm_state = ACE_FSM_STATE_INVALIDATE_MEDIA;
+		}
+	}
+
+	/* Process the next state in the FSM */
 	switch (ace->fsm_state) {
+	case ACE_FSM_STATE_NO_MEDIA:
+		/* No media inserted into the drive.  If media is inserted
+		 * then kick the workqueue.  The workqueue will cause a
+		 * transition to the IDLE state. */
+		if (ace_in(ace, ACE_STATUS) & ACE_STATUS_CFDETECT) {
+			ace->fsm_state = ACE_FSM_STATE_KICKSTART;
+			break;
+		}
+		ace->fsm_continue_flag = 0;
+		break;
+
+	case ACE_FSM_STATE_KICKSTART:
+		/* Everything looks good hardware wise; kick off the
+		 * initialization sequence.
+		 *
+		 * fsm_worker causes transition from here to the IDLE state.
+		 * The FSM cannot transition itself.
+		 */
+		queue_work(ace_workqueue, &ace->fsm_worker);
+		ace->fsm_continue_flag = 0;
+		break;
+
 	case ACE_FSM_STATE_IDLE:
 		/* See if there is anything to do */
 		if (ace->id_req_count || ace_get_next_request(ace->queue)) {
 			ace->fsm_iter_num++;
 			ace->fsm_state = ACE_FSM_STATE_REQ_LOCK;
-			mod_timer(&ace->stall_timer, jiffies + HZ);
-			if (!timer_pending(&ace->stall_timer))
-				add_timer(&ace->stall_timer);
 			break;
 		}
-		del_timer(&ace->stall_timer);
 		ace->fsm_continue_flag = 0;
 		break;
 
@@ -538,7 +579,10 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			break;
 		}
 
-		/* Device is ready for command; determine what to do next */
+		/* Device is ready for command; determine what to do next.
+		 * - If a revalidate is pending, do that.
+		 * - Otherwise go to to process the next block request.
+		 */
 		if (ace->id_req_count)
 			ace->fsm_state = ACE_FSM_STATE_IDENTIFY_PREPARE;
 		else
@@ -598,22 +642,19 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 		if (ace->data_result) {
 			/* Error occured, disable the disk */
-			ace->media_change = 1;
-			set_capacity(ace->gd, 0);
 			dev_err(ace->dev, "error fetching CF id (%i)\n",
 				ace->data_result);
-		} else {
-			ace->media_change = 0;
-
-			/* Record disk parameters */
-			set_capacity(ace->gd, ace->cf_id.lba_capacity);
-			dev_info(ace->dev, "capacity: %i sectors\n",
-				 ace->cf_id.lba_capacity);
+			ace->fsm_state = ACE_FSM_STATE_INVALIDATE_MEDIA;
+			break;
 		}
 
-		/* We're done, drop to IDLE state and notify waiters */
+		/* Record disk parameters */
+		set_capacity(ace->gd, ace->cf_id.lba_capacity);
+		dev_info(ace->dev, "capacity: %i sectors\n",
+			 ace->cf_id.lba_capacity);
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
-		ace->id_result = ace->data_result;
+
+		/* We're done, notify waiters */
 		while (ace->id_req_count) {
 			complete(&ace->id_completion);
 			ace->id_req_count--;
@@ -727,12 +768,90 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
 		break;
 
+	case ACE_FSM_STATE_INVALIDATE_MEDIA:
+		/* The media has been removed, or a fatal error has
+		 * occured.
+		 *
+		 * This state can only transition to the MEDIA_DISABLED
+		 * state; but it is not done in this state machine handler
+		 * Rather, when this state is entered, the workqueue is
+		 * kicked to deregister the gendisk and it is the workqueue
+		 * that causes the transition to the MEDIA_DISABLED state
+		 */
+
+		/* If there are any waiters, wake them up so they are not
+		 * hung on the problem */
+		while (ace->id_req_count) {
+			complete(&ace->id_completion);
+			ace->id_req_count--;
+		}
+
+		/* Schedule the worker to invalidate the block device */
+		queue_work(ace_workqueue, &ace->fsm_worker);
+		ace->fsm_continue_flag = 0;
+		break;
+
+	case ACE_FSM_STATE_MEDIA_DISABLED:
+		/* The media is no longer registered.  If the sysace reports
+		 * that the media has been removed, then we can transition
+		 * to the NO_MEDIA state.
+		 */
+		ace->fsm_continue_flag = 0;
+		break;
+
 	default:
-		ace->fsm_state = ACE_FSM_STATE_IDLE;
+		/* Something weird has happened.  Go to the catchall
+		 * exception handling state */
+		ace->fsm_state = ACE_FSM_STATE_INVALIDATE_MEDIA;
 		break;
 	}
 }
 
+static void ace_fsm_work(struct work_struct *work)
+{
+	struct ace_device *ace;
+	unsigned long flags;
+
+	ace = container_of(work, struct ace_device, fsm_worker);
+
+	/* Note on worker states: this worker can only begin processing if
+	 * the FSM is either in the KICKSTART or the INVALIDATE_MEDIA states.
+	 * In both cases, the FSM cannot transition out of the state itself.
+	 * Instead, this worker must begin processing and cause a transition
+	 * to the next state manually. */
+	if (ace->fsm_state == ACE_FSM_STATE_KICKSTART) {
+		/* Hardware is ready for initialization sequence */
+		dev_info(ace->dev, "Kickstart\n");
+		ace->fsm_state = ACE_FSM_STATE_IDLE;
+
+		spin_lock_irqsave(&ace->lock, flags);
+		ace->id_req_count++;
+		spin_unlock_irqrestore(&ace->lock, flags);
+
+		tasklet_schedule(&ace->fsm_tasklet);
+		wait_for_completion(&ace->id_completion);
+
+		/* Make the sysace device 'live' */
+		if (ace->fsm_state != ACE_FSM_STATE_INVALIDATE_MEDIA);
+			add_disk(ace->gd);
+	}
+
+	if (ace->fsm_state == ACE_FSM_STATE_INVALIDATE_MEDIA) {
+		dev_info(ace->dev, "card error/removed; Invalidating\n");
+		/* Media has been removed or an error has occured.
+		 * Unregister the block device so it can no longer be used.
+		 */
+		if (ace->gd->flags & GENHD_FL_UP)
+			del_gendisk(ace->gd);
+
+		/* All done; go to the MEDIA_DISABLED state.
+		 * This is safe to do w/o the lock because the FSM is stalled
+		 * on the INVALIDATE_MEDIA state.
+		 */
+		ace->fsm_state = ACE_FSM_STATE_MEDIA_DISABLED;
+	};
+}
+
 static void ace_fsm_tasklet(unsigned long data)
 {
 	struct ace_device *ace = (void *)data;
@@ -753,10 +872,28 @@ static void ace_stall_timer(unsigned long data)
 	struct ace_device *ace = (void *)data;
 	unsigned long flags;
 
-	dev_warn(ace->dev,
-		 "kicking stalled fsm; state=%i task=%i iter=%i dc=%i\n",
-		 ace->fsm_state, ace->fsm_task, ace->fsm_iter_num,
-		 ace->data_count);
+	/* Report if FSM stalls when we don't expect it. */
+	switch (ace->fsm_state) {
+	  case ACE_FSM_STATE_NO_MEDIA:
+	  case ACE_FSM_STATE_KICKSTART:
+	  case ACE_FSM_STATE_IDLE:
+		break;
+
+	  case ACE_FSM_STATE_INVALIDATE_MEDIA:
+	  case ACE_FSM_STATE_MEDIA_DISABLED:
+		dev_warn(ace->dev, "FSM timer: state=%i t=%i i=%i dc=%i\n",
+			 ace->fsm_state, ace->fsm_task,
+			 ace->fsm_iter_num, ace->data_count);
+
+	  default:
+		ace->stall_count++;
+		if (ace->stall_count > 2)
+			dev_warn(ace->dev, "kicking stalled FSM; "
+				           "state=%i t=%i i=%i dc=%i\n",
+				 ace->fsm_state, ace->fsm_task,
+				 ace->fsm_iter_num, ace->data_count);
+	}
+
 	spin_lock_irqsave(&ace->lock, flags);
 
 	/* Rearm the stall timer *before* entering FSM (which may then
@@ -798,6 +935,7 @@ static irqreturn_t ace_interrupt(int irq, void *dev_id)
 	/* be safe and get the lock */
 	spin_lock(&ace->lock);
 	ace->in_irq = 1;
+	ace->stall_count = 0;
 
 	/* clear the interrupt */
 	creg = ace_in(ace, ACE_CTRL);
@@ -845,36 +983,6 @@ static void ace_request(struct request_queue * q)
 	}
 }
 
-static int ace_media_changed(struct gendisk *gd)
-{
-	struct ace_device *ace = gd->private_data;
-	dev_dbg(ace->dev, "ace_media_changed(): %i\n", ace->media_change);
-
-	return ace->media_change;
-}
-
-static int ace_revalidate_disk(struct gendisk *gd)
-{
-	struct ace_device *ace = gd->private_data;
-	unsigned long flags;
-
-	dev_dbg(ace->dev, "ace_revalidate_disk()\n");
-
-	if (ace->media_change) {
-		dev_dbg(ace->dev, "requesting cf id and scheduling tasklet\n");
-
-		spin_lock_irqsave(&ace->lock, flags);
-		ace->id_req_count++;
-		spin_unlock_irqrestore(&ace->lock, flags);
-
-		tasklet_schedule(&ace->fsm_tasklet);
-		wait_for_completion(&ace->id_completion);
-	}
-
-	dev_dbg(ace->dev, "revalidate complete\n");
-	return ace->id_result;
-}
-
 static int ace_open(struct inode *inode, struct file *filp)
 {
 	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
@@ -926,8 +1034,6 @@ static struct block_device_operations ace_fops = {
 	.owner = THIS_MODULE,
 	.open = ace_open,
 	.release = ace_release,
-	.media_changed = ace_media_changed,
-	.revalidate_disk = ace_revalidate_disk,
 	.getgeo = ace_getgeo,
 };
 
@@ -954,8 +1060,9 @@ static int __devinit ace_setup(struct ace_device *ace)
 		goto err_ioremap;
 
 	/*
-	 * Initialize the state machine tasklet and stall timer
+	 * Initialize the state machine work, tasklet and stall timer
 	 */
+	INIT_WORK(&ace->fsm_worker, ace_fsm_work);
 	tasklet_init(&ace->fsm_tasklet, ace_fsm_tasklet, (unsigned long)ace);
 	setup_timer(&ace->stall_timer, ace_stall_timer, (unsigned long)ace);
 
@@ -1026,11 +1133,8 @@ static int __devinit ace_setup(struct ace_device *ace)
 	dev_dbg(ace->dev, "physaddr 0x%lx, mapped to 0x%p, irq=%i\n",
 		ace->physaddr, ace->baseaddr, ace->irq);
 
-	ace->media_change = 1;
-	ace_revalidate_disk(ace->gd);
-
-	/* Make the sysace device 'live' */
-	add_disk(ace->gd);
+	/* Kick things off */
+	mod_timer(&ace->stall_timer, jiffies + HZ);
 
 	return 0;
 
@@ -1244,6 +1348,12 @@ static int __init ace_init(void)
 {
 	int rc;
 
+	ace_workqueue = create_singlethread_workqueue("xsysace");
+	if (!ace_workqueue) {
+		rc = -ENOMEM;
+		goto err_wq;
+	}
+
 	ace_major = register_blkdev(ace_major, "xsysace");
 	if (ace_major <= 0) {
 		rc = -ENOMEM;
@@ -1267,6 +1377,8 @@ err_plat:
 err_of:
 	unregister_blkdev(ace_major, "xsysace");
 err_blk:
+	destroy_workqueue(ace_workqueue);
+err_wq:
 	printk(KERN_ERR "xsysace: registration failed; err=%i\n", rc);
 	return rc;
 }
@@ -1274,6 +1386,7 @@ err_blk:
 static void __exit ace_exit(void)
 {
 	pr_debug("Unregistering Xilinx SystemACE driver\n");
+	destroy_workqueue(ace_workqueue);
 	platform_driver_unregister(&ace_platform_driver);
 	ace_of_unregister();
 	unregister_blkdev(ace_major, "xsysace");

