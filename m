Return-Path: <linux-kernel-owner+w=401wt.eu-S1760397AbZJIJBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397AbZJIJBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbZJIJBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:01:40 -0400
Received: from mail.df.lth.se ([194.47.250.12]:34425 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756555AbZJIJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:01:36 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Add COH 901 318 DMA block driver v2
Date: Fri,  9 Oct 2009 11:00:43 +0200
Message-Id: <1255078843-24958-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ST-Ericsson COH 901 318 DMA block,
found in the U300 series platforms. It registers a DMA slave for
device I/O and also a memcpy slave for memcpy.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
ChangeLog v1->v2
- Removed check for non-existing channel - this cannot happen with
  the strict configuration we now impose. As a result the DMA stop
  and continue functions are now returning void - they cannot fail.
- Clarified that we write COH901318_CX_CFG twice due to a HW bug.
- Fixed unbalanced spin_lock/unlocks in error paths.
- Spelling errors...
- Regarding Maciejs comment that enable_powersave() is already
  called by coh901318_stop() inside coh901318_terminate_all():
  yes, true, but unfortunately there can be a race where an
  IRQ occurs between the coh901318_stop() and spin_lock_irqsave()
  right after. Sending separate mail on this.
---
 drivers/dma/Kconfig         |    8 +
 drivers/dma/Makefile        |    1 +
 drivers/dma/coh901318.c     | 1465 +++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/coh901318_lli.c |  317 ++++++++++
 drivers/dma/coh901318_lli.h |  124 ++++
 include/linux/coh901318.h   |  310 +++++++++
 6 files changed, 2225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/coh901318.c
 create mode 100644 drivers/dma/coh901318_lli.c
 create mode 100644 drivers/dma/coh901318_lli.h
 create mode 100644 include/linux/coh901318.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 5903a88..25d3c54 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -109,6 +109,14 @@ config SH_DMAE
 	help
 	  Enable support for the Renesas SuperH DMA controllers.
 
+config COH901318
+	bool "ST-Ericsson COH901318 DMA support"
+	select DMA_ENGINE
+	depends on ARCH_U300
+	default y if ARCH_U300
+	help
+	  Enable support for ST-Ericsson COH 901 318 DMA.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index eca71ba..4db768e 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
+obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
new file mode 100644
index 0000000..3fa3d95
--- /dev/null
+++ b/drivers/dma/coh901318.c
@@ -0,0 +1,1465 @@
+/*
+ * driver/dma/coh901318.c
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * DMA driver for COH 901 318
+ * Author: Per Friden <per.friden@stericsson.com>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h> /* printk() */
+#include <linux/fs.h> /* everything... */
+#include <linux/slab.h> /* kmalloc() */
+#include <linux/dmaengine.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/irqreturn.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/coh901318.h>
+
+#include "coh901318_lli.h"
+
+#define COHC_2_DEV(cohc) (&cohc->chan.dev->device)
+
+struct coh901318_desc {
+	struct dma_async_tx_descriptor desc;
+	struct list_head node;
+	struct scatterlist *sg;
+	unsigned int sg_len;
+	struct coh901318_lli *data;
+	enum dma_data_direction dir;
+	int pending_irqs;
+	unsigned long flags;
+};
+
+struct coh901318_base {
+	struct device *dev;
+	void __iomem *virtbase;
+	struct coh901318_pool pool;
+	struct powersave pm;
+	struct dma_device dma_slave;
+	struct dma_device dma_memcpy;
+	struct coh901318_chan *chans;
+	struct coh901318_platform *platform;
+};
+
+struct coh901318_chan {
+	spinlock_t lock;
+	int allocated;
+	int id;
+	int stopped;
+
+	struct work_struct free_work;
+	struct dma_chan chan;
+
+	struct tasklet_struct tasklet;
+
+	struct list_head active;
+	struct list_head queue;
+	struct list_head free;
+
+	unsigned long nbr_active_done;
+	unsigned long busy;
+	int pending_irqs;
+
+	struct coh901318_base *base;
+};
+
+#ifdef VERBOSE_DEBUG
+static void coh901318_list_print(struct coh901318_chan *cohc,
+				 struct coh901318_lli *lli)
+{
+	struct coh901318_lli *l;
+	dma_addr_t addr =  virt_to_phys(list);
+	int i = 0;
+
+	while (addr) {
+		l = phys_to_virt(addr);
+		dev_info(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%x"
+			 ", dst 0x%x, link 0x%x link_virt 0x%p\n",
+			 i, l, l->control, l->src_addr, l->dst_addr,
+			 l->link_addr, phys_to_virt(l->link_addr));
+		i++;
+		addr = l->link_addr;
+	}
+}
+#else
+#define coh901318_list_print(cohc, lli)
+#endif
+
+#ifdef CONFIG_DEBUG_FS
+
+#define COH901318_DEBUGFS_ASSIGN(x, y) (x = y)
+
+static struct coh901318_base *debugfs_dma_base;
+static struct dentry *dma_dentry;
+
+static int coh901318_debugfs_open(struct inode *inode, struct file *file)
+{
+
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static int coh901318_debugfs_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *f_pos)
+{
+	u64 started_channels = debugfs_dma_base->pm.started_channels;
+	int pool_count = debugfs_dma_base->pool.debugfs_pool_counter;
+	int i;
+	char tmp[256];
+	int ret = 0;
+	char *dev_buf;
+	int dev_size;
+
+	dev_buf = kmalloc(4*1024, GFP_KERNEL);
+
+	snprintf(tmp, 50, "DMA -- enable dma channels\n");
+	strcat(dev_buf, tmp);
+
+	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++) {
+		if (started_channels & (1 << i)) {
+			snprintf(tmp, 50, "channel %d\n", i);
+			strcat(dev_buf, tmp);
+		}
+	}
+
+	snprintf(tmp, 50, "Pool alloc nbr %d\n", pool_count);
+	strcat(dev_buf, tmp);
+
+	dev_size = strlen(dev_buf) + 1;
+
+	/* No more to read if offset != 0 */
+	if (*f_pos > dev_size)
+		goto out;
+
+	if (*f_pos + count > dev_size)
+		count = dev_size - *f_pos;
+
+	if (copy_to_user(buf, dev_buf + *f_pos, count))
+		ret = -EINVAL;
+	ret = count;
+	*f_pos += count;
+
+ out:
+
+	kfree(dev_buf);
+	return ret;
+}
+
+static const struct file_operations coh901318_debugfs_status_operations = {
+	.owner		= THIS_MODULE,
+	.open		= coh901318_debugfs_open,
+	.read		= coh901318_debugfs_read,
+};
+
+
+static int __init init_coh901318_debugfs(void)
+{
+
+	dma_dentry = debugfs_create_dir("dma", NULL);
+
+	(void) debugfs_create_file("status",
+				   S_IFREG | S_IRUGO,
+				   dma_dentry, NULL,
+				   &coh901318_debugfs_status_operations);
+	return 0;
+}
+
+static void __exit exit_coh901318_debugfs(void)
+{
+	debugfs_remove_recursive(dma_dentry);
+}
+
+module_init(init_coh901318_debugfs);
+module_exit(exit_coh901318_debugfs);
+#else
+
+#define COH901318_DEBUGFS_ASSIGN(x, y)
+
+#endif /* CONFIG_DEBUG_FS */
+
+static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct coh901318_chan, chan);
+}
+
+static inline dma_addr_t
+cohc_dev_addr(struct coh901318_chan *cohc)
+{
+	return cohc->base->platform->chan_conf[cohc->id].dev_addr;
+}
+
+static inline const struct coh901318_params *
+cohc_chan_param(struct coh901318_chan *cohc)
+{
+	return &cohc->base->platform->chan_conf[cohc->id].param;
+}
+
+static inline const struct dma_channel *
+cohc_chan_conf(struct coh901318_chan *cohc)
+{
+	return &cohc->base->platform->chan_conf[cohc->id];
+}
+
+static void enable_powersave(struct coh901318_chan *cohc)
+{
+	unsigned long flags;
+	struct powersave *pm = &cohc->base->pm;
+
+	spin_lock_irqsave(&pm->lock, flags);
+
+	pm->started_channels &= ~((u64)1 << cohc->id);
+
+	if (!pm->started_channels) {
+		/* DMA no longer intends to access memory */
+		cohc->base->platform->access_memory_state(false);
+	}
+
+	spin_unlock_irqrestore(&pm->lock, flags);
+}
+static void disable_powersave(struct coh901318_chan *cohc)
+{
+	unsigned long flags;
+	struct powersave *pm = &cohc->base->pm;
+
+	spin_lock_irqsave(&pm->lock, flags);
+
+	if (!pm->started_channels) {
+		/* DMA intends to access memory */
+		cohc->base->platform->access_memory_state(true);
+	}
+
+	pm->started_channels |= ((u64)1 << cohc->id);
+
+	spin_unlock_irqrestore(&pm->lock, flags);
+}
+
+static inline int coh901318_set_ctrl(struct coh901318_chan *cohc, u32 control)
+{
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	writel(control,
+	       virtbase + COH901318_CX_CTRL +
+	       COH901318_CX_CTRL_SPACING * channel);
+	wmb();
+	return 0;
+}
+
+static inline int coh901318_set_conf(struct coh901318_chan *cohc, u32 conf)
+{
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	writel(conf,
+	       virtbase + COH901318_CX_CFG +
+	       COH901318_CX_CFG_SPACING*channel);
+	wmb();
+	return 0;
+}
+
+
+static int coh901318_start(struct coh901318_chan *cohc)
+{
+	u32 val;
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	disable_powersave(cohc);
+
+	val = readl(virtbase + COH901318_CX_CFG +
+		    COH901318_CX_CFG_SPACING * channel);
+
+	/* Enable channel */
+	val |= COH901318_CX_CFG_CH_ENABLE;
+	writel(val, virtbase + COH901318_CX_CFG +
+	       COH901318_CX_CFG_SPACING * channel);
+
+	wmb();
+
+	return 0;
+}
+
+static int coh901318_prep_linked_list(struct coh901318_chan *cohc,
+				      struct coh901318_lli *data)
+{
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	BUG_ON(readl(virtbase + COH901318_CX_STAT +
+		     COH901318_CX_STAT_SPACING*channel) &
+	       COH901318_CX_STAT_ACTIVE);
+
+	writel(data->src_addr,
+	       virtbase + COH901318_CX_SRC_ADDR +
+	       COH901318_CX_SRC_ADDR_SPACING * channel);
+
+	writel(data->dst_addr, virtbase +
+	       COH901318_CX_DST_ADDR +
+	       COH901318_CX_DST_ADDR_SPACING * channel);
+
+	writel(data->link_addr, virtbase + COH901318_CX_LNK_ADDR +
+	       COH901318_CX_LNK_ADDR_SPACING * channel);
+
+	writel(data->control, virtbase + COH901318_CX_CTRL +
+	       COH901318_CX_CTRL_SPACING * channel);
+
+	wmb();
+
+	return 0;
+}
+static dma_cookie_t
+coh901318_assign_cookie(struct coh901318_chan *cohc,
+			struct coh901318_desc *cohd)
+{
+	dma_cookie_t cookie = cohc->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	cohc->chan.cookie = cookie;
+	cohd->desc.cookie = cookie;
+
+	return cookie;
+}
+
+static struct coh901318_desc *
+coh901318_desc_get(struct coh901318_chan *cohc)
+{
+	struct coh901318_desc *desc;
+
+	if (list_empty(&cohc->free)) {
+		/* alloc new desc because we're out of used ones
+		 * TODO: alloc a pile of descs instead of just one,
+		 * avoid many small allocations.
+		 */
+		desc = kmalloc(sizeof(struct coh901318_desc), GFP_ATOMIC);
+		if (desc == NULL)
+			goto out;
+		INIT_LIST_HEAD(&desc->node);
+	} else {
+		/* Reuse an old desc. */
+		desc = list_first_entry(&cohc->free,
+					struct coh901318_desc,
+					node);
+		list_del(&desc->node);
+	}
+
+ out:
+	return desc;
+}
+
+static void
+coh901318_desc_free(struct coh901318_chan *cohc, struct coh901318_desc *cohd)
+{
+	list_add_tail(&cohd->node, &cohc->free);
+}
+
+/* call with irq lock held */
+static void
+coh901318_desc_submit(struct coh901318_chan *cohc, struct coh901318_desc *desc)
+{
+	list_add_tail(&desc->node, &cohc->active);
+
+	BUG_ON(cohc->pending_irqs != 0);
+
+	cohc->pending_irqs = desc->pending_irqs;
+}
+
+static struct coh901318_desc *
+coh901318_first_active_get(struct coh901318_chan *cohc)
+{
+	struct coh901318_desc *d;
+
+	if (list_empty(&cohc->active))
+		return NULL;
+
+	d = list_first_entry(&cohc->active,
+			     struct coh901318_desc,
+			     node);
+	return d;
+}
+
+static void
+coh901318_desc_remove(struct coh901318_desc *cohd)
+{
+	list_del(&cohd->node);
+}
+
+static void
+coh901318_desc_queue(struct coh901318_chan *cohc, struct coh901318_desc *desc)
+{
+	list_add_tail(&desc->node, &cohc->queue);
+}
+
+static struct coh901318_desc *
+coh901318_first_queued(struct coh901318_chan *cohc)
+{
+	struct coh901318_desc *d;
+
+	if (list_empty(&cohc->queue))
+		return NULL;
+
+	d = list_first_entry(&cohc->queue,
+			     struct coh901318_desc,
+			     node);
+	return d;
+}
+
+/*
+ * DMA start/stop controls
+ */
+u32 coh901318_get_bytes_left(struct dma_chan *chan)
+{
+	unsigned long flags;
+	u32 ret;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* Read transfer count value */
+	ret = readl(cohc->base->virtbase +
+		    COH901318_CX_CTRL+COH901318_CX_CTRL_SPACING *
+		    cohc->id) & COH901318_CX_CTRL_TC_VALUE_MASK;
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(coh901318_get_bytes_left);
+
+
+/* Stops a transfer without losing data. Enables power save.
+   Use this function in conjunction with coh901318_continue(..)
+*/
+void coh901318_stop(struct dma_chan *chan)
+{
+	u32 val;
+	unsigned long flags;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* Disable channel in HW */
+	val = readl(virtbase + COH901318_CX_CFG +
+		    COH901318_CX_CFG_SPACING * channel);
+
+	/* Stopping infinit transfer */
+	if ((val & COH901318_CX_CTRL_TC_ENABLE) == 0 &&
+	    (val & COH901318_CX_CFG_CH_ENABLE))
+		cohc->stopped = 1;
+
+
+	val &= ~COH901318_CX_CFG_CH_ENABLE;
+	/* Enable twice, HW bug work around */
+	writel(val, virtbase + COH901318_CX_CFG +
+	       COH901318_CX_CFG_SPACING * channel);
+	writel(val, virtbase + COH901318_CX_CFG +
+	       COH901318_CX_CFG_SPACING * channel);
+	wmb();
+
+	/* Spin-wait for it to actually go inactive */
+	while (readl(virtbase + COH901318_CX_STAT+COH901318_CX_STAT_SPACING *
+		     channel) & COH901318_CX_STAT_ACTIVE) {}
+
+	/* Check if we stopped an active job */
+	if ((readl(virtbase + COH901318_CX_CTRL+COH901318_CX_CTRL_SPACING *
+		   channel) & COH901318_CX_CTRL_TC_VALUE_MASK) > 0)
+		cohc->stopped = 1;
+
+	enable_powersave(cohc);
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+}
+EXPORT_SYMBOL(coh901318_stop);
+
+/* Continues a transfer that has been stopped via 300_dma_stop(..).
+   Power save is handled.
+*/
+void coh901318_continue(struct dma_chan *chan)
+{
+	u32 val;
+	unsigned long flags;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int channel = cohc->id;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	disable_powersave(cohc);
+
+	if (cohc->stopped) {
+		/* Enable channel in HW */
+		val = readl(cohc->base->virtbase + COH901318_CX_CFG +
+			    COH901318_CX_CFG_SPACING * channel);
+
+		val |= COH901318_CX_CFG_CH_ENABLE;
+
+		writel(val, cohc->base->virtbase + COH901318_CX_CFG +
+		       COH901318_CX_CFG_SPACING*channel);
+		wmb();
+
+		cohc->stopped = 0;
+	}
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+}
+EXPORT_SYMBOL(coh901318_continue);
+
+bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
+{
+	unsigned int ch_nr = (unsigned int) chan_id;
+
+	if (ch_nr == to_coh901318_chan(chan)->id)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(coh901318_filter_id);
+
+
+/*
+ * DMA channel allocation
+ */
+static int coh901318_config(struct coh901318_chan *cohc,
+			    struct coh901318_params *param)
+{
+	unsigned long flags;
+	const struct coh901318_params *p;
+	int channel = cohc->id;
+	void *virtbase = cohc->base->virtbase;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	if (param)
+		p = param;
+	else
+		p = &cohc->base->platform->chan_conf[channel].param;
+
+	/* Clear any pending BE or TC interrupt */
+	if (channel < 32) {
+		writel(1 << channel, virtbase + COH901318_BE_INT_CLEAR1);
+		writel(1 << channel, virtbase + COH901318_TC_INT_CLEAR1);
+	} else {
+		writel(1 << (channel - 32), virtbase +
+		       COH901318_BE_INT_CLEAR2);
+		writel(1 << (channel - 32), virtbase +
+		       COH901318_TC_INT_CLEAR2);
+	}
+	wmb();
+
+	coh901318_set_conf(cohc, p->config);
+	coh901318_set_ctrl(cohc, p->ctrl_lli_last);
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	return 0;
+}
+
+/* must lock when calling this function
+ * start queued jobs, if any
+ * TODO: start all queued jobs in one go
+ *
+ * Returns descriptor if queued job is started otherwise NULL.
+ * If the queue is empty NULL is returned.
+ */
+static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
+{
+	struct coh901318_desc *cohd_que;
+
+	/* start queued jobs, if any
+	 * TODO: transmit all queued jobs in one go
+	 */
+	cohd_que = coh901318_first_queued(cohc);
+
+	if (cohd_que != NULL) {
+		/* Remove from queue */
+		coh901318_desc_remove(cohd_que);
+		/* initiate DMA job */
+		cohc->busy = 1;
+
+		coh901318_desc_submit(cohc, cohd_que);
+
+		coh901318_prep_linked_list(cohc, cohd_que->data);
+
+		/* start dma job */
+		coh901318_start(cohc);
+
+	}
+
+	return cohd_que;
+}
+
+static void dma_tasklet(unsigned long data)
+{
+	struct coh901318_chan *cohc = (struct coh901318_chan *) data;
+	struct coh901318_desc *cohd_fin;
+	unsigned long flags;
+	dma_async_tx_callback callback;
+	void *callback_param;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* get first active entry from list */
+	cohd_fin = coh901318_first_active_get(cohc);
+
+	BUG_ON(cohd_fin->pending_irqs == 0);
+
+	cohd_fin->pending_irqs--;
+
+	BUG_ON(cohc->nbr_active_done && cohd_fin == NULL);
+
+	if (cohc->nbr_active_done == 0)
+		return;
+
+	if (cohd_fin == NULL)
+		goto err;
+
+	if (cohd_fin->sg != NULL) {
+		dma_unmap_sg(cohc->chan.dev->device.parent,
+			     cohd_fin->sg, cohd_fin->sg_len, cohd_fin->dir);
+	}
+
+	if (!cohd_fin->pending_irqs) {
+		/* release the lli allocation*/
+		coh901318_lli_free(&cohc->base->pool, &cohd_fin->data);
+	}
+
+	dev_vdbg(COHC_2_DEV(cohc), "[%s] chan_id %d pending_irqs %d"
+		 " nbr_active_done %ld\n", __func__,
+		 cohc->id, cohc->pending_irqs, cohc->nbr_active_done);
+
+	/* callback to client */
+	callback = cohd_fin->desc.callback;
+	callback_param = cohd_fin->desc.callback_param;
+
+	if (!cohd_fin->pending_irqs) {
+		coh901318_desc_remove(cohd_fin);
+
+		/* return desc to free-list */
+		coh901318_desc_free(cohc, cohd_fin);
+	}
+
+	if (cohc->nbr_active_done)
+		cohc->nbr_active_done--;
+
+	if (cohc->nbr_active_done) {
+		if (cohc_chan_conf(cohc)->priority_high)
+			tasklet_hi_schedule(&cohc->tasklet);
+		else
+			tasklet_schedule(&cohc->tasklet);
+	}
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	if (callback)
+		callback(callback_param);
+
+	return;
+
+ err:
+	spin_unlock_irqrestore(&cohc->lock, flags);
+	dev_err(COHC_2_DEV(cohc), "[%s] No active dma desc\n", __func__);
+}
+
+
+/* called from interrupt context */
+static void dma_tc_handle(struct coh901318_chan *cohc)
+{
+	BUG_ON(!cohc->allocated && (list_empty(&cohc->active) ||
+				    list_empty(&cohc->queue)));
+
+	if (!cohc->allocated)
+		return;
+
+	BUG_ON(cohc->pending_irqs == 0);
+
+	cohc->pending_irqs--;
+	cohc->nbr_active_done++;
+
+	if (cohc->pending_irqs == 0 && coh901318_queue_start(cohc) == NULL)
+		cohc->busy = 0;
+
+	BUG_ON(list_empty(&cohc->active));
+
+	if (cohc_chan_conf(cohc)->priority_high)
+		tasklet_hi_schedule(&cohc->tasklet);
+	else
+		tasklet_schedule(&cohc->tasklet);
+}
+
+
+static irqreturn_t dma_irq_handler(int irq, void *dev_id)
+{
+	u32 status1;
+	u32 status2;
+	int i;
+	int ch;
+	struct coh901318_base *base  = dev_id;
+	struct coh901318_chan *cohc;
+	void *virtbase = base->virtbase;
+
+	status1 = readl(virtbase + COH901318_INT_STATUS1);
+	status2 = readl(virtbase + COH901318_INT_STATUS2);
+
+	rmb();
+
+	if (unlikely(status1 == 0 && status2 == 0)) {
+		dev_warn(base->dev, "spurious DMA IRQ from no channel!\n");
+		return IRQ_HANDLED;
+	}
+
+	/* TODO: consider handle IRQ in tasklet here to
+	 *       minimize interrupt latency */
+
+	/* Check the first 32 DMA channels for IRQ */
+	while (status1) {
+		/* Find first bit set, return as a number. */
+		i = ffs(status1) - 1;
+		ch = i;
+
+		cohc = &base->chans[ch];
+		spin_lock(&cohc->lock);
+
+		/* Mask off this bit */
+		status1 &= ~(1 << i);
+		/* Check the individual channel bits */
+		if (test_bit(i, virtbase + COH901318_BE_INT_STATUS1)) {
+			dev_crit(COHC_2_DEV(cohc),
+				 "DMA bus error on channel %d!\n", ch);
+			BUG_ON(1);
+			/* Clear BE interrupt */
+			__set_bit(i, virtbase + COH901318_BE_INT_CLEAR1);
+		} else {
+			/* Caused by TC, really? */
+			if (unlikely(!test_bit(i, virtbase +
+					       COH901318_TC_INT_STATUS1))) {
+				dev_warn(COHC_2_DEV(cohc),
+					 "ignoring interrupt not caused by terminal count on channel %d\n", ch);
+				/* Clear TC interrupt */
+				BUG_ON(1);
+				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR1);
+			} else {
+				/* Enable powersave if transfer has finished */
+				if (!(readl(virtbase + COH901318_CX_STAT +
+					    COH901318_CX_STAT_SPACING*ch) &
+				      COH901318_CX_STAT_ENABLED)) {
+					enable_powersave(cohc);
+				}
+
+				/* Must clear TC interrupt before calling
+				 * dma_tc_handle
+				 * in case tc_handle initate a new dma job
+				 */
+				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR1);
+
+				dma_tc_handle(cohc);
+			}
+		}
+		spin_unlock(&cohc->lock);
+	}
+
+	/* Check the remaining 32 DMA channels for IRQ */
+	while (status2) {
+		/* Find first bit set, return as a number. */
+		i = ffs(status2) - 1;
+		ch = i + 32;
+		cohc = &base->chans[ch];
+		spin_lock(&cohc->lock);
+
+		/* Mask off this bit */
+		status2 &= ~(1 << i);
+		/* Check the individual channel bits */
+		if (test_bit(i, virtbase + COH901318_BE_INT_STATUS2)) {
+			dev_crit(COHC_2_DEV(cohc),
+				 "DMA bus error on channel %d!\n", ch);
+			/* Clear BE interrupt */
+			BUG_ON(1);
+			__set_bit(i, virtbase + COH901318_BE_INT_CLEAR2);
+		} else {
+			/* Caused by TC, really? */
+			if (unlikely(!test_bit(i, virtbase +
+					       COH901318_TC_INT_STATUS2))) {
+				dev_warn(COHC_2_DEV(cohc),
+					 "ignoring interrupt not caused by terminal count on channel %d\n", ch);
+				/* Clear TC interrupt */
+				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR2);
+				BUG_ON(1);
+			} else {
+				/* Enable powersave if transfer has finished */
+				if (!(readl(virtbase + COH901318_CX_STAT +
+					    COH901318_CX_STAT_SPACING*ch) &
+				      COH901318_CX_STAT_ENABLED)) {
+					enable_powersave(cohc);
+				}
+				/* Must clear TC interrupt before calling
+				 * dma_tc_handle
+				 * in case tc_handle initate a new dma job
+				 */
+				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR2);
+
+				dma_tc_handle(cohc);
+			}
+		}
+		spin_unlock(&cohc->lock);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int coh901318_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct coh901318_chan	*cohc = to_coh901318_chan(chan);
+
+	dev_vdbg(COHC_2_DEV(cohc), "[%s] DMA channel %d\n",
+		 __func__, cohc->id);
+
+	if (chan->client_count > 1)
+		return -EBUSY;
+
+	coh901318_config(cohc, NULL);
+
+	cohc->allocated = 1;
+
+	return 1;
+}
+
+static void
+coh901318_free_chan_resources(struct dma_chan *chan)
+{
+	struct coh901318_chan	*cohc = to_coh901318_chan(chan);
+	int channel = cohc->id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* Disable HW */
+	writel(0x00000000U, cohc->base->virtbase + COH901318_CX_CFG +
+	       COH901318_CX_CFG_SPACING*channel);
+	writel(0x00000000U, cohc->base->virtbase + COH901318_CX_CTRL +
+	       COH901318_CX_CTRL_SPACING*channel);
+
+	cohc->allocated = 0;
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	chan->device->device_terminate_all(chan);
+}
+
+
+static dma_cookie_t
+coh901318_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct coh901318_desc *cohd = container_of(tx, struct coh901318_desc,
+						   desc);
+	struct coh901318_chan *cohc = to_coh901318_chan(tx->chan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	tx->cookie = coh901318_assign_cookie(cohc, cohd);
+
+	coh901318_desc_queue(cohc, cohd);
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
+	return tx->cookie;
+}
+
+int coh901318_channel_link(struct dma_chan *chan, struct dma_chan *chan_dest,
+			   int size)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	struct coh901318_chan *cohc_dst = to_coh901318_chan(chan_dest);
+	int err = 0;
+	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli_chained;
+	u32 config = cohc_chan_param(cohc)->config;
+	struct coh901318_lli lli;
+	unsigned long flags;
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	dev_vdbg(COHC_2_DEV(cohc),
+		 "[%s] chan_src %d chan_dst %d, size %d\n",
+		 __func__, cohc->id, cohc_dst->id, size);
+
+	/* TODO: Add support for size != -1 */
+	if (size != -1) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ctrl &= ~COH901318_CX_CTRL_MASTER_MODE_MASK;
+	ctrl |= cohc_chan_param(cohc_dst)->ctrl_lli_chained &
+		COH901318_CX_CTRL_MASTER_MODE_MASK;
+
+	/* transfer between two peripheral, src and dest is constant */
+	ctrl &= ~COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
+	ctrl &= ~COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
+
+	/* set COH901318_CX_CTRL_PRDD_SOURCE */
+	ctrl &= ~COH901318_CX_CTRL_PRDD_DEST;
+
+	/* Handshake both two primary and secondary peripheral */
+	ctrl |= COH901318_CX_CTRL_HSP_ENABLE;
+	ctrl |= COH901318_CX_CTRL_HSS_ENABLE;
+
+	config |= COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY;
+	config |= cohc_dst->id << COH901318_CX_CFG_LCRF_SHIFT;
+
+	if (size == -1)
+		ctrl &= ~COH901318_CX_CTRL_TC_ENABLE;
+
+	coh901318_set_conf(cohc, config);
+	lli.control = ctrl;
+	lli.src_addr = cohc_dev_addr(cohc);
+	lli.dst_addr = cohc_dev_addr(cohc_dst);
+	lli.link_addr = 0;
+
+	coh901318_list_print(cohc, &lli);
+
+	coh901318_prep_linked_list(cohc, &lli);
+
+	coh901318_start(cohc);
+
+ out:
+	spin_unlock_irqrestore(&cohc->lock, flags);
+	return err;
+}
+EXPORT_SYMBOL(coh901318_channel_link);
+
+struct dma_async_tx_descriptor *
+coh901318_prep_single(struct dma_chan *chan, dma_addr_t buf,
+		      unsigned int size, enum dma_data_direction dir,
+		      unsigned long flags)
+{
+	struct coh901318_lli *data;
+	struct coh901318_desc *cohd;
+	unsigned long flg;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int lli_len;
+
+	spin_lock_irqsave(&cohc->lock, flg);
+
+	dev_vdbg(COHC_2_DEV(cohc), "[%s] channel %d\n",
+		 __func__, cohc->id);
+
+	lli_len = size >> MAX_DMA_PACKET_SIZE_SHIFT;
+	if ((lli_len << MAX_DMA_PACKET_SIZE_SHIFT) < size)
+		lli_len++;
+
+	data = coh901318_lli_alloc(&cohc->base->pool, lli_len);
+
+	if (data == NULL)
+		goto err;
+
+	cohd = coh901318_desc_get(cohc);
+	cohd->sg = NULL;
+	cohd->sg_len = 0;
+	cohd->dir = dir;
+	cohd->data = data;
+
+	cohd->pending_irqs =
+		coh901318_lli_fill_single(
+					  &cohc->base->pool, data, buf, size,
+					  cohc_dev_addr(cohc),
+					  cohc_chan_param(cohc)->ctrl_lli_chained,
+					  cohc_chan_param(cohc)->ctrl_lli_last,
+					  dir);
+	cohd->flags = flags;
+
+	coh901318_list_print(cohc, data);
+
+	dma_async_tx_descriptor_init(&cohd->desc, chan);
+
+	cohd->desc.tx_submit = coh901318_tx_submit;
+
+	spin_unlock_irqrestore(&cohc->lock, flg);
+
+	return &cohd->desc;
+ err:
+	spin_unlock_irqrestore(&cohc->lock, flg);
+	return NULL;
+}
+EXPORT_SYMBOL(coh901318_prep_single);
+
+static struct dma_async_tx_descriptor *
+coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		      size_t size, unsigned long flags)
+{
+	struct coh901318_lli *data;
+	struct coh901318_desc *cohd;
+	unsigned long flg;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int lli_len;
+
+	spin_lock_irqsave(&cohc->lock, flg);
+
+	dev_vdbg(COHC_2_DEV(cohc),
+		 "[%s] channel %d src 0x%x dest 0x%x size %d\n",
+		 __func__, cohc->id, src, dest, size);
+
+	lli_len = size >> MAX_DMA_PACKET_SIZE_SHIFT;
+	if ((lli_len << MAX_DMA_PACKET_SIZE_SHIFT) < size)
+		lli_len++;
+
+	data = coh901318_lli_alloc(&cohc->base->pool, lli_len);
+
+	if (data == NULL)
+		goto err;
+
+	cohd = coh901318_desc_get(cohc);
+	cohd->sg = NULL;
+	cohd->sg_len = 0;
+	cohd->data = data;
+
+	cohd->pending_irqs =
+		coh901318_lli_fill_memcpy(
+					  &cohc->base->pool, data, src, size, dest,
+					  cohc_chan_param(cohc)->ctrl_lli_chained,
+					  cohc_chan_param(cohc)->ctrl_lli_last);
+	cohd->flags = flags;
+
+	coh901318_list_print(cohc, data);
+
+	dma_async_tx_descriptor_init(&cohd->desc, chan);
+
+	cohd->desc.tx_submit = coh901318_tx_submit;
+
+	spin_unlock_irqrestore(&cohc->lock, flg);
+
+	return &cohd->desc;
+ err:
+	spin_unlock_irqrestore(&cohc->lock, flg);
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+			unsigned int nents, enum dma_data_direction direction,
+			unsigned long flags)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	struct coh901318_lli *data;
+	struct coh901318_desc *cohd;
+	struct scatterlist *sg;
+	unsigned int sg_len;
+	int len = 0;
+	int size;
+	int i;
+	u32 ctrl_chained = cohc_chan_param(cohc)->ctrl_lli_chained;
+	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli;
+	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	unsigned long flg;
+
+	if (!sgl)
+		goto out;
+	if (sgl->length == 0)
+		goto out;
+
+	spin_lock_irqsave(&cohc->lock, flg);
+
+	sg_len = dma_map_sg(chan->dev->device.parent,
+			    sgl, nents, direction);
+
+	dev_vdbg(COHC_2_DEV(cohc), "[%s] sg_len %d dir %d\n",
+		 __func__, sg_len, direction);
+
+	cohd = coh901318_desc_get(cohc);
+	cohd->sg = NULL;
+	cohd->sg_len = 0;
+	cohd->dir = direction;
+
+	if (direction == DMA_TO_DEVICE) {
+		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
+			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
+
+		ctrl_chained |= tx_flags;
+		ctrl_last |= tx_flags;
+		ctrl |= tx_flags;
+
+		if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+
+			cohd->sg = sgl;
+			cohd->sg_len = nents;
+		}
+	} else if (direction == DMA_FROM_DEVICE) {
+		u32 rx_flags = COH901318_CX_CTRL_PRDD_DEST |
+			COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
+
+		ctrl_chained |= rx_flags;
+		ctrl_last |= rx_flags;
+		ctrl |= rx_flags;
+
+		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+
+			cohd->sg = sgl;
+			cohd->sg_len = nents;
+		}
+
+	} else
+		goto err_direction;
+
+	dma_async_tx_descriptor_init(&cohd->desc, chan);
+
+	cohd->desc.tx_submit = coh901318_tx_submit;
+
+
+	/* The dma only supports transmitting packages up to
+	 * MAX_DMA_PACKET_SIZE. Calculate to total number of
+	 * dma elemts required to send the entire sg list
+	 */
+	for_each_sg(sgl, sg, sg_len, i) {
+		unsigned int factor;
+		size = sg_dma_len(sg);
+
+		if (size <= MAX_DMA_PACKET_SIZE) {
+			len++;
+			continue;
+		}
+
+		factor = size >> MAX_DMA_PACKET_SIZE_SHIFT;
+		if ((factor << MAX_DMA_PACKET_SIZE_SHIFT) < size)
+			factor++;
+
+		len += factor;
+	}
+
+	data = coh901318_lli_alloc(&cohc->base->pool, len);
+
+	if (data == NULL)
+		goto err_dma_alloc;
+
+	/* initiate allocated data list */
+	cohd->pending_irqs =
+		coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
+				      cohc_dev_addr(cohc),
+				      ctrl_chained,
+				      ctrl,
+				      ctrl_last,
+				      direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
+	cohd->data = data;
+
+	cohd->flags = flags;
+
+	coh901318_list_print(cohc, data);
+
+	spin_unlock_irqrestore(&cohc->lock, flg);
+
+	return &cohd->desc;
+ err_dma_alloc:
+	if ((direction == DMA_TO_DEVICE &&
+	     !(flags & DMA_COMPL_SKIP_SRC_UNMAP)) ||
+	    (direction == DMA_FROM_DEVICE &&
+	     !(flags & DMA_COMPL_SKIP_DEST_UNMAP)))
+		dma_unmap_sg(cohc->chan.dev->device.parent,
+			     cohd->sg, cohd->sg_len, direction);
+ err_direction:
+	coh901318_desc_remove(cohd);
+	coh901318_desc_free(cohc, cohd);
+	spin_unlock_irqrestore(&cohc->lock, flg);
+ out:
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+coh901318_prep_interrupt(struct dma_chan *chan,
+			 unsigned long flags)
+{
+	/* TODO implement */
+
+	return NULL;
+}
+
+static enum dma_status
+coh901318_is_tx_complete(struct dma_chan *chan,
+			 dma_cookie_t cookie, dma_cookie_t *last,
+			 dma_cookie_t *used)
+{
+	/* TODO implement */
+
+	return DMA_SUCCESS;
+}
+
+static void
+coh901318_issue_pending(struct dma_chan *chan)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* Busy means that pending jobs are already being processed */
+	if (!cohc->busy)
+		coh901318_queue_start(cohc);
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+}
+
+static void
+coh901318_terminate_all(struct dma_chan *chan)
+{
+	unsigned long flags;
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	struct coh901318_desc *cohd;
+	void *virtbase = cohc->base->virtbase;
+
+	coh901318_stop(chan);
+
+	spin_lock_irqsave(&cohc->lock, flags);
+
+	/* Clear any pending BE or TC interrupt */
+	if (cohc->id < 32) {
+		writel(1 << cohc->id, virtbase + COH901318_BE_INT_CLEAR1);
+		writel(1 << cohc->id, virtbase + COH901318_TC_INT_CLEAR1);
+	} else {
+		writel(1 << (cohc->id - 32), virtbase +
+		       COH901318_BE_INT_CLEAR2);
+		writel(1 << (cohc->id - 32), virtbase +
+		       COH901318_TC_INT_CLEAR2);
+	}
+
+	enable_powersave(cohc);
+
+	while ((cohd = coh901318_first_active_get(cohc))) {
+		/* release the lli allocation*/
+		coh901318_lli_free(&cohc->base->pool, &cohd->data);
+
+		coh901318_desc_remove(cohd);
+
+		/* return desc to free-list */
+		coh901318_desc_free(cohc, cohd);
+	}
+
+	while ((cohd = coh901318_first_queued(cohc))) {
+		/* release the lli allocation*/
+		coh901318_lli_free(&cohc->base->pool, &cohd->data);
+
+		coh901318_desc_remove(cohd);
+
+		/* return desc to free-list */
+		coh901318_desc_free(cohc, cohd);
+	}
+
+
+	cohc->nbr_active_done = 0;
+	cohc->busy = 0;
+	cohc->pending_irqs = 0;
+
+	spin_unlock_irqrestore(&cohc->lock, flags);
+}
+void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
+			 struct coh901318_base *base)
+{
+	int chans_i;
+	int i = 0;
+	struct coh901318_chan *cohc;
+
+	INIT_LIST_HEAD(&dma->channels);
+
+	for (chans_i = 0; pick_chans[chans_i] != -1; chans_i += 2) {
+		for (i = pick_chans[chans_i]; i <= pick_chans[chans_i+1]; i++) {
+			cohc = &base->chans[i];
+
+			cohc->base = base;
+			cohc->chan.device = dma;
+			cohc->id = i;
+			cohc->chan.cookie = i;
+
+			/* TODO: do we really need this lock if only one
+			 * client is connected to each channel?
+			 */
+
+			spin_lock_init(&cohc->lock);
+
+			cohc->pending_irqs = 0;
+			cohc->nbr_active_done = 0;
+			cohc->busy = 0;
+			INIT_LIST_HEAD(&cohc->free);
+			INIT_LIST_HEAD(&cohc->active);
+			INIT_LIST_HEAD(&cohc->queue);
+
+			tasklet_init(&cohc->tasklet, dma_tasklet,
+				     (unsigned long) cohc);
+
+			list_add_tail(&cohc->chan.device_node,
+				      &dma->channels);
+		}
+	}
+}
+
+static int __init coh901318_probe(struct platform_device *pdev)
+{
+	int err = 0;
+	struct coh901318_platform *pdata;
+	struct coh901318_base *base;
+	int irq;
+	struct resource *io;
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!io)
+		goto err_get_resource;
+
+	/* Map DMA controller registers to virtual memory */
+	if (request_mem_region(io->start,
+			       resource_size(io),
+			       pdev->dev.driver->name) == NULL) {
+		err = -EBUSY;
+		goto err_request_mem;
+	}
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		goto err_no_platformdata;
+
+	base = kmalloc(ALIGN(sizeof(struct coh901318_base), 4) +
+		       pdata->max_channels *
+		       sizeof(struct coh901318_chan),
+		       GFP_KERNEL);
+	base->chans = ((void *)base) + ALIGN(sizeof(struct coh901318_base), 4);
+
+	if (!base)
+		goto err_alloc_dma_channels;
+
+	base->virtbase = ioremap(io->start, resource_size(io));
+	if (!base->virtbase) {
+		err = -ENOMEM;
+		goto err_no_ioremap;
+	}
+
+	base->dev = &pdev->dev;
+	base->platform = pdata;
+	spin_lock_init(&base->pm.lock);
+	base->pm.started_channels = 0;
+
+	COH901318_DEBUGFS_ASSIGN(debugfs_dma_base, base);
+
+	platform_set_drvdata(pdev, base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		goto err_no_irq;
+
+	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
+			  "coh901318", base);
+	if (err) {
+		dev_crit(&pdev->dev,
+			 "Cannot allocate IRQ for DMA controller!\n");
+		goto err_request_irq;
+	}
+
+	err = coh901318_pool_create(&base->pool, &pdev->dev,
+				    sizeof(struct coh901318_lli),
+				    32);
+	if (err)
+		goto err_pool_create;
+
+	/* init channels for device transfers */
+	coh901318_base_init(&base->dma_slave,  base->platform->chans_slave,
+			    base);
+
+	dma_cap_zero(base->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+
+	base->dma_slave.device_alloc_chan_resources = coh901318_alloc_chan_resources;
+	base->dma_slave.device_free_chan_resources = coh901318_free_chan_resources;
+	base->dma_slave.device_prep_dma_interrupt = coh901318_prep_interrupt;
+	base->dma_slave.device_prep_slave_sg = coh901318_prep_slave_sg;
+	base->dma_slave.device_is_tx_complete = coh901318_is_tx_complete;
+	base->dma_slave.device_issue_pending = coh901318_issue_pending;
+	base->dma_slave.device_terminate_all = coh901318_terminate_all;
+	base->dma_slave.dev = &pdev->dev;
+
+	err = dma_async_device_register(&base->dma_slave);
+
+	if (err)
+		goto err_register_slave;
+
+	/* init channels for memcpy */
+	coh901318_base_init(&base->dma_memcpy, base->platform->chans_memcpy,
+			    base);
+
+	dma_cap_zero(base->dma_memcpy.cap_mask);
+	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
+
+	base->dma_memcpy.device_alloc_chan_resources = coh901318_alloc_chan_resources;
+	base->dma_memcpy.device_free_chan_resources = coh901318_free_chan_resources;
+	base->dma_memcpy.device_prep_dma_interrupt = coh901318_prep_interrupt;
+	base->dma_memcpy.device_prep_dma_memcpy = coh901318_prep_memcpy;
+	base->dma_memcpy.device_is_tx_complete = coh901318_is_tx_complete;
+	base->dma_memcpy.device_issue_pending = coh901318_issue_pending;
+	base->dma_memcpy.device_terminate_all = coh901318_terminate_all;
+	base->dma_memcpy.dev = &pdev->dev;
+	err = dma_async_device_register(&base->dma_memcpy);
+
+	if (err)
+		goto err_register_memcpy;
+
+	dev_dbg(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
+		(u32) base->virtbase);
+
+	return err;
+
+	dma_async_device_unregister(&base->dma_memcpy);
+ err_register_memcpy:
+	dma_async_device_unregister(&base->dma_slave);
+ err_register_slave:
+	coh901318_pool_destroy(&base->pool);
+ err_pool_create:
+	free_irq(platform_get_irq(pdev, 0), NULL);
+ err_request_irq:
+ err_no_irq:
+	iounmap(base->virtbase);
+ err_no_ioremap:
+	kfree(base);
+ err_alloc_dma_channels:
+ err_no_platformdata:
+	release_mem_region(pdev->resource->start,
+			   resource_size(pdev->resource));
+ err_request_mem:
+ err_get_resource:
+	return err;
+}
+
+static int __exit coh901318_remove(struct platform_device *pdev)
+{
+	struct coh901318_base *base = platform_get_drvdata(pdev);
+
+	dma_async_device_unregister(&base->dma_memcpy);
+	dma_async_device_unregister(&base->dma_slave);
+	coh901318_pool_destroy(&base->pool);
+	free_irq(platform_get_irq(pdev, 0), NULL);
+	kfree(base);
+	iounmap(base->virtbase);
+	release_mem_region(pdev->resource->start,
+			   resource_size(pdev->resource));
+	return 0;
+}
+
+
+static struct platform_driver coh901318_driver = {
+	.remove = __exit_p(coh901318_remove),
+	.driver = {
+		.name	= "coh901318",
+	},
+};
+
+int __init coh901318_init(void)
+{
+	return platform_driver_probe(&coh901318_driver, coh901318_probe);
+}
+subsys_initcall(coh901318_init);
+
+void __exit coh901318_exit(void)
+{
+	platform_driver_unregister(&coh901318_driver);
+}
+module_exit(coh901318_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Per Friden");
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
new file mode 100644
index 0000000..43fdfcc
--- /dev/null
+++ b/drivers/dma/coh901318_lli.c
@@ -0,0 +1,317 @@
+/*
+ * driver/dma/coh901318_lli.c
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Support functions for handling lli for dma
+ * Author: Per Friden <per.friden@stericsson.com>
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/dmapool.h>
+#include <linux/memory.h>
+#include <linux/coh901318.h>
+
+#include "coh901318_lli.h"
+
+#if (defined(CONFIG_DEBUG_FS) && defined(CONFIG_U300_DEBUG))
+#define DEBUGFS_POOL_COUNTER_RESET(pool) (pool->debugfs_pool_counter = 0)
+#define DEBUGFS_POOL_COUNTER_ADD(pool, add) (pool->debugfs_pool_counter += add)
+#else
+#define DEBUGFS_POOL_COUNTER_RESET(pool)
+#define DEBUGFS_POOL_COUNTER_ADD(pool, add)
+#endif
+
+static struct coh901318_lli *
+coh901318_lli_next(struct coh901318_lli *data)
+{
+	if (data == NULL || data->link_addr == 0)
+		return NULL;
+
+	return (struct coh901318_lli *) data->virt_link_addr;
+}
+
+int coh901318_pool_create(struct coh901318_pool *pool,
+			  struct device *dev,
+			  size_t size, size_t align)
+{
+	spin_lock_init(&pool->lock);
+	pool->dev = dev;
+	pool->dmapool = dma_pool_create("lli_pool", dev, size, align, 0);
+
+	DEBUGFS_POOL_COUNTER_RESET(pool);
+	return 0;
+}
+
+int coh901318_pool_destroy(struct coh901318_pool *pool)
+{
+
+	dma_pool_destroy(pool->dmapool);
+	return 0;
+}
+
+struct coh901318_lli *
+coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
+{
+	int i;
+	struct coh901318_lli *head;
+	struct coh901318_lli *lli;
+	struct coh901318_lli *lli_prev;
+	dma_addr_t phy;
+
+	if (len == 0)
+		goto err;
+
+	spin_lock(&pool->lock);
+
+	head = dma_pool_alloc(pool->dmapool, GFP_ATOMIC, &phy);
+
+	if (head == NULL)
+		goto err;
+
+	DEBUGFS_POOL_COUNTER_ADD(pool, 1);
+
+	lli = head;
+	lli->phy_this = phy;
+
+	for (i = 1; i < len; i++) {
+		lli_prev = lli;
+
+		lli = dma_pool_alloc(pool->dmapool, GFP_ATOMIC, &phy);
+
+		if (lli == NULL)
+			goto err_clean_up;
+
+		DEBUGFS_POOL_COUNTER_ADD(pool, 1);
+		lli->phy_this = phy;
+
+		lli_prev->link_addr = phy;
+		lli_prev->virt_link_addr = lli;
+	}
+
+	lli->link_addr = 0x00000000U;
+
+	spin_unlock(&pool->lock);
+
+	return head;
+
+ err:
+	spin_unlock(&pool->lock);
+	return NULL;
+
+ err_clean_up:
+	lli_prev->link_addr = 0x00000000U;
+	spin_unlock(&pool->lock);
+	coh901318_lli_free(pool, &head);
+	return NULL;
+}
+
+void coh901318_lli_free(struct coh901318_pool *pool,
+			struct coh901318_lli **lli)
+{
+	struct coh901318_lli *l;
+	struct coh901318_lli *next;
+
+	if (lli == NULL)
+		return;
+
+	l = *lli;
+
+	if (l == NULL)
+		return;
+
+	spin_lock(&pool->lock);
+
+	while (l->link_addr) {
+		next = l->virt_link_addr;
+		dma_pool_free(pool->dmapool, l, l->phy_this);
+		DEBUGFS_POOL_COUNTER_ADD(pool, -1);
+		l = next;
+	}
+	dma_pool_free(pool->dmapool, l, l->phy_this);
+	DEBUGFS_POOL_COUNTER_ADD(pool, -1);
+
+	spin_unlock(&pool->lock);
+	*lli = NULL;
+}
+
+int
+coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t source, unsigned int size,
+			  dma_addr_t destination, u32 ctrl_chained,
+			  u32 ctrl_eom)
+{
+	int s = size;
+	dma_addr_t src = source;
+	dma_addr_t dst = destination;
+
+	lli->src_addr = src;
+	lli->dst_addr = dst;
+
+	while (lli->link_addr) {
+		lli->control = ctrl_chained | MAX_DMA_PACKET_SIZE;
+		lli->src_addr = src;
+		lli->dst_addr = dst;
+
+		s -= MAX_DMA_PACKET_SIZE;
+		lli = coh901318_lli_next(lli);
+
+		src += MAX_DMA_PACKET_SIZE;
+		dst += MAX_DMA_PACKET_SIZE;
+	}
+
+	lli->control = ctrl_eom | s;
+	lli->src_addr = src;
+	lli->dst_addr = dst;
+
+	/* One irq per single transfer */
+	return 1;
+}
+
+int
+coh901318_lli_fill_single(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t buf, unsigned int size,
+			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_eom,
+			  enum dma_data_direction dir)
+{
+	int s = size;
+	dma_addr_t src;
+	dma_addr_t dst;
+
+
+	if (dir == DMA_TO_DEVICE) {
+		src = buf;
+		dst = dev_addr;
+
+	} else if (dir == DMA_FROM_DEVICE) {
+
+		src = dev_addr;
+		dst = buf;
+	} else {
+		return -EINVAL;
+	}
+
+	while (lli->link_addr) {
+		size_t block_size = MAX_DMA_PACKET_SIZE;
+		lli->control = ctrl_chained | MAX_DMA_PACKET_SIZE;
+
+		/* If we are on the next-to-final block and there will
+		 * be less than half a DMA packet left for the last
+		 * block, then we want to make this block a little
+		 * smaller to balance the sizes. This is meant to
+		 * avoid too small transfers if the buffer size is
+		 * (MAX_DMA_PACKET_SIZE*N + 1) */
+		if (s < (MAX_DMA_PACKET_SIZE + MAX_DMA_PACKET_SIZE/2))
+			block_size = MAX_DMA_PACKET_SIZE/2;
+
+		s -= block_size;
+		lli->src_addr = src;
+		lli->dst_addr = dst;
+
+		lli = coh901318_lli_next(lli);
+
+		if (dir == DMA_TO_DEVICE)
+			src += block_size;
+		else if (dir == DMA_FROM_DEVICE)
+			dst += block_size;
+	}
+
+	lli->control = ctrl_eom | s;
+	lli->src_addr = src;
+	lli->dst_addr = dst;
+
+	/* One irq per single transfer */
+	return 1;
+}
+
+int
+coh901318_lli_fill_sg(struct coh901318_pool *pool,
+		      struct coh901318_lli *lli,
+		      struct scatterlist *sgl, unsigned int nents,
+		      dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl,
+		      u32 ctrl_last,
+		      enum dma_data_direction dir, u32 ctrl_irq_mask)
+{
+	int i;
+	struct scatterlist *sg;
+	u32 ctrl_sg;
+	dma_addr_t src = 0;
+	dma_addr_t dst = 0;
+	int nbr_of_irq = 0;
+	u32 bytes_to_transfer;
+	u32 elem_size;
+
+	if (lli == NULL)
+		goto err;
+
+	spin_lock(&pool->lock);
+
+	if (dir == DMA_TO_DEVICE)
+		dst = dev_addr;
+	else if (dir == DMA_FROM_DEVICE)
+		src = dev_addr;
+	else
+		goto err;
+
+	for_each_sg(sgl, sg, nents, i) {
+		if (sg_is_chain(sg)) {
+			/* sg continues to the next sg-element don't
+			 * send ctrl_finish until the last
+			 * sg-element in the chain
+			 */
+			ctrl_sg = ctrl_chained;
+		} else if (i == nents - 1)
+			ctrl_sg = ctrl_last;
+		else
+			ctrl_sg = ctrl ? ctrl : ctrl_last;
+
+
+		if ((ctrl_sg & ctrl_irq_mask))
+			nbr_of_irq++;
+
+		if (dir == DMA_TO_DEVICE)
+			/* increment source address */
+			src = sg_dma_address(sg);
+		else
+			/* increment destination address */
+			dst =  sg_dma_address(sg);
+
+		bytes_to_transfer = sg_dma_len(sg);
+
+		while (bytes_to_transfer) {
+			u32 val;
+
+			if (bytes_to_transfer > MAX_DMA_PACKET_SIZE) {
+				elem_size = MAX_DMA_PACKET_SIZE;
+				val = ctrl_chained;
+			} else {
+				elem_size = bytes_to_transfer;
+				val = ctrl_sg;
+			}
+
+			lli->control = val | elem_size;
+			lli->src_addr = src;
+			lli->dst_addr = dst;
+
+			if (dir == DMA_FROM_DEVICE)
+				dst += elem_size;
+			else
+				src += elem_size;
+
+			BUG_ON(lli->link_addr & 3);
+
+			bytes_to_transfer -= elem_size;
+			lli = coh901318_lli_next(lli);
+		}
+
+	}
+	spin_unlock(&pool->lock);
+
+	/* There can be many IRQs per sg transfer */
+	return nbr_of_irq;
+ err:
+	return -EINVAL;
+}
diff --git a/drivers/dma/coh901318_lli.h b/drivers/dma/coh901318_lli.h
new file mode 100644
index 0000000..4a42e6d
--- /dev/null
+++ b/drivers/dma/coh901318_lli.h
@@ -0,0 +1,124 @@
+/*
+ * driver/dma/coh901318_lli.h
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * Support functions for handling lli for coh901318
+ * Author: Per Friden <per.friden@stericsson.com>
+ */
+
+#ifndef COH901318_LLI_H
+#define COH901318_LLI_H
+
+#include <linux/coh901318.h>
+
+struct device;
+
+struct coh901318_pool {
+	spinlock_t lock;
+	struct dma_pool *dmapool;
+	struct device *dev;
+
+#ifdef CONFIG_DEBUG_FS
+	int debugfs_pool_counter;
+#endif
+};
+
+struct device;
+/**
+ * coh901318_pool_create() - Creates an dma pool for lli:s
+ * @pool: pool handle
+ * @dev: dma device
+ * @lli_nbr: number of lli:s in the pool
+ * @algin: adress alignemtn of lli:s
+ * returns 0 on success otherwise none zero
+ */
+int coh901318_pool_create(struct coh901318_pool *pool,
+			  struct device *dev,
+			  size_t lli_nbr, size_t align);
+
+/**
+ * coh901318_pool_destroy() - Destroys the dma pool
+ * @pool: pool handle
+ * returns 0 on success otherwise none zero
+ */
+int coh901318_pool_destroy(struct coh901318_pool *pool);
+
+/**
+ * coh901318_lli_alloc() - Allocates a linked list
+ *
+ * @pool: pool handle
+ * @len: length to list
+ * return: none NULL if success otherwise NULL
+ */
+struct coh901318_lli *
+coh901318_lli_alloc(struct coh901318_pool *pool,
+		    unsigned int len);
+
+/**
+ * coh901318_lli_free() - Returns the linked list items to the pool
+ * @pool: pool handle
+ * @lli: reference to lli pointer to be freed
+ */
+void coh901318_lli_free(struct coh901318_pool *pool,
+			struct coh901318_lli **lli);
+
+/**
+ * coh901318_lli_fill_memcpy() - Prepares the lli:s for dma memcpy
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @src: src address
+ * @size: transfer size
+ * @dst: destination address
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl_last: ctrl for the last lli
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t src, unsigned int size,
+			  dma_addr_t dst, u32 ctrl_chained, u32 ctrl_last);
+
+/**
+ * coh901318_lli_fill_single() - Prepares the lli:s for dma single transfer
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @buf: transfer buffer
+ * @size: transfer size
+ * @dev_addr: address of periphal
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl_last: ctrl for the last lli
+ * @dir: direction of transfer (to or from device)
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_single(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t buf, unsigned int size,
+			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_last,
+			  enum dma_data_direction dir);
+
+/**
+ * coh901318_lli_fill_single() - Prepares the lli:s for dma scatter list transfer
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @sg: scatter gather list
+ * @nents: number of entries in sg
+ * @dev_addr: address of periphal
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl: ctrl of middle lli
+ * @ctrl_last: ctrl for the last lli
+ * @dir: direction of transfer (to or from device)
+ * @ctrl_irq_mask: ctrl mask for CPU interrupt
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_sg(struct coh901318_pool *pool,
+		      struct coh901318_lli *lli,
+		      struct scatterlist *sg, unsigned int nents,
+		      dma_addr_t dev_addr, u32 ctrl_chained,
+		      u32 ctrl, u32 ctrl_last,
+		      enum dma_data_direction dir, u32 ctrl_irq_mask);
+
+#endif /* COH901318_LLI_H */
diff --git a/include/linux/coh901318.h b/include/linux/coh901318.h
new file mode 100644
index 0000000..ca9ab68
--- /dev/null
+++ b/include/linux/coh901318.h
@@ -0,0 +1,310 @@
+/*
+ *
+ * include/linux/coh901318.h
+ *
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ * DMA driver for COH 901 318
+ * Author: Per Friden <per.friden@stericsson.com>
+ */
+
+#ifndef COH901318_H
+#define COH901318_H
+
+#define MAX_DMA_PACKET_SIZE_SHIFT 11
+#define MAX_DMA_PACKET_SIZE (1 << MAX_DMA_PACKET_SIZE_SHIFT)
+
+struct dma_chan;
+struct platform_device;
+struct dma_chan;
+struct dma_async_tx_descriptor;
+enum dma_data_direction;
+
+/**
+ * struct coh901318_lli - linked list item for DMAC
+ * @control: control settings for DMAC
+ * @src_addr: transfer source address
+ * @dst_addr: transfer destination address
+ * @link_addr:  physical address to next lli
+ * @virt_link_addr: virtual addres of next lli (only used by pool_free)
+ * @phy_this: physical address of current lli (only used by pool_free)
+ */
+struct coh901318_lli {
+	u32 control;
+	dma_addr_t src_addr;
+	dma_addr_t dst_addr;
+	dma_addr_t link_addr;
+
+	void *virt_link_addr;
+	dma_addr_t phy_this;
+};
+/**
+ * struct coh901318_params - parameters for DMAC configuration
+ * @config: DMA config register
+ * @ctrl_lli_last: DMA control register for the last lli in the list
+ * @ctrl_lli: DMA control register for an lli
+ * @ctrl_lli_chained: DMA control register for a chained lli
+ */
+struct coh901318_params {
+	u32 config;
+	u32 ctrl_lli_last;
+	u32 ctrl_lli;
+	u32 ctrl_lli_chained;
+};
+/**
+ * struct dma_channel - dma channel base
+ * @name: ascii name of dma channel
+ * @number: channel id number
+ * @desc_nbr_max: number of preallocated descriptortors
+ * @priority_high: prio of channel, 0 low otherwise high.
+ * @param: configuration parameters
+ * @dev_addr: physical address of periphal connected to channel
+ */
+struct dma_channel {
+	const char name[32];
+	const int number;
+	const int desc_nbr_max;
+	const int priority_high;
+	const struct coh901318_params param;
+	const dma_addr_t dev_addr;
+};
+
+/**
+ * dma_access_memory_state_t - register dma for memory access
+ *
+ * @active:  1 means dma intends to access memory
+ *           0 means dma wont access memory
+ */
+typedef void (*dma_access_memory_state_t)(bool active);
+
+/**
+ * struct powersave - DMA power save structure
+ * @lock: lock protecting data in this struct
+ * @started_channels: bit mask indicating active dma channels
+ */
+struct powersave {
+	spinlock_t lock;
+	u64 started_channels;
+};
+/**
+ * struct coh901318_platform - platform arch structure
+ * @chans_slave: specifying dma slave channels
+ * @chans_memcpy: specifying dma memcpy channels
+ * @access_memory_state: requesting DMA memeory access (on / off)
+ * @chan_conf: dma channel configurations
+ * @max_channels: max number of dma chanenls
+ */
+struct coh901318_platform {
+	const int *chans_slave;
+	const int *chans_memcpy;
+	const dma_access_memory_state_t access_memory_state;
+	const struct dma_channel *chan_conf;
+	const int max_channels;
+};
+
+/**
+ * coh901318_channel_link() - Start dma transfer between two channels,
+ *                            from master dma channel to slave dma channel.
+ * @src: handle of the src dma channel, feeds the dest channel
+ * @dest: handle of the dest dma channel
+ * @size: number of bytes to transfer, -1 means inifinite length
+ *
+ * return 0 on success otherwise negative value
+ */
+int coh901318_channel_link(struct dma_chan *src, struct dma_chan *dest,
+			   int size);
+
+/**
+ * coh901318_prep_single() - Prepares a single transfer between
+ *                           phy mem buffer and periphal
+ * @chan: dma channel handle
+ * @buf: transfer buffer
+ * @size: sise of transfer buffer
+ * @dir: transfer direction
+ * @flags: control flags
+ * return none NULL on success otherwise NULL
+ */
+struct dma_async_tx_descriptor *
+coh901318_prep_single(struct dma_chan *chan, dma_addr_t buf,
+		      unsigned int size, enum dma_data_direction dir,
+		      unsigned long flags);
+
+/**
+ * coh901318_get_bytes_left() - Get number of bytes left on a current transfer
+ * @chan: dma channel handle
+ * return number of bytes left, or negative on error
+ */
+u32 coh901318_get_bytes_left(struct dma_chan *chan);
+
+/**
+ * coh901318_stop() - Stops dma transfer
+ * @chan: dma channel handle
+ * return 0 on success otherwise negative value
+ */
+void coh901318_stop(struct dma_chan *chan);
+
+/**
+ * coh901318_continue() - Resumes a stopped dma transfer
+ * @chan: dma channel handle
+ * return 0 on success otherwise negative value
+ */
+void coh901318_continue(struct dma_chan *chan);
+
+/**
+ * coh901318_filter_id() - DMA channel filter function
+ * @chan: dma channel handle
+ * @chan_id: id of dma channel to be filter out
+ *
+ * In dma_request_channel() it specifies what channel id to be requested
+ */
+bool coh901318_filter_id(struct dma_chan *chan, void *chan_id);
+
+
+/*
+ * DMA Controller - this access the static mappings of the coh901318 dma.
+ *
+ */
+
+#define COH901318_MOD32_MASK					(0x1F)
+#define COH901318_WORD_MASK					(0xFFFFFFFF)
+/* INT_STATUS - Interrupt Status Registers 32bit (R/-) */
+#define COH901318_INT_STATUS1					(0x0000)
+#define COH901318_INT_STATUS2					(0x0004)
+/* TC_INT_STATUS - Terminal Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_TC_INT_STATUS1				(0x0008)
+#define COH901318_TC_INT_STATUS2				(0x000C)
+/* TC_INT_CLEAR - Terminal Count Interrupt Clear Registers 32bit (-/W) */
+#define COH901318_TC_INT_CLEAR1					(0x0010)
+#define COH901318_TC_INT_CLEAR2					(0x0014)
+/* RAW_TC_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_RAW_TC_INT_STATUS1				(0x0018)
+#define COH901318_RAW_TC_INT_STATUS2				(0x001C)
+/* BE_INT_STATUS - Bus Error Interrupt Status Registers 32bit (R/-) */
+#define COH901318_BE_INT_STATUS1				(0x0020)
+#define COH901318_BE_INT_STATUS2				(0x0024)
+/* BE_INT_CLEAR - Bus Error Interrupt Clear Registers 32bit (-/W) */
+#define COH901318_BE_INT_CLEAR1					(0x0028)
+#define COH901318_BE_INT_CLEAR2					(0x002C)
+/* RAW_BE_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_RAW_BE_INT_STATUS1				(0x0030)
+#define COH901318_RAW_BE_INT_STATUS2				(0x0034)
+
+/*
+ * CX_CFG - Channel Configuration Registers 32bit (R/W)
+ */
+#define COH901318_CX_CFG					(0x0100)
+#define COH901318_CX_CFG_SPACING				(0x04)
+/* Channel enable activates tha dma job */
+#define COH901318_CX_CFG_CH_ENABLE				(0x00000001)
+#define COH901318_CX_CFG_CH_DISABLE				(0x00000000)
+/* Request Mode */
+#define COH901318_CX_CFG_RM_MASK				(0x00000006)
+#define COH901318_CX_CFG_RM_MEMORY_TO_MEMORY			(0x0 << 1)
+#define COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY			(0x1 << 1)
+#define COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY			(0x1 << 1)
+#define COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY		(0x3 << 1)
+#define COH901318_CX_CFG_RM_SECONDARY_TO_PRIMARY		(0x3 << 1)
+/* Linked channel request field. RM must == 11 */
+#define COH901318_CX_CFG_LCRF_SHIFT				3
+#define COH901318_CX_CFG_LCRF_MASK				(0x000001F8)
+#define COH901318_CX_CFG_LCR_DISABLE				(0x00000000)
+/* Terminal Counter Interrupt Request Mask */
+#define COH901318_CX_CFG_TC_IRQ_ENABLE				(0x00000200)
+#define COH901318_CX_CFG_TC_IRQ_DISABLE				(0x00000000)
+/* Bus Error interrupt Mask */
+#define COH901318_CX_CFG_BE_IRQ_ENABLE				(0x00000400)
+#define COH901318_CX_CFG_BE_IRQ_DISABLE				(0x00000000)
+
+/*
+ * CX_STAT - Channel Status Registers 32bit (R/-)
+ */
+#define COH901318_CX_STAT					(0x0200)
+#define COH901318_CX_STAT_SPACING				(0x04)
+#define COH901318_CX_STAT_RBE_IRQ_IND				(0x00000008)
+#define COH901318_CX_STAT_RTC_IRQ_IND				(0x00000004)
+#define COH901318_CX_STAT_ACTIVE				(0x00000002)
+#define COH901318_CX_STAT_ENABLED				(0x00000001)
+
+/*
+ * CX_CTRL - Channel Control Registers 32bit (R/W)
+ */
+#define COH901318_CX_CTRL					(0x0400)
+#define COH901318_CX_CTRL_SPACING				(0x10)
+/* Transfer Count Enable */
+#define COH901318_CX_CTRL_TC_ENABLE				(0x00001000)
+#define COH901318_CX_CTRL_TC_DISABLE				(0x00000000)
+/* Transfer Count Value 0 - 4095 */
+#define COH901318_CX_CTRL_TC_VALUE_MASK				(0x00000FFF)
+/* Burst count */
+#define COH901318_CX_CTRL_BURST_COUNT_MASK			(0x0000E000)
+#define COH901318_CX_CTRL_BURST_COUNT_64_BYTES			(0x7 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_48_BYTES			(0x6 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_32_BYTES			(0x5 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_16_BYTES			(0x4 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_8_BYTES			(0x3 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_4_BYTES			(0x2 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_2_BYTES			(0x1 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_1_BYTE			(0x0 << 13)
+/* Source bus size  */
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_MASK			(0x00030000)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS			(0x2 << 16)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS			(0x1 << 16)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS			(0x0 << 16)
+/* Source address increment */
+#define COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE			(0x00040000)
+#define COH901318_CX_CTRL_SRC_ADDR_INC_DISABLE			(0x00000000)
+/* Destination Bus Size */
+#define COH901318_CX_CTRL_DST_BUS_SIZE_MASK			(0x00180000)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS			(0x2 << 19)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS			(0x1 << 19)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS			(0x0 << 19)
+/* Destination address increment */
+#define COH901318_CX_CTRL_DST_ADDR_INC_ENABLE			(0x00200000)
+#define COH901318_CX_CTRL_DST_ADDR_INC_DISABLE			(0x00000000)
+/* Master Mode (Master2 is only connected to MSL) */
+#define COH901318_CX_CTRL_MASTER_MODE_MASK			(0x00C00000)
+#define COH901318_CX_CTRL_MASTER_MODE_M2R_M1W			(0x3 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M1R_M2W			(0x2 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M2RW			(0x1 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M1RW			(0x0 << 22)
+/* Terminal Count flag to PER enable */
+#define COH901318_CX_CTRL_TCP_ENABLE				(0x01000000)
+#define COH901318_CX_CTRL_TCP_DISABLE				(0x00000000)
+/* Terminal Count flags to CPU enable */
+#define COH901318_CX_CTRL_TC_IRQ_ENABLE				(0x02000000)
+#define COH901318_CX_CTRL_TC_IRQ_DISABLE			(0x00000000)
+/* Hand shake to peripheral */
+#define COH901318_CX_CTRL_HSP_ENABLE				(0x04000000)
+#define COH901318_CX_CTRL_HSP_DISABLE				(0x00000000)
+#define COH901318_CX_CTRL_HSS_ENABLE				(0x08000000)
+#define COH901318_CX_CTRL_HSS_DISABLE				(0x00000000)
+/* DMA mode */
+#define COH901318_CX_CTRL_DDMA_MASK				(0x30000000)
+#define COH901318_CX_CTRL_DDMA_LEGACY				(0x0 << 28)
+#define COH901318_CX_CTRL_DDMA_DEMAND_DMA1			(0x1 << 28)
+#define COH901318_CX_CTRL_DDMA_DEMAND_DMA2			(0x2 << 28)
+/* Primary Request Data Destination */
+#define COH901318_CX_CTRL_PRDD_MASK				(0x40000000)
+#define COH901318_CX_CTRL_PRDD_DEST				(0x1 << 30)
+#define COH901318_CX_CTRL_PRDD_SOURCE				(0x0 << 30)
+
+/*
+ * CX_SRC_ADDR - Channel Source Address Registers 32bit (R/W)
+ */
+#define COH901318_CX_SRC_ADDR					(0x0404)
+#define COH901318_CX_SRC_ADDR_SPACING				(0x10)
+
+/*
+ * CX_DST_ADDR - Channel Destination Address Registers 32bit R/W
+ */
+#define COH901318_CX_DST_ADDR					(0x0408)
+#define COH901318_CX_DST_ADDR_SPACING				(0x10)
+
+/*
+ * CX_LNK_ADDR - Channel Link Address Registers 32bit (R/W)
+ */
+#define COH901318_CX_LNK_ADDR					(0x040C)
+#define COH901318_CX_LNK_ADDR_SPACING				(0x10)
+#define COH901318_CX_LNK_LINK_IMMEDIATE				(0x00000001)
+#endif /* COH901318_H */
-- 
1.6.3.3

