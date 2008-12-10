Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYLJXNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYLJXNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYLJXNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:13:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:39157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYLJXNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:13:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,749,1220252400"; 
   d="scan'208";a="472913736"
Subject: [git pull] async_tx/dmaengine fixes for 2.6.28-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Saeed Bishara <saeed@marvell.com>, Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 16:13:09 -0700
Message-Id: <1228950789.1224.26.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Dan Williams (3):
      ioat: wait for self-test completion
      dmaengine: protect 'id' from concurrent registrations
      async_xor: dma_map destination DMA_BIDIRECTIONAL

 crypto/async_tx/async_xor.c |   11 +++++++++--
 drivers/dma/dmaengine.c     |    3 +++
 drivers/dma/ioat_dma.c      |    5 ++++-
 drivers/dma/iop-adma.c      |   16 +++++++++++++---
 drivers/dma/mv_xor.c        |   15 ++++++++++++---
 5 files changed, 41 insertions(+), 9 deletions(-)

The ioat fix corrects a driver initialization failure.  The dmaengine
fix should not be triggerable in mainline, but is straightforward.  The
async_xor fix corrects a misuse of the dma-api.  This change is a no-op
for current mainline implementations (mv_xor/iop_adma), but can trip up
xor-drivers in development on platforms where dma_map is more than just
cache maintenance operations.

Regards,
Dan

commit a06d568f7c5e40e34ea64881842deb8f4382babf
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 8 13:46:00 2008 -0700

    async_xor: dma_map destination DMA_BIDIRECTIONAL
    
    Mapping the destination multiple times is a misuse of the dma-api.
    Since the destination may be reused as a source, ensure that it is only
    mapped once and that it is mapped bidirectionally.  This appears to add
    ugliness on the unmap side in that it always reads back the destination
    address from the descriptor, but gcc can determine that dma_unmap is a
    nop and not emit the code that calculates its arguments.
    
    Cc: <stable@kernel.org>
    Cc: Saeed Bishara <saeed@marvell.com>
    Acked-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index c029d3e..595b786 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -53,10 +53,17 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	int xor_src_cnt;
 	dma_addr_t dma_dest;
 
-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_FROM_DEVICE);
-	for (i = 0; i < src_cnt; i++)
+	/* map the dest bidrectional in case it is re-used as a source */
+	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
+	for (i = 0; i < src_cnt; i++) {
+		/* only map the dest once */
+		if (unlikely(src_list[i] == dest)) {
+			dma_src[i] = dma_dest;
+			continue;
+		}
 		dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
 					  len, DMA_TO_DEVICE);
+	}
 
 	while (src_cnt) {
 		async_flags = flags;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c7a9306..6be3172 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -85,18 +85,28 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 			enum dma_ctrl_flags flags = desc->async_tx.flags;
 			u32 src_cnt;
 			dma_addr_t addr;
+			dma_addr_t dest;
 
+			src_cnt = unmap->unmap_src_cnt;
+			dest = iop_desc_get_dest_addr(unmap, iop_chan);
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				addr = iop_desc_get_dest_addr(unmap, iop_chan);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				enum dma_data_direction dir;
+
+				if (src_cnt > 1) /* is xor? */
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+
+				dma_unmap_page(dev, dest, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = iop_desc_get_src_addr(unmap,
 								     iop_chan,
 								     src_cnt);
+					if (addr == dest)
+						continue;
 					dma_unmap_page(dev, addr, len,
 						       DMA_TO_DEVICE);
 				}
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0328da0..bcda174 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -311,17 +311,26 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 			enum dma_ctrl_flags flags = desc->async_tx.flags;
 			u32 src_cnt;
 			dma_addr_t addr;
+			dma_addr_t dest;
 
+			src_cnt = unmap->unmap_src_cnt;
+			dest = mv_desc_get_dest_addr(unmap);
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				addr = mv_desc_get_dest_addr(unmap);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				enum dma_data_direction dir;
+
+				if (src_cnt > 1) /* is xor ? */
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+				dma_unmap_page(dev, dest, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = mv_desc_get_src_addr(unmap,
 								    src_cnt);
+					if (addr == dest)
+						continue;
 					dma_unmap_page(dev, addr, len,
 						       DMA_TO_DEVICE);
 				}

commit b0b42b16ff2b90f17bc1a4308366c9beba4b276e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Dec 3 17:17:07 2008 -0700

    dmaengine: protect 'id' from concurrent registrations
    
    There is a possibility to have two devices registered with the same id.
    
    Cc: <stable@kernel.org>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 5317e08..6579965 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -388,7 +388,10 @@ int dma_async_device_register(struct dma_device *device)
 
 	init_completion(&device->done);
 	kref_init(&device->refcount);
+
+	mutex_lock(&dma_list_mutex);
 	device->dev_id = id++;
+	mutex_unlock(&dma_list_mutex);
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {

commit 532d3b1f86f41834a25373e3ded981d68e4ce17f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Dec 3 17:16:55 2008 -0700

    ioat: wait for self-test completion
    
    As part of the ioat_dma self-test it performs a printk from a completion
    callback.  Depending on the system console configuration this output can
    take longer than a millisecond causing the self-test to fail.  Introduce a
    completion with a generous timeout to mitigate this failure.
    
    Cc: <stable@kernel.org>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index ecd743f..6607fdd 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1341,10 +1341,12 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
  */
 #define IOAT_TEST_SIZE 2000
 
+DECLARE_COMPLETION(test_completion);
 static void ioat_dma_test_callback(void *dma_async_param)
 {
 	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
 		dma_async_param);
+	complete(&test_completion);
 }
 
 /**
@@ -1410,7 +1412,8 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 		goto free_resources;
 	}
 	device->common.device_issue_pending(dma_chan);
-	msleep(1);
+
+	wait_for_completion_timeout(&test_completion, msecs_to_jiffies(3000));
 
 	if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
 					!= DMA_SUCCESS) {


