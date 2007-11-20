Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbXKTLc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbXKTLc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 06:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXKTLcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 06:32:51 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51667 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755619AbXKTLcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 06:32:50 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] dmaengine: Simple DMA memcpy test client
Date: Tue, 20 Nov 2007 12:32:34 +0100
Message-Id: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This client tests DMA memcpy using various lengths and various offsets
into the source and destination buffers. It will initialize both
buffers with a know pattern and verify that the DMA engine copies the
requested region and nothing more.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
This patch depends on "DMAENGINE: Convert from class_device to
device". Please let me know if you want a patch that doesn't.

 drivers/dma/Kconfig   |    8 ++
 drivers/dma/Makefile  |    1 +
 drivers/dma/dmatest.c |  272 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 281 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/dmatest.c

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6a7d25f..b669595 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -49,4 +49,12 @@ config NET_DMA
 	  Since this is the main user of the DMA engine, it should be enabled;
 	  say Y here.
 
+config DMATEST
+	tristate "DMA Test client"
+	depends on DMA_ENGINE
+	default n
+	help
+	  Simple DMA test client. Say N unless you're debugging a
+	  DMA Device driver.
+
 endif
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index b152cd8..7ab85ae 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
+obj-$(CONFIG_DMATEST) += dmatest.o
 ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
new file mode 100644
index 0000000..d9e9866
--- /dev/null
+++ b/drivers/dma/dmatest.c
@@ -0,0 +1,272 @@
+/*
+ * DMA Engine test module
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/wait.h>
+
+#define TEST_BUF_SIZE		(16384)
+
+#define SRC_PATTERN		0x7c
+#define SRC_PATTERN_OUTSIDE	0X8d
+#define POISON_UNINIT		0x49
+#define POISON_OUTSIDE		0x37
+
+struct dmatest {
+	spinlock_t		lock;
+	struct dma_client	client;
+	struct task_struct	*thread;
+	struct dma_chan		*chan;
+	wait_queue_head_t	wq;
+	u8			*srcbuf;
+	u8			*dstbuf;
+};
+
+static inline struct dmatest *to_dmatest(struct dma_client *client)
+{
+	return container_of(client, struct dmatest, client);
+}
+
+static enum dma_state_client
+dmatest_event(struct dma_client *client, struct dma_chan *chan,
+		enum dma_state state)
+{
+	struct dmatest		*test = to_dmatest(client);
+	enum dma_state_client	ack = DMA_DUP;
+
+	spin_lock(&test->lock);
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		if (!test->chan) {
+			printk(KERN_INFO "dmatest: Got channel %s\n",
+				chan->dev.bus_id);
+			test->chan = chan;
+			wake_up_interruptible(&test->wq);
+			ack = DMA_ACK;
+		}
+		break;
+
+	case DMA_RESOURCE_REMOVED:
+		if (test->chan == chan) {
+			printk(KERN_INFO "dmatest: Lost channel %s\n",
+				chan->dev.bus_id);
+			test->chan = NULL;
+			ack = DMA_ACK;
+		}
+		break;
+
+	default:
+		break;
+	}
+	spin_unlock(&test->lock);
+
+	return ack;
+}
+
+static unsigned long dmatest_random(void)
+{
+	unsigned long buf;
+
+	get_random_bytes(&buf, sizeof(buf));
+	return buf;
+}
+
+static unsigned int dmatest_verify(u8 *buf, unsigned int start,
+		unsigned int end, u8 expected)
+{
+	unsigned int i;
+	unsigned int error_count = 0;
+
+	for (i = start; i < end; i++) {
+		if (buf[i] != expected) {
+			if (error_count < 32)
+				printk(KERN_ERR "dmatest: buf[0x%x] = %02x "
+					"(expected %02x)\n",
+					i, buf[i], expected);
+			error_count++;
+		}
+	}
+
+	if (error_count > 32)
+		printk(KERN_ERR "dmatest: %u errors suppressed\n",
+			error_count - 32);
+
+	return error_count;
+}
+
+static int dmatest_func(void *data)
+{
+	struct dmatest	*test = data;
+	struct dma_chan	*chan;
+	bool		should_stop = false;
+	unsigned int	src_off, dst_off, len;
+	unsigned int	error_count;
+	dma_cookie_t	cookie;
+	enum dma_status	status;
+
+	dma_cap_set(DMA_MEMCPY, test->client.cap_mask);
+	dma_async_client_register(&test->client);
+	dma_async_client_chan_request(&test->client);
+
+	for (;;) {
+		DEFINE_WAIT(chan_wait);
+
+		pr_debug("dmatest: Waiting for a channel...\n");
+		for (;;) {
+			spin_lock(&test->lock);
+			prepare_to_wait(&test->wq, &chan_wait,
+					TASK_UNINTERRUPTIBLE);
+			if (kthread_should_stop()) {
+				should_stop = true;
+				break;
+			}
+
+			if (test->chan) {
+				chan = test->chan;
+				dma_chan_get(chan);
+				break;
+			}
+			spin_unlock(&test->lock);
+
+			schedule();
+		}
+		finish_wait(&test->wq, &chan_wait);
+		spin_unlock(&test->lock);
+
+		if (should_stop)
+			break;
+
+		pr_debug("dmatest: Got it!\n");
+
+		len = dmatest_random() % TEST_BUF_SIZE;
+		src_off = dmatest_random() % (TEST_BUF_SIZE - len);
+		dst_off = dmatest_random() % (TEST_BUF_SIZE - len);
+
+		memset(test->srcbuf, SRC_PATTERN_OUTSIDE, src_off);
+		memset(test->srcbuf + src_off, SRC_PATTERN, len);
+		memset(test->srcbuf + src_off + len, SRC_PATTERN_OUTSIDE,
+				TEST_BUF_SIZE - (src_off + len));
+		memset(test->dstbuf, POISON_OUTSIDE, dst_off);
+		memset(test->dstbuf + dst_off, POISON_UNINIT, len);
+		memset(test->dstbuf + dst_off + len, POISON_OUTSIDE,
+				TEST_BUF_SIZE - (dst_off + len));
+
+		cookie = dma_async_memcpy_buf_to_buf(chan,
+				test->dstbuf + dst_off,
+				test->srcbuf + src_off,
+				len);
+		if (dma_submit_error(cookie)) {
+			printk("dmatest: submit error: %d\n", cookie);
+			dma_chan_put(chan);
+			msleep(100);
+			continue;
+		}
+		dma_async_memcpy_issue_pending(chan);
+
+		do {
+			msleep(1);
+			status = dma_async_memcpy_complete(
+					chan, cookie, NULL, NULL);
+		} while (status == DMA_IN_PROGRESS);
+
+		dma_chan_put(chan);
+
+		if (status == DMA_ERROR) {
+			printk("dmatest: error during copy\n");
+			continue;
+		}
+
+		error_count = 0;
+
+		printk(KERN_INFO "dmatest: verifying source buffer...\n");
+		error_count += dmatest_verify(test->srcbuf, 0, src_off,
+				SRC_PATTERN_OUTSIDE);
+		error_count += dmatest_verify(test->srcbuf, src_off,
+				src_off + len, SRC_PATTERN);
+		error_count += dmatest_verify(test->srcbuf, src_off + len,
+				TEST_BUF_SIZE, SRC_PATTERN_OUTSIDE);
+
+		printk(KERN_INFO "dmatest: verifying dest buffer...\n");
+		error_count += dmatest_verify(test->dstbuf, 0, dst_off,
+				POISON_OUTSIDE);
+		error_count += dmatest_verify(test->dstbuf, dst_off,
+				dst_off + len, SRC_PATTERN);
+		error_count += dmatest_verify(test->dstbuf, dst_off + len,
+				TEST_BUF_SIZE, POISON_OUTSIDE);
+
+		if (error_count)
+			printk(KERN_ERR "dmatest: %u errors with "
+				"src_off=0x%x dst_off=0x%x len=0x%x\n",
+				error_count, src_off, dst_off, len);
+		else
+			printk(KERN_INFO "dmatest: No errors with "
+				"src_off=0x%x dst_off=0x%x len=0x%x\n",
+				src_off, dst_off, len);
+	}
+
+	dma_async_client_unregister(&test->client);
+
+	return 0;
+}
+
+static struct dmatest dmatest_data = {
+	.client		= {
+		.event_callback	= dmatest_event,
+	},
+	.wq		= __WAIT_QUEUE_HEAD_INITIALIZER(dmatest_data.wq),
+};
+
+static int __init dmatest_init(void)
+{
+	struct dmatest	*test = &dmatest_data;
+	int		ret = -ENOMEM;
+
+	spin_lock_init(&test->lock);
+
+	test->srcbuf = kmalloc(TEST_BUF_SIZE, GFP_KERNEL);
+	if (!test->srcbuf)
+		goto err_srcbuf;
+	test->dstbuf = kmalloc(TEST_BUF_SIZE, GFP_KERNEL);
+	if (!test->dstbuf)
+		goto err_dstbuf;
+
+	test->thread = kthread_run(dmatest_func, test, "kdmatestd");
+	if (IS_ERR(test->thread)) {
+		ret = PTR_ERR(test->thread);
+		goto err_kthread;
+	}
+
+	return 0;
+
+err_kthread:
+	kfree(test->dstbuf);
+err_dstbuf:
+	kfree(test->srcbuf);
+err_srcbuf:
+	return ret;
+}
+module_init(dmatest_init);
+
+static void __exit dmatest_exit(void)
+{
+	int ret;
+
+	ret = kthread_stop(dmatest_data.thread);
+	printk("dmatest: Thread exited with status %d\n", ret);
+	kfree(dmatest_data.srcbuf);
+	kfree(dmatest_data.dstbuf);
+}
+module_exit(dmatest_exit);
+
+MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.5.3.4

