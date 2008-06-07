Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYFGWta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYFGWta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYFGWtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:49:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:57886 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYFGWtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k5v+eAA7N137fLolvMrNDd//umoSc8++yLNvvl94g//ToNCJrdtrSOnePN+X1eBK5H
         8VuXhgqxPMEPb3rWm+UlCNagDNRR04tYg6Y6VqWh2wHyjEBBg9sEKgGoYnpXB+jXd3oD
         bfvgsjHMF8nOQlMsj21X31qbZ2AA9AInY/APo=
Date: Sun, 8 Jun 2008 00:48:40 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC PATCH] v4l: saa7134: fix multiple clients access (and oops)
Message-ID: <20080607224835.GA25025@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking for a reason of multiple oopses in empress_querycap as reported
by kerneloops.org I noticed that only first open of device initializes
struct_file->private_data properly. (Closing the device was broken too).

So initialize private_date and free all resources on last close.
I think this change will fix oops in empress_querycap.

http://kerneloops.org/guilty.php?guilty=empress_querycap&version=2.6.25-release&start=1671168&end=1703935&class=oops

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com
---

Compile tested only. Please test on real hardware.

---
 drivers/media/video/saa7134/saa7134-empress.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 81431ee..e543074 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -96,11 +96,11 @@ static int ts_open(struct inode *inode, struct file *file)
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
 
-	dev->empress_users++;
-	file->private_data = dev;
 	err = 0;
 
 done_up:
+	dev->empress_users++;
+	file->private_data = dev;
 	mutex_unlock(&dev->empress_tsq.vb_lock);
 done:
 	return err;
@@ -110,16 +110,19 @@ static int ts_release(struct inode *inode, struct file *file)
 {
 	struct saa7134_dev *dev = file->private_data;
 
-	videobuf_stop(&dev->empress_tsq);
-	videobuf_mmap_free(&dev->empress_tsq);
-	dev->empress_users--;
+	mutex_lock(&dev->empress_tsq.vb_lock);
+	if (--dev->empress_users == 0) {
+		videobuf_stop(&dev->empress_tsq);
+		videobuf_mmap_free(&dev->empress_tsq);
 
-	/* stop the encoder */
-	ts_reset_encoder(dev);
+		/* stop the encoder */
+		ts_reset_encoder(dev);
 
-	/* Mute audio */
-	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
-		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
+		/* Mute audio */
+		saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
+			saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
+	}
+	mutex_unlock(&dev->empress_tsq.vb_lock);
 
 	return 0;
 }
-- 
1.5.4.5

