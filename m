Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYBLQox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYBLQox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763404AbYBLQoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:44:14 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63633 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758314AbYBLQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:44:09 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v3 3/7] dmaengine: Add dma_chan_is_in_use() function
Date: Tue, 12 Feb 2008 17:43:54 +0100
Message-Id: <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the code checking if a DMA channel is in use from
show_in_use() into an inline helper function, dma_is_in_use(). DMA
controllers can use this in order to give clients exclusive access to
channels (usually necessary when setting up slave DMA.)

I have to admit that I don't really understand the channel refcounting
logic at all... dma_chan_get() simply increments a per-cpu value. How
can we be sure that whatever CPU calls dma_chan_is_in_use() sees the
same value?

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c   |   12 +-----------
 include/linux/dmaengine.h |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d11f06..3076d80 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -105,17 +105,7 @@ static ssize_t show_bytes_transferred(struct device *dev, struct device_attribut
 static ssize_t show_in_use(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct dma_chan *chan = to_dma_chan(dev);
-	int in_use = 0;
-
-	if (unlikely(chan->slow_ref) &&
-		atomic_read(&chan->refcount.refcount) > 1)
-		in_use = 1;
-	else {
-		if (local_read(&(per_cpu_ptr(chan->local,
-			get_cpu())->refcount)) > 0)
-			in_use = 1;
-		put_cpu();
-	}
+	int in_use = dma_chan_is_in_use(chan);
 
 	return sprintf(buf, "%d\n", in_use);
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9cd7ed9..5d9a3a2 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -175,6 +175,23 @@ static inline void dma_chan_put(struct dma_chan *chan)
 	}
 }
 
+static inline bool dma_chan_is_in_use(struct dma_chan *chan)
+{
+	bool in_use = false;
+
+	if (unlikely(chan->slow_ref) &&
+		atomic_read(&chan->refcount.refcount) > 1)
+		in_use = true;
+	else {
+		if (local_read(&(per_cpu_ptr(chan->local,
+			get_cpu())->refcount)) > 0)
+			in_use = true;
+		put_cpu();
+	}
+
+	return in_use;
+}
+
 /*
  * typedef dma_event_callback - function pointer to a DMA event callback
  * For each channel added to the system this routine is called for each client.
-- 
1.5.3.8

