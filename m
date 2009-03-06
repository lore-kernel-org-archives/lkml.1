Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZCFNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZCFNf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZCFNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:31:00 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54825 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754224AbZCFNau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:50 -0500
X-BigFish: VPS-5(zz146fK18c1Kzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UU-03-1UP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/18] dma-debug: add core checking functions
Date: Fri, 6 Mar 2009 14:30:19 +0100
Message-ID: <1236346229-6618-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0261 (UTC) FILETIME=[B7FC3250:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add functions to check on dma unmap and sync

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |  188 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 187 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 20d6cdb..d0cb47a 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -17,10 +17,13 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
+#include <linux/device.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -50,7 +53,7 @@ struct dma_debug_entry {
 struct hash_bucket {
 	struct list_head list;
 	spinlock_t lock;
-} __cacheline_aligned_in_smp;
+} ____cacheline_aligned_in_smp;
 
 /* Hash list to save the allocated dma addresses */
 static struct hash_bucket dma_entry_hash[HASH_SIZE];
@@ -85,6 +88,36 @@ static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
 
+static const char *type2name[4] = { "single", "page",
+				    "scather-gather", "coherent" };
+
+static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
+				   "DMA_FROM_DEVICE", "DMA_NONE" };
+
+/*
+ * The access to some variables in this macro is racy. We can't use atomic_t
+ * here because all these variables are exported to debugfs. Some of them even
+ * writeable. This is also the reason why a lock won't help much. But anyway,
+ * the races are no big deal. Here is why:
+ *
+ *   error_count: the addition is racy, but the worst thing that can happen is
+ *                that we don't count some errors
+ *   show_num_errors: the subtraction is racy. Also no big deal because in
+ *                    worst case this will result in one warning more in the
+ *                    system log than the user configured. This variable is
+ *                    writeable via debugfs.
+ */
+#define err_printk(dev, format, arg...) do {			\
+		error_count += 1;				\
+		if (show_all_errors || show_num_errors > 0) {	\
+			WARN(1, "%s %s: " format,		\
+			     dev_driver_string(dev),		\
+			     dev_name(dev) , ## arg);		\
+		}						\
+		if (!show_all_errors && show_num_errors > 0)	\
+			show_num_errors -= 1;			\
+	} while (0);
+
 /*
  * Hash related functions
  *
@@ -380,3 +413,156 @@ static __init int dma_debug_entries_cmdline(char *str)
 __setup("dma_debug=", dma_debug_cmdline);
 __setup("dma_debug_entries=", dma_debug_entries_cmdline);
 
+static void check_unmap(struct dma_debug_entry *ref)
+{
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	if (dma_mapping_error(ref->dev, ref->dev_addr))
+		return;
+
+	bucket = get_hash_bucket(ref, &flags);
+	entry = hash_bucket_find(bucket, ref);
+
+	if (!entry) {
+		err_printk(ref->dev, "DMA-API: device driver tries "
+			   "to free DMA memory it has not allocated "
+			   "[device address=0x%016llx] [size=%llu bytes]\n",
+			   ref->dev_addr, ref->size);
+		goto out;
+	}
+
+	if (ref->size != entry->size) {
+		err_printk(ref->dev, "DMA-API: device driver frees "
+			   "DMA memory with different size "
+			   "[device address=0x%016llx] [map size=%llu bytes] "
+			   "[unmap size=%llu bytes]\n",
+			   ref->dev_addr, entry->size, ref->size);
+	}
+
+	if (ref->type != entry->type) {
+		err_printk(ref->dev, "DMA-API: device driver frees "
+			   "DMA memory with wrong function "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped as %s] [unmapped as %s]\n",
+			   ref->dev_addr, ref->size,
+			   type2name[entry->type], type2name[ref->type]);
+	} else if ((entry->type == dma_debug_coherent) &&
+		   (ref->paddr != entry->paddr)) {
+		err_printk(ref->dev, "DMA-API: device driver frees "
+			   "DMA memory with different CPU address "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[cpu alloc address=%p] [cpu free address=%p]",
+			   ref->dev_addr, ref->size,
+			   (void *)entry->paddr, (void *)ref->paddr);
+	}
+
+	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
+	    ref->sg_call_ents != entry->sg_call_ents) {
+		err_printk(ref->dev, "DMA-API: device driver frees "
+			   "DMA sg list with different entry count "
+			   "[map count=%d] [unmap count=%d]\n",
+			   entry->sg_call_ents, ref->sg_call_ents);
+	}
+
+	/*
+	 * This may be no bug in reality - but most implementations of the
+	 * DMA API don't handle this properly, so check for it here
+	 */
+	if (ref->direction != entry->direction) {
+		err_printk(ref->dev, "DMA-API: device driver frees "
+			   "DMA memory with different direction "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped with %s] [unmapped with %s]\n",
+			   ref->dev_addr, ref->size,
+			   dir2name[entry->direction],
+			   dir2name[ref->direction]);
+	}
+
+	hash_bucket_del(entry);
+	dma_entry_free(entry);
+
+out:
+	put_hash_bucket(bucket, &flags);
+}
+
+static void check_for_stack(struct device *dev, void *addr)
+{
+	if (object_is_on_stack(addr))
+		err_printk(dev, "DMA-API: device driver maps memory from stack"
+				" [addr=%p]\n", addr);
+}
+
+static void check_sync(struct device *dev, dma_addr_t addr,
+		       u64 size, u64 offset, int direction, bool to_cpu)
+{
+	struct dma_debug_entry ref = {
+		.dev            = dev,
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = direction,
+	};
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	bucket = get_hash_bucket(&ref, &flags);
+
+	entry = hash_bucket_find(bucket, &ref);
+
+	if (!entry) {
+		err_printk(dev, "DMA-API: device driver tries "
+				"to sync DMA memory it has not allocated "
+				"[device address=0x%016llx] [size=%llu bytes]\n",
+				addr, size);
+		goto out;
+	}
+
+	if ((offset + size) > entry->size) {
+		err_printk(dev, "DMA-API: device driver syncs"
+				" DMA memory outside allocated range "
+				"[device address=0x%016llx] "
+				"[allocation size=%llu bytes] [sync offset=%llu] "
+				"[sync size=%llu]\n", entry->dev_addr, entry->size,
+				offset, size);
+	}
+
+	if (direction != entry->direction) {
+		err_printk(dev, "DMA-API: device driver syncs "
+				"DMA memory with different direction "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+	}
+
+	if (entry->direction == DMA_BIDIRECTIONAL)
+		goto out;
+
+	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
+		      !(direction == DMA_TO_DEVICE))
+		err_printk(dev, "DMA-API: device driver syncs "
+				"device read-only DMA memory for cpu "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+
+	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
+		       !(direction == DMA_FROM_DEVICE))
+		err_printk(dev, "DMA-API: device driver syncs "
+				"device write-only DMA memory to device "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+
+out:
+	put_hash_bucket(bucket, &flags);
+
+}
+
-- 
1.5.6.4


