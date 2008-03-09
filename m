Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYCIQ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYCIQ40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCIQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:56:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:51458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYCIQ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eZJOsBaFk3lcFXUakrHKM3GtyPn+vpkx5sFiGFKf3MfdslMcimlao2rAZHLuwJCsr3OGTsgqFG8LOHE7dZL6sEiWlbpsoPZMrVd3K08gH2FfKFpJGZ8mrSV4lqwcAHsp6T4pi/OZy+XJv0tWfQrCx/yz405PUXb+XLLNN8RxI4s=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 3/3] v4l: reduce stack usage of v4l1_compat_sync
Date: Sun,  9 Mar 2008 17:55:55 +0100
Message-Id: <1205081755-18455-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1205081266-18368-1-git-send-email-marcin.slusarz@gmail.com>
References: <1205081266-18368-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_one allocated on stack struct poll_wqueues which is pretty big
structure (>500 bytes on x86_64). v4l1_compat_sync invokes poll_one
in a loop, so allocate struct poll_wqueues in v4l1_compat_sync (with
kmalloc) and pass it to poll_one.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/v4l1-compat.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index aa73472..9f73d52 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -199,14 +199,13 @@ pixelformat_to_palette(unsigned int pixelformat)
 
 /* ----------------------------------------------------------------- */
 
-static int poll_one(struct file *file)
+static int poll_one(struct file *file, struct poll_wqueues *pwq)
 {
 	int retval = 1;
 	poll_table *table;
-	struct poll_wqueues pwq; /*TODO: allocate dynamically*/
 
-	poll_initwait(&pwq);
-	table = &pwq.pt;
+	poll_initwait(pwq);
+	table = &pwq->pt;
 	for (;;) {
 		int mask;
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -221,7 +220,7 @@ static int poll_one(struct file *file)
 		schedule();
 	}
 	set_current_state(TASK_RUNNING);
-	poll_freewait(&pwq);
+	poll_freewait(pwq);
 	return retval;
 }
 
@@ -1043,6 +1042,7 @@ static noinline int v4l1_compat_sync(
 	int err;
 	enum v4l2_buf_type captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	struct v4l2_buffer buf;
+	struct poll_wqueues *pwq;
 
 	memset(&buf, 0, sizeof(buf));
 	buf.index = *i;
@@ -1066,10 +1066,11 @@ static noinline int v4l1_compat_sync(
 		goto done;
 	}
 
+	pwq = kmalloc(sizeof(*pwq), GFP_KERNEL);
 	/*  Loop as long as the buffer is queued, but not done  */
 	while ((buf.flags & (V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE))
 						== V4L2_BUF_FLAG_QUEUED) {
-		err = poll_one(file);
+		err = poll_one(file, pwq);
 		if (err < 0 ||	/* error or sleep was interrupted  */
 		    err == 0)	/* timeout? Shouldn't occur.  */
 			break;
@@ -1077,6 +1078,7 @@ static noinline int v4l1_compat_sync(
 		if (err < 0)
 			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
 	}
+	kfree(pwq);
 	if (!(buf.flags & V4L2_BUF_FLAG_DONE)) /* not done */
 		goto done;
 	do {
-- 
1.5.3.7

