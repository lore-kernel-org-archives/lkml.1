Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZCFNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZCFNda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZCFNay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:54 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4579 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754035AbZCFNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:48 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UV-02-TL3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/18] dma-debug: print stacktrace of mapping path on unmap error
Date: Fri, 6 Mar 2009 14:30:29 +0100
Message-ID: <1236346229-6618-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0558 (UTC) FILETIME=[B82983E0:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

Impact: saves stacktrace of a dma mapping and prints it if there is an  error

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 1b6b650..128d9de 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -19,6 +19,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/stacktrace.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
@@ -39,6 +40,8 @@ enum {
 	dma_debug_coherent,
 };
 
+#define DMA_DEBUG_STACKTRACE_ENTRIES 5
+
 struct dma_debug_entry {
 	struct list_head list;
 	struct device    *dev;
@@ -49,6 +52,10 @@ struct dma_debug_entry {
 	int              direction;
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
+#ifdef CONFIG_STACKTRACE
+	struct		 stack_trace stacktrace;
+	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
+#endif
 };
 
 struct hash_bucket {
@@ -108,12 +115,23 @@ static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
  *                    system log than the user configured. This variable is
  *                    writeable via debugfs.
  */
-#define err_printk(dev, format, arg...) do {			\
+static inline void dump_entry_trace(struct dma_debug_entry *entry)
+{
+#ifdef CONFIG_STACKTRACE
+	if (entry) {
+		printk(KERN_WARNING "Mapped at:\n");
+		print_stack_trace(&entry->stacktrace, 0);
+	}
+#endif
+}
+
+#define err_printk(dev, entry, format, arg...) do {		\
 		error_count += 1;				\
 		if (show_all_errors || show_num_errors > 0) {	\
 			WARN(1, "%s %s: " format,		\
 			     dev_driver_string(dev),		\
 			     dev_name(dev) , ## arg);		\
+			dump_entry_trace(entry);		\
 		}						\
 		if (!show_all_errors && show_num_errors > 0)	\
 			show_num_errors -= 1;			\
@@ -260,6 +278,12 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	list_del(&entry->list);
 	memset(entry, 0, sizeof(*entry));
 
+#ifdef CONFIG_STACKTRACE
+	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
+	entry->stacktrace.entries = entry->st_entries;
+	entry->stacktrace.skip = 2;
+	save_stack_trace(&entry->stacktrace);
+#endif
 	num_free_entries -= 1;
 	if (num_free_entries < min_free_entries)
 		min_free_entries = num_free_entries;
@@ -457,7 +481,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	entry = hash_bucket_find(bucket, ref);
 
 	if (!entry) {
-		err_printk(ref->dev, "DMA-API: device driver tries "
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free DMA memory it has not allocated "
 			   "[device address=0x%016llx] [size=%llu bytes]\n",
 			   ref->dev_addr, ref->size);
@@ -465,7 +489,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	if (ref->size != entry->size) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different size "
 			   "[device address=0x%016llx] [map size=%llu bytes] "
 			   "[unmap size=%llu bytes]\n",
@@ -473,7 +497,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	if (ref->type != entry->type) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with wrong function "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped as %s] [unmapped as %s]\n",
@@ -481,7 +505,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   type2name[entry->type], type2name[ref->type]);
 	} else if ((entry->type == dma_debug_coherent) &&
 		   (ref->paddr != entry->paddr)) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[cpu alloc address=%p] [cpu free address=%p]",
@@ -491,7 +515,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 
 	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
 	    ref->sg_call_ents != entry->sg_call_ents) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA sg list with different entry count "
 			   "[map count=%d] [unmap count=%d]\n",
 			   entry->sg_call_ents, ref->sg_call_ents);
@@ -502,7 +526,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	 * DMA API don't handle this properly, so check for it here
 	 */
 	if (ref->direction != entry->direction) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different direction "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped with %s] [unmapped with %s]\n",
@@ -521,8 +545,8 @@ out:
 static void check_for_stack(struct device *dev, void *addr)
 {
 	if (object_is_on_stack(addr))
-		err_printk(dev, "DMA-API: device driver maps memory from stack"
-				" [addr=%p]\n", addr);
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from"
+				"stack [addr=%p]\n", addr);
 }
 
 static void check_sync(struct device *dev, dma_addr_t addr,
@@ -543,7 +567,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	entry = hash_bucket_find(bucket, &ref);
 
 	if (!entry) {
-		err_printk(dev, "DMA-API: device driver tries "
+		err_printk(dev, NULL, "DMA-API: device driver tries "
 				"to sync DMA memory it has not allocated "
 				"[device address=0x%016llx] [size=%llu bytes]\n",
 				addr, size);
@@ -551,7 +575,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	}
 
 	if ((offset + size) > entry->size) {
-		err_printk(dev, "DMA-API: device driver syncs"
+		err_printk(dev, entry, "DMA-API: device driver syncs"
 				" DMA memory outside allocated range "
 				"[device address=0x%016llx] "
 				"[allocation size=%llu bytes] [sync offset=%llu] "
@@ -560,7 +584,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	}
 
 	if (direction != entry->direction) {
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
@@ -574,7 +598,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(direction == DMA_TO_DEVICE))
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device read-only DMA memory for cpu "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
@@ -584,7 +608,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 
 	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
 		       !(direction == DMA_FROM_DEVICE))
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device write-only DMA memory to device "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-- 
1.5.6.4


