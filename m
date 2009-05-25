Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZEYHdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZEYHdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZEYHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:32:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38726 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZEYHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:17 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/13] block: first cut at implementing a NAPI approach for block devices
Date: Mon, 25 May 2009 09:31:06 +0200
Message-Id: <1243236668-3398-24-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for AHCI only, along with the generic code.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/Makefile            |    2 +-
 block/blk-ipoll.c         |  160 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/ahci.c        |   53 ++++++++++++++-
 include/linux/blk-ipoll.h |   38 +++++++++++
 include/linux/interrupt.h |    1 +
 include/linux/libata.h    |    2 +
 6 files changed, 252 insertions(+), 4 deletions(-)
 create mode 100644 block/blk-ipoll.c
 create mode 100644 include/linux/blk-ipoll.h

diff --git a/block/Makefile b/block/Makefile
index e9fa4dd..537e88a 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
-			ioctl.o genhd.o scsi_ioctl.o cmd-filter.o
+			blk-ipoll.o ioctl.o genhd.o scsi_ioctl.o cmd-filter.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
diff --git a/block/blk-ipoll.c b/block/blk-ipoll.c
new file mode 100644
index 0000000..700b74d
--- /dev/null
+++ b/block/blk-ipoll.c
@@ -0,0 +1,160 @@
+/*
+ * Functions related to interrupt-poll handling in the block layer. This
+ * is similar to NAPI for network devices.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+#include <linux/blk-ipoll.h>
+
+#include "blk.h"
+
+static DEFINE_PER_CPU(struct list_head, blk_cpu_ipoll);
+
+void blk_ipoll_sched(struct blk_ipoll *ipoll)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	list_add_tail(&ipoll->list, &__get_cpu_var(blk_cpu_ipoll));
+	__raise_softirq_irqoff(BLOCK_IPOLL_SOFTIRQ);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(blk_ipoll_sched);
+
+void __blk_ipoll_complete(struct blk_ipoll *ipoll)
+{
+	list_del(&ipoll->list);
+	smp_mb__before_clear_bit();
+	clear_bit(IPOLL_F_SCHED, &ipoll->state);
+}
+
+void blk_ipoll_complete(struct blk_ipoll *ipoll)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__blk_ipoll_complete(ipoll);
+	local_irq_restore(flags);
+}
+
+static void blk_ipoll_softirq(struct softirq_action *h)
+{
+	struct list_head *list = &__get_cpu_var(blk_cpu_ipoll);
+	unsigned long start_time = jiffies;
+	int rearm = 0, budget = 64;
+
+	local_irq_disable();
+
+	while (!list_empty(list)) {
+		struct blk_ipoll *ipoll;
+		int work, weight;
+
+		/*
+		 * If softirq window is exhausted then punt.
+		 */
+		if (budget <= 0 || jiffies != start_time) {
+			rearm = 1;
+			break;
+		}
+
+		local_irq_enable();
+
+		/* Even though interrupts have been re-enabled, this
+		 * access is safe because interrupts can only add new
+		 * entries to the tail of this list, and only ->ipoll()
+		 * calls can remove this head entry from the list.
+		 */
+		ipoll = list_entry(list->next, struct blk_ipoll, list);
+
+		weight = ipoll->weight;
+		work = ipoll->ipoll(ipoll, weight);
+		budget -= work;
+
+		local_irq_disable();
+
+		/* Drivers must not modify the NAPI state if they
+		 * consume the entire weight.  In such cases this code
+		 * still "owns" the NAPI instance and therefore can
+		 * move the instance around on the list at-will.
+		 */
+		if (work >= weight) {
+			if (blk_ipoll_disable_pending(ipoll))
+				__blk_ipoll_complete(ipoll);
+			else
+				list_move_tail(&ipoll->list, list);
+		}
+	}
+
+	if (rearm)
+		__raise_softirq_irqoff(BLOCK_IPOLL_SOFTIRQ);
+
+	local_irq_enable();
+}
+
+void blk_ipoll_disable(struct blk_ipoll *ipoll)
+{
+	set_bit(IPOLL_F_DISABLE, &ipoll->state);
+	while (test_and_set_bit(IPOLL_F_SCHED, &ipoll->state))
+		msleep(1);
+	clear_bit(IPOLL_F_DISABLE, &ipoll->state);
+}
+EXPORT_SYMBOL(blk_ipoll_disable);
+
+void blk_ipoll_enable(struct blk_ipoll *ipoll)
+{
+	BUG_ON(!test_bit(IPOLL_F_SCHED, &ipoll->state));
+        smp_mb__before_clear_bit();
+        clear_bit(IPOLL_F_SCHED, &ipoll->state);
+}
+EXPORT_SYMBOL(blk_ipoll_enable);
+
+void blk_ipoll_init(struct blk_ipoll *ipoll, int weight, blk_ipoll_fn *poll_fn)
+{
+	memset(ipoll, 0, sizeof(*ipoll));
+	INIT_LIST_HEAD(&ipoll->list);
+	ipoll->weight = weight;
+	ipoll->ipoll = poll_fn;
+}
+EXPORT_SYMBOL(blk_ipoll_init);
+
+static int __cpuinit blk_ipoll_cpu_notify(struct notifier_block *self,
+					  unsigned long action, void *hcpu)
+{
+	/*
+	 * If a CPU goes away, splice its entries to the current CPU
+	 * and trigger a run of the softirq
+	 */
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		int cpu = (unsigned long) hcpu;
+
+		local_irq_disable();
+		list_splice_init(&per_cpu(blk_cpu_ipoll, cpu),
+				 &__get_cpu_var(blk_cpu_ipoll));
+		raise_softirq_irqoff(BLOCK_IPOLL_SOFTIRQ);
+		local_irq_enable();
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata blk_ipoll_cpu_notifier = {
+	.notifier_call	= blk_ipoll_cpu_notify,
+};
+
+static __init int blk_ipoll_setup(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(blk_cpu_ipoll, i));
+
+	open_softirq(BLOCK_IPOLL_SOFTIRQ, blk_ipoll_softirq);
+	register_hotcpu_notifier(&blk_ipoll_cpu_notifier);
+	return 0;
+}
+subsys_initcall(blk_ipoll_setup);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 08186ec..9701f93 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -45,6 +45,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include <linux/blk-ipoll.h>
 
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
@@ -2047,7 +2048,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_port_intr(struct ata_port *ap)
+static int ahci_port_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -2077,7 +2078,7 @@ static void ahci_port_intr(struct ata_port *ap)
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
-		return;
+		return 0;
 	}
 
 	if (status & PORT_IRQ_SDB_FIS) {
@@ -2118,7 +2119,48 @@ static void ahci_port_intr(struct ata_port *ap)
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_RESET;
 		ata_port_freeze(ap);
+		rc = 0;
+	}
+
+	return rc;
+}
+
+static void ap_irq_disable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	writel(0, port_mmio + PORT_IRQ_MASK);
+}
+
+static void ap_irq_enable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+
+static int ahci_ipoll(struct blk_ipoll *ipoll, int budget)
+{
+	struct ata_port *ap = container_of(ipoll, struct ata_port, ipoll);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	ret = ahci_port_intr(ap);
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+
+	if (ret > ipoll->max) {
+		printk("new ipoll max of %d\n", ret);
+		ipoll->max = ret;
+	}
+
+	if (ret < budget) {
+		blk_ipoll_complete(ipoll);
+		ap_irq_enable(ap);
 	}
+
+	return ret;
 }
 
 static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
@@ -2151,7 +2193,10 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			if (blk_ipoll_sched_prep(&ap->ipoll)) {
+				ap_irq_disable(ap);
+				blk_ipoll_sched(&ap->ipoll);
+			}
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -2407,6 +2452,8 @@ static int ahci_port_start(struct ata_port *ap)
 
 	ap->private_data = pp;
 
+	blk_ipoll_init(&ap->ipoll, 32, ahci_ipoll);
+
 	/* engage engines, captain */
 	return ahci_port_resume(ap);
 }
diff --git a/include/linux/blk-ipoll.h b/include/linux/blk-ipoll.h
new file mode 100644
index 0000000..dcc638f
--- /dev/null
+++ b/include/linux/blk-ipoll.h
@@ -0,0 +1,38 @@
+#ifndef BLK_IPOLL_H
+#define BLK_IPOLL_H
+
+struct blk_ipoll;
+typedef int (blk_ipoll_fn)(struct blk_ipoll *, int);
+
+struct blk_ipoll {
+	struct list_head list;
+	unsigned long state;
+	int weight;
+	int max;
+	blk_ipoll_fn *ipoll;
+};
+
+enum {
+	IPOLL_F_SCHED		= 0,
+	IPOLL_F_DISABLE		= 1,
+};
+
+static inline int blk_ipoll_sched_prep(struct blk_ipoll *ipoll)
+{
+	return !test_bit(IPOLL_F_DISABLE, &ipoll->state) &&
+		!test_and_set_bit(IPOLL_F_SCHED, &ipoll->state);
+}
+
+static inline int blk_ipoll_disable_pending(struct blk_ipoll *ipoll)
+{
+	return test_bit(IPOLL_F_DISABLE, &ipoll->state);
+}
+
+extern void blk_ipoll_sched(struct blk_ipoll *);
+extern void blk_ipoll_init(struct blk_ipoll *, int, blk_ipoll_fn *);
+extern void blk_ipoll_complete(struct blk_ipoll *);
+extern void __blk_ipoll_complete(struct blk_ipoll *);
+extern void blk_ipoll_enable(struct blk_ipoll *);
+extern void blk_ipoll_disable(struct blk_ipoll *);
+
+#endif
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 91bb76f..514cd75 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -335,6 +335,7 @@ enum
 	NET_TX_SOFTIRQ,
 	NET_RX_SOFTIRQ,
 	BLOCK_SOFTIRQ,
+	BLOCK_IPOLL_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index cf1e54e..9f9df5e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -37,6 +37,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
+#include <linux/blk-ipoll.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -759,6 +760,7 @@ struct ata_port {
 #endif
 	/* owned by EH */
 	u8			sector_buf[ATA_SECT_SIZE] ____cacheline_aligned;
+	struct blk_ipoll	ipoll;
 };
 
 /* The following initializer overrides a method to NULL whether one of
-- 
1.6.3.rc0.1.gf800

