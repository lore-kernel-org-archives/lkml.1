Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYK3ARU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYK3ARU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 19:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYK3AQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 19:16:47 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23011 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYK3AQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 19:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xuTcynS/s5pq6Y9EwtcTRiH7yLs/0kuEYB2xwaIXIsWdzPEWE8obkeLC9UZpODWl+C
         Bjwg2DbBQxl5lmIav+Uc/afK8E1ZYgm0OMeStqUQuKjxp00N1wU46YtDE8JsdYpJ1N/U
         QMzvaRXEMZPt2rGs5Umbz/+xOT+xXhZqEygnA=
Subject: [RESEND take 2][PATCH 2/2] Update mempool function calls.
From: Remi Colinet <remi.colinet@gmail.com>
Reply-To: remi.colinet@gmail.com
To: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1228003445.13070.1.camel@localhost.localdomain>
References: <1228003445.13070.1.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Personal
Date: Sun, 30 Nov 2008 01:13:51 +0100
Message-Id: <1228004031.13070.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update mempool function calls.

Signed-off-by: Remi Colinet <remi.colinet@gmail.com>
---
 block/blk-core.c               |    3 ++-
 drivers/block/pktcdvd.c        |    4 ++--
 drivers/block/virtio_blk.c     |    3 ++-
 drivers/md/dm-crypt.c          |    5 +++--
 drivers/md/dm-io.c             |    3 ++-
 drivers/md/dm-raid1.c          |    2 +-
 drivers/md/dm-region-hash.c    |    2 +-
 drivers/md/multipath.c         |    2 +-
 drivers/md/raid1.c             |    7 +++----
 drivers/md/raid10.c            |    5 +++--
 drivers/s390/scsi/zfcp_aux.c   |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 drivers/scsi/lpfc/lpfc_mem.c   |    5 +++--
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 fs/bio.c                       |    2 +-
 mm/bounce.c                    |    4 ++--
 16 files changed, 29 insertions(+), 24 deletions(-)

diff -uNrp linux/block/blk-core.c linux-mempool/block/blk-core.c
--- linux/block/blk-core.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/block/blk-core.c	2008-11-29 23:21:06.000000000 +0100
@@ -479,7 +479,8 @@ static int blk_init_free_list(struct req
 	init_waitqueue_head(&rl->wait[WRITE]);
 
 	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
-				mempool_free_slab, request_cachep, q->node);
+		mempool_free_slab, request_cachep, q->node, "blk_rq",
+		MEMPOOL_SLAB);
 
 	if (!rl->rq_pool)
 		return -ENOMEM;
diff -uNrp linux/drivers/block/pktcdvd.c
linux-mempool/drivers/block/pktcdvd.c
--- linux/drivers/block/pktcdvd.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/block/pktcdvd.c	2008-11-29 22:24:38.000000000
+0100
@@ -2879,7 +2879,7 @@ static int pkt_setup_dev(dev_t dev, dev_
 		goto out_mutex;
 
 	pd->rb_pool = mempool_create_kmalloc_pool(PKT_RB_POOL_SIZE,
-						  sizeof(struct pkt_rb_node));
+					sizeof(struct pkt_rb_node), "pkt_rb");
 	if (!pd->rb_pool)
 		goto out_mem;
 
@@ -3070,7 +3070,7 @@ static int __init pkt_init(void)
 	mutex_init(&ctl_mutex);
 
 	psd_pool = mempool_create_kmalloc_pool(PSD_POOL_SIZE,
-					sizeof(struct packet_stacked_data));
+				sizeof(struct packet_stacked_data), "pkt_psd");
 	if (!psd_pool)
 		return -ENOMEM;
 
diff -uNrp linux/drivers/block/virtio_blk.c
linux-mempool/drivers/block/virtio_blk.c
--- linux/drivers/block/virtio_blk.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/block/virtio_blk.c	2008-11-29
22:25:15.000000000 +0100
@@ -218,7 +218,8 @@ static int virtblk_probe(struct virtio_d
 		goto out_free_vblk;
 	}
 
-	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct
virtblk_req));
+	vblk->pool = mempool_create_kmalloc_pool(1, sizeof(struct
virtblk_req),
+									"vblk");
 	if (!vblk->pool) {
 		err = -ENOMEM;
 		goto out_free_vq;
diff -uNrp linux/drivers/md/dm-crypt.c
linux-mempool/drivers/md/dm-crypt.c
--- linux/drivers/md/dm-crypt.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/dm-crypt.c	2008-11-29 23:21:27.000000000
+0100
@@ -1047,14 +1047,15 @@ static int crypt_ctr(struct dm_target *t
 			   ~(crypto_tfm_ctx_alignment() - 1);
 
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
-			sizeof(struct dm_crypt_request) + cc->iv_size);
+		sizeof(struct dm_crypt_request) + cc->iv_size, "dm-crypt_req");
 	if (!cc->req_pool) {
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad_req_pool;
 	}
 	cc->req = NULL;
 
-	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0,
+							"dm-crypt_page");
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad_page_pool;
diff -uNrp linux/drivers/md/dm-io.c linux-mempool/drivers/md/dm-io.c
--- linux/drivers/md/dm-io.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/dm-io.c	2008-11-29 23:21:48.000000000 +0100
@@ -52,7 +52,8 @@ struct dm_io_client *dm_io_client_create
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io));
+	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io),
+							"dm-io_client");
 	if (!client->pool)
 		goto bad;
 
diff -uNrp linux/drivers/md/dm-raid1.c
linux-mempool/drivers/md/dm-raid1.c
--- linux/drivers/md/dm-raid1.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/dm-raid1.c	2008-11-29 21:33:57.000000000
+0100
@@ -766,7 +766,7 @@ static struct mirror_set *alloc_context(
 
 	len = sizeof(struct dm_raid1_read_record);
 	ms->read_record_pool = mempool_create_kmalloc_pool(MIN_READ_RECORDS,
-							   len);
+						len, "dm-raid read record");
 	if (!ms->read_record_pool) {
 		ti->error = "Error creating mirror read_record_pool";
 		kfree(ms);
diff -uNrp linux/drivers/md/dm-region-hash.c
linux-mempool/drivers/md/dm-region-hash.c
--- linux/drivers/md/dm-region-hash.c	2008-11-29 23:42:26.000000000
+0100
+++ linux-mempool/drivers/md/dm-region-hash.c	2008-11-29
21:33:57.000000000 +0100
@@ -214,7 +214,7 @@ struct dm_region_hash *dm_region_hash_cr
 	INIT_LIST_HEAD(&rh->failed_recovered_regions);
 
 	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
-						      sizeof(struct dm_region));
+				sizeof(struct dm_region), "md-region-hash");
 	if (!rh->region_pool) {
 		vfree(rh->buckets);
 		kfree(rh);
diff -uNrp linux/drivers/md/multipath.c
linux-mempool/drivers/md/multipath.c
--- linux/drivers/md/multipath.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/multipath.c	2008-11-29 22:26:47.000000000
+0100
@@ -476,7 +476,7 @@ static int multipath_run (mddev_t *mddev
 	mddev->degraded = conf->raid_disks - conf->working_disks;
 
 	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
-						 sizeof(struct multipath_bh));
+				sizeof(struct multipath_bh), "multipath_bh");
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
 			"multipath: couldn't allocate memory for %s\n",
diff -uNrp linux/drivers/md/raid10.c linux-mempool/drivers/md/raid10.c
--- linux/drivers/md/raid10.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/raid10.c	2008-11-29 23:22:12.000000000
+0100
@@ -1636,7 +1636,8 @@ static int init_resync(conf_t *conf)
 
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r10buf_pool);
-	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc,
r10buf_pool_free, conf);
+	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc,
+		r10buf_pool_free, conf, "md_r10buf", MEMPOOL_PRIVATE);
 	if (!conf->r10buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -2098,7 +2099,7 @@ static int run(mddev_t *mddev)
 	conf->stride = stride << conf->chunk_shift;
 
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
-						r10bio_pool_free, conf);
+		r10bio_pool_free, conf, "md_r10bio", MEMPOOL_PRIVATE);
 	if (!conf->r10bio_pool) {
 		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
 			mdname(mddev));
diff -uNrp linux/drivers/md/raid1.c linux-mempool/drivers/md/raid1.c
--- linux/drivers/md/raid1.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/drivers/md/raid1.c	2008-11-29 21:33:57.000000000 +0100
@@ -1678,7 +1678,7 @@ static int init_resync(conf_t *conf)
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r1buf_pool);
 	conf->r1buf_pool = mempool_create(buffs, r1buf_pool_alloc,
r1buf_pool_free,
-					  conf->poolinfo);
+				  conf->poolinfo, "md_r1buf", MEMPOOL_PRIVATE);
 	if (!conf->r1buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -1956,8 +1956,7 @@ static int run(mddev_t *mddev)
 	conf->poolinfo->mddev = mddev;
 	conf->poolinfo->raid_disks = mddev->raid_disks;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-					  r1bio_pool_free,
-					  conf->poolinfo);
+		r1bio_pool_free, conf->poolinfo, "md_r1bio", MEMPOOL_PRIVATE);
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
@@ -2171,7 +2170,7 @@ static int raid1_reshape(mddev_t *mddev)
 	newpoolinfo->raid_disks = raid_disks;
 
 	newpool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-				 r1bio_pool_free, newpoolinfo);
+		r1bio_pool_free, newpoolinfo, "md_raid1", MEMPOOL_PRIVATE);
 	if (!newpool) {
 		kfree(newpoolinfo);
 		return -ENOMEM;
diff -uNrp linux/drivers/s390/scsi/zfcp_aux.c
linux-mempool/drivers/s390/scsi/zfcp_aux.c
--- linux/drivers/s390/scsi/zfcp_aux.c	2008-11-29 23:42:26.000000000
+0100
+++ linux-mempool/drivers/s390/scsi/zfcp_aux.c	2008-11-29
21:55:55.000000000 +0100
@@ -372,7 +372,7 @@ static int zfcp_allocate_low_mem_buffers
 
 	adapter->pool.fsf_req_status_read =
 		mempool_create_kmalloc_pool(FSF_STATUS_READS_RECOM,
-					    sizeof(struct zfcp_fsf_req));
+				sizeof(struct zfcp_fsf_req), "zfcp_fsf_req");
 	if (!adapter->pool.fsf_req_status_read)
 		return -ENOMEM;
 
diff -uNrp linux/drivers/scsi/ibmvscsi/ibmvfc.c
linux-mempool/drivers/scsi/ibmvscsi/ibmvfc.c
--- linux/drivers/scsi/ibmvscsi/ibmvfc.c	2008-11-29 23:42:26.000000000
+0100
+++ linux-mempool/drivers/scsi/ibmvscsi/ibmvfc.c	2008-11-29
22:01:31.000000000 +0100
@@ -3809,7 +3809,7 @@ static int ibmvfc_alloc_mem(struct ibmvf
 		goto free_disc_buffer;
 
 	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
-						      sizeof(struct ibmvfc_target));
+				sizeof(struct ibmvfc_target), "ibmvfc_target");
 
 	if (!vhost->tgt_pool) {
 		dev_err(dev, "Couldn't allocate target memory pool\n");
diff -uNrp linux/drivers/scsi/lpfc/lpfc_mem.c
linux-mempool/drivers/scsi/lpfc/lpfc_mem.c
--- linux/drivers/scsi/lpfc/lpfc_mem.c	2008-11-29 23:42:26.000000000
+0100
+++ linux-mempool/drivers/scsi/lpfc/lpfc_mem.c	2008-11-29
23:40:37.000000000 +0100
@@ -19,6 +19,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#include <linux/slab.h>
 #include <linux/mempool.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
@@ -89,12 +90,12 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 	}
 
 	phba->mbox_mem_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
-							 sizeof(LPFC_MBOXQ_t));
+					sizeof(LPFC_MBOXQ_t), "mbox_mem_pool");
 	if (!phba->mbox_mem_pool)
 		goto fail_free_mbuf_pool;
 
 	phba->nlp_mem_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
-						sizeof(struct lpfc_nodelist));
+				sizeof(struct lpfc_nodelist), "nlp_mem_pool");
 	if (!phba->nlp_mem_pool)
 		goto fail_free_mbox_pool;
 
diff -uNrp linux/drivers/scsi/qla4xxx/ql4_os.c
linux-mempool/drivers/scsi/qla4xxx/ql4_os.c
--- linux/drivers/scsi/qla4xxx/ql4_os.c	2008-11-29 23:42:26.000000000
+0100
+++ linux-mempool/drivers/scsi/qla4xxx/ql4_os.c	2008-11-29
22:28:06.000000000 +0100
@@ -563,7 +563,7 @@ static int qla4xxx_mem_alloc(struct scsi
 
 	/* Allocate memory for srb pool. */
 	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
-					 mempool_free_slab, srb_cachep);
+		mempool_free_slab, srb_cachep, "srb_mempool", MEMPOOL_PRIVATE);
 	if (ha->srb_mempool == NULL) {
 		dev_warn(&ha->pdev->dev,
 			"Memory Allocation failed - SRB Pool.\n");
diff -uNrp linux/fs/bio.c linux-mempool/fs/bio.c
--- linux/fs/bio.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/fs/bio.c	2008-11-29 21:33:57.000000000 +0100
@@ -1428,7 +1428,7 @@ static int __init init_bio(void)
 		panic("bio: can't allocate bios\n");
 
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
+				sizeof(struct bio_pair), "bio_pair");
 	if (!bio_split_pool)
 		panic("bio: can't create split pool\n");
 
diff -uNrp linux/mm/bounce.c linux-mempool/mm/bounce.c
--- linux/mm/bounce.c	2008-11-29 23:42:26.000000000 +0100
+++ linux-mempool/mm/bounce.c	2008-11-29 21:33:57.000000000 +0100
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


