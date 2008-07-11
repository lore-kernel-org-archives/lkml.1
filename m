Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYGKLra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYGKLra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbYGKLrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:47:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:45420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986AbYGKLrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:47:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,344,1212390000"; 
   d="scan'208";a="590928109"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 2/2] I/OAT: tcp_dma_copybreak default value dependant on I/OAT
	version
To: dan.j.williams@intel.com
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:37:08 +0200
Message-ID: <20080711113703.337.72444.stgit@linux.site>
In-Reply-To: <20080711113553.337.50006.stgit@linux.site>
References: <20080711113553.337.50006.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I/OAT DMA performance tuning showed different optimal values 
of tcp_dma_copybreak for different I/OAT versions
(4096 for 1.2 and 2048 for 2.0).
This patch lets ioatdma driver set tcp_dma_copybreak value 
according to these results.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---

 drivers/dma/dmaengine.c   |    3 +++
 drivers/dma/ioat_dma.c    |   15 +++++++++++++++
 include/linux/dmaengine.h |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 97b329e..d57365a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -70,6 +70,7 @@ #include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
+#include <net/tcp.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static LIST_HEAD(dma_device_list);
@@ -402,6 +403,8 @@ int dma_async_device_register(struct dma
 	list_add_tail(&device->global_node, &dma_device_list);
 	mutex_unlock(&dma_list_mutex);
 
+	sysctl_tcp_dma_copybreak = device->tcp_dma_copybreak;
+
 	dma_clients_notify_available();
 
 	return 0;
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 9c0b90a..42e5bfb 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -53,6 +53,12 @@ #define WATCHDOG_DELAY  round_jiffies(ms
 static void ioat_dma_chan_reset_part2(struct work_struct *work);
 static void ioat_dma_chan_watchdog(struct work_struct *work);
 
+/*
+ * default tcp_dma_copybreak values for different IOAT versions
+ */
+#define IOAT1_DEFAULT_TCP_DMA_COPYBREAK 4096
+#define IOAT2_DEFAULT_TCP_DMA_COPYBREAK 2048
+
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
@@ -1571,6 +1577,15 @@ struct ioatdma_device *ioat_dma_probe(st
 	if (err)
 		goto err_self_test;
 
+	switch (device->version) {
+	case IOAT_VER_1_2:
+		device->common.tcp_dma_copybreak = IOAT1_DEFAULT_TCP_DMA_COPYBREAK;
+		break;
+	case IOAT_VER_2_0:
+		device->common.tcp_dma_copybreak = IOAT2_DEFAULT_TCP_DMA_COPYBREAK;
+		break;
+	}
+
 	dma_async_device_register(&device->common);
 
 	INIT_DELAYED_WORK(&device->work, ioat_dma_chan_watchdog);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d08a5c5..c09128e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -251,6 +251,7 @@ struct dma_async_tx_descriptor {
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
+ * @tcp_dma_copybreak: lower limit of TCP socket reads size offloaded by DMA 
  * @refcount: reference count
  * @done: IO completion struct
  * @dev_id: unique device ID
@@ -272,6 +273,7 @@ struct dma_device {
 	struct list_head global_node;
 	dma_cap_mask_t  cap_mask;
 	int max_xor;
+	int tcp_dma_copybreak;
 
 	struct kref refcount;
 	struct completion done;

