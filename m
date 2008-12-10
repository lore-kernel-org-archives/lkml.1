Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYLJOLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYLJOLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLJOL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:11:27 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18417 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYLJOL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:11:26 -0500
Date: Wed, 10 Dec 2008 15:11:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2008-12-09-15-24: memory corruption (bio slab)
Message-ID: <20081210141109.GS23742@kernel.dk>
References: <1228917441-830-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228917441-830-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10 2008, Jiri Slaby wrote:
> Hi,
> 
> on every bootup of this kernel, I get this (not sure if it is right after the moment when / gets mounted from md1):
> 
> wlan0 renamed to wlan1
> udev: renamed network interface wlan0 to wlan1
> swap_cgroup: uses 7848 bytes of vmalloc for pointer array space and 4018176 bytes to hold mem_cgroup pointers on swap
> swap_cgroup can be disabled by noswapaccount boot option.
> Adding 2008084k swap on /dev/sdb6.  Priority:-1 extents:1 across:2008084k 
> EXT3 FS on md1, internal journal
> bio: create slab <bio-1> at 1
> =============================================================================
> BUG bio-1: Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff88007bacf068-0xffff88007bacf06f. First byte 0x68 instead of 0xcc
> INFO: Allocated in 0x6b6b6b6b6b6b6b6b age=10706345584330245030 cpu=1802201963 pid=1802201963
> INFO: Freed in 0x6b6b6b6b6b6b6b6b age=6527005130130424742 cpu=1802201963 pid=1802201963
> INFO: Slab 0xffffe20001b0dd48 objects=21 used=4 fp=0xffff88007bacf300 flags=0x40000000000000c3
> INFO: Object 0xffff88007bacf000 @offset=0 fp=0x0000000000001000
> 
>   Object 0xffff88007bacf000:  fd 6f 57 04 00 00 00 00 00 00 00 00 00 00 00 00 375oW.............
>   Object 0xffff88007bacf010:  80 86 c2 7c 00 88 ff ff 19 00 00 00 00 00 00 00 ..302|..377377........
>   Object 0xffff88007bacf020:  00 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 ................
>   Object 0xffff88007bacf030:  00 00 00 00 00 10 00 00 00 10 00 00 04 00 00 00 ................
>   Object 0xffff88007bacf040:  ff ff ff ff 00 00 00 00 68 f0 ac 7b 00 88 ff ff 377377377377....h360254{..377377
>   Object 0xffff88007bacf050:  b0 ad 49 80 ff ff ff ff 58 99 b7 7a 00 88 ff ff 260255I.377377377377X.267z..377377
>   Object 0xffff88007bacf060:  10 98 49 80 ff ff ff ff                         ..I.377377377377        
>  Redzone 0xffff88007bacf068:  68 1b b1 01 00 e2 ff ff                         h.261..342377377        
>  Padding 0xffff88007bacf0a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>  Padding 0xffff88007bacf0b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> Pid: 815, comm: udevd Tainted: G        W  2.6.28-rc7-mm1_64 #490
> Call Trace:
>  <IRQ>  [<ffffffff802b6ed6>] print_trailer+0x106/0x160
>  [<ffffffff802b7145>] check_bytes_and_report+0x125/0x180
>  [<ffffffff802b83d6>] check_object+0x66/0x280
>  [<ffffffff802b9e65>] __slab_free+0x225/0x370
>  [<ffffffff8028f5d2>] ? mempool_free_slab+0x12/0x20
>  [<ffffffff802bb7f2>] kmem_cache_free+0x72/0xa0
>  [<ffffffff8028f5d2>] mempool_free_slab+0x12/0x20
>  [<ffffffff8028f66a>] mempool_free+0x8a/0xa0
>  [<ffffffff802ea03d>] bio_free+0x4d/0x60
>  [<ffffffff8049981d>] dm_bio_destructor+0xd/0x10
>  [<ffffffff802e848b>] bio_put+0x2b/0x40
>  [<ffffffff8049ae39>] clone_endio+0x89/0xd0
>  [<ffffffff802e851c>] bio_endio+0x1c/0x40
>  [<ffffffff8034f42b>] req_bio_endio+0x8b/0xe0
>  [<ffffffff8034f527>] __end_that_request_first+0xa7/0x2b0
>  [<ffffffff8034f75c>] end_that_request_data+0x2c/0x70
>  [<ffffffff8034f80d>] blk_end_io+0x2d/0xb0
>  [<ffffffff8034f8be>] blk_end_request+0xe/0x10
>  [<ffffffff80418edb>] scsi_io_completion+0x13b/0x490
>  [<ffffffff8041250c>] scsi_finish_command+0xac/0xe0
>  [<ffffffff80418d1a>] scsi_softirq_done+0xba/0x140
>  [<ffffffff8043df0c>] ? ahci_interrupt+0x9c/0x5c0
>  [<ffffffff80353a85>] blk_done_softirq+0x75/0x90
>  [<ffffffff8025ab83>] ? sched_clock_cpu+0x143/0x190
>  [<ffffffff80244052>] __do_softirq+0xc2/0x190
>  [<ffffffff8020d6bc>] call_softirq+0x1c/0x30
>  [<ffffffff8020ea15>] do_softirq+0x45/0x90
>  [<ffffffff80243d9d>] irq_exit+0x8d/0xa0
>  [<ffffffff8020ecc5>] do_IRQ+0xc5/0x110
>  [<ffffffff8020cf93>] ret_from_intr+0x0/0xa
>  <EOI> <3>FIX bio-1: Restoring 0xffff88007bacf068-0xffff88007bacf06f=0xcc
> 
> =============================================================================
> BUG bio-1: Redzone overwritten
> -----------------------------------------------------------------------------
> 
> ffffffff8049981d is in dm_bio_destructor from drivers/md/dm.c.
> 
> Inlined vecs doesn't fit to the allocated slab portion in my eyes, doesn't
> the patch below make sense?

Ah good, this looks like it's narrowing things down.

> Enlarge bio slabs to include inlined vecs
> 
> ---
>  fs/bio.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 40b6488..cd1a439 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -68,7 +68,8 @@ static unsigned int bio_slab_nr, bio_slab_max;
>  
>  static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
>  {
> -	unsigned int sz = sizeof(struct bio) + extra_size;
> +	unsigned int sz = sizeof(struct bio) +
> +		sizeof(struct bio_vec) * BIO_INLINE_VECS + extra_size;
>  	struct kmem_cache *slab = NULL;
>  	struct bio_slab *bslab;
>  	unsigned int i, entry = -1;

But we already accounted for those bytes at the end. The generic setup
does:

unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
...
fs_bio_set = bioset_create(BIO_POOL_SIZE, 0, back_pad);

But I notice that you are seeing this with bio-1, not bio-0. So this
must be the one of the pools created by md/dm. Does this help?

I'll probably rework this a bit, perhaps we should just hide the back
padding functionality and force it to be used for vec inlining only.
Then it becomes invisible to the users.

diff --git a/fs/bio.c b/fs/bio.c
index b4008e3..ed9fc15 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -294,15 +294,20 @@ void bio_init(struct bio *bio)
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	unsigned int inline_vecs;
 	struct bio *bio = NULL;
 
 	if (bs) {
 		void *p = mempool_alloc(bs->bio_pool, gfp_mask);
 
-		if (p)
+		if (p) {
 			bio = p + bs->front_pad;
-	} else
+			inline_vecs = bs->inline_vecs;
+		}
+	} else {
 		bio = kmalloc(sizeof(*bio), gfp_mask);
+		inline_vecs = 0;
+	}
 
 	if (likely(bio)) {
 		struct bio_vec *bvl = NULL;
@@ -311,10 +316,10 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		if (likely(nr_iovecs)) {
 			unsigned long uninitialized_var(idx);
 
-			if (nr_iovecs <= BIO_INLINE_VECS) {
+			if (nr_iovecs <= inline_vecs) {
 				idx = 0;
 				bvl = bio->bi_inline_vecs;
-				nr_iovecs = BIO_INLINE_VECS;
+				nr_iovecs = inline_vecs;
 			} else {
 				bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx,
 							bs);
@@ -1605,6 +1610,8 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
+	fs_bio_set->inline_vecs = BIO_INLINE_VECS;
+
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
 						     sizeof(struct bio_pair));
 	if (!bio_split_pool)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fbb62fb..c9f8d26 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -417,6 +417,7 @@ static inline void bio_set_completion_cpu(struct bio *bio, unsigned int cpu)
 struct bio_set {
 	struct kmem_cache *bio_slab;
 	unsigned int front_pad;
+	unsigned int inline_vecs;
 
 	mempool_t *bio_pool;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)

-- 
Jens Axboe

