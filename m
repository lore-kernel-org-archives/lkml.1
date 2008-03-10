Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYCJVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYCJVWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYCJVWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:22:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYCJVWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pbMo66VHuVPwQoz9QA8F0aYMN0L3uVMzkogpOr1m9sWOXY9DXyNstifxNFg3iTPsC04g2S6NrFe9Nf7bkwx+D5EiKxWVJnBsyH87zcJzbUJND3ncLLkQL8H8Mfbsg8LI8iq6Pk34vvM0eZGIu40rK5Q2yHi5YwZEIXPOBxq+y6s=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 3/3 v4l-dvb] v4l: reduce stack usage of v4l1_compat_sync
Date: Mon, 10 Mar 2008 22:21:40 +0100
Message-Id: <1205184100-28073-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: 20080310145707.6815fbf0@gaivota
References: 20080310145707.6815fbf0@gaivota
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
index e42cea9..a0f6c60 100644
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
 
@@ -1068,6 +1067,7 @@ static noinline int v4l1_compat_sync(
 	int err;
 	enum v4l2_buf_type captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	struct v4l2_buffer buf;
+	struct poll_wqueues *pwq;
 
 	memset(&buf, 0, sizeof(buf));
 	buf.index = *i;
@@ -1091,10 +1091,11 @@ static noinline int v4l1_compat_sync(
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
@@ -1102,6 +1103,7 @@ static noinline int v4l1_compat_sync(
 		if (err < 0)
 			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
 	}
+	kfree(pwq);
 	if (!(buf.flags & V4L2_BUF_FLAG_DONE)) /* not done */
 		goto done;
 	do {
-- 
1.5.3.7

