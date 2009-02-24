Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZBXWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZBXWBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZBXWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:01:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZBXWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:01:09 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-kernel@vger.kernel.org
Subject: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885 video_open
Date: Tue, 24 Feb 2009 17:00:55 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27.18-171.2.28.fc10.x86_64; KDE/4.2.0; x86_64; ; )
Cc: Mike Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241700.56099.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Jenks
https://www.redhat.com/mailman/private/video4linux-list/2009-January/msg00041.html

The Hauppauge WinTV HVR-1800 tv tuner card has both digital and analog
abilities, both of which are supported by v4l/dvb under 2.6.27.y. The analog
side also features a hardware mpeg2 encoder. The HVR-1250 tv tuner card
has both digital and analog abilities, but analog isn't currently supported
under any kernel. These cards both utilize the cx23885 driver, but with
slightly different usage. When the code paths for each card is executed,
they wind up poking a cx23885_devlist, which contains devices from both
of the cards, and access attempts are made to portions of 'struct
cx23885_dev' that aren't valid for that device. Simply add some extra
checks before trying to access these structs.

More gory details:
  http://article.gmane.org/gmane.linux.drivers.dvb/46630

This was triggering on my own system at home w/both cards in it, and
no longer happens with this patch included.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

---

 drivers/media/video/cx23885/cx23885-417.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 7b0e8c0..19154b6 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1585,7 +1585,7 @@ static int mpeg_open(struct inode *inode, struct file *file)
 
 	list_for_each(list, &cx23885_devlist) {
 		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->v4l_device->minor == minor) {
+		if (h->v4l_device && h->v4l_device->minor == minor) {
 			dev = h;
 			break;
 		}
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 6047c78..a2b5a0c 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -733,7 +733,7 @@ static int video_open(struct inode *inode, struct file *file)
 
 	list_for_each(list, &cx23885_devlist) {
 		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->video_dev->minor == minor) {
+		if (h->video_dev && h->video_dev->minor == minor) {
 			dev  = h;
 			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		}


-- 
Jarod Wilson
jarod@redhat.com
