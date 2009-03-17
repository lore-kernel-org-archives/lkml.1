Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbZCQQJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbZCQQJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZCQQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:09:43 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:56626 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbZCQQJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:09:42 -0400
Date: Wed, 18 Mar 2009 01:09:39 +0900 (JST)
Message-Id: <20090318.010939.128619068.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
References: <1237240246.27945.6.camel@dwillia2-linux.ch.intel.com>
	<20090317.112019.147212126.nemoto@toshiba-tops.co.jp>
	<e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 21:52:10 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Hmm.. why idr_ref is dynamically allocated?  Just putting it in
> > dma_device makes thing more simple, no?
> 
> The sysfs device has a longer lifetime than dma_device.  See commit
> 41d5e59c [1].

The sysfs device for dma_chan (dma_chan_dev) has a shorter lifetime
than dma_device, doesn't it?

I mean something like this (only compile tested):
------------------------------------------------------
Subject: dmaengine: Add idr_ref to dma_device

This fixes memory leak on some error path.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 280a9d2..0708931 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -153,7 +153,6 @@ static void chan_dev_release(struct device *dev)
 		mutex_lock(&dma_list_mutex);
 		idr_remove(&dma_idr, chan_dev->dev_id);
 		mutex_unlock(&dma_list_mutex);
-		kfree(chan_dev->idr_ref);
 	}
 	kfree(chan_dev);
 }
@@ -610,7 +609,6 @@ int dma_async_device_register(struct dma_device *device)
 {
 	int chancnt = 0, rc;
 	struct dma_chan* chan;
-	atomic_t *idr_ref;
 
 	if (!device)
 		return -ENODEV;
@@ -637,10 +635,7 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
-	idr_ref = kmalloc(sizeof(*idr_ref), GFP_KERNEL);
-	if (!idr_ref)
-		return -ENOMEM;
-	atomic_set(idr_ref, 0);
+	atomic_set(&device->idr_ref, 0);
  idr_retry:
 	if (!idr_pre_get(&dma_idr, GFP_KERNEL))
 		return -ENOMEM;
@@ -667,9 +662,9 @@ int dma_async_device_register(struct dma_device *device)
 		chan->dev->device.class = &dma_devclass;
 		chan->dev->device.parent = device->dev;
 		chan->dev->chan = chan;
-		chan->dev->idr_ref = idr_ref;
+		chan->dev->idr_ref = &device->idr_ref;
 		chan->dev->dev_id = device->dev_id;
-		atomic_inc(idr_ref);
+		atomic_inc(&device->idr_ref);
 		dev_set_name(&chan->dev->device, "dma%dchan%d",
 			     device->dev_id, chan->chan_id);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1956c8d..9e99d82 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -234,6 +234,7 @@ struct dma_device {
 
 	int dev_id;
 	struct device *dev;
+	atomic_t idr_ref;
 
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
