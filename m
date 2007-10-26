Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbXJZQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbXJZQM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760957AbXJZQMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:12:51 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56362 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760264AbXJZQMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:12:50 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Shannon Nelson" <shannon.nelson@intel.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] DMA: Fix broken device refcounting
Date: Fri, 26 Oct 2007 18:12:42 +0200
Message-Id: <1193415162504-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a DMA device is unregistered, its reference count is decremented
twice for each channel: Once dma_class_dev_release() and once in
dma_chan_cleanup(). This may result in the DMA device driver's
remove() function completing before all channels have been cleaned
up, causing lots of use-after-free fun.

Fix it by incrementing the device's reference count twice for each
channel during registration.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
I'm not sure if this is the correct way to solve it, but it seems to
work. The remove() function does not hang, which indicates that the
device's reference count does drop all the way to zero on
unregistration, which in turn indicates that it did actually drop
_below_ zero before.

 drivers/dma/dmaengine.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8248992..302eded 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -397,6 +397,8 @@ int dma_async_device_register(struct dma_device *device)
 			goto err_out;
 		}
 
+		/* One for the channel, one of the class device */
+		kref_get(&device->refcount);
 		kref_get(&device->refcount);
 		kref_init(&chan->refcount);
 		chan->slow_ref = 0;
-- 
1.5.2.5

