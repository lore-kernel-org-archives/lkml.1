Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXFUSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXFUSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXFUSpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:45:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:43351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXFUSpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:45:12 -0400
Message-ID: <467AC742.7070007@suse.com>
Date: Thu, 21 Jun 2007 14:45:22 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Gerd Knorr <kraxel@bytesex.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] saa7134: fix thread shutdown handling
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch changes the test for the thread pid from >= 0 to > 0.

 When the saa8134 driver initialization fails after a certain point,
 it goes through the complete shutdown process for the driver. Part
 of shutting it down includes tearing down the thread for tv audio.

 The test for tearing down the thread tests for >= 0. Since the dev
 structure is kzalloc'd, the test will always be true if we haven't
 tried to start the thread yet. We end up waiting on pid 0 to complete,
 which will never happen, so we lock up.

 This bug was observed in Novell Bugzilla 284718, when request_irq()
 failed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-12 15:45:16.000000000 -0400
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-15 14:16:14.000000000 -0400
@@ -1005,7 +1005,7 @@
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
 	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
+	if (dev->thread.pid > 0) {
 		dev->thread.shutdown = 1;
 		wake_up_interruptible(&dev->thread.wq);
 		wait_for_completion(&dev->thread.exit);

-- 
Jeff Mahoney
SUSE Labs
