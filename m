Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbXISFo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbXISFo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXISFoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:44:20 -0400
Received: from mail.queued.net ([207.210.101.209]:3446 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXISFoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:44:19 -0400
Date: Wed, 19 Sep 2007 01:44:18 -0400
From: Andres Salomon <dilinger@queued.net>
To: video4linux-list@redhat.com
Cc: v4l-dvb-maintainer@linuxtv.org, corbet@lwn.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cafe_ccic: default to allocating DMA buffers at probe time
Message-Id: <20070919014418.073543bc.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By default, we allocate DMA buffers when actually reading from the video
capture device.  On a system with 128MB or 256MB of ram, it's very easy
for that memory to quickly become fragmented.  We've had users report
having 30+MB of memory free, but the cafe_ccic driver is still unable to
allocate DMA buffers.

Our workaround has been to make use of the 'alloc_bufs_at_load' parameter
to allocate DMA buffers during device probing.  This patch makes DMA
buffer allocation happen during device probe by default, and changes
the parameter to 'alloc_bufs_at_read'.  The camera hardware is there,
if the cafe_ccic driver is enabled/loaded it should do its best to ensure
that the camera is actually usable; delaying DMA buffer allocation
saves an insignicant amount of memory, and causes the driver to be much
less useful.
---

 drivers/media/video/cafe_ccic.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index ef53618..3588a59 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -63,13 +63,13 @@ MODULE_SUPPORTED_DEVICE("Video");
  */
 
 #define MAX_DMA_BUFS 3
-static int alloc_bufs_at_load = 0;
-module_param(alloc_bufs_at_load, bool, 0444);
-MODULE_PARM_DESC(alloc_bufs_at_load,
-		"Non-zero value causes DMA buffers to be allocated at module "
-		"load time.  This increases the chances of successfully getting "
-		"those buffers, but at the cost of nailing down the memory from "
-		"the outset.");
+static int alloc_bufs_at_read = 0;
+module_param(alloc_bufs_at_read, bool, 0444);
+MODULE_PARM_DESC(alloc_bufs_at_read,
+		"Non-zero value causes DMA buffers to be allocated when the "
+		"video capture device is read, rather than at module load "
+		"time.  This saves memory, but decreases the chances of "
+		"successfully getting those buffers.");
 
 static int n_dma_bufs = 3;
 module_param(n_dma_bufs, uint, 0644);
@@ -1503,7 +1503,7 @@ static int cafe_v4l_release(struct inode *inode, struct file *filp)
 	}
 	if (cam->users == 0) {
 		cafe_ctlr_power_down(cam);
-		if (! alloc_bufs_at_load)
+		if (alloc_bufs_at_read)
 			cafe_free_dma_bufs(cam);
 	}
 	mutex_unlock(&cam->s_mutex);
@@ -2162,7 +2162,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	/*
 	 * If so requested, try to get our DMA buffers now.
 	 */
-	if (alloc_bufs_at_load) {
+	if (!alloc_bufs_at_read) {
 		if (cafe_alloc_dma_bufs(cam, 1))
 			cam_warn(cam, "Unable to alloc DMA buffers at load"
 					" will try again later.");
