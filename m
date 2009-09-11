Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZIKQWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZIKQWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZIKQW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:22:29 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34661 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbZIKQW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:22:26 -0400
Date: Fri, 11 Sep 2009 18:22:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/8] drivers/staging: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909111822100.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc or kzalloc should free the
allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/staging/dream/camera/msm_v4l2.c       |    8 ++++++--
 drivers/staging/dream/camera/msm_vfe8x_proc.c |   16 ++++++++++++----
 drivers/staging/iio/accel/lis3l02dq_ring.c    |    1 +
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index c21198d..a6b7c72 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -286,6 +286,7 @@ static void lis3l02dq_trigger_bh_to_ring(struct work_struct *work_s)
 	rx_array = kmalloc(4 * (st->indio_dev->scan_count), GFP_KERNEL);
 	if (rx_array == NULL) {
 		dev_err(&st->us->dev, "memory alloc failed in ring bh");
+		kfree(data);
 		return;
 	}
 
diff --git a/drivers/staging/dream/camera/msm_vfe8x_proc.c b/drivers/staging/dream/camera/msm_vfe8x_proc.c
index 5436f71..10aef0e 100644
--- a/drivers/staging/dream/camera/msm_vfe8x_proc.c
+++ b/drivers/staging/dream/camera/msm_vfe8x_proc.c
@@ -967,8 +967,10 @@ vfe_send_af_stats_msg(uint32_t afBufAddress)
 	/* fill message with right content. */
 	/* @todo This is causing issues, need further investigate */
 	/* spin_lock_irqsave(&ctrl->state_lock, flags); */
-	if (ctrl->vstate != VFE_STATE_ACTIVE)
+	if (ctrl->vstate != VFE_STATE_ACTIVE) {
+		kfree(msg);
 		goto af_stats_done;
+	}
 
 	msg->_d = VFE_MSG_ID_STATS_AUTOFOCUS;
 	msg->_u.msgStatsAf.afBuffer = afBufAddress;
@@ -1053,8 +1055,10 @@ static void vfe_send_awb_stats_msg(uint32_t awbBufAddress)
 	/* fill message with right content. */
 	/* @todo This is causing issues, need further investigate */
 	/* spin_lock_irqsave(&ctrl->state_lock, flags); */
-	if (ctrl->vstate != VFE_STATE_ACTIVE)
+	if (ctrl->vstate != VFE_STATE_ACTIVE) {
+		kfree(msg);
 		goto awb_stats_done;
+	}
 
 	msg->_d = VFE_MSG_ID_STATS_WB_EXP;
 	msg->_u.msgStatsWbExp.awbBuffer = awbBufAddress;
@@ -1483,8 +1487,10 @@ static void vfe_send_output2_msg(
 	/* fill message with right content. */
 	/* @todo This is causing issues, need further investigate */
 	/* spin_lock_irqsave(&ctrl->state_lock, flags); */
-	if (ctrl->vstate != VFE_STATE_ACTIVE)
+	if (ctrl->vstate != VFE_STATE_ACTIVE) {
+		kfree(msg);
 		goto output2_msg_done;
+	}
 
 	msg->_d = VFE_MSG_ID_OUTPUT2;
 
@@ -1518,8 +1524,10 @@ static void vfe_send_output1_msg(
 
 	/* @todo This is causing issues, need further investigate */
 	/* spin_lock_irqsave(&ctrl->state_lock, flags); */
-	if (ctrl->vstate != VFE_STATE_ACTIVE)
+	if (ctrl->vstate != VFE_STATE_ACTIVE) {
+		kfree(msg);
 		goto output1_msg_done;
+	}
 
 	msg->_d = VFE_MSG_ID_OUTPUT1;
 	memmove(&(msg->_u),
diff --git a/drivers/staging/dream/camera/msm_v4l2.c b/drivers/staging/dream/camera/msm_v4l2.c
index 46a6eb1..6a7d46c 100644
--- a/drivers/staging/dream/camera/msm_v4l2.c
+++ b/drivers/staging/dream/camera/msm_v4l2.c
@@ -521,13 +521,17 @@ static int msm_v4l2_s_fmt_cap(struct file *f,
   ctrlcmd->value      = pfmt;
   ctrlcmd->timeout_ms = 10000;
 
-	if (pfmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (pfmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		kfree(ctrlcmd);
 		return -1;
+	}
 
 #if 0
 	/* FIXEME */
-	if (pfmt->fmt.pix.pixelformat != V4L2_PIX_FMT_YVU420)
+	if (pfmt->fmt.pix.pixelformat != V4L2_PIX_FMT_YVU420) {
+		kfree(ctrlcmd);
 		return -EINVAL;
+	}
 #endif
 
 	/* Ok, but check other params, too. */
