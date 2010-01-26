Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928Ab0AZXoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0AZXoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877Ab0AZXoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:11 -0500
Received: from kroah.org ([198.145.64.141]:35464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0AZXoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233930.846297610@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [76/98] [S390] cio: dont panic in non-fatal conditions
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

commit 16b9a0571da4ee5cd15ca75e871722b0b5aee64d upstream.

Remove the call to BUG() for situations which are unexpected
but do not cause actual problems.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/cio/device_fsm.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -1080,14 +1080,14 @@ void ccw_device_trigger_reprobe(struct c
 		ccw_device_start_id(cdev, 0);
 }
 
-static void
-ccw_device_offline_irq(struct ccw_device *cdev, enum dev_event dev_event)
+static void ccw_device_disabled_irq(struct ccw_device *cdev,
+				    enum dev_event dev_event)
 {
 	struct subchannel *sch;
 
 	sch = to_subchannel(cdev->dev.parent);
 	/*
-	 * An interrupt in state offline means a previous disable was not
+	 * An interrupt in a disabled state means a previous disable was not
 	 * successful - should not happen, but we try to disable again.
 	 */
 	cio_disable_subchannel(sch);
@@ -1150,25 +1150,12 @@ ccw_device_nop(struct ccw_device *cdev, 
 }
 
 /*
- * Bug operation action. 
- */
-static void
-ccw_device_bug(struct ccw_device *cdev, enum dev_event dev_event)
-{
-	CIO_MSG_EVENT(0, "Internal state [%i][%i] not handled for device "
-		      "0.%x.%04x\n", cdev->private->state, dev_event,
-		      cdev->private->dev_id.ssid,
-		      cdev->private->dev_id.devno);
-	BUG();
-}
-
-/*
  * device statemachine
  */
 fsm_func_t *dev_jumptable[NR_DEV_STATES][NR_DEV_EVENTS] = {
 	[DEV_STATE_NOT_OPER] = {
 		[DEV_EVENT_NOTOPER]	= ccw_device_nop,
-		[DEV_EVENT_INTERRUPT]	= ccw_device_bug,
+		[DEV_EVENT_INTERRUPT]	= ccw_device_disabled_irq,
 		[DEV_EVENT_TIMEOUT]	= ccw_device_nop,
 		[DEV_EVENT_VERIFY]	= ccw_device_nop,
 	},
@@ -1186,7 +1173,7 @@ fsm_func_t *dev_jumptable[NR_DEV_STATES]
 	},
 	[DEV_STATE_OFFLINE] = {
 		[DEV_EVENT_NOTOPER]	= ccw_device_generic_notoper,
-		[DEV_EVENT_INTERRUPT]	= ccw_device_offline_irq,
+		[DEV_EVENT_INTERRUPT]	= ccw_device_disabled_irq,
 		[DEV_EVENT_TIMEOUT]	= ccw_device_nop,
 		[DEV_EVENT_VERIFY]	= ccw_device_offline_verify,
 	},
@@ -1243,7 +1230,7 @@ fsm_func_t *dev_jumptable[NR_DEV_STATES]
 	[DEV_STATE_DISCONNECTED] = {
 		[DEV_EVENT_NOTOPER]	= ccw_device_nop,
 		[DEV_EVENT_INTERRUPT]	= ccw_device_start_id,
-		[DEV_EVENT_TIMEOUT]	= ccw_device_bug,
+		[DEV_EVENT_TIMEOUT]	= ccw_device_nop,
 		[DEV_EVENT_VERIFY]	= ccw_device_start_id,
 	},
 	[DEV_STATE_DISCONNECTED_SENSE_ID] = {


