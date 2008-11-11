Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYKKUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYKKUjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYKKUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:39:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:31297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYKKUjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:39:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,585,1220252400"; 
   d="scan'208";a="461800388"
Subject: [git pull] dmaengine fixes for 2.6.28-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 13:39:00 -0700
Message-Id: <1226435940.15607.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Dan Williams (2):
      iop-adma: add a dummy read to flush next descriptor update
      iop-adma: use iop_paranoia() for debug BUG_ONs

Kay Sievers (1):
      dmaengine: struct device - replace bus_id with dev_name(), dev_set_name()

 arch/arm/include/asm/hardware/iop3xx-adma.h |    5 +++--
 arch/arm/include/asm/hardware/iop_adma.h    |    6 ++++++
 arch/arm/mach-iop13xx/include/mach/adma.h   |    3 ++-
 drivers/dma/dmaengine.c                     |    4 ++--
 drivers/dma/dmatest.c                       |   22 +++++++++++-----------
 drivers/dma/iop-adma.c                      |   11 ++++++-----
 6 files changed, 30 insertions(+), 21 deletions(-)

A couple more fixes to drivers/dma/ on top of the I/OAT fixes that went
in with the last net-2.6 pull.  I also included the bus_id-to-dev_name
change as I have seen other subsystems merge it for 2.6.28.

Thanks,
Dan

commit 06190d8415219d9eef7d8f04b52a109e34575a76
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Tue Nov 11 13:12:33 2008 -0700

    dmaengine: struct device - replace bus_id with dev_name(), dev_set_name()
    
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

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
 

commit 65e503814dec83c7b2ac955e75919d009109c919
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Nov 11 13:12:33 2008 -0700

    iop-adma: use iop_paranoia() for debug BUG_ONs
    
    Now that the critical read back to flush the next descriptor address is
    fixed we can downgrade some BUG_ONs that need only be enabled when testing
    changes to the driver.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/arch/arm/include/asm/hardware/iop3xx-adma.h b/arch/arm/include/asm/hardware/iop3xx-adma.h
index 87bff09..83e6ba3 100644
--- a/arch/arm/include/asm/hardware/iop3xx-adma.h
+++ b/arch/arm/include/asm/hardware/iop3xx-adma.h
@@ -730,7 +730,8 @@ static inline void iop_desc_set_next_desc(struct iop_adma_desc_slot *desc,
 {
 	/* hw_desc->next_desc is the same location for all channels */
 	union iop3xx_desc hw_desc = { .ptr = desc->hw_desc, };
-	BUG_ON(hw_desc.dma->next_desc);
+
+	iop_paranoia(hw_desc.dma->next_desc);
 	hw_desc.dma->next_desc = next_desc_addr;
 }
 
@@ -760,7 +761,7 @@ static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
 	struct iop3xx_desc_aau *hw_desc = desc->hw_desc;
 	struct iop3xx_aau_desc_ctrl desc_ctrl = hw_desc->desc_ctrl_field;
 
-	BUG_ON(!(desc_ctrl.tx_complete && desc_ctrl.zero_result_en));
+	iop_paranoia(!(desc_ctrl.tx_complete && desc_ctrl.zero_result_en));
 	return desc_ctrl.zero_result_err;
 }
 
diff --git a/arch/arm/include/asm/hardware/iop_adma.h b/arch/arm/include/asm/hardware/iop_adma.h
index cb7e361..385c6e8 100644
--- a/arch/arm/include/asm/hardware/iop_adma.h
+++ b/arch/arm/include/asm/hardware/iop_adma.h
@@ -23,6 +23,12 @@
 
 #define IOP_ADMA_SLOT_SIZE 32
 #define IOP_ADMA_THRESHOLD 4
+#ifdef DEBUG
+#define IOP_PARANOIA 1
+#else
+#define IOP_PARANOIA 0
+#endif
+#define iop_paranoia(x) BUG_ON(IOP_PARANOIA && (x))
 
 /**
  * struct iop_adma_device - internal representation of an ADMA device
diff --git a/arch/arm/mach-iop13xx/include/mach/adma.h b/arch/arm/mach-iop13xx/include/mach/adma.h
index 60019c8..5722e86 100644
--- a/arch/arm/mach-iop13xx/include/mach/adma.h
+++ b/arch/arm/mach-iop13xx/include/mach/adma.h
@@ -404,7 +404,8 @@ static inline void iop_desc_set_next_desc(struct iop_adma_desc_slot *desc,
 					u32 next_desc_addr)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
-	BUG_ON(hw_desc->next_desc);
+
+	iop_paranoia(hw_desc->next_desc);
 	hw_desc->next_desc = next_desc_addr;
 }
 
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 95f5a94..c7a9306 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -431,7 +431,7 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 	BUG_ON(iop_desc_get_next_desc(old_chain_tail) != next_dma); /* flush */
 
 	/* check for pre-chained descriptors */
-	BUG_ON(iop_desc_get_next_desc(sw_desc));
+	iop_paranoia(iop_desc_get_next_desc(sw_desc));
 
 	/* increment the pending count by the number of slots
 	 * memcpy operations have a 1:1 (slot:operation) relation

commit 137cb55c6dcd56cb367285adaf15f808a2a9fec7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Nov 11 13:12:33 2008 -0700

    iop-adma: add a dummy read to flush next descriptor update
    
    The current dummy read references the wrong address allowing the next
    descriptor address update to linger in the store buffer and get passed
    by an 'append' event.
    
    This issue was uncovered by the change from strongly-ordered to device
    memory for the adma registers.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 71fba82..95f5a94 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -411,6 +411,7 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 	int slot_cnt;
 	int slots_per_op;
 	dma_cookie_t cookie;
+	dma_addr_t next_dma;
 
 	grp_start = sw_desc->group_head;
 	slot_cnt = grp_start->slot_cnt;
@@ -425,11 +426,11 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 			 &old_chain_tail->chain_node);
 
 	/* fix up the hardware chain */
-	iop_desc_set_next_desc(old_chain_tail, grp_start->async_tx.phys);
+	next_dma = grp_start->async_tx.phys;
+	iop_desc_set_next_desc(old_chain_tail, next_dma);
+	BUG_ON(iop_desc_get_next_desc(old_chain_tail) != next_dma); /* flush */
 
-	/* 1/ don't add pre-chained descriptors
-	 * 2/ dummy read to flush next_desc write
-	 */
+	/* check for pre-chained descriptors */
 	BUG_ON(iop_desc_get_next_desc(sw_desc));
 
 	/* increment the pending count by the number of slots


