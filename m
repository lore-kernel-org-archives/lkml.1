Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXF0BxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXF0BxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXF0BvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:51:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:48207 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbXF0Bu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,465,1175497200"; 
   d="scan'208";a="259271252"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 04/19] async_tx: add the async_tx api
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Date: Tue, 26 Jun 2007 18:50:55 -0700
Message-ID: <20070627015055.18962.61680.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The async_tx api provides methods for describing a chain of asynchronous
bulk memory transfers/transforms with support for inter-transactional
dependencies.  It is implemented as a dmaengine client that smooths over
the details of different hardware offload engine implementations.  Code
that is written to the api can optimize for asynchronous operation and the
api will fit the chain of operations to the available offload resources. 
 
	I imagine that any piece of ADMA hardware would register with the
	'async_*' subsystem, and a call to async_X would be routed as
	appropriate, or be run in-line. - Neil Brown

async_tx exploits the capabilities of struct dma_async_tx_descriptor to
provide an api of the following general format:

struct dma_async_tx_descriptor *
async_<operation>(..., struct dma_async_tx_descriptor *depend_tx,
			dma_async_tx_callback cb_fn, void *cb_param)
{
	struct dma_chan *chan = async_tx_find_channel(depend_tx, <operation>);
	struct dma_device *device = chan ? chan->device : NULL;
	int int_en = cb_fn ? 1 : 0;
	struct dma_async_tx_descriptor *tx = device ?
		device->device_prep_dma_<operation>(chan, len, int_en) : NULL;

	if (tx) { /* run <operation> asynchronously */
		...
		tx->tx_set_dest(addr, tx, index);
		...
		tx->tx_set_src(addr, tx, index);
		...
		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
	} else { /* run <operation> synchronously */
		...
		<operation>
		...
		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
	}

	return tx;
}

async_tx_find_channel() returns a capable channel from its pool.  The
channel pool is organized as a per-cpu array of channel pointers.  The
async_tx_rebalance() routine is tasked with managing these arrays.  In the
uniprocessor case async_tx_rebalance() tries to spread responsibility
evenly over channels of similar capabilities.  For example if there are two
copy+xor channels, one will handle copy operations and the other will
handle xor.  In the SMP case async_tx_rebalance() attempts to spread the
operations evenly over the cpus, e.g. cpu0 gets copy channel0 and xor
channel0 while cpu1 gets copy channel 1 and xor channel 1.  When a
dependency is specified async_tx_find_channel defaults to keeping the
operation on the same channel.  A xor->copy->xor chain will stay on one
channel if it supports both operation types, otherwise the transaction will
transition between a copy and a xor resource.

Currently the raid5 implementation in the MD raid456 driver has been
converted to the async_tx api.  A driver for the offload engines on the
Intel Xscale series of I/O processors, iop-adma, is provided in a later
commit.  With the iop-adma driver and async_tx, raid456 is able to offload
copy, xor, and xor-zero-sum operations to hardware engines.
 
On iop342 tiobench showed higher throughput for sequential writes (20 - 30%
improvement) and sequential reads to a degraded array (40 - 55%
improvement).  For the other cases performance was roughly equal, +/- a few
percentage points.  On a x86-smp platform the performance of the async_tx
implementation (in synchronous mode) was also +/- a few percentage points
of the original implementation.  According to 'top' on iop342 CPU
utilization drops from ~50% to ~15% during a 'resync' while the speed
according to /proc/mdstat doubles from ~25 MB/s to ~50 MB/s.
 
The tiobench command line used for testing was: tiobench --size 2048
--block 4096 --block 131072 --dir /mnt/raid --numruns 5
* iop342 had 1GB of memory available

Details:
* if CONFIG_DMA_ENGINE=n the asynchronous path is compiled away by making
  async_tx_find_channel a static inline routine that always returns NULL
* when a callback is specified for a given transaction an interrupt will
  fire at operation completion time and the callback will occur in a
  tasklet.  if the the channel does not support interrupts then a live
  polling wait will be performed
* the api is written as a dmaengine client that requests all available
  channels
* In support of dependencies the api implicitly schedules channel-switch
  interrupts.  The interrupt triggers the cleanup tasklet which causes
  pending operations to be scheduled on the next channel
* Xor engines treat an xor destination address differently than a software
  xor routine.  To the software routine the destination address is an implied
  source, whereas engines treat it as a write-only destination.  This patch
  modifies the xor_blocks routine to take a an explicit destination address
  to mirror the hardware.

Changelog:
* fixed a leftover debug print
* don't allow callbacks in async_interrupt_cond
* fixed xor_block changes
* fixed usage of ASYNC_TX_XOR_DROP_DEST
* drop dma mapping methods, suggested by Chris Leech
* printk warning fixups from Andrew Morton
* don't use inline in C files, Adrian Bunk
* select the API when MD is enabled
* BUG_ON xor source counts <= 1
* implicitly handle hardware concerns like channel switching and
  interrupts, Neil Brown
* remove the per operation type list, and distribute operation capabilities
  evenly amongst the available channels
* simplify async_tx_find_channel to optimize the fast path
* introduce the channel_table_initialized flag to prevent early calls to
  the api
* reorganize the code to mimic crypto
* include mm.h as not all archs include it in dma-mapping.h
* make the Kconfig options non-user visible, Adrian Bunk
* move async_tx under crypto since it is meant as 'core' functionality, and
  the two may share algorithms in the future
* move large inline functions into c files
* checkpatch.pl fixes
* gpl v2 only correction

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 crypto/Kconfig                 |    6 
 crypto/Makefile                |    2 
 crypto/async_tx/Kconfig        |   16 +
 crypto/async_tx/Makefile       |    4 
 crypto/async_tx/async_memcpy.c |  131 +++++++++++
 crypto/async_tx/async_memset.c |  109 +++++++++
 crypto/async_tx/async_tx.c     |  497 ++++++++++++++++++++++++++++++++++++++++
 crypto/async_tx/async_xor.c    |  327 ++++++++++++++++++++++++++
 crypto/xor.c                   |   29 +-
 drivers/dma/Kconfig            |    5 
 drivers/md/Kconfig             |    3 
 drivers/md/raid5.c             |   54 ++--
 include/linux/async_tx.h       |  156 +++++++++++++
 include/linux/raid/xor.h       |    5 
 14 files changed, 1294 insertions(+), 50 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b749a1a..07090e9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -5,9 +5,13 @@ config XOR_BLOCKS
 	tristate
 
 #
-# Cryptographic API Configuration
+# async_tx api: hardware offloaded memory transfer/transform support
 #
+source "crypto/async_tx/Kconfig"
 
+#
+# Cryptographic API Configuration
+#
 menu "Cryptographic options"
 
 config CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index 68e934b..0cf17f1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -55,4 +55,4 @@ obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 # generic algorithms and the async_tx api
 #
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
-
+obj-$(CONFIG_ASYNC_CORE) += async_tx/
diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
new file mode 100644
index 0000000..d8fb391
--- /dev/null
+++ b/crypto/async_tx/Kconfig
@@ -0,0 +1,16 @@
+config ASYNC_CORE
+	tristate
+
+config ASYNC_MEMCPY
+	tristate
+	select ASYNC_CORE
+
+config ASYNC_XOR
+	tristate
+	select ASYNC_CORE
+	select XOR_BLOCKS
+
+config ASYNC_MEMSET
+	tristate
+	select ASYNC_CORE
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
new file mode 100644
index 0000000..27baa7d
--- /dev/null
+++ b/crypto/async_tx/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_ASYNC_CORE) += async_tx.o
+obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
+obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
+obj-$(CONFIG_ASYNC_XOR) += async_xor.o
diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
new file mode 100644
index 0000000..a973f4e
--- /dev/null
+++ b/crypto/async_tx/async_memcpy.c
@@ -0,0 +1,131 @@
+/*
+ * copy offload engine support
+ *
+ * Copyright © 2006, Intel Corporation.
+ *
+ *      Dan Williams <dan.j.williams@intel.com>
+ *
+ *      with architecture considerations by:
+ *      Neil Brown <neilb@suse.de>
+ *      Jeff Garzik <jeff@garzik.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/async_tx.h>
+
+/**
+ * async_memcpy - attempt to copy memory with a dma engine.
+ * @dest: destination page
+ * @src: src page
+ * @offset: offset in pages to start transaction
+ * @len: length in bytes
+ * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
+ *	ASYNC_TX_KMAP_SRC, ASYNC_TX_KMAP_DST
+ * @depend_tx: memcpy depends on the result of this transaction
+ * @cb_fn: function to call when the memcpy completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
+	unsigned int src_offset, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY);
+	struct dma_device *device = chan ? chan->device : NULL;
+	int int_en = cb_fn ? 1 : 0;
+	struct dma_async_tx_descriptor *tx = device ?
+		device->device_prep_dma_memcpy(chan, len,
+		int_en) : NULL;
+
+	if (tx) { /* run the memcpy asynchronously */
+		dma_addr_t addr;
+		enum dma_data_direction dir;
+
+		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_FROM_DEVICE;
+
+		addr = dma_map_page(device->dev, dest, dest_offset, len, dir);
+		tx->tx_set_dest(addr, tx, 0);
+
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_TO_DEVICE;
+
+		addr = dma_map_page(device->dev, src, src_offset, len, dir);
+		tx->tx_set_src(addr, tx, 0);
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else { /* run the memcpy synchronously */
+		void *dest_buf, *src_buf;
+		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+
+		/* wait for any prerequisite operations */
+		if (depend_tx) {
+			/* if ack is already set then we cannot be sure
+			 * we are referring to the correct operation
+			 */
+			BUG_ON(depend_tx->ack);
+			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
+				panic("%s: DMA_ERROR waiting for depend_tx\n",
+					__FUNCTION__);
+		}
+
+		if (flags & ASYNC_TX_KMAP_DST)
+			dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
+		else
+			dest_buf = page_address(dest) + dest_offset;
+
+		if (flags & ASYNC_TX_KMAP_SRC)
+			src_buf = kmap_atomic(src, KM_USER0) + src_offset;
+		else
+			src_buf = page_address(src) + src_offset;
+
+		memcpy(dest_buf, src_buf, len);
+
+		if (flags & ASYNC_TX_KMAP_DST)
+			kunmap_atomic(dest_buf, KM_USER0);
+
+		if (flags & ASYNC_TX_KMAP_SRC)
+			kunmap_atomic(src_buf, KM_USER0);
+
+		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_memcpy);
+
+static int __init async_memcpy_init(void)
+{
+	return 0;
+}
+
+static void __exit async_memcpy_exit(void)
+{
+	do { } while (0);
+}
+
+module_init(async_memcpy_init);
+module_exit(async_memcpy_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("asynchronous memcpy api");
+MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
new file mode 100644
index 0000000..66ef635
--- /dev/null
+++ b/crypto/async_tx/async_memset.c
@@ -0,0 +1,109 @@
+/*
+ * memory fill offload engine support
+ *
+ * Copyright © 2006, Intel Corporation.
+ *
+ *      Dan Williams <dan.j.williams@intel.com>
+ *
+ *      with architecture considerations by:
+ *      Neil Brown <neilb@suse.de>
+ *      Jeff Garzik <jeff@garzik.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/async_tx.h>
+
+/**
+ * async_memset - attempt to fill memory with a dma engine.
+ * @dest: destination page
+ * @val: fill value
+ * @offset: offset in pages to start transaction
+ * @len: length in bytes
+ * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: memset depends on the result of this transaction
+ * @cb_fn: function to call when the memcpy completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_memset(struct page *dest, int val, unsigned int offset,
+	size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET);
+	struct dma_device *device = chan ? chan->device : NULL;
+	int int_en = cb_fn ? 1 : 0;
+	struct dma_async_tx_descriptor *tx = device ?
+		device->device_prep_dma_memset(chan, val, len,
+			int_en) : NULL;
+
+	if (tx) { /* run the memset asynchronously */
+		dma_addr_t dma_addr;
+		enum dma_data_direction dir;
+
+		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_FROM_DEVICE;
+
+		dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+		tx->tx_set_dest(dma_addr, tx, 0);
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else { /* run the memset synchronously */
+		void *dest_buf;
+		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+
+		dest_buf = (void *) (((char *) page_address(dest)) + offset);
+
+		/* wait for any prerequisite operations */
+		if (depend_tx) {
+			/* if ack is already set then we cannot be sure
+			 * we are referring to the correct operation
+			 */
+			BUG_ON(depend_tx->ack);
+			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
+				panic("%s: DMA_ERROR waiting for depend_tx\n",
+					__FUNCTION__);
+		}
+
+		memset(dest_buf, val, len);
+
+		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_memset);
+
+static int __init async_memset_init(void)
+{
+	return 0;
+}
+
+static void __exit async_memset_exit(void)
+{
+	do { } while (0);
+}
+
+module_init(async_memset_init);
+module_exit(async_memset_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("asynchronous memset api");
+MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
new file mode 100644
index 0000000..0350071
--- /dev/null
+++ b/crypto/async_tx/async_tx.c
@@ -0,0 +1,497 @@
+/*
+ * core routines for the asynchronous memory transfer/transform api
+ *
+ * Copyright © 2006, Intel Corporation.
+ *
+ *	Dan Williams <dan.j.williams@intel.com>
+ *
+ *	with architecture considerations by:
+ *	Neil Brown <neilb@suse.de>
+ *	Jeff Garzik <jeff@garzik.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/async_tx.h>
+
+#ifdef CONFIG_DMA_ENGINE
+static enum dma_state_client
+dma_channel_add_remove(struct dma_client *client,
+	struct dma_chan *chan, enum dma_state state);
+
+static struct dma_client async_tx_dma = {
+	.event_callback = dma_channel_add_remove,
+	/* .cap_mask == 0 defaults to all channels */
+};
+
+/**
+ * dma_cap_mask_all - enable iteration over all operation types
+ */
+static dma_cap_mask_t dma_cap_mask_all;
+
+/**
+ * chan_ref_percpu - tracks channel allocations per core/opertion
+ */
+struct chan_ref_percpu {
+	struct dma_chan_ref *ref;
+};
+
+static int channel_table_initialized;
+static struct chan_ref_percpu *channel_table[DMA_TX_TYPE_END];
+
+/**
+ * async_tx_lock - protect modification of async_tx_master_list and serialize
+ *	rebalance operations
+ */
+static spinlock_t async_tx_lock;
+
+static struct list_head
+async_tx_master_list = LIST_HEAD_INIT(async_tx_master_list);
+
+/* async_tx_issue_pending_all - start all transactions on all channels */
+void async_tx_issue_pending_all(void)
+{
+	struct dma_chan_ref *ref;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+		ref->chan->device->device_issue_pending(ref->chan);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(async_tx_issue_pending_all);
+
+/* dma_wait_for_async_tx - spin wait for a transcation to complete
+ * @tx: transaction to wait on
+ */
+enum dma_status
+dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
+{
+	enum dma_status status;
+	struct dma_async_tx_descriptor *iter;
+
+	if (!tx)
+		return DMA_SUCCESS;
+
+	/* poll through the dependency chain, return when tx is complete */
+	do {
+		iter = tx;
+		while (iter->cookie == -EBUSY)
+			iter = iter->parent;
+
+		status = dma_sync_wait(iter->chan, iter->cookie);
+	} while (status == DMA_IN_PROGRESS || (iter != tx));
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(dma_wait_for_async_tx);
+
+/* async_tx_run_dependencies - helper routine for dma drivers to process
+ *	(start) dependent operations on their target channel
+ * @tx: transaction with dependencies
+ */
+void
+async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
+{
+	struct dma_async_tx_descriptor *dep_tx, *_dep_tx;
+	struct dma_device *dev;
+	struct dma_chan *chan;
+
+	list_for_each_entry_safe(dep_tx, _dep_tx, &tx->depend_list,
+		depend_node) {
+		chan = dep_tx->chan;
+		dev = chan->device;
+		/* we can't depend on ourselves */
+		BUG_ON(chan == tx->chan);
+		list_del(&dep_tx->depend_node);
+		tx->tx_submit(dep_tx);
+
+		/* we need to poke the engine as client code does not
+		 * know about dependency submission events
+		 */
+		dev->device_issue_pending(chan);
+	}
+}
+EXPORT_SYMBOL_GPL(async_tx_run_dependencies);
+
+static void
+free_dma_chan_ref(struct rcu_head *rcu)
+{
+	struct dma_chan_ref *ref;
+	ref = container_of(rcu, struct dma_chan_ref, rcu);
+	kfree(ref);
+}
+
+static void
+init_dma_chan_ref(struct dma_chan_ref *ref, struct dma_chan *chan)
+{
+	INIT_LIST_HEAD(&ref->node);
+	INIT_RCU_HEAD(&ref->rcu);
+	ref->chan = chan;
+	atomic_set(&ref->count, 0);
+}
+
+/**
+ * get_chan_ref_by_cap - returns the nth channel of the given capability
+ * 	defaults to returning the channel with the desired capability and the
+ * 	lowest reference count if the index can not be satisfied
+ * @cap: capability to match
+ * @index: nth channel desired, passing -1 has the effect of forcing the
+ *  default return value
+ */
+static struct dma_chan_ref *
+get_chan_ref_by_cap(enum dma_transaction_type cap, int index)
+{
+	struct dma_chan_ref *ret_ref = NULL, *min_ref = NULL, *ref;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+		if (dma_has_cap(cap, ref->chan->device->cap_mask)) {
+			if (!min_ref)
+				min_ref = ref;
+			else if (atomic_read(&ref->count) <
+				atomic_read(&min_ref->count))
+				min_ref = ref;
+
+			if (index-- == 0) {
+				ret_ref = ref;
+				break;
+			}
+		}
+	rcu_read_unlock();
+
+	if (!ret_ref)
+		ret_ref = min_ref;
+
+	if (ret_ref)
+		atomic_inc(&ret_ref->count);
+
+	return ret_ref;
+}
+
+/**
+ * async_tx_rebalance - redistribute the available channels, optimize
+ * for cpu isolation in the SMP case, and opertaion isolation in the
+ * uniprocessor case
+ */
+static void async_tx_rebalance(void)
+{
+	int cpu, cap, cpu_idx = 0;
+	unsigned long flags;
+
+	if (!channel_table_initialized)
+		return;
+
+	spin_lock_irqsave(&async_tx_lock, flags);
+
+	/* undo the last distribution */
+	for_each_dma_cap_mask(cap, dma_cap_mask_all)
+		for_each_possible_cpu(cpu) {
+			struct dma_chan_ref *ref =
+				per_cpu_ptr(channel_table[cap], cpu)->ref;
+			if (ref) {
+				atomic_set(&ref->count, 0);
+				per_cpu_ptr(channel_table[cap], cpu)->ref =
+									NULL;
+			}
+		}
+
+	for_each_dma_cap_mask(cap, dma_cap_mask_all)
+		for_each_online_cpu(cpu) {
+			struct dma_chan_ref *new;
+			if (NR_CPUS > 1)
+				new = get_chan_ref_by_cap(cap, cpu_idx++);
+			else
+				new = get_chan_ref_by_cap(cap, -1);
+
+			per_cpu_ptr(channel_table[cap], cpu)->ref = new;
+		}
+
+	spin_unlock_irqrestore(&async_tx_lock, flags);
+}
+
+static enum dma_state_client
+dma_channel_add_remove(struct dma_client *client,
+	struct dma_chan *chan, enum dma_state state)
+{
+	unsigned long found, flags;
+	struct dma_chan_ref *master_ref, *ref;
+	enum dma_state_client ack = DMA_DUP; /* default: take no action */
+
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		found = 0;
+		rcu_read_lock();
+		list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+			if (ref->chan == chan) {
+				found = 1;
+				break;
+			}
+		rcu_read_unlock();
+
+		pr_debug("async_tx: dma resource available [%s]\n",
+			found ? "old" : "new");
+
+		if (!found)
+			ack = DMA_ACK;
+		else
+			break;
+
+		/* add the channel to the generic management list */
+		master_ref = kmalloc(sizeof(*master_ref), GFP_KERNEL);
+		if (master_ref) {
+			/* keep a reference until async_tx is unloaded */
+			dma_chan_get(chan);
+			init_dma_chan_ref(master_ref, chan);
+			spin_lock_irqsave(&async_tx_lock, flags);
+			list_add_tail_rcu(&master_ref->node,
+				&async_tx_master_list);
+			spin_unlock_irqrestore(&async_tx_lock,
+				flags);
+		} else {
+			printk(KERN_WARNING "async_tx: unable to create"
+				" new master entry in response to"
+				" a DMA_RESOURCE_ADDED event"
+				" (-ENOMEM)\n");
+			return 0;
+		}
+
+		async_tx_rebalance();
+		break;
+	case DMA_RESOURCE_REMOVED:
+		found = 0;
+		spin_lock_irqsave(&async_tx_lock, flags);
+		list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+			if (ref->chan == chan) {
+				/* permit backing devices to go away */
+				dma_chan_put(ref->chan);
+				list_del_rcu(&ref->node);
+				call_rcu(&ref->rcu, free_dma_chan_ref);
+				found = 1;
+				break;
+			}
+		spin_unlock_irqrestore(&async_tx_lock, flags);
+
+		pr_debug("async_tx: dma resource removed [%s]\n",
+			found ? "ours" : "not ours");
+
+		if (found)
+			ack = DMA_ACK;
+		else
+			break;
+
+		async_tx_rebalance();
+		break;
+	case DMA_RESOURCE_SUSPEND:
+	case DMA_RESOURCE_RESUME:
+		printk(KERN_WARNING "async_tx: does not support dma channel"
+			" suspend/resume\n");
+		break;
+	default:
+		BUG();
+	}
+
+	return ack;
+}
+
+static int __init
+async_tx_init(void)
+{
+	enum dma_transaction_type cap;
+
+	spin_lock_init(&async_tx_lock);
+	bitmap_fill(dma_cap_mask_all.bits, DMA_TX_TYPE_END);
+
+	/* an interrupt will never be an explicit operation type.
+	 * clearing this bit prevents allocation to a slot in 'channel_table'
+	 */
+	clear_bit(DMA_INTERRUPT, dma_cap_mask_all.bits);
+
+	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
+		channel_table[cap] = alloc_percpu(struct chan_ref_percpu);
+		if (!channel_table[cap])
+			goto err;
+	}
+
+	channel_table_initialized = 1;
+	dma_async_client_register(&async_tx_dma);
+	dma_async_client_chan_request(&async_tx_dma);
+
+	printk(KERN_INFO "async_tx: api initialized (async)\n");
+
+	return 0;
+err:
+	printk(KERN_ERR "async_tx: initialization failure\n");
+
+	while (--cap >= 0)
+		free_percpu(channel_table[cap]);
+
+	return 1;
+}
+
+static void __exit async_tx_exit(void)
+{
+	enum dma_transaction_type cap;
+
+	channel_table_initialized = 0;
+
+	for_each_dma_cap_mask(cap, dma_cap_mask_all)
+		if (channel_table[cap])
+			free_percpu(channel_table[cap]);
+
+	dma_async_client_unregister(&async_tx_dma);
+}
+
+/**
+ * async_tx_find_channel - find a channel to carry out the operation or let
+ *	the transaction execute synchronously
+ * @depend_tx: transaction dependency
+ * @tx_type: transaction type
+ */
+struct dma_chan *
+async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
+	enum dma_transaction_type tx_type)
+{
+	/* see if we can keep the chain on one channel */
+	if (depend_tx &&
+		dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
+		return depend_tx->chan;
+	else if (likely(channel_table_initialized)) {
+		struct dma_chan_ref *ref;
+		int cpu = get_cpu();
+		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
+		put_cpu();
+		return ref ? ref->chan : NULL;
+	} else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(async_tx_find_channel);
+#else
+static int __init async_tx_init(void)
+{
+	printk(KERN_INFO "async_tx: api initialized (sync-only)\n");
+	return 0;
+}
+
+static void __exit async_tx_exit(void)
+{
+	do { } while (0);
+}
+#endif
+
+void
+async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	tx->callback = cb_fn;
+	tx->callback_param = cb_param;
+
+	/* set this new tx to run after depend_tx if:
+	 * 1/ a dependency exists (depend_tx is !NULL)
+	 * 2/ the tx can not be submitted to the current channel
+	 */
+	if (depend_tx && depend_tx->chan != chan) {
+		/* if ack is already set then we cannot be sure
+		 * we are referring to the correct operation
+		 */
+		BUG_ON(depend_tx->ack);
+
+		tx->parent = depend_tx;
+		spin_lock_bh(&depend_tx->lock);
+		list_add_tail(&tx->depend_node, &depend_tx->depend_list);
+		if (depend_tx->cookie == 0) {
+			struct dma_chan *dep_chan = depend_tx->chan;
+			struct dma_device *dep_dev = dep_chan->device;
+			dep_dev->device_dependency_added(dep_chan);
+		}
+		spin_unlock_bh(&depend_tx->lock);
+
+		/* schedule an interrupt to trigger the channel switch */
+		async_trigger_callback(ASYNC_TX_ACK, depend_tx, NULL, NULL);
+	} else {
+		tx->parent = NULL;
+		tx->tx_submit(tx);
+	}
+
+	if (flags & ASYNC_TX_ACK)
+		async_tx_ack(tx);
+
+	if (depend_tx && (flags & ASYNC_TX_DEP_ACK))
+		async_tx_ack(depend_tx);
+}
+EXPORT_SYMBOL_GPL(async_tx_submit);
+
+/**
+ * async_trigger_callback - schedules the callback function to be run after
+ * any dependent operations have been completed.
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: 'callback' requires the completion of this transaction
+ * @cb_fn: function to call after depend_tx completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_trigger_callback(enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan;
+	struct dma_device *device;
+	struct dma_async_tx_descriptor *tx;
+
+	if (depend_tx) {
+		chan = depend_tx->chan;
+		device = chan->device;
+
+		/* see if we can schedule an interrupt
+		 * otherwise poll for completion
+		 */
+		if (device && !dma_has_cap(DMA_INTERRUPT, device->cap_mask))
+			device = NULL;
+
+		tx = device ? device->device_prep_dma_interrupt(chan) : NULL;
+	} else
+		tx = NULL;
+
+	if (tx) {
+		pr_debug("%s: (async)\n", __FUNCTION__);
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		pr_debug("%s: (sync)\n", __FUNCTION__);
+
+		/* wait for any prerequisite operations */
+		if (depend_tx) {
+			/* if ack is already set then we cannot be sure
+			 * we are referring to the correct operation
+			 */
+			BUG_ON(depend_tx->ack);
+			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
+				panic("%s: DMA_ERROR waiting for depend_tx\n",
+					__FUNCTION__);
+		}
+
+		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_trigger_callback);
+
+module_init(async_tx_init);
+module_exit(async_tx_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Asynchronous Bulk Memory Transactions API");
+MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
new file mode 100644
index 0000000..2575f67
--- /dev/null
+++ b/crypto/async_tx/async_xor.c
@@ -0,0 +1,327 @@
+/*
+ * xor offload engine api
+ *
+ * Copyright © 2006, Intel Corporation.
+ *
+ *      Dan Williams <dan.j.williams@intel.com>
+ *
+ *      with architecture considerations by:
+ *      Neil Brown <neilb@suse.de>
+ *      Jeff Garzik <jeff@garzik.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/raid/xor.h>
+#include <linux/async_tx.h>
+
+static void
+do_async_xor(struct dma_async_tx_descriptor *tx, struct dma_device *device,
+	struct dma_chan *chan, struct page *dest, struct page **src_list,
+	unsigned int offset, unsigned int src_cnt, size_t len,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	dma_addr_t dma_addr;
+	enum dma_data_direction dir;
+	int i;
+
+	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+
+	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+		DMA_NONE : DMA_FROM_DEVICE;
+
+	dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+	tx->tx_set_dest(dma_addr, tx, 0);
+
+	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+		DMA_NONE : DMA_TO_DEVICE;
+
+	for (i = 0; i < src_cnt; i++) {
+		dma_addr = dma_map_page(device->dev, src_list[i],
+			offset, len, dir);
+		tx->tx_set_src(dma_addr, tx, i);
+	}
+
+	async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+}
+
+static void
+do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
+	unsigned int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	void *_dest;
+	int i;
+
+	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+
+	/* reuse the 'src_list' array to convert to buffer pointers */
+	for (i = 0; i < src_cnt; i++)
+		src_list[i] = (struct page *)
+			(page_address(src_list[i]) + offset);
+
+	/* set destination address */
+	_dest = page_address(dest) + offset;
+
+	if (flags & ASYNC_TX_XOR_ZERO_DST)
+		memset(_dest, 0, len);
+
+	xor_blocks(src_cnt, len, _dest,
+		(void **) src_list);
+
+	async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
+}
+
+/**
+ * async_xor - attempt to xor a set of blocks with a dma engine.
+ *	xor_blocks always uses the dest as a source so the ASYNC_TX_XOR_ZERO_DST
+ *	flag must be set to not include dest data in the calculation.  The
+ *	assumption with dma eninges is that they only use the destination
+ *	buffer as a source when it is explicity specified in the source list.
+ * @dest: destination page
+ * @src_list: array of source pages (if the dest is also a source it must be
+ *	at index zero).  The contents of this array may be overwritten.
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST,
+ *	ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: xor depends on the result of this transaction.
+ * @cb_fn: function to call when the xor completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_xor(struct page *dest, struct page **src_list, unsigned int offset,
+	int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	dma_async_tx_callback _cb_fn;
+	void *_cb_param;
+	unsigned long local_flags;
+	int xor_src_cnt;
+	int i = 0, src_off = 0, int_en;
+
+	BUG_ON(src_cnt <= 1);
+
+	while (src_cnt) {
+		local_flags = flags;
+		if (device) { /* run the xor asynchronously */
+			xor_src_cnt = min(src_cnt, device->max_xor);
+			/* if we are submitting additional xors
+			 * only set the callback on the last transaction
+			 */
+			if (src_cnt > xor_src_cnt) {
+				local_flags &= ~ASYNC_TX_ACK;
+				_cb_fn = NULL;
+				_cb_param = NULL;
+			} else {
+				_cb_fn = cb_fn;
+				_cb_param = cb_param;
+			}
+
+			int_en = _cb_fn ? 1 : 0;
+
+			tx = device->device_prep_dma_xor(
+				chan, xor_src_cnt, len, int_en);
+
+			if (tx) {
+				do_async_xor(tx, device, chan, dest,
+				&src_list[src_off], offset, xor_src_cnt, len,
+				local_flags, depend_tx, _cb_fn,
+				_cb_param);
+			} else /* fall through */
+				goto xor_sync;
+		} else { /* run the xor synchronously */
+xor_sync:
+			/* in the sync case the dest is an implied source
+			 * (assumes the dest is at the src_off index)
+			 */
+			if (flags & ASYNC_TX_XOR_DROP_DST) {
+				src_cnt--;
+				src_off++;
+			}
+
+			/* process up to 'MAX_XOR_BLOCKS' sources */
+			xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
+
+			/* if we are submitting additional xors
+			 * only set the callback on the last transaction
+			 */
+			if (src_cnt > xor_src_cnt) {
+				local_flags &= ~ASYNC_TX_ACK;
+				_cb_fn = NULL;
+				_cb_param = NULL;
+			} else {
+				_cb_fn = cb_fn;
+				_cb_param = cb_param;
+			}
+
+			/* wait for any prerequisite operations */
+			if (depend_tx) {
+				/* if ack is already set then we cannot be sure
+				 * we are referring to the correct operation
+				 */
+				BUG_ON(depend_tx->ack);
+				if (dma_wait_for_async_tx(depend_tx) ==
+					DMA_ERROR)
+					panic("%s: DMA_ERROR waiting for "
+						"depend_tx\n",
+						__FUNCTION__);
+			}
+
+			do_sync_xor(dest, &src_list[src_off], offset,
+				xor_src_cnt, len, local_flags, depend_tx,
+				_cb_fn, _cb_param);
+		}
+
+		/* the previous tx is hidden from the client,
+		 * so ack it
+		 */
+		if (i && depend_tx)
+			async_tx_ack(depend_tx);
+
+		depend_tx = tx;
+
+		if (src_cnt > xor_src_cnt) {
+			/* drop completed sources */
+			src_cnt -= xor_src_cnt;
+			src_off += xor_src_cnt;
+
+			/* unconditionally preserve the destination */
+			flags &= ~ASYNC_TX_XOR_ZERO_DST;
+
+			/* use the intermediate result a source, but remember
+			 * it's dropped, because it's implied, in the sync case
+			 */
+			src_list[--src_off] = dest;
+			src_cnt++;
+			flags |= ASYNC_TX_XOR_DROP_DST;
+		} else
+			src_cnt = 0;
+		i++;
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_xor);
+
+static int page_is_zero(struct page *p, unsigned int offset, size_t len)
+{
+	char *a = page_address(p) + offset;
+	return ((*(u32 *) a) == 0 &&
+		memcmp(a, a + 4, len - 4) == 0);
+}
+
+/**
+ * async_xor_zero_sum - attempt a xor parity check with a dma engine.
+ * @dest: destination page used if the xor is performed synchronously
+ * @src_list: array of source pages.  The dest page must be listed as a source
+ * 	at index zero.  The contents of this array may be overwritten.
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @result: 0 if sum == 0 else non-zero
+ * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: xor depends on the result of this transaction.
+ * @cb_fn: function to call when the xor completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_xor_zero_sum(struct page *dest, struct page **src_list,
+	unsigned int offset, int src_cnt, size_t len,
+	u32 *result, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM);
+	struct dma_device *device = chan ? chan->device : NULL;
+	int int_en = cb_fn ? 1 : 0;
+	struct dma_async_tx_descriptor *tx = device ?
+		device->device_prep_dma_zero_sum(chan, src_cnt, len, result,
+			int_en) : NULL;
+	int i;
+
+	BUG_ON(src_cnt <= 1);
+
+	if (tx) {
+		dma_addr_t dma_addr;
+		enum dma_data_direction dir;
+
+		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_TO_DEVICE;
+
+		for (i = 0; i < src_cnt; i++) {
+			dma_addr = dma_map_page(device->dev, src_list[i],
+				offset, len, dir);
+			tx->tx_set_src(dma_addr, tx, i);
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		unsigned long xor_flags = flags;
+
+		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+
+		xor_flags |= ASYNC_TX_XOR_DROP_DST;
+		xor_flags &= ~ASYNC_TX_ACK;
+
+		tx = async_xor(dest, src_list, offset, src_cnt, len, xor_flags,
+			depend_tx, NULL, NULL);
+
+		if (tx) {
+			if (dma_wait_for_async_tx(tx) == DMA_ERROR)
+				panic("%s: DMA_ERROR waiting for tx\n",
+					__FUNCTION__);
+			async_tx_ack(tx);
+		}
+
+		*result = page_is_zero(dest, offset, len) ? 0 : 1;
+
+		tx = NULL;
+
+		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_xor_zero_sum);
+
+static int __init async_xor_init(void)
+{
+	return 0;
+}
+
+static void __exit async_xor_exit(void)
+{
+	do { } while (0);
+}
+
+module_init(async_xor_init);
+module_exit(async_xor_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
+MODULE_LICENSE("GPL");
diff --git a/crypto/xor.c b/crypto/xor.c
index 8281ac5..b2e6db0 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -26,31 +26,30 @@
 static struct xor_block_template *active_template;
 
 void
-xor_blocks(unsigned int count, unsigned int bytes, void **ptr)
+xor_blocks(unsigned int src_count, unsigned int bytes, void *dest, void **srcs)
 {
-	unsigned long *p0, *p1, *p2, *p3, *p4;
+	unsigned long *p1, *p2, *p3, *p4;
 
-	p0 = (unsigned long *) ptr[0];
-	p1 = (unsigned long *) ptr[1];
-	if (count == 2) {
-		active_template->do_2(bytes, p0, p1);
+	p1 = (unsigned long *) srcs[0];
+	if (src_count == 1) {
+		active_template->do_2(bytes, dest, p1);
 		return;
 	}
 
-	p2 = (unsigned long *) ptr[2];
-	if (count == 3) {
-		active_template->do_3(bytes, p0, p1, p2);
+	p2 = (unsigned long *) srcs[1];
+	if (src_count == 2) {
+		active_template->do_3(bytes, dest, p1, p2);
 		return;
 	}
 
-	p3 = (unsigned long *) ptr[3];
-	if (count == 4) {
-		active_template->do_4(bytes, p0, p1, p2, p3);
+	p3 = (unsigned long *) srcs[2];
+	if (src_count == 3) {
+		active_template->do_4(bytes, dest, p1, p2, p3);
 		return;
 	}
 
-	p4 = (unsigned long *) ptr[4];
-	active_template->do_5(bytes, p0, p1, p2, p3, p4);
+	p4 = (unsigned long *) srcs[3];
+	active_template->do_5(bytes, dest, p1, p2, p3, p4);
 }
 EXPORT_SYMBOL(xor_blocks);
 
@@ -128,7 +127,7 @@ calibrate_xor_blocks(void)
 			fastest->name);
 		xor_speed(fastest);
 	} else {
-		printk(KERN_INFO "xor: measuring checksumming speed\n");
+		printk(KERN_INFO "xor: measuring software checksum speed\n");
 		XOR_TRY_TEMPLATES;
 		fastest = template_list;
 		for (f = fastest; f; f = f->next)
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 72be6c6..492aa08 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -8,8 +8,8 @@ menu "DMA Engine support"
 config DMA_ENGINE
 	bool "Support for DMA engines"
 	---help---
-	  DMA engines offload copy operations from the CPU to dedicated
-	  hardware, allowing the copies to happen asynchronously.
+          DMA engines offload bulk memory operations from the CPU to dedicated
+          hardware, allowing the operations to happen asynchronously.
 
 comment "DMA Clients"
 
@@ -31,5 +31,4 @@ config INTEL_IOATDMA
 	default m
 	---help---
 	  Enable support for the Intel(R) I/OAT DMA engine.
-
 endmenu
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 24d93d0..bfd9b9c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -109,7 +109,8 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
-	select XOR_BLOCKS
+	select ASYNC_MEMCPY
+	select ASYNC_XOR
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5adbe0b..4f51dfa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -916,25 +916,25 @@ static void copy_data(int frombio, struct bio *bio,
 	}
 }
 
-#define check_xor() 	do { 						\
-			   if (count == MAX_XOR_BLOCKS) {		\
-				xor_blocks(count, STRIPE_SIZE, ptr);	\
-				count = 1;				\
-			   }						\
+#define check_xor()	do {						  \
+				if (count == MAX_XOR_BLOCKS) {		  \
+				xor_blocks(count, STRIPE_SIZE, dest, ptr);\
+				count = 0;				  \
+			   }						  \
 			} while(0)
 
 
 static void compute_block(struct stripe_head *sh, int dd_idx)
 {
 	int i, count, disks = sh->disks;
-	void *ptr[MAX_XOR_BLOCKS], *p;
+	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
 
 	PRINTK("compute_block, stripe %llu, idx %d\n", 
 		(unsigned long long)sh->sector, dd_idx);
 
-	ptr[0] = page_address(sh->dev[dd_idx].page);
-	memset(ptr[0], 0, STRIPE_SIZE);
-	count = 1;
+	dest = page_address(sh->dev[dd_idx].page);
+	memset(dest, 0, STRIPE_SIZE);
+	count = 0;
 	for (i = disks ; i--; ) {
 		if (i == dd_idx)
 			continue;
@@ -948,8 +948,8 @@ static void compute_block(struct stripe_head *sh, int dd_idx)
 
 		check_xor();
 	}
-	if (count != 1)
-		xor_blocks(count, STRIPE_SIZE, ptr);
+	if (count)
+		xor_blocks(count, STRIPE_SIZE, dest, ptr);
 	set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 }
 
@@ -957,14 +957,14 @@ static void compute_parity5(struct stripe_head *sh, int method)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i, pd_idx = sh->pd_idx, disks = sh->disks, count;
-	void *ptr[MAX_XOR_BLOCKS];
+	void *ptr[MAX_XOR_BLOCKS], *dest;
 	struct bio *chosen;
 
 	PRINTK("compute_parity5, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
 
-	count = 1;
-	ptr[0] = page_address(sh->dev[pd_idx].page);
+	count = 0;
+	dest = page_address(sh->dev[pd_idx].page);
 	switch(method) {
 	case READ_MODIFY_WRITE:
 		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags));
@@ -987,7 +987,7 @@ static void compute_parity5(struct stripe_head *sh, int method)
 		}
 		break;
 	case RECONSTRUCT_WRITE:
-		memset(ptr[0], 0, STRIPE_SIZE);
+		memset(dest, 0, STRIPE_SIZE);
 		for (i= disks; i-- ;)
 			if (i!=pd_idx && sh->dev[i].towrite) {
 				chosen = sh->dev[i].towrite;
@@ -1003,9 +1003,9 @@ static void compute_parity5(struct stripe_head *sh, int method)
 	case CHECK_PARITY:
 		break;
 	}
-	if (count>1) {
-		xor_blocks(count, STRIPE_SIZE, ptr);
-		count = 1;
+	if (count) {
+		xor_blocks(count, STRIPE_SIZE, dest, ptr);
+		count = 0;
 	}
 	
 	for (i = disks; i--;)
@@ -1037,9 +1037,9 @@ static void compute_parity5(struct stripe_head *sh, int method)
 				check_xor();
 			}
 	}
-	if (count != 1)
-		xor_blocks(count, STRIPE_SIZE, ptr);
-	
+	if (count)
+		xor_blocks(count, STRIPE_SIZE, dest, ptr);
+
 	if (method != CHECK_PARITY) {
 		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
@@ -1132,7 +1132,7 @@ static void compute_parity6(struct stripe_head *sh, int method)
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
 	int i, count, disks = sh->disks;
-	void *ptr[MAX_XOR_BLOCKS], *p;
+	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
@@ -1143,9 +1143,9 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 		/* We're actually computing the Q drive */
 		compute_parity6(sh, UPDATE_PARITY);
 	} else {
-		ptr[0] = page_address(sh->dev[dd_idx].page);
-		if (!nozero) memset(ptr[0], 0, STRIPE_SIZE);
-		count = 1;
+		dest = page_address(sh->dev[dd_idx].page);
+		if (!nozero) memset(dest, 0, STRIPE_SIZE);
+		count = 0;
 		for (i = disks ; i--; ) {
 			if (i == dd_idx || i == qd_idx)
 				continue;
@@ -1159,8 +1159,8 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 
 			check_xor();
 		}
-		if (count != 1)
-			xor_blocks(count, STRIPE_SIZE, ptr);
+		if (count)
+			xor_blocks(count, STRIPE_SIZE, dest, ptr);
 		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
new file mode 100644
index 0000000..ff12550
--- /dev/null
+++ b/include/linux/async_tx.h
@@ -0,0 +1,156 @@
+/*
+ * Copyright © 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef _ASYNC_TX_H_
+#define _ASYNC_TX_H_
+#include <linux/dmaengine.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+
+/**
+ * dma_chan_ref - object used to manage dma channels received from the
+ *   dmaengine core.
+ * @chan - the channel being tracked
+ * @node - node for the channel to be placed on async_tx_master_list
+ * @rcu - for list_del_rcu
+ * @count - number of times this channel is listed in the pool
+ *	(for channels with multiple capabiities)
+ */
+struct dma_chan_ref {
+	struct dma_chan *chan;
+	struct list_head node;
+	struct rcu_head rcu;
+	atomic_t count;
+};
+
+/**
+ * async_tx_flags - modifiers for the async_* calls
+ * @ASYNC_TX_XOR_ZERO_DST: this flag must be used for xor operations where the
+ * the destination address is not a source.  The asynchronous case handles this
+ * implicitly, the synchronous case needs to zero the destination block.
+ * @ASYNC_TX_XOR_DROP_DST: this flag must be used if the destination address is
+ * also one of the source addresses.  In the synchronous case the destination
+ * address is an implied source, whereas the asynchronous case it must be listed
+ * as a source.  The destination address must be the first address in the source
+ * array.
+ * @ASYNC_TX_ASSUME_COHERENT: skip cache maintenance operations
+ * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
+ * dependency chain
+ * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
+ * @ASYNC_TX_KMAP_SRC: if the transaction is to be performed synchronously
+ * take an atomic mapping (KM_USER0) on the source page(s)
+ * @ASYNC_TX_KMAP_DST: if the transaction is to be performed synchronously
+ * take an atomic mapping (KM_USER0) on the dest page(s)
+ */
+enum async_tx_flags {
+	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
+	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
+	ASYNC_TX_ASSUME_COHERENT = (1 << 2),
+	ASYNC_TX_ACK		 = (1 << 3),
+	ASYNC_TX_DEP_ACK	 = (1 << 4),
+	ASYNC_TX_KMAP_SRC	 = (1 << 5),
+	ASYNC_TX_KMAP_DST	 = (1 << 6),
+};
+
+#ifdef CONFIG_DMA_ENGINE
+void async_tx_issue_pending_all(void);
+enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
+void async_tx_run_dependencies(struct dma_async_tx_descriptor *tx);
+struct dma_chan *
+async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
+	enum dma_transaction_type tx_type);
+#else
+static inline void async_tx_issue_pending_all(void)
+{
+	do { } while (0);
+}
+
+static inline enum dma_status
+dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
+{
+	return DMA_SUCCESS;
+}
+
+static inline void
+async_tx_run_dependencies(struct dma_async_tx_descriptor *tx,
+	struct dma_chan *host_chan)
+{
+	do { } while (0);
+}
+
+static inline struct dma_chan *
+async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
+	enum dma_transaction_type tx_type)
+{
+	return NULL;
+}
+#endif
+
+/**
+ * async_tx_sync_epilog - actions to take if an operation is run synchronously
+ * @flags: async_tx flags
+ * @depend_tx: transaction depends on depend_tx
+ * @cb_fn: function to call when the transaction completes
+ * @cb_fn_param: parameter to pass to the callback routine
+ */
+static inline void
+async_tx_sync_epilog(unsigned long flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param)
+{
+	if (cb_fn)
+		cb_fn(cb_fn_param);
+
+	if (depend_tx && (flags & ASYNC_TX_DEP_ACK))
+		async_tx_ack(depend_tx);
+}
+
+void
+async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_xor(struct page *dest, struct page **src_list, unsigned int offset,
+	int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_xor_zero_sum(struct page *dest, struct page **src_list,
+	unsigned int offset, int src_cnt, size_t len,
+	u32 *result, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
+	unsigned int src_offset, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_memset(struct page *dest, int val, unsigned int offset,
+	size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_trigger_callback(enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_fn_param);
+#endif /* _ASYNC_TX_H_ */
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 7d6c20b..3e12058 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -3,9 +3,10 @@
 
 #include <linux/raid/md.h>
 
-#define MAX_XOR_BLOCKS 5
+#define MAX_XOR_BLOCKS 4
 
-extern void xor_blocks(unsigned int count, unsigned int bytes, void **ptr);
+extern void xor_blocks(unsigned int count, unsigned int bytes,
+	void *dest, void **srcs);
 
 struct xor_block_template {
         struct xor_block_template *next;
