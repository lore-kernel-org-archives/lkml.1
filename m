Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbXLDR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbXLDR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXLDR11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:27:27 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63710 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLDR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:27:26 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 04 Dec 2007 18:27:23 +0100
Message-Id: <1196789243.9441.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/kernel/entry.S     |    2 ++
 arch/s390/kernel/setup.c     |    4 +---
 drivers/s390/block/dcssblk.c |    4 ++--
 drivers/s390/cio/css.c       |    1 +
 drivers/s390/cio/device_id.c |   37 ++++++++++++++++++++++++++++---------
 5 files changed, 34 insertions(+), 14 deletions(-)

Christian Borntraeger (2):
      [S390] dcssblk: prevent early access without own make_request function
      [S390] Fix compile error on 31bit without preemption

Cornelia Huck (1):
      [S390] cio: Issue SenseID per path.

Heiko Carstens (1):
      [S390] Make sure the restore psw masks are initialized.

Peter Oberparleiter (1):
      [S390] cio: add missing reprobe loop end statement

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index b2b2edc..1a6dac8 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -1079,8 +1079,10 @@ cleanup_io_leave_insn:
 .Lexecve_tail:	.long	execve_tail
 .Ljump_table:	.long	pgm_check_table
 .Lschedule:	.long	schedule
+#ifdef CONFIG_PREEMPT
 .Lpreempt_schedule_irq:
 		.long	preempt_schedule_irq
+#endif
 .Ltrace:	.long	syscall_trace
 .Lschedtail:	.long	schedule_tail
 .Lsysc_table:	.long	sys_call_table
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 50f8f1e..577aa7d 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -486,9 +486,7 @@ static void setup_addressing_mode(void)
 	if (s390_noexec) {
 		printk("S390 execute protection active, ");
 		set_amode_and_uaccess(PSW_ASC_SECONDARY, PSW32_ASC_SECONDARY);
-		return;
-	}
-	if (switch_amode) {
+	} else if (switch_amode) {
 		printk("S390 address spaces switched, ");
 		set_amode_and_uaccess(PSW_ASC_PRIMARY, PSW32_ASC_PRIMARY);
 	}
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5e083d1..15a5789 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -472,11 +472,11 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto unregister_dev;
 
-	add_disk(dev_info->gd);
-
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
 	blk_queue_hardsect_size(dev_info->dcssblk_queue, 4096);
 
+	add_disk(dev_info->gd);
+
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
 		case SEG_TYPE_ER:
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 6db3108..c3df2cd 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -451,6 +451,7 @@ static int reprobe_subchannel(struct subchannel_id schid, void *data)
 		break;
 	case -ENXIO:
 	case -ENOMEM:
+	case -EIO:
 		/* These should abort looping */
 		break;
 	default:
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index 2f6bf46..156f3f9 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -113,6 +113,7 @@ __ccw_device_sense_id_start(struct ccw_device *cdev)
 {
 	struct subchannel *sch;
 	struct ccw1 *ccw;
+	int ret;
 
 	sch = to_subchannel(cdev->dev.parent);
 	/* Setup sense channel program. */
@@ -124,9 +125,25 @@ __ccw_device_sense_id_start(struct ccw_device *cdev)
 
 	/* Reset device status. */
 	memset(&cdev->private->irb, 0, sizeof(struct irb));
-	cdev->private->flags.intretry = 0;
 
-	return cio_start(sch, ccw, LPM_ANYPATH);
+	/* Try on every path. */
+	ret = -ENODEV;
+	while (cdev->private->imask != 0) {
+		if ((sch->opm & cdev->private->imask) != 0 &&
+		    cdev->private->iretry > 0) {
+			cdev->private->iretry--;
+			/* Reset internal retry indication. */
+			cdev->private->flags.intretry = 0;
+			ret = cio_start (sch, cdev->private->iccws,
+					 cdev->private->imask);
+			/* ret is 0, -EBUSY, -EACCES or -ENODEV */
+			if (ret != -EACCES)
+				return ret;
+		}
+		cdev->private->imask >>= 1;
+		cdev->private->iretry = 5;
+	}
+	return ret;
 }
 
 void
@@ -136,7 +153,8 @@ ccw_device_sense_id_start(struct ccw_device *cdev)
 
 	memset (&cdev->private->senseid, 0, sizeof (struct senseid));
 	cdev->private->senseid.cu_type = 0xFFFF;
-	cdev->private->iretry = 3;
+	cdev->private->imask = 0x80;
+	cdev->private->iretry = 5;
 	ret = __ccw_device_sense_id_start(cdev);
 	if (ret && ret != -EBUSY)
 		ccw_device_sense_id_done(cdev, ret);
@@ -252,13 +270,14 @@ ccw_device_sense_id_irq(struct ccw_device *cdev, enum dev_event dev_event)
 		ccw_device_sense_id_done(cdev, ret);
 		break;
 	case -EACCES:		/* channel is not operational. */
+		sch->lpm &= ~cdev->private->imask;
+		cdev->private->imask >>= 1;
+		cdev->private->iretry = 5;
+		/* fall through. */
 	case -EAGAIN:		/* try again. */
-		cdev->private->iretry--;
-		if (cdev->private->iretry > 0) {
-			ret = __ccw_device_sense_id_start(cdev);
-			if (ret == 0 || ret == -EBUSY)
-				break;
-		}
+		ret = __ccw_device_sense_id_start(cdev);
+		if (ret == 0 || ret == -EBUSY)
+			break;
 		/* fall through. */
 	default:		/* Sense ID failed. Try asking VM. */
 		if (MACHINE_IS_VM) {


