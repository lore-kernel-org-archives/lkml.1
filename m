Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXCSThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXCSThm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXCSThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:37:42 -0400
Received: from saeurebad.de ([85.214.36.134]:54021 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbXCSThl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:37:41 -0400
Date: Mon, 19 Mar 2007 20:33:02 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] dmaenginge.c: class_device_register() return value
Message-ID: <20070319193301.GA11921@leiferikson>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this patch makes dma_async_device_register() in drivers/dma/dmaengine.c
handle a failing class_device_register().  Patched against Linus' git
tree, compile-tested.

I also thought about calling dma_async_device_unregister on failure, but
I was not quite sure if this would work.  And I noticed that memory is
allocated for chan->local in dma_async_device_register() but I couldn't
find where it is released again.

I am quite new to this all, please give me feedback!


Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dmaengine_class_device_register_retval.patch"

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 322ee29..5560e39 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -316,8 +316,8 @@ EXPORT_SYMBOL(dma_async_client_chan_request);
 int dma_async_device_register(struct dma_device *device)
 {
 	static int id;
-	int chancnt = 0;
-	struct dma_chan* chan;
+	int chancnt, err;
+	struct dma_chan *chan, *last;
 
 	if (!device)
 		return -ENODEV;
@@ -326,9 +326,13 @@ int dma_async_device_register(struct dma_device *device)
 	kref_init(&device->refcount);
 	device->dev_id = id++;
 
+	err = chancnt = 0;
+
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
 		chan->local = alloc_percpu(typeof(*chan->local));
+
+		/* Should this be handled less relaxed? */
 		if (chan->local == NULL)
 			continue;
 
@@ -339,7 +343,11 @@ int dma_async_device_register(struct dma_device *device)
 		         device->dev_id, chan->chan_id);
 
 		kref_get(&device->refcount);
-		class_device_register(&chan->class_dev);
+		err = class_device_register(&chan->class_dev);
+		if (err) {
+			last = chan;
+			goto err_dev_reg;
+		}
 	}
 
 	mutex_lock(&dma_list_mutex);
@@ -349,6 +357,22 @@ int dma_async_device_register(struct dma_device *device)
 	dma_chans_rebalance();
 
 	return 0;
+
+err_dev_reg:
+	list_for_each_entry(chan, &device->channels, device_node) {
+		kref_put(&device->refcount, dma_async_device_cleanup);
+
+		if (chan->local)
+			free_percpu(chan->local);
+
+		if (chan == last)
+			break;
+
+		class_device_unregister(&chan->class_dev);
+	}
+	wait_for_completion(&device->done);
+	device->dev_id = 0;
+	return err;
 }
 EXPORT_SYMBOL(dma_async_device_register);
 
diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 8e87261..c25f548 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -768,10 +768,13 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_self_test;
 
-	dma_async_device_register(&device->common);
+	err = dma_async_device_register(&device->common)
+	if (err)
+		goto err_dev_reg;
 
 	return 0;
 
+err_dev_reg:
 err_self_test:
 err_irq:
 	pci_pool_destroy(device->completion_pool);

--VbJkn9YxBvnuCH5J--
