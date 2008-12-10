Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYLJObQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYLJObQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLJOa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:30:59 -0500
Received: from brick.kernel.dk ([93.163.65.50]:17234 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYLJOa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:30:57 -0500
Date: Wed, 10 Dec 2008 15:30:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2008-12-09-15-24: memory corruption (bio slab)
Message-ID: <20081210143041.GT23742@kernel.dk>
References: <1228917441-830-1-git-send-email-jirislaby@gmail.com> <20081210141109.GS23742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210141109.GS23742@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10 2008, Jens Axboe wrote:
> On Wed, Dec 10 2008, Jiri Slaby wrote:
> > Hi,
> > 
> > on every bootup of this kernel, I get this (not sure if it is right after the moment when / gets mounted from md1):
> > 
> > wlan0 renamed to wlan1
> > udev: renamed network interface wlan0 to wlan1
> > swap_cgroup: uses 7848 bytes of vmalloc for pointer array space and 4018176 bytes to hold mem_cgroup pointers on swap
> > swap_cgroup can be disabled by noswapaccount boot option.
> > Adding 2008084k swap on /dev/sdb6.  Priority:-1 extents:1 across:2008084k 
> > EXT3 FS on md1, internal journal
> > bio: create slab <bio-1> at 1
> > =============================================================================
> > BUG bio-1: Redzone overwritten
> > -----------------------------------------------------------------------------
> > 
> > INFO: 0xffff88007bacf068-0xffff88007bacf06f. First byte 0x68 instead of 0xcc
> > INFO: Allocated in 0x6b6b6b6b6b6b6b6b age=10706345584330245030 cpu=1802201963 pid=1802201963
> > INFO: Freed in 0x6b6b6b6b6b6b6b6b age=6527005130130424742 cpu=1802201963 pid=1802201963
> > INFO: Slab 0xffffe20001b0dd48 objects=21 used=4 fp=0xffff88007bacf300 flags=0x40000000000000c3
> > INFO: Object 0xffff88007bacf000 @offset=0 fp=0x0000000000001000
> > 
> >   Object 0xffff88007bacf000:  fd 6f 57 04 00 00 00 00 00 00 00 00 00 00 00 00 375oW.............
> >   Object 0xffff88007bacf010:  80 86 c2 7c 00 88 ff ff 19 00 00 00 00 00 00 00 ..302|..377377........
> >   Object 0xffff88007bacf020:  00 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 ................
> >   Object 0xffff88007bacf030:  00 00 00 00 00 10 00 00 00 10 00 00 04 00 00 00 ................
> >   Object 0xffff88007bacf040:  ff ff ff ff 00 00 00 00 68 f0 ac 7b 00 88 ff ff 377377377377....h360254{..377377
> >   Object 0xffff88007bacf050:  b0 ad 49 80 ff ff ff ff 58 99 b7 7a 00 88 ff ff 260255I.377377377377X.267z..377377
> >   Object 0xffff88007bacf060:  10 98 49 80 ff ff ff ff                         ..I.377377377377        
> >  Redzone 0xffff88007bacf068:  68 1b b1 01 00 e2 ff ff                         h.261..342377377        
> >  Padding 0xffff88007bacf0a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> >  Padding 0xffff88007bacf0b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> > Pid: 815, comm: udevd Tainted: G        W  2.6.28-rc7-mm1_64 #490
> > Call Trace:
> >  <IRQ>  [<ffffffff802b6ed6>] print_trailer+0x106/0x160
> >  [<ffffffff802b7145>] check_bytes_and_report+0x125/0x180
> >  [<ffffffff802b83d6>] check_object+0x66/0x280
> >  [<ffffffff802b9e65>] __slab_free+0x225/0x370
> >  [<ffffffff8028f5d2>] ? mempool_free_slab+0x12/0x20
> >  [<ffffffff802bb7f2>] kmem_cache_free+0x72/0xa0
> >  [<ffffffff8028f5d2>] mempool_free_slab+0x12/0x20
> >  [<ffffffff8028f66a>] mempool_free+0x8a/0xa0
> >  [<ffffffff802ea03d>] bio_free+0x4d/0x60
> >  [<ffffffff8049981d>] dm_bio_destructor+0xd/0x10
> >  [<ffffffff802e848b>] bio_put+0x2b/0x40
> >  [<ffffffff8049ae39>] clone_endio+0x89/0xd0
> >  [<ffffffff802e851c>] bio_endio+0x1c/0x40
> >  [<ffffffff8034f42b>] req_bio_endio+0x8b/0xe0
> >  [<ffffffff8034f527>] __end_that_request_first+0xa7/0x2b0
> >  [<ffffffff8034f75c>] end_that_request_data+0x2c/0x70
> >  [<ffffffff8034f80d>] blk_end_io+0x2d/0xb0
> >  [<ffffffff8034f8be>] blk_end_request+0xe/0x10
> >  [<ffffffff80418edb>] scsi_io_completion+0x13b/0x490
> >  [<ffffffff8041250c>] scsi_finish_command+0xac/0xe0
> >  [<ffffffff80418d1a>] scsi_softirq_done+0xba/0x140
> >  [<ffffffff8043df0c>] ? ahci_interrupt+0x9c/0x5c0
> >  [<ffffffff80353a85>] blk_done_softirq+0x75/0x90
> >  [<ffffffff8025ab83>] ? sched_clock_cpu+0x143/0x190
> >  [<ffffffff80244052>] __do_softirq+0xc2/0x190
> >  [<ffffffff8020d6bc>] call_softirq+0x1c/0x30
> >  [<ffffffff8020ea15>] do_softirq+0x45/0x90
> >  [<ffffffff80243d9d>] irq_exit+0x8d/0xa0
> >  [<ffffffff8020ecc5>] do_IRQ+0xc5/0x110
> >  [<ffffffff8020cf93>] ret_from_intr+0x0/0xa
> >  <EOI> <3>FIX bio-1: Restoring 0xffff88007bacf068-0xffff88007bacf06f=0xcc
> > 
> > =============================================================================
> > BUG bio-1: Redzone overwritten
> > -----------------------------------------------------------------------------
> > 
> > ffffffff8049981d is in dm_bio_destructor from drivers/md/dm.c.
> > 
> > Inlined vecs doesn't fit to the allocated slab portion in my eyes, doesn't
> > the patch below make sense?
> 
> Ah good, this looks like it's narrowing things down.
> 
> > Enlarge bio slabs to include inlined vecs
> > 
> > ---
> >  fs/bio.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 40b6488..cd1a439 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -68,7 +68,8 @@ static unsigned int bio_slab_nr, bio_slab_max;
> >  
> >  static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
> >  {
> > -	unsigned int sz = sizeof(struct bio) + extra_size;
> > +	unsigned int sz = sizeof(struct bio) +
> > +		sizeof(struct bio_vec) * BIO_INLINE_VECS + extra_size;
> >  	struct kmem_cache *slab = NULL;
> >  	struct bio_slab *bslab;
> >  	unsigned int i, entry = -1;
> 
> But we already accounted for those bytes at the end. The generic setup
> does:
> 
> unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
> ...
> fs_bio_set = bioset_create(BIO_POOL_SIZE, 0, back_pad);
> 
> But I notice that you are seeing this with bio-1, not bio-0. So this
> must be the one of the pools created by md/dm. Does this help?
> 
> I'll probably rework this a bit, perhaps we should just hide the back
> padding functionality and force it to be used for vec inlining only.
> Then it becomes invisible to the users.

Something like this, I'll fold it into the original patch.

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b6b1b80..3326750 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1060,7 +1060,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_page_pool;
 	}
 
-	cc->bs = bioset_create(MIN_IOS, 0, 0);
+	cc->bs = bioset_create(MIN_IOS, 0);
 	if (!cc->bs) {
 		ti->error = "Cannot allocate crypt bioset";
 		goto bad_bs;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index eb518b8..a343385 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -56,7 +56,7 @@ struct dm_io_client *dm_io_client_create(unsigned num_pages)
 	if (!client->pool)
 		goto bad;
 
-	client->bios = bioset_create(16, 0, 0);
+	client->bios = bioset_create(16, 0);
 	if (!client->bios)
 		goto bad;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 35975a4..368ffa3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1091,7 +1091,7 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->tio_pool)
 		goto bad_tio_pool;
 
-	md->bs = bioset_create(16, 0, 0);
+	md->bs = bioset_create(16, 0);
 	if (!md->bs)
 		goto bad_no_bioset;
 
diff --git a/fs/bio.c b/fs/bio.c
index b4008e3..45ddca4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1519,19 +1519,18 @@ void bioset_free(struct bio_set *bs)
  * bioset_create  - Create a bio_set
  * @pool_size:	Number of bio and bio_vecs to cache in the mempool
  * @front_pad:	Number of bytes to allocate in front of the returned bio
- * @back_pad:	Number of bytes to allocate behind the returned bio
  *
  * Description:
  *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
- *    to ask for a number of bytes to be allocated in front and back of the
- *    bio. Front pad allocation is useful for embedding the bio inside
+ *    to ask for a number of bytes to be allocated in front of the bio.
+ *    Front pad allocation is useful for embedding the bio inside
  *    another structure, to avoid allocating extra data to go with the bio.
  *    Note that the bio must be embedded at the END of that structure always,
- *    or things will break badly if back padding is also used.
+ *    or things will break badly.
  */
-struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad,
-			      unsigned int back_pad)
+struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 {
+	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
 
 	bs = kzalloc(sizeof(*bs), GFP_KERNEL);
@@ -1584,8 +1583,6 @@ static void __init biovec_init_slabs(void)
 
 static int __init init_bio(void)
 {
-	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
-
 	bio_slab_max = 2;
 	bio_slab_nr = 0;
 	bio_slabs = kzalloc(bio_slab_max * sizeof(struct bio_slab), GFP_KERNEL);
@@ -1595,13 +1592,7 @@ static int __init init_bio(void)
 	bio_integrity_init_slab();
 	biovec_init_slabs();
 
-	if (back_pad) {
-		printk(KERN_INFO "bio: Using %d inlines, %u -> %u bytes\n",
-			BIO_INLINE_VECS, (int) sizeof(struct bio),
-			(int) sizeof(struct bio) + back_pad);
-	}
-
-	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0, back_pad);
+	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0);
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fbb62fb..76134d7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -348,7 +348,7 @@ struct bio_pair {
 extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
-extern struct bio_set *bioset_create(unsigned int, unsigned int, unsigned int);
+extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 
 extern struct bio *bio_alloc(gfp_t, int);

-- 
Jens Axboe

