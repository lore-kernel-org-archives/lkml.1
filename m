Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYAFOQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYAFOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYAFOQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:16:20 -0500
Received: from dns.vs-node3.de ([87.106.12.105]:58725 "EHLO
	aragorn.vidconference.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYAFOQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:16:19 -0500
Date: Sun, 6 Jan 2008 15:15:54 +0100
To: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] Re: Regression: VIDIOCGMBUF ioctl hangs on bttv driver (2.6.24-rc6)
Message-ID: <20080106141548.GB18690@vidsoft.de>
References: <20080105223338.GA18690@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105223338.GA18690@vidsoft.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Gregor Jasny <jasny@vidsoft.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregor Jasny <gjasny@web.de>

Fix bttv VIDIOCGMBUF locking like done in commit
820eacd84cff23b76693f4be1e28feb672f4488f. 

Signed-off-by: Gregor Jasny <gjasny@web.de>
---
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index c02d92d..581a3c9 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3063,11 +3063,10 @@ static int bttv_do_ioctl(struct inode *inode, struct file *file,
 		struct video_mbuf *mbuf = arg;
 		unsigned int i;
 
-		mutex_lock(&fh->cap.lock);
 		retval = videobuf_mmap_setup(&fh->cap,gbuffers,gbufsize,
 					     V4L2_MEMORY_MMAP);
 		if (retval < 0)
-			goto fh_unlock_and_return;
+			return retval;
 
 		gbuffers = retval;
 		memset(mbuf,0,sizeof(*mbuf));
@@ -3075,7 +3074,6 @@ static int bttv_do_ioctl(struct inode *inode, struct file *file,
 		mbuf->size   = gbuffers * gbufsize;
 		for (i = 0; i < gbuffers; i++)
 			mbuf->offsets[i] = i * gbufsize;
-		mutex_unlock(&fh->cap.lock);
 		return 0;
 	}
 	case VIDIOCMCAPTURE:
