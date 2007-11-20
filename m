Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXKTRes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXKTRes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXKTRek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:34:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:1130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbXKTRej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:34:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,442,1188802800"; 
   d="scan'208";a="235095346"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] dmaengine: Simple DMA memcpy test client
Date: Tue, 20 Nov 2007 09:34:38 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03752493@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] dmaengine: Simple DMA memcpy test client
Thread-Index: AcgraREWxxHSltbhROWaiCdqzIpHpgALDUzQ
References: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "Olof Johansson" <olof@lixom.net>
X-OriginalArrivalTime: 20 Nov 2007 17:34:39.0007 (UTC) FILETIME=[A05772F0:01C82B9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Haavard Skinnemoen [mailto:hskinnemoen@atmel.com] 
>
>This client tests DMA memcpy using various lengths and various offsets
>into the source and destination buffers. It will initialize both
>buffers with a know pattern and verify that the DMA engine copies the
>requested region and nothing more.
>
>Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
>---

[...]

>diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
>new file mode 100644
>index 0000000..d9e9866
>--- /dev/null
>+++ b/drivers/dma/dmatest.c
>@@ -0,0 +1,272 @@
>+/*
>+ * DMA Engine test module
>+ *
>+ * Copyright (C) 2007 Atmel Corporation
>+ *
>+ * This program is free software; you can redistribute it 
>and/or modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+#include <linux/delay.h>
>+#include <linux/dmaengine.h>
>+#include <linux/init.h>
>+#include <linux/kthread.h>
>+#include <linux/module.h>
>+#include <linux/random.h>
>+#include <linux/wait.h>
>+
>+#define TEST_BUF_SIZE		(16384)

You might make this a module parameter so we can test with various
sizes.


>+
>+#define SRC_PATTERN		0x7c
>+#define SRC_PATTERN_OUTSIDE	0X8d
>+#define POISON_UNINIT		0x49
>+#define POISON_OUTSIDE		0x37
>+
>+struct dmatest {
>+	spinlock_t		lock;
>+	struct dma_client	client;
>+	struct task_struct	*thread;
>+	struct dma_chan		*chan;
>+	wait_queue_head_t	wq;
>+	u8			*srcbuf;
>+	u8			*dstbuf;
>+};
>+
>+static inline struct dmatest *to_dmatest(struct dma_client *client)
>+{
>+	return container_of(client, struct dmatest, client);
>+}
>+
>+static enum dma_state_client
>+dmatest_event(struct dma_client *client, struct dma_chan *chan,
>+		enum dma_state state)
>+{
>+	struct dmatest		*test = to_dmatest(client);
>+	enum dma_state_client	ack = DMA_DUP;

DMA_NAK is better default for DMA_RESOURCE_AVAILABLE once you've got the
channel you want, as that will stop DMAEngine from handing you more, and
doesn't bother the DMA_RESOURCE_REMOVED process.

>+
>+	spin_lock(&test->lock);
>+	switch (state) {
>+	case DMA_RESOURCE_AVAILABLE:
>+		if (!test->chan) {
>+			printk(KERN_INFO "dmatest: Got channel %s\n",
>+				chan->dev.bus_id);
>+			test->chan = chan;
>+			wake_up_interruptible(&test->wq);
>+			ack = DMA_ACK;
>+		}
>+		break;

Do you ever want to test a specific channel?  Is there a way to identify
specific channels, perhaps by checking the PCI bus/chan/func?  This
could be useful in debugging specific hardware issues - a frilly extra
feature and very HW specific, but potentially useful.  I suppose this
might also depend upon your hardware - is there more than one channel in
your gizmo?

>+
>+	case DMA_RESOURCE_REMOVED:
>+		if (test->chan == chan) {

Should you use your test->lock here? 

>+			printk(KERN_INFO "dmatest: Lost channel %s\n",
>+				chan->dev.bus_id);
>+			test->chan = NULL;
>+			ack = DMA_ACK;
>+		}
>+		break;
>+
>+	default:

Since this is a test program, perhaps a printk() here might be useful...

>+		break;
>+	}
>+	spin_unlock(&test->lock);
>+
>+	return ack;
>+}
>+
>+static unsigned long dmatest_random(void)
>+{
>+	unsigned long buf;
>+
>+	get_random_bytes(&buf, sizeof(buf));
>+	return buf;
>+}
>+
>+static unsigned int dmatest_verify(u8 *buf, unsigned int start,
>+		unsigned int end, u8 expected)
>+{
>+	unsigned int i;
>+	unsigned int error_count = 0;
>+
>+	for (i = start; i < end; i++) {
>+		if (buf[i] != expected) {
>+			if (error_count < 32)
>+				printk(KERN_ERR "dmatest: 
>buf[0x%x] = %02x "
>+					"(expected %02x)\n",
>+					i, buf[i], expected);
>+			error_count++;
>+		}
>+	}
>+
>+	if (error_count > 32)
>+		printk(KERN_ERR "dmatest: %u errors suppressed\n",
>+			error_count - 32);
>+
>+	return error_count;
>+}
>+
>+static int dmatest_func(void *data)
>+{
>+	struct dmatest	*test = data;
>+	struct dma_chan	*chan;
>+	bool		should_stop = false;
>+	unsigned int	src_off, dst_off, len;
>+	unsigned int	error_count;
>+	dma_cookie_t	cookie;
>+	enum dma_status	status;
>+
>+	dma_cap_set(DMA_MEMCPY, test->client.cap_mask);
>+	dma_async_client_register(&test->client);
>+	dma_async_client_chan_request(&test->client);
>+
>+	for (;;) {
>+		DEFINE_WAIT(chan_wait);
>+
>+		pr_debug("dmatest: Waiting for a channel...\n");
>+		for (;;) {
>+			spin_lock(&test->lock);
>+			prepare_to_wait(&test->wq, &chan_wait,
>+					TASK_UNINTERRUPTIBLE);

Hmmm - so the only way to trigger the loop is to remove then add a
channel, basically rmmod and insmod your dma driver?  It would be nice
to have a method to trigger more than one test, maybe even a stream of
copy requests.  Or am I asking for too many features?  :-)

>+			if (kthread_should_stop()) {
>+				should_stop = true;
>+				break;
>+			}
>+
>+			if (test->chan) {
>+				chan = test->chan;
>+				dma_chan_get(chan);

I suppose you are doing this extra get and put to be absolutely sure the
channel doesn't disappear out from under you, even though your
dmatest_event() already ACK'd the removal, right?

[...]


Thanks for posting this.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
