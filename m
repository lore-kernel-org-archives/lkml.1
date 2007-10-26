Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbXJZREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbXJZREh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXJZREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:04:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:12276 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbXJZREa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,334,1188802800"; 
   d="scan'208";a="306127465"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] DMA: Fix broken device refcounting
Date: Fri, 26 Oct 2007 09:59:41 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C034CC6C7@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1193415162504-git-send-email-hskinnemoen@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] DMA: Fix broken device refcounting
Thread-Index: AcgX6xO6uG3w9lkWQU2JQWJBlHK/CQABg9Zw
References: <1193415162504-git-send-email-hskinnemoen@atmel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Oct 2007 16:59:42.0368 (UTC) FILETIME=[9A51FA00:01C817F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Haavard Skinnemoen [mailto:hskinnemoen@atmel.com] 
>
>When a DMA device is unregistered, its reference count is decremented
>twice for each channel: Once dma_class_dev_release() and once in
>dma_chan_cleanup(). This may result in the DMA device driver's
>remove() function completing before all channels have been cleaned
>up, causing lots of use-after-free fun.
>
>Fix it by incrementing the device's reference count twice for each
>channel during registration.
>
>Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
>---
>I'm not sure if this is the correct way to solve it, but it seems to
>work. The remove() function does not hang, which indicates that the
>device's reference count does drop all the way to zero on
>unregistration, which in turn indicates that it did actually drop
>_below_ zero before.
>
> drivers/dma/dmaengine.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>index 8248992..302eded 100644
>--- a/drivers/dma/dmaengine.c
>+++ b/drivers/dma/dmaengine.c
>@@ -397,6 +397,8 @@ int dma_async_device_register(struct 
>dma_device *device)
> 			goto err_out;
> 		}
> 
>+		/* One for the channel, one of the class device */
>+		kref_get(&device->refcount);
> 		kref_get(&device->refcount);
> 		kref_init(&chan->refcount);
> 		chan->slow_ref = 0;
>-- 
>1.5.2.5
>

As Dan said, we've been discussing this offline, and hadn't come to an
agreement yet.  My version of the patch is the opposite of yours -
instead of adding a kref_get(), I remove one of the kref_put() calls.
--

When a channel is removed from dmaengine, too many kref_put() calls
are made and the device removal happens too soon, usually causing
a panic.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/dmaengine.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8248992..144a1b7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -131,7 +131,6 @@ static void dma_async_device_cleanup(struct kref
*kref);
 static void dma_class_dev_release(struct class_device *cd)
 {
 	struct dma_chan *chan = container_of(cd, struct dma_chan,
class_dev);
-	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
 
 static struct class dma_devclass = {
