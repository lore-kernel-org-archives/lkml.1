Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZBYHdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZBYHdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZBYHdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:33:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:42051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZBYHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:33:35 -0500
Subject: Re: [PATCH 0/16] DMA-API debugging facility v3
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       johannes@sipsolutions.net
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 16:33:19 +0900
Message-Id: <1235547199.519.36.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where we complain about a discrepancy between unmap/sync and the
original mapping, it can sometimes be useful to see the backtrace of the
code which _mapped_ the region originally.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Untested. Builds though. Thanks Johannes for pointing me at an example.

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9c1a498..79542db 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/list.h>
+#include <linux/stacktrace.h>
 #include <linux/slab.h>
 
 #define HASH_SIZE       256
@@ -39,6 +40,8 @@ enum {
 	dma_debug_coherent,
 };
 
+#define DMA_DEBUG_STACKTRACE_ENTRIES 5
+
 struct dma_debug_entry {
 	struct list_head list;
 	struct device    *dev;
@@ -47,6 +50,10 @@ struct dma_debug_entry {
 	u64              dev_addr;
 	u64              size;
 	int              direction;
+#ifdef CONFIG_STACKTRACE
+	struct stack_trace stacktrace;
+	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
+#endif
 };
 
 struct hash_bucket {
@@ -106,13 +113,24 @@ static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
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
 		}						\
+		dump_entry_trace(entry);			\
 		if (!show_all_errors && show_num_errors > 0)	\
 			show_num_errors -= 1;			\
 	} while (0);
@@ -258,6 +276,12 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	list_del(&entry->list);
 	memset(entry, 0, sizeof(*entry));
 
+#ifdef CONFIG_STACKTRACE
+	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
+	entry->stacktrace.entries = entry->st_entries;
+	entry->stacktrace.skip = 1;
+	save_stack_trace(&entry->stacktrace);
+#endif
 	num_free_entries -= 1;
 	if (num_free_entries < min_free_entries)
 		min_free_entries = num_free_entries;
@@ -455,7 +479,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	entry = hash_bucket_find(bucket, ref);
 
 	if (!entry) {
-		err_printk(ref->dev, "DMA-API: device driver tries "
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free DMA memory it has not allocated "
 			   "[device address=0x%016llx] [size=%llu bytes]\n",
 			   ref->dev_addr, ref->size);
@@ -463,7 +487,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	if (ref->size != entry->size) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different size "
 			   "[device address=0x%016llx] [map size=%llu bytes] "
 			   "[unmap size=%llu bytes]\n",
@@ -471,7 +495,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	if (ref->type != entry->type) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with wrong function "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped as %s] [unmapped as %s]\n",
@@ -479,7 +503,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   type2name[entry->type], type2name[ref->type]);
 	} else if ((entry->type == dma_debug_coherent) &&
 		   (ref->paddr != entry->paddr)) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[cpu alloc address=%p] [cpu free address=%p]",
@@ -492,7 +516,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	 * DMA API don't handle this properly, so check for it here
 	 */
 	if (ref->direction != entry->direction) {
-		err_printk(ref->dev, "DMA-API: device driver frees "
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different direction "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped with %s] [unmapped with %s]\n",
@@ -511,8 +535,8 @@ out:
 static void check_for_stack(struct device *dev, void *addr)
 {
 	if (object_is_on_stack(addr))
-		err_printk(dev, "DMA-API: device driver maps memory from stack"
-				" [addr=%p]\n", addr);
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from"
+				"stack [addr=%p]\n", addr);
 }
 
 static void check_sync(struct device *dev, dma_addr_t addr,
@@ -533,7 +557,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	entry = hash_bucket_find(bucket, &ref);
 
 	if (!entry) {
-		err_printk(dev, "DMA-API: device driver tries "
+		err_printk(dev, NULL, "DMA-API: device driver tries "
 				"to sync DMA memory it has not allocated "
 				"[device address=0x%016llx] [size=%llu bytes]\n",
 				addr, size);
@@ -541,7 +565,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	}
 
 	if ((offset + size) > entry->size) {
-		err_printk(dev, "DMA-API: device driver syncs"
+		err_printk(dev, entry, "DMA-API: device driver syncs"
 				" DMA memory outside allocated range "
 				"[device address=0x%016llx] "
 				"[allocation size=%llu bytes] [sync offset=%llu] "
@@ -550,7 +574,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 	}
 
 	if (direction != entry->direction) {
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
@@ -564,7 +588,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(direction == DMA_TO_DEVICE))
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device read-only DMA memory for cpu "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
@@ -574,7 +598,7 @@ static void check_sync(struct device *dev, dma_addr_t addr,
 
 	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
 		       !(direction == DMA_FROM_DEVICE))
-		err_printk(dev, "DMA-API: device driver syncs "
+		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device write-only DMA memory to device "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

