Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZF3LIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZF3LIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZF3LIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:08:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44461 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZF3LId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:08:33 -0400
Message-Id: <4A4A0E50020000780000830B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:08:32 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] replace various uses of num_physpages by
	 totalram_pages
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sizing of memory allocations shouldn't depend on the number of physical
pages found in a system, as that generally include (perhaps a huge
amount of) non-RAM pages. The amount of what actually is usable as
storage should instead be used as a basis here.

In line with that, the memory hotplug code should update num_physpages
in a way that it retains its original (post-boot) meaning; in
particular, decreasing the value should at best be done with great care
- this patch doesn't try to ever decrease this value at all as it
doesn't really seem meaningful to do so.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/char/agp/backend.c        |    4 ++--
 drivers/parisc/ccio-dma.c         |    4 ++--
 drivers/parisc/sba_iommu.c        |    4 ++--
 drivers/xen/balloon.c             |    4 ----
 fs/ntfs/malloc.h                  |    2 +-
 include/linux/mm.h                |    1 +
 init/main.c                       |    4 ++--
 mm/memory_hotplug.c               |    6 ++++--
 mm/slab.c                         |    2 +-
 mm/swap.c                         |    2 +-
 mm/vmalloc.c                      |    4 ++--
 net/core/sock.c                   |    4 ++--
 net/dccp/proto.c                  |    6 +++---
 net/decnet/dn_route.c             |    2 +-
 net/ipv4/route.c                  |    2 +-
 net/ipv4/tcp.c                    |    4 ++--
 net/netfilter/nf_conntrack_core.c |    4 ++--
 net/netfilter/x_tables.c          |    2 +-
 net/netfilter/xt_hashlimit.c      |    8 ++++----
 net/netlink/af_netlink.c          |    6 +++---
 net/sctp/protocol.c               |    6 +++---
 21 files changed, 40 insertions(+), 41 deletions(-)

--- linux-2.6.31-rc1/drivers/char/agp/backend.c	2009-06-26 17:49:43.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/drivers/char/agp/backend.c	2009-06-24 16:09:34.000000000 +0200
@@ -114,9 +114,9 @@ static int agp_find_max(void)
 	long memory, index, result;
 
 #if PAGE_SHIFT < 20
-	memory = num_physpages >> (20 - PAGE_SHIFT);
+	memory = totalram_pages >> (20 - PAGE_SHIFT);
 #else
-	memory = num_physpages << (PAGE_SHIFT - 20);
+	memory = totalram_pages << (PAGE_SHIFT - 20);
 #endif
 	index = 1;
 
--- linux-2.6.31-rc1/drivers/parisc/ccio-dma.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/drivers/parisc/ccio-dma.c	2009-06-24 16:10:47.000000000 +0200
@@ -1267,7 +1267,7 @@ ccio_ioc_init(struct ioc *ioc)
 	** Hot-Plug/Removal of PCI cards. (aka PCI OLARD).
 	*/
 
-	iova_space_size = (u32) (num_physpages / count_parisc_driver(&ccio_driver));
+	iova_space_size = (u32) (totalram_pages / count_parisc_driver(&ccio_driver));
 
 	/* limit IOVA space size to 1MB-1GB */
 
@@ -1306,7 +1306,7 @@ ccio_ioc_init(struct ioc *ioc)
 
 	DBG_INIT("%s() hpa 0x%p mem %luMB IOV %dMB (%d bits)\n",
 			__func__, ioc->ioc_regs,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
--- linux-2.6.31-rc1/drivers/parisc/sba_iommu.c	2009-06-26 17:49:47.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/drivers/parisc/sba_iommu.c	2009-06-24 16:10:58.000000000 +0200
@@ -1390,7 +1390,7 @@ sba_ioc_init(struct parisc_device *sba, 
 	** for DMA hints - ergo only 30 bits max.
 	*/
 
-	iova_space_size = (u32) (num_physpages/global_ioc_cnt);
+	iova_space_size = (u32) (totalram_pages/global_ioc_cnt);
 
 	/* limit IOVA space size to 1MB-1GB */
 	if (iova_space_size < (1 << (20 - PAGE_SHIFT))) {
@@ -1415,7 +1415,7 @@ sba_ioc_init(struct parisc_device *sba, 
 	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
 			__func__,
 			ioc->ioc_hpa,
-			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
+			(unsigned long) totalram_pages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
--- linux-2.6.31-rc1/drivers/xen/balloon.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/drivers/xen/balloon.c	2009-06-24 16:02:01.000000000 +0200
@@ -96,11 +96,7 @@ static struct balloon_stats balloon_stat
 /* We increase/decrease in batches which fit in a page */
 static unsigned long frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
-/* VM /proc information for memory */
-extern unsigned long totalram_pages;
-
 #ifdef CONFIG_HIGHMEM
-extern unsigned long totalhigh_pages;
 #define inc_totalhigh_pages() (totalhigh_pages++)
 #define dec_totalhigh_pages() (totalhigh_pages--)
 #else
--- linux-2.6.31-rc1/fs/ntfs/malloc.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/fs/ntfs/malloc.h	2009-06-24 16:11:49.000000000 +0200
@@ -47,7 +47,7 @@ static inline void *__ntfs_malloc(unsign
 		return kmalloc(PAGE_SIZE, gfp_mask & ~__GFP_HIGHMEM);
 		/* return (void *)__get_free_page(gfp_mask); */
 	}
-	if (likely(size >> PAGE_SHIFT < num_physpages))
+	if (likely((size >> PAGE_SHIFT) < totalram_pages))
 		return __vmalloc(size, gfp_mask, PAGE_KERNEL);
 	return NULL;
 }
--- linux-2.6.31-rc1/include/linux/mm.h	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/include/linux/mm.h	2009-06-24 16:00:50.000000000 +0200
@@ -25,6 +25,7 @@ extern unsigned long max_mapnr;
 #endif
 
 extern unsigned long num_physpages;
+extern unsigned long totalram_pages;
 extern void * high_memory;
 extern int page_cluster;
 
--- linux-2.6.31-rc1/init/main.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/init/main.c	2009-06-24 16:12:30.000000000 +0200
@@ -691,12 +691,12 @@ asmlinkage void __init start_kernel(void
 #endif
 	thread_info_cache_init();
 	cred_init();
-	fork_init(num_physpages);
+	fork_init(totalram_pages);
 	proc_caches_init();
 	buffer_init();
 	key_init();
 	security_init();
-	vfs_caches_init(num_physpages);
+	vfs_caches_init(totalram_pages);
 	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
--- linux-2.6.31-rc1/mm/memory_hotplug.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/mm/memory_hotplug.c	2009-06-24 16:04:44.000000000 +0200
@@ -339,8 +339,11 @@ EXPORT_SYMBOL_GPL(__remove_pages);
 
 void online_page(struct page *page)
 {
+	unsigned long pfn = page_to_pfn(page);
+
 	totalram_pages++;
-	num_physpages++;
+	if (pfn >= num_physpages)
+		num_physpages = pfn + 1;
 
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
@@ -831,7 +834,6 @@ repeat:
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
-	num_physpages -= offlined_pages;
 
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
--- linux-2.6.31-rc1/mm/slab.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/mm/slab.c	2009-06-24 16:06:21.000000000 +0200
@@ -1384,7 +1384,7 @@ void __init kmem_cache_init(void)
 	 * Fragmentation resistance on low memory - only use bigger
 	 * page orders on machines with more than 32MB of memory.
 	 */
-	if (num_physpages > (32 << 20) >> PAGE_SHIFT)
+	if (totalram_pages > (32 << 20) >> PAGE_SHIFT)
 		slab_break_gfp_order = BREAK_GFP_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
--- linux-2.6.31-rc1/mm/swap.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/mm/swap.c	2009-06-24 16:06:40.000000000 +0200
@@ -496,7 +496,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  */
 void __init swap_setup(void)
 {
-	unsigned long megs = num_physpages >> (20 - PAGE_SHIFT);
+	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
--- linux-2.6.31-rc1/mm/vmalloc.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/mm/vmalloc.c	2009-06-24 16:05:47.000000000 +0200
@@ -1368,7 +1368,7 @@ void *vmap(struct page **pages, unsigned
 
 	might_sleep();
 
-	if (count > num_physpages)
+	if (count > totalram_pages)
 		return NULL;
 
 	area = get_vm_area_caller((count << PAGE_SHIFT), flags,
@@ -1475,7 +1475,7 @@ static void *__vmalloc_node(unsigned lon
 	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > num_physpages)
+	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
 	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
--- linux-2.6.31-rc1/net/core/sock.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/core/sock.c	2009-06-24 16:14:00.000000000 +0200
@@ -1169,12 +1169,12 @@ EXPORT_SYMBOL_GPL(sk_setup_caps);
 
 void __init sk_init(void)
 {
-	if (num_physpages <= 4096) {
+	if (totalram_pages <= 4096) {
 		sysctl_wmem_max = 32767;
 		sysctl_rmem_max = 32767;
 		sysctl_wmem_default = 32767;
 		sysctl_rmem_default = 32767;
-	} else if (num_physpages >= 131072) {
+	} else if (totalram_pages >= 131072) {
 		sysctl_wmem_max = 131071;
 		sysctl_rmem_max = 131071;
 	}
--- linux-2.6.31-rc1/net/dccp/proto.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/dccp/proto.c	2009-06-24 16:13:35.000000000 +0200
@@ -1049,10 +1049,10 @@ static int __init dccp_init(void)
 	 *
 	 * The methodology is similar to that of the buffer cache.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (23 - PAGE_SHIFT);
+		goal = totalram_pages >> (23 - PAGE_SHIFT);
 
 	if (thash_entries)
 		goal = (thash_entries *
--- linux-2.6.31-rc1/net/decnet/dn_route.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/decnet/dn_route.c	2009-06-24 16:17:11.000000000 +0200
@@ -1750,7 +1750,7 @@ void __init dn_route_init(void)
 	dn_route_timer.expires = jiffies + decnet_dst_gc_interval * HZ;
 	add_timer(&dn_route_timer);
 
-	goal = num_physpages >> (26 - PAGE_SHIFT);
+	goal = totalram_pages >> (26 - PAGE_SHIFT);
 
 	for(order = 0; (1UL << order) < goal; order++)
 		/* NOTHING */;
--- linux-2.6.31-rc1/net/ipv4/route.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/ipv4/route.c	2009-06-24 16:14:48.000000000 +0200
@@ -3412,7 +3412,7 @@ int __init ip_rt_init(void)
 		alloc_large_system_hash("IP route cache",
 					sizeof(struct rt_hash_bucket),
 					rhash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					15 : 17,
 					0,
 					&rt_hash_log,
--- linux-2.6.31-rc1/net/ipv4/tcp.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/ipv4/tcp.c	2009-06-24 16:14:24.000000000 +0200
@@ -2857,7 +2857,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP established",
 					sizeof(struct inet_ehash_bucket),
 					thash_entries,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.ehash_size,
@@ -2874,7 +2874,7 @@ void __init tcp_init(void)
 		alloc_large_system_hash("TCP bind",
 					sizeof(struct inet_bind_hashbucket),
 					tcp_hashinfo.ehash_size,
-					(num_physpages >= 128 * 1024) ?
+					(totalram_pages >= 128 * 1024) ?
 					13 : 15,
 					0,
 					&tcp_hashinfo.bhash_size,
--- linux-2.6.31-rc1/net/netfilter/nf_conntrack_core.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/netfilter/nf_conntrack_core.c	2009-06-24 16:16:47.000000000 +0200
@@ -1230,9 +1230,9 @@ static int nf_conntrack_init_init_net(vo
 	 * machine has 512 buckets. >= 1GB machines have 16384 buckets. */
 	if (!nf_conntrack_htable_size) {
 		nf_conntrack_htable_size
-			= (((num_physpages << PAGE_SHIFT) / 16384)
+			= (((totalram_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			nf_conntrack_htable_size = 16384;
 		if (nf_conntrack_htable_size < 32)
 			nf_conntrack_htable_size = 32;
--- linux-2.6.31-rc1/net/netfilter/x_tables.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/netfilter/x_tables.c	2009-06-24 16:16:28.000000000 +0200
@@ -617,7 +617,7 @@ struct xt_table_info *xt_alloc_table_inf
 	int cpu;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > num_physpages)
+	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
 	newinfo = kzalloc(XT_TABLE_INFO_SZ, GFP_KERNEL);
--- linux-2.6.31-rc1/net/netfilter/xt_hashlimit.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/netfilter/xt_hashlimit.c	2009-06-24 16:16:07.000000000 +0200
@@ -194,9 +194,9 @@ static int htable_create_v0(struct xt_ha
 	if (minfo->cfg.size)
 		size = minfo->cfg.size;
 	else {
-		size = ((num_physpages << PAGE_SHIFT) / 16384) /
+		size = ((totalram_pages << PAGE_SHIFT) / 16384) /
 		       sizeof(struct list_head);
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			size = 8192;
 		if (size < 16)
 			size = 16;
@@ -266,9 +266,9 @@ static int htable_create(struct xt_hashl
 	if (minfo->cfg.size) {
 		size = minfo->cfg.size;
 	} else {
-		size = (num_physpages << PAGE_SHIFT) / 16384 /
+		size = (totalram_pages << PAGE_SHIFT) / 16384 /
 		       sizeof(struct list_head);
-		if (num_physpages > 1024 * 1024 * 1024 / PAGE_SIZE)
+		if (totalram_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
 			size = 8192;
 		if (size < 16)
 			size = 16;
--- linux-2.6.31-rc1/net/netlink/af_netlink.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/netlink/af_netlink.c	2009-06-24 16:17:28.000000000 +0200
@@ -2026,10 +2026,10 @@ static int __init netlink_proto_init(voi
 	if (!nl_table)
 		goto panic;
 
-	if (num_physpages >= (128 * 1024))
-		limit = num_physpages >> (21 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		limit = totalram_pages >> (21 - PAGE_SHIFT);
 	else
-		limit = num_physpages >> (23 - PAGE_SHIFT);
+		limit = totalram_pages >> (23 - PAGE_SHIFT);
 
 	order = get_bitmask_order(limit) - 1 + PAGE_SHIFT;
 	limit = (1UL << order) / sizeof(struct hlist_head);
--- linux-2.6.31-rc1/net/sctp/protocol.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-use-totalram_pages/net/sctp/protocol.c	2009-06-24 16:15:36.000000000 +0200
@@ -1185,10 +1185,10 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Size and allocate the association hash table.
 	 * The methodology is similar to that of the tcp hash tables.
 	 */
-	if (num_physpages >= (128 * 1024))
-		goal = num_physpages >> (22 - PAGE_SHIFT);
+	if (totalram_pages >= (128 * 1024))
+		goal = totalram_pages >> (22 - PAGE_SHIFT);
 	else
-		goal = num_physpages >> (24 - PAGE_SHIFT);
+		goal = totalram_pages >> (24 - PAGE_SHIFT);
 
 	for (order = 0; (1UL << order) < goal; order++)
 		;


