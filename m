Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYJ3A3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYJ3A3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYJ3A3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:29:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:10749 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYJ3A3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:29:02 -0400
Subject: dmaengine: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:29:03 +0100
Message-Id: <1225326543.5970.25.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: dmaengine: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index dc003a3..5317e08 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -399,8 +399,8 @@ int dma_async_device_register(struct dma_device *device)
 		chan->chan_id = chancnt++;
 		chan->dev.class = &dma_devclass;
 		chan->dev.parent = device->dev;
-		snprintf(chan->dev.bus_id, BUS_ID_SIZE, "dma%dchan%d",
-		         device->dev_id, chan->chan_id);
+		dev_set_name(&chan->dev, "dma%dchan%d",
+			     device->dev_id, chan->chan_id);
 
 		rc = device_register(&chan->dev);
 		if (rc) {
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index d1e381e..ed9636b 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -20,11 +20,11 @@ static unsigned int test_buf_size = 16384;
 module_param(test_buf_size, uint, S_IRUGO);
 MODULE_PARM_DESC(test_buf_size, "Size of the memcpy test buffer");
 
-static char test_channel[BUS_ID_SIZE];
+static char test_channel[20];
 module_param_string(channel, test_channel, sizeof(test_channel), S_IRUGO);
 MODULE_PARM_DESC(channel, "Bus ID of the channel to test (default: any)");
 
-static char test_device[BUS_ID_SIZE];
+static char test_device[20];
 module_param_string(device, test_device, sizeof(test_device), S_IRUGO);
 MODULE_PARM_DESC(device, "Bus ID of the DMA Engine to test (default: any)");
 
@@ -80,14 +80,14 @@ static bool dmatest_match_channel(struct dma_chan *chan)
 {
 	if (test_channel[0] == '\0')
 		return true;
-	return strcmp(chan->dev.bus_id, test_channel) == 0;
+	return strcmp(dev_name(&chan->dev), test_channel) == 0;
 }
 
 static bool dmatest_match_device(struct dma_device *device)
 {
 	if (test_device[0] == '\0')
 		return true;
-	return strcmp(device->dev->bus_id, test_device) == 0;
+	return strcmp(dev_name(device->dev), test_device) == 0;
 }
 
 static unsigned long dmatest_random(void)
@@ -332,7 +332,7 @@ static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
 
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
 	if (!dtc) {
-		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
+		pr_warning("dmatest: No memory for %s\n", dev_name(&chan->dev));
 		return DMA_NAK;
 	}
 
@@ -343,16 +343,16 @@ static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
 		thread = kzalloc(sizeof(struct dmatest_thread), GFP_KERNEL);
 		if (!thread) {
 			pr_warning("dmatest: No memory for %s-test%u\n",
-					chan->dev.bus_id, i);
+				   dev_name(&chan->dev), i);
 			break;
 		}
 		thread->chan = dtc->chan;
 		smp_wmb();
 		thread->task = kthread_run(dmatest_func, thread, "%s-test%u",
-				chan->dev.bus_id, i);
+				dev_name(&chan->dev), i);
 		if (IS_ERR(thread->task)) {
 			pr_warning("dmatest: Failed to run thread %s-test%u\n",
-					chan->dev.bus_id, i);
+					dev_name(&chan->dev), i);
 			kfree(thread);
 			break;
 		}
@@ -362,7 +362,7 @@ static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
 		list_add_tail(&thread->node, &dtc->threads);
 	}
 
-	pr_info("dmatest: Started %u threads using %s\n", i, chan->dev.bus_id);
+	pr_info("dmatest: Started %u threads using %s\n", i, dev_name(&chan->dev));
 
 	list_add_tail(&dtc->node, &dmatest_channels);
 	nr_channels++;
@@ -379,7 +379,7 @@ static enum dma_state_client dmatest_remove_channel(struct dma_chan *chan)
 			list_del(&dtc->node);
 			dmatest_cleanup_channel(dtc);
 			pr_debug("dmatest: lost channel %s\n",
-					chan->dev.bus_id);
+					dev_name(&chan->dev));
 			return DMA_ACK;
 		}
 	}
@@ -418,7 +418,7 @@ dmatest_event(struct dma_client *client, struct dma_chan *chan,
 
 	default:
 		pr_info("dmatest: Unhandled event %u (%s)\n",
-				state, chan->dev.bus_id);
+				state, dev_name(&chan->dev));
 		break;
 	}
 

