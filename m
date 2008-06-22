Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYFVRF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYFVRF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYFVRFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:05:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:58189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYFVRFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:05:13 -0400
Date: Sun, 22 Jun 2008 10:05:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] Fix open/close race in saa7134
Message-ID: <20080622100507.779acc59@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 22 Jun 2008 10:03:02 -0700
Subject: [PATCH] Fix open/close race in saa7134

The saa7134 driver uses a (non-atomic) variable in an attempt to
only allow one opener of the device (how it deals with sending
the fd over unix sockets I don't know).

Unfortunately, the release function first decrements this variable,
and THEN goes on to disable more of the device. This allows for
a race where another opener of the device comes in after the decrement of
the variable, configures the hardware just to then see the hardware
be disabled by the rest of the release function.

This patch makes the release function use the same lock as the open
function to protect the hardware as well as the variable (which now
at least has some locking to protect it).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/media/video/saa7134/saa7134-empress.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 81431ee..9108843 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -110,6 +110,8 @@ static int ts_release(struct inode *inode, struct file *file)
 {
 	struct saa7134_dev *dev = file->private_data;
 
+	mutex_lock(&dev->empress_tsq.vb_lock);
+
 	videobuf_stop(&dev->empress_tsq);
 	videobuf_mmap_free(&dev->empress_tsq);
 	dev->empress_users--;
@@ -121,6 +123,8 @@ static int ts_release(struct inode *inode, struct file *file)
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
 
+	mutex_unlock(&dev->empress_tsq.vb_lock);
+
 	return 0;
 }
 
-- 
1.5.5.1



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
