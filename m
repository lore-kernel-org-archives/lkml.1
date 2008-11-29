Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYK2RrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYK2RrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 12:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYK2RrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 12:47:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:64537 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYK2RrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 12:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:organization:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=XWFJ/c2efGteu5V3lFnD/Jco2z+IbQynFGeOvHK/mHgViBXzpljHBZteok8+O2AChs
         Vw2exewR9iJr4VIqKOWLVRjxGOfdU/XE4y8YtzKg95bfu02byd9DRPvPARbYRuCQiDSr
         dzMw3o9bIQJ7fMM2bGHV/J4IcjE9O3NilZghQ=
Subject: [RESEND][PATCH] Add /proc/mempool to display mempool usage
From: Remi Colinet <remi.colinet@gmail.com>
Reply-To: remi.colinet@gmail.com
To: Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Personal
Date: Sat, 29 Nov 2008 18:44:49 +0100
Message-Id: <1227980689.6354.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new /proc/mempool file in order to display mempool usage.

The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
configuration.

Patch againt 2.6.28-rc6.

Signed-off-by: Remi Colinet <remi.colinet@gmail.com>
---
Add /proc/mempool to display mempool usage.
Can be disabled with CONFIG_PROC_MEMPOOL=N

Resend #1 : cosmetic cleaning.

 block/blk-core.c            |    2 +-
 drivers/block/pktcdvd.c     |    4 ++--
 drivers/block/virtio_blk.c  |    2 +-
 drivers/md/dm-crypt.c       |    4 ++--
 drivers/md/dm-io.c          |    2 +-
 drivers/md/dm-raid1.c       |    2 +-
 drivers/md/dm-region-hash.c |    2 +-
 drivers/md/multipath.c      |    2 +-
 drivers/md/raid1.c          |    7 +++----
 drivers/md/raid10.c         |    5 +++--
 fs/bio.c                    |    2 +-
 fs/proc/Kconfig             |    6 ++++++
 fs/proc/Makefile            |    1 +
 include/linux/mempool.h     |   40
+++++++++++++++++++++++++++++++---------
 mm/bounce.c                 |    4 ++--
 mm/mempool.c                |   42
+++++++++++++++++++++++++++++++++++++++---
 16 files changed, 96 insertions(+), 31 deletions(-)

diff -uNrp linux/block/blk-core.c linux-mempool/block/blk-core.c
--- linux/block/blk-core.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/block/blk-core.c	2008-11-29 15:49:32.000000000 +0100
@@ -483,7 +483,7 @@ static int blk_init_free_list(struct req
 	init_waitqueue_head(&rl->wait[WRITE]);
 
 	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
-				mempool_free_slab, request_cachep, q->node);
+		mempool_free_slab, request_cachep, q->node, "blk_rq", MEMPOOL_SLAB);
 
 	if (!rl->rq_pool)
 		return -ENOMEM;
diff -uNrp linux/drivers/block/pktcdvd.c linux-mempool/drivers/block/pktcdvd.c
--- linux/drivers/block/pktcdvd.c	2008-11-23 15:22:13.000000000 +0100
+++ linux-mempool/drivers/block/pktcdvd.c	2008-11-29 15:49:32.000000000 +0100
@@ -2879,7 +2879,7 @@ static int pkt_setup_dev(dev_t dev, dev_
 		goto out_mutex;
 
 	pd->rb_pool = mempool_create_kmalloc_pool(PKT_RB_POOL_SIZE,
-						  sizeof(struct pkt_rb_node));
+		  		sizeof(struct pkt_rb_node), "pkt_rb");
 	if (!pd->rb_pool)
 		goto out_mem;
 
@@ -3070,7 +3070,7 @@ static int __init pkt_init(void)
 	mutex_init(&ctl_mutex);
 
 	psd_pool = mempool_create_kmalloc_pool(PSD_POOL_SIZE,
-					sizeof(struct packet_stacked_data));
+				sizeof(struct packet_stacked_data), "pkt_psd");
 	if (!psd_pool)
 		return -ENOMEM;
 
diff -uNrp linux/drivers/block/virtio_blk.c linux-mempool/drivers/block/virtio_blk.c
--- linux/drivers/block/virtio_blk.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/block/virtio_blk.c	2008-11-29 15:49:32.000000000 +0100
@@ -230,7 +230,7 @@ static int virtblk_probe(struct virtio_d
 		goto out_free_vblk;
 	}
 
-	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct virtblk_req));
+	vblk->pool = mempool_create_kmalloc_pool(1, sizeof(struct virtblk_req), "vblk");
 	if (!vblk->pool) {
 		err = -ENOMEM;
 		goto out_free_vq;
diff -uNrp linux/drivers/md/dm-crypt.c linux-mempool/drivers/md/dm-crypt.c
--- linux/drivers/md/dm-crypt.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/md/dm-crypt.c	2008-11-29 15:49:32.000000000 +0100
@@ -1047,14 +1047,14 @@ static int crypt_ctr(struct dm_target *t
 			   ~(crypto_tfm_ctx_alignment() - 1);
 
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
-			sizeof(struct dm_crypt_request) + cc->iv_size);
+			sizeof(struct dm_crypt_request) + cc->iv_size, "dm-crypt_req");
 	if (!cc->req_pool) {
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad_req_pool;
 	}
 	cc->req = NULL;
 
-	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0, "dm-crypt_page");
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad_page_pool;
diff -uNrp linux/drivers/md/dm-io.c linux-mempool/drivers/md/dm-io.c
--- linux/drivers/md/dm-io.c	2008-11-23 15:25:56.000000000 +0100
+++ linux-mempool/drivers/md/dm-io.c	2008-11-29 15:49:32.000000000 +0100
@@ -52,7 +52,7 @@ struct dm_io_client *dm_io_client_create
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io));
+	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io), "dm-io_client");
 	if (!client->pool)
 		goto bad;
 
diff -uNrp linux/drivers/md/dm-raid1.c linux-mempool/drivers/md/dm-raid1.c
--- linux/drivers/md/dm-raid1.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/md/dm-raid1.c	2008-11-29 15:49:32.000000000 +0100
@@ -766,7 +766,7 @@ static struct mirror_set *alloc_context(
 
 	len = sizeof(struct dm_raid1_read_record);
 	ms->read_record_pool = mempool_create_kmalloc_pool(MIN_READ_RECORDS,
-							   len);
+						len, "dm-raid read record");
 	if (!ms->read_record_pool) {
 		ti->error = "Error creating mirror read_record_pool";
 		kfree(ms);
diff -uNrp linux/drivers/md/dm-region-hash.c linux-mempool/drivers/md/dm-region-hash.c
--- linux/drivers/md/dm-region-hash.c	2008-11-23 17:39:20.000000000 +0100
+++ linux-mempool/drivers/md/dm-region-hash.c	2008-11-29 15:49:32.000000000 +0100
@@ -214,7 +214,7 @@ struct dm_region_hash *dm_region_hash_cr
 	INIT_LIST_HEAD(&rh->failed_recovered_regions);
 
 	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
-						      sizeof(struct dm_region));
+				sizeof(struct dm_region), "md-region-hash");
 	if (!rh->region_pool) {
 		vfree(rh->buckets);
 		kfree(rh);
diff -uNrp linux/drivers/md/multipath.c linux-mempool/drivers/md/multipath.c
--- linux/drivers/md/multipath.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/md/multipath.c	2008-11-29 15:49:32.000000000 +0100
@@ -475,7 +475,7 @@ static int multipath_run (mddev_t *mddev
 	mddev->degraded = conf->raid_disks - conf->working_disks;
 
 	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
-						 sizeof(struct multipath_bh));
+					sizeof(struct multipath_bh), "multipath_bh");
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
 			"multipath: couldn't allocate memory for %s\n",
diff -uNrp linux/drivers/md/raid10.c linux-mempool/drivers/md/raid10.c
--- linux/drivers/md/raid10.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/md/raid10.c	2008-11-29 15:49:32.000000000 +0100
@@ -1636,7 +1636,8 @@ static int init_resync(conf_t *conf)
 
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r10buf_pool);
-	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf);
+	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf,
+		"md_r10buf", MEMPOOL_PRIVATE);
 	if (!conf->r10buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -2097,7 +2098,7 @@ static int run(mddev_t *mddev)
 	conf->stride = stride << conf->chunk_shift;
 
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
-						r10bio_pool_free, conf);
+		r10bio_pool_free, conf, "md_r10bio", MEMPOOL_PRIVATE);
 	if (!conf->r10bio_pool) {
 		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
 			mdname(mddev));
diff -uNrp linux/drivers/md/raid1.c linux-mempool/drivers/md/raid1.c
--- linux/drivers/md/raid1.c	2008-11-28 22:43:55.000000000 +0100
+++ linux-mempool/drivers/md/raid1.c	2008-11-29 15:49:32.000000000 +0100
@@ -1678,7 +1678,7 @@ static int init_resync(conf_t *conf)
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r1buf_pool);
 	conf->r1buf_pool = mempool_create(buffs, r1buf_pool_alloc, r1buf_pool_free,
-					  conf->poolinfo);
+				  conf->poolinfo, "md_r1buf", MEMPOOL_PRIVATE);
 	if (!conf->r1buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -1955,8 +1955,7 @@ static int run(mddev_t *mddev)
 	conf->poolinfo->mddev = mddev;
 	conf->poolinfo->raid_disks = mddev->raid_disks;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-					  r1bio_pool_free,
-					  conf->poolinfo);
+		r1bio_pool_free, conf->poolinfo, "md_r1bio", MEMPOOL_PRIVATE);
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
@@ -2170,7 +2169,7 @@ static int raid1_reshape(mddev_t *mddev)
 	newpoolinfo->raid_disks = raid_disks;
 
 	newpool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-				 r1bio_pool_free, newpoolinfo);
+		r1bio_pool_free, newpoolinfo, "md_raid1", MEMPOOL_PRIVATE);
 	if (!newpool) {
 		kfree(newpoolinfo);
 		return -ENOMEM;
diff -uNrp linux/fs/bio.c linux-mempool/fs/bio.c
--- linux/fs/bio.c	2008-11-23 15:31:14.000000000 +0100
+++ linux-mempool/fs/bio.c	2008-11-29 15:49:32.000000000 +0100
@@ -1428,7 +1428,7 @@ static int __init init_bio(void)
 		panic("bio: can't allocate bios\n");
 
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
+				sizeof(struct bio_pair), "bio_pair");
 	if (!bio_split_pool)
 		panic("bio: can't create split pool\n");
 
diff -uNrp linux/fs/proc/Kconfig linux-mempool/fs/proc/Kconfig
--- linux/fs/proc/Kconfig	2008-11-23 15:18:54.000000000 +0100
+++ linux-mempool/fs/proc/Kconfig	2008-11-29 15:49:32.000000000 +0100
@@ -67,3 +67,9 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
+
+config PROC_MEMPOOL
+	default y
+	bool "Enable /proc mempool"
+	help
+	  Display mempool created and usage
diff -uNrp linux/fs/proc/Makefile linux-mempool/fs/proc/Makefile
--- linux/fs/proc/Makefile	2008-11-28 22:43:59.000000000 +0100
+++ linux-mempool/fs/proc/Makefile	2008-11-29 15:49:32.000000000 +0100
@@ -26,3 +26,4 @@ proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PROC_MEMPOOL)	+= mempool.o
diff -uNrp linux/include/linux/mempool.h linux-mempool/include/linux/mempool.h
--- linux/include/linux/mempool.h	2008-11-23 15:10:51.000000000 +0100
+++ linux-mempool/include/linux/mempool.h	2008-11-29 15:49:32.000000000 +0100
@@ -18,15 +18,33 @@ typedef struct mempool_s {
 	void **elements;
 
 	void *pool_data;
+	struct list_head list;
+	char* name;
+	unsigned int size;
+	unsigned short type;
 	mempool_alloc_t *alloc;
 	mempool_free_t *free;
 	wait_queue_head_t wait;
 } mempool_t;
 
+extern struct list_head mempool_list;
+extern rwlock_t mempool_lock;
+
+enum MEMPOOL_TYPE {
+	MEMPOOL_SLAB,
+	MEMPOOL_KMALLOC,
+	MEMPOOL_KZALLOC,
+	MEMPOOL_PAGE,
+	MEMPOOL_PRIVATE,        /* For private or default usage */
+	MEMPOOL_NR_TYPES
+};
+
 extern mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data);
+	mempool_free_t *free_fn, void *pool_data, const char *name, 
+	unsigned short type);
 extern mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int nid);
+	mempool_free_t *free_fn, void *pool_data, int nid, const char *name, 
+	unsigned short type);
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask);
 extern void mempool_destroy(mempool_t *pool);
@@ -42,8 +60,9 @@ void mempool_free_slab(void *element, vo
 static inline mempool_t *
 mempool_create_slab_pool(int min_nr, struct kmem_cache *kc)
 {
+	const char *name = kmem_cache_name(kc);
 	return mempool_create(min_nr, mempool_alloc_slab, mempool_free_slab,
-			      (void *) kc);
+			      (void *) kc, name, MEMPOOL_SLAB);
 }
 
 /*
@@ -53,15 +72,17 @@ mempool_create_slab_pool(int min_nr, str
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data);
 void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data);
 void mempool_kfree(void *element, void *pool_data);
-static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size)
+static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size,
+	const char* name)
 {
 	return mempool_create(min_nr, mempool_kmalloc, mempool_kfree,
-			      (void *) size);
+			      (void *) size, name, MEMPOOL_KMALLOC);
 }
-static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size)
+static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size, 
+	const char* name)
 {
 	return mempool_create(min_nr, mempool_kzalloc, mempool_kfree,
-			      (void *) size);
+			      (void *) size, name, MEMPOOL_KMALLOC);
 }
 
 /*
@@ -70,10 +91,11 @@ static inline mempool_t *mempool_create_
  */
 void *mempool_alloc_pages(gfp_t gfp_mask, void *pool_data);
 void mempool_free_pages(void *element, void *pool_data);
-static inline mempool_t *mempool_create_page_pool(int min_nr, int order)
+static inline mempool_t *mempool_create_page_pool(int min_nr, int order,
+	const char* name)
 {
 	return mempool_create(min_nr, mempool_alloc_pages, mempool_free_pages,
-			      (void *)(long)order);
+			      (void *)(long)order, name, MEMPOOL_PAGE);
 }
 
 #endif /* _LINUX_MEMPOOL_H */
diff -uNrp linux/mm/bounce.c linux-mempool/mm/bounce.c
--- linux/mm/bounce.c	2008-11-23 15:09:22.000000000 +0100
+++ linux-mempool/mm/bounce.c	2008-11-29 15:49:32.000000000 +0100
@@ -31,7 +31,7 @@ static __init int init_emergency_pool(vo
 	if (!i.totalhigh)
 		return 0;
 
-	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
+	page_pool = mempool_create_page_pool(POOL_SIZE, 0, "highmem_bounce");
 	BUG_ON(!page_pool);
 	printk("highmem bounce pool size: %d pages\n", POOL_SIZE);
 
@@ -80,7 +80,7 @@ int init_emergency_isa_pool(void)
 		return 0;
 
 	isa_page_pool = mempool_create(ISA_POOL_SIZE, mempool_alloc_pages_isa,
-				       mempool_free_pages, (void *) 0);
+	       mempool_free_pages, (void *) 0, "isa_page_pool", MEMPOOL_PAGE);
 	BUG_ON(!isa_page_pool);
 
 	printk("isa bounce pool size: %d pages\n", ISA_POOL_SIZE);
diff -uNrp linux/mm/mempool.c linux-mempool/mm/mempool.c
--- linux/mm/mempool.c	2008-11-23 14:59:51.000000000 +0100
+++ linux-mempool/mm/mempool.c	2008-11-29 15:49:32.000000000 +0100
@@ -15,6 +15,9 @@
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
 
+LIST_HEAD(mempool_list);
+DEFINE_RWLOCK(mempool_lock);
+
 static void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
@@ -44,6 +47,8 @@ static void free_pool(mempool_t *pool)
  * @alloc_fn:  user-defined element-allocation function.
  * @free_fn:   user-defined element-freeing function.
  * @pool_data: optional private data available to the user-defined functions.
+ * @name: name of the mempool
+ * @type: type of the mempool (PAGE, SLAB, KMALLOC, KZALLOC, PRIVATE)
  *
  * this function creates and allocates a guaranteed size, preallocated
  * memory pool. The pool can be used from the mempool_alloc() and mempool_free()
@@ -52,14 +57,16 @@ static void free_pool(mempool_t *pool)
  * from IRQ contexts.
  */
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
-				mempool_free_t *free_fn, void *pool_data)
+	mempool_free_t *free_fn, void *pool_data, const char *name, 
+	unsigned short type)
 {
-	return  mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,-1);
+	return  mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,-1, name, type);
 }
 EXPORT_SYMBOL(mempool_create);
 
 mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int node_id)
+	mempool_free_t *free_fn, void *pool_data, int node_id, const char *name, 
+	unsigned short type)
 {
 	mempool_t *pool;
 	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL | __GFP_ZERO, node_id);
@@ -91,6 +98,35 @@ mempool_t *mempool_create_node(int min_n
 		}
 		add_element(pool, element);
 	}
+
+	/*
+	 * Setup name of the mempool
+	 */
+	pool->name = kmalloc(strlen(name), GFP_KERNEL);
+	if (pool->name == NULL) {
+		/* should release other memory allocations */
+		return ERR_PTR(-ENOMEM);
+	}
+
+	strcpy(pool->name, name);
+	pool->type = type;
+	if (type == MEMPOOL_KZALLOC || type == MEMPOOL_KMALLOC)
+		pool->size = (int)(long) pool_data;
+	if (type == MEMPOOL_PAGE)
+		pool->size = (int)(PAGE_SIZE << (int)(long) pool_data);
+	if (type == MEMPOOL_SLAB) {
+		struct kmem_cache *kc = pool_data;
+		pool->size = kmem_cache_size(kc);
+	}
+	if (type == MEMPOOL_PRIVATE)
+		pool->size = 0;
+
+	/*
+	 * Add the mempool to the global list
+	 */
+	write_lock(&mempool_lock);
+	list_add_tail(&pool->list, &mempool_list);
+	write_unlock(&mempool_lock);
 	return pool;
 }
 EXPORT_SYMBOL(mempool_create_node);


