Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYKQLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYKQLPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYKQLPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:15:42 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38871 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYKQLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:15:38 -0500
Date: Mon, 17 Nov 2008 12:13:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117111350.GJ26778@kernel.dk>
References: <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com> <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk> <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117094551.GI26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Jens Axboe wrote:
> On Mon, Nov 17 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Mon, Nov 17 2008, Jens Axboe wrote:
> > > > On Mon, Nov 17 2008, Ingo Molnar wrote:
> > > > > 
> > > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > 
> > > > > > On Mon, Nov 17 2008, Ingo Molnar wrote:
> > > > > > > 
> > > > > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > > > 
> > > > > > > > +#define kunmap(p)			\
> > > > > > > > +	do {				\
> > > > > > > > +		struct page *__p;	\
> > > > > > > > +		(void) (&__p == &(p));	\
> > > > > > > > +		__kunmap(p);		\
> > > > > > > > +	} while (0)
> > > > > > > > +
> > > > > > > > +#define kunmap_atomic(a, t)		\
> > > > > > > > +	do {				\
> > > > > > > > +		void *__p;		\
> > > > > > > > +		(void) (&__p == &(a));	\
> > > > > > > > +		__kunmap_atomic(a, t);	\
> > > > > > > > +	} while (0)
> > > > > > > 
> > > > > > > Agreed - but please use the typecheck() primitive. (linux/typecheck.h)
> > > > > > 
> > > > > > Neat, didn't know about that, thanks.
> > > > > 
> > > > > and ack on your patch obviously. Feel free to push it via the block 
> > > > > tree straight away, it doesnt collide with anything pending in the x86 
> > > > > tree.
> > > > > 
> > > > > Acked-by: Ingo Molnar <mingo@elte.hu>
> > > > 
> > > > The kunmap() bit is easy to do as I mentioned, but the kunmap_atomic()
> > > > gets a bit more ugly. Lots of users can just be switched to void *
> > > > types, but some get ugly like:
> > > > 
> > > > static struct page **shmem_dir_map(struct page *page)
> > > >         return (struct page **)kmap_atomic(page, KM_USER0);
> > > >  }
> > > >  
> > > > -static inline void shmem_dir_unmap(struct page **dir)
> > > > +static inline void shmem_dir_unmap(void *dir)
> > > >  {
> > > >         kunmap_atomic(dir, KM_USER0);
> > > >  }
> > > > 
> > > > and others again like fs/exec.c:remove_arg_zero() would really like to
> > > > use a char * type since it dereferences it.
> > > > 
> > > > I think the kunmap_atomic() change it the most needed part of the patch,
> > > > but I don't think it can come for free (eg, we have to add variable to
> > > > the above function).
> > > 
> > > OK, (void *) cast works fine when I fixed it. Here's a normal build diff
> > > to show approximately how bad it is. I expected it to be worse, so it
> > > looks quite doable I think.
> > 
> > hm:
> > 
> >    32 files changed, 89 insertions(+), 62 deletions(-)
> > 
> > regarding churn it looks a bit like on the high side. OTOH it's 
> > trivial, most of the churn is spread-out in various architectures, and 
> > it can catch real bugs so i'm still acking it.
> > 
> > Could you please send the patch with a full changelog? I've Cc:-ed 
> > Linus and Andrew - please let us know if you think that this too much 
> > churn for -rc6.
> 
> I'll send out a new version when I've done a full build, to avoid
> introducing new warnings. And I'll do that as a proper patch with SOB
> and description, etc.

So here's the full patch that fixes up all related warnings on an
allyesconfig on x86-64. It's big though:

 60 files changed, 144 insertions(+), 115 deletions(-)

so while it's still 100% trivial, perhaps it's better to wait for
2.6.29.

One exception is a real bug that this turned up. The XEN balloon driver
passes the virt address into kunmap() as well, so that part should go in
for 2.6.28. I've CC'ed Jeremy.

 arch/frv/mm/highmem.c                     |    2 -
 arch/parisc/include/asm/cacheflush.h      |    4 +--
 arch/powerpc/include/asm/highmem.h        |    4 +--
 arch/sparc/mm/highmem.c                   |    2 -
 arch/x86/include/asm/highmem.h            |    4 +--
 arch/x86/kvm/paging_tmpl.h                |    2 -
 arch/x86/mm/highmem_32.c                  |    8 +++----
 drivers/ata/libata-sff.c                  |    4 +--
 drivers/block/loop.c                      |    8 +++----
 drivers/gpu/drm/drm_cache.c               |    2 -
 drivers/ide/ide-atapi.c                   |    2 -
 drivers/ide/ide-taskfile.c                |    2 -
 drivers/infiniband/ulp/iser/iser_memory.c |    4 +--
 drivers/md/bitmap.c                       |   10 ++++-----
 drivers/memstick/host/jmb38x_ms.c         |    2 -
 drivers/memstick/host/tifm_ms.c           |    2 -
 drivers/mmc/host/tifm_sd.c                |    8 +++----
 drivers/net/e1000e/netdev.c               |    4 +--
 drivers/scsi/arcmsr/arcmsr_hba.c          |    4 +--
 drivers/scsi/gdth.c                       |    2 -
 drivers/scsi/ips.c                        |    4 +--
 drivers/scsi/libsas/sas_host_smp.c        |    3 +-
 drivers/scsi/scsi_debug.c                 |    2 -
 drivers/scsi/sd_dif.c                     |    8 +++----
 drivers/xen/balloon.c                     |    2 -
 fs/aio.c                                  |    8 +++----
 fs/cifs/file.c                            |    2 -
 fs/ecryptfs/mmap.c                        |    2 -
 fs/ecryptfs/read_write.c                  |    2 -
 fs/exec.c                                 |    2 -
 fs/jbd/journal.c                          |    2 -
 fs/jbd/transaction.c                      |    2 -
 fs/jbd2/commit.c                          |    4 +--
 fs/jbd2/journal.c                         |    2 -
 fs/jbd2/transaction.c                     |    2 -
 fs/minix/dir.c                            |    2 -
 fs/namei.c                                |    2 -
 fs/nfs/dir.c                              |    2 -
 fs/nfs/nfs2xdr.c                          |    7 +++---
 fs/nfs/nfs3xdr.c                          |    7 +++---
 fs/nfs/nfs4proc.c                         |    3 +-
 fs/nfs/nfs4xdr.c                          |    7 +++---
 fs/ntfs/aops.c                            |   10 ++++-----
 fs/ntfs/attrib.c                          |    4 +--
 fs/ntfs/file.c                            |    9 ++++----
 fs/ntfs/super.c                           |    8 +++----
 fs/pipe.c                                 |    2 -
 fs/reiserfs/stree.c                       |    2 -
 fs/reiserfs/tail_conversion.c             |    2 -
 fs/splice.c                               |    4 +--
 fs/udf/file.c                             |    2 -
 include/linux/bio.h                       |    2 -
 include/linux/highmem.h                   |   31 ++++++++++++++++++++++++++----
 mm/bounce.c                               |    2 -
 mm/filemap.c                              |    4 +--
 mm/shmem.c                                |    6 ++---
 net/sunrpc/auth_gss/gss_krb5_wrap.c       |    2 -
 net/sunrpc/socklib.c                      |    2 -
 net/sunrpc/xdr.c                          |    6 ++---
 net/sunrpc/xprtrdma/rpc_rdma.c            |    4 +--
 60 files changed, 144 insertions(+), 115 deletions(-)

diff --git a/arch/frv/mm/highmem.c b/arch/frv/mm/highmem.c
index eadd076..de7802c 100644
--- a/arch/frv/mm/highmem.c
+++ b/arch/frv/mm/highmem.c
@@ -21,7 +21,7 @@ void *kmap(struct page *page)
 
 EXPORT_SYMBOL(kmap);
 
-void kunmap(struct page *page)
+void __kunmap(struct page *page)
 {
 	if (in_interrupt())
 		BUG();
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index b7ca6dc..b8fd949 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -107,11 +107,11 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-#define kunmap(page)			kunmap_parisc(page_address(page))
+#define __kunmap(page)			kunmap_parisc(page_address(page))
 
 #define kmap_atomic(page, idx)		page_address(page)
 
-#define kunmap_atomic(addr, idx)	kunmap_parisc(addr)
+#define __kunmap_atomic(addr, idx)	kunmap_parisc(addr)
 
 #define kmap_atomic_pfn(pfn, idx)	page_address(pfn_to_page(pfn))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
diff --git a/arch/powerpc/include/asm/highmem.h b/arch/powerpc/include/asm/highmem.h
index 91c5895..b948918 100644
--- a/arch/powerpc/include/asm/highmem.h
+++ b/arch/powerpc/include/asm/highmem.h
@@ -55,7 +55,7 @@ static inline void *kmap(struct page *page)
 	return kmap_high(page);
 }
 
-static inline void kunmap(struct page *page)
+static inline void __kunmap(struct page *page)
 {
 	BUG_ON(in_interrupt());
 	if (!PageHighMem(page))
@@ -95,7 +95,7 @@ static inline void *kmap_atomic(struct page *page, enum km_type type)
 	return kmap_atomic_prot(page, type, kmap_prot);
 }
 
-static inline void kunmap_atomic(void *kvaddr, enum km_type type)
+static inline void __kunmap_atomic(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
diff --git a/arch/sparc/mm/highmem.c b/arch/sparc/mm/highmem.c
index 01fc6c2..8a6e6a4 100644
--- a/arch/sparc/mm/highmem.c
+++ b/arch/sparc/mm/highmem.c
@@ -63,7 +63,7 @@ void *kmap_atomic(struct page *page, enum km_type type)
 	return (void*) vaddr;
 }
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void __kunmap_atomic(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index bf9276b..4b6f197 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -58,10 +58,10 @@ extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
 
 void *kmap(struct page *page);
-void kunmap(struct page *page);
+void __kunmap(struct page *page);
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
-void kunmap_atomic(void *kvaddr, enum km_type type);
+void __kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 613ec9a..fcce3bf 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -106,7 +106,7 @@ static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 
 	table = kmap_atomic(page, KM_USER0);
 	ret = CMPXCHG(&table[index], orig_pte, new_pte);
-	kunmap_atomic(table, KM_USER0);
+	kunmap_atomic((void *) table, KM_USER0);
 
 	kvm_release_page_dirty(page);
 
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..40ef500 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -9,7 +9,7 @@ void *kmap(struct page *page)
 	return kmap_high(page);
 }
 
-void kunmap(struct page *page)
+void __kunmap(struct page *page)
 {
 	if (in_interrupt())
 		BUG();
@@ -91,7 +91,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	return (void *)vaddr;
 }
 
-void *kmap_atomic(struct page *page, enum km_type type)
+void *__kmap_atomic(struct page *page, enum km_type type)
 {
 	return kmap_atomic_prot(page, type, kmap_prot);
 }
@@ -153,6 +153,6 @@ struct page *kmap_atomic_to_page(void *ptr)
 }
 
 EXPORT_SYMBOL(kmap);
-EXPORT_SYMBOL(kunmap);
+EXPORT_SYMBOL(__kunmap);
 EXPORT_SYMBOL(kmap_atomic);
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(__kunmap_atomic);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4b47394..77a7a0d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -762,7 +762,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned int offset;
-	unsigned char *buf;
+	void *buf;
 
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
@@ -887,7 +887,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	struct ata_eh_info *ehi = &dev->link->eh_info;
 	struct scatterlist *sg;
 	struct page *page;
-	unsigned char *buf;
+	void *buf;
 	unsigned int offset, count, consumed;
 
 next_sg:
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5c4ee70..f0a64cd 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -92,8 +92,8 @@ static int transfer_none(struct loop_device *lo, int cmd,
 			 struct page *loop_page, unsigned loop_off,
 			 int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	void *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
+	void *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
 
 	if (cmd == READ)
 		memcpy(loop_buf, raw_buf, size);
@@ -111,8 +111,8 @@ static int transfer_xor(struct loop_device *lo, int cmd,
 			struct page *loop_page, unsigned loop_off,
 			int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	void *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
+	void *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
 	char *in, *out, *key;
 	int i, keysize;
 
diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 0e994a0..c601daf 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -34,7 +34,7 @@
 static void
 drm_clflush_page(struct page *page)
 {
-	uint8_t *page_virtual;
+	void *page_virtual;
 	unsigned int i;
 
 	if (unlikely(page == NULL))
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 4e58b9e..e4d381b 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -69,7 +69,7 @@ int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
 	struct scatterlist *sg = pc->sg;
-	char *buf;
+	void *buf;
 	int count, done = 0;
 
 	while (bcount) {
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index bf4fb9d..8265ce9 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -203,7 +203,7 @@ static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
 	unsigned long flags;
 #endif
 	unsigned int offset;
-	u8 *buf;
+	void *buf;
 
 	cursg = hwif->cursg;
 	if (!cursg) {
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index b9453d0..ed2a4fd 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -125,7 +125,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		struct scatterlist *sgl = (struct scatterlist *)data->buf;
 		struct scatterlist *sg;
 		int i;
-		char *p, *from;
+		void *p, *from;
 
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
@@ -177,7 +177,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 	if (cmd_dir == ISER_DIR_IN) {
 		char *mem;
 		struct scatterlist *sgl, *sg;
-		unsigned char *p, *to;
+		void *p, *to;
 		unsigned int sg_size;
 		int i;
 
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ac89a5d..c1d0f55 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -495,7 +495,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		bitmap->events_cleared = bitmap->mddev->events;
 		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
 	}
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic((void *) sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
 
@@ -525,7 +525,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
 	printk(KERN_DEBUG "     sync size: %llu KB\n",
 			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic((void *) sb, KM_USER0);
 }
 
 /* read the superblock from the bitmap file and initialize some bitmap fields */
@@ -614,7 +614,7 @@ success:
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic((void *) sb, KM_USER0);
 	if (err)
 		bitmap_print_sb(bitmap);
 	return err;
@@ -648,7 +648,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 				break;
 		default: BUG();
 	}
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic((void *) sb, KM_USER0);
 	return old;
 }
 
@@ -1134,7 +1134,7 @@ void bitmap_daemon_work(struct bitmap *bitmap)
 				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 				sb->events_cleared =
 					cpu_to_le64(bitmap->events_cleared);
-				kunmap_atomic(sb, KM_USER0);
+				kunmap_atomic((void *) sb, KM_USER0);
 				write_page(bitmap, bitmap->sb_page, 1);
 			}
 			spin_lock_irqsave(&bitmap->lock, flags);
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 2fb95a5..1d824cb 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -300,7 +300,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	unsigned int length;
 	unsigned int off;
 	unsigned int t_size, p_cnt;
-	unsigned char *buf;
+	void *buf;
 	struct page *pg;
 	unsigned long flags = 0;
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index d32d6ad..4f7d122 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -184,7 +184,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 	unsigned int length;
 	unsigned int off;
 	unsigned int t_size, p_cnt;
-	unsigned char *buf;
+	void *buf;
 	struct page *pg;
 	unsigned long flags = 0;
 
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 1384484..5177960 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -133,7 +133,7 @@ static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
 		}
 		buf[pos++] = (val >> 8) & 0xff;
 	}
-	kunmap_atomic(buf - off, KM_BIO_DST_IRQ);
+	kunmap_atomic((void *) buf - off, KM_BIO_DST_IRQ);
 }
 
 static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
@@ -160,7 +160,7 @@ static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
 		val |= (buf[pos++] << 8) & 0xff00;
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
 	}
-	kunmap_atomic(buf - off, KM_BIO_SRC_IRQ);
+	kunmap_atomic((void *) buf - off, KM_BIO_SRC_IRQ);
 }
 
 static void tifm_sd_transfer_data(struct tifm_sd *host)
@@ -211,8 +211,8 @@ static void tifm_sd_copy_page(struct page *dst, unsigned int dst_off,
 			      struct page *src, unsigned int src_off,
 			      unsigned int count)
 {
-	unsigned char *src_buf = kmap_atomic(src, KM_BIO_SRC_IRQ) + src_off;
-	unsigned char *dst_buf = kmap_atomic(dst, KM_BIO_DST_IRQ) + dst_off;
+	void *src_buf = kmap_atomic(src, KM_BIO_SRC_IRQ) + src_off;
+	void *dst_buf = kmap_atomic(dst, KM_BIO_DST_IRQ) + dst_off;
 
 	memcpy(dst_buf, src_buf, count);
 
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index abd492b..ac116de 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -787,7 +787,7 @@ static bool e1000_clean_rx_irq_ps(struct e1000_adapter *adapter,
 		 */
 		if (l1 && (l1 <= copybreak) &&
 		    ((length + l1) <= adapter->rx_ps_bsize0)) {
-			u8 *vaddr;
+			void *vaddr;
 
 			ps_page = &buffer_info->ps_pages[0];
 
@@ -982,7 +982,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 				 * copybreak to save the put_page/alloc_page */
 				if (length <= copybreak &&
 				    skb_tailroom(skb) >= length) {
-					u8 *vaddr;
+					void *vaddr;
 					vaddr = kmap_atomic(buffer_info->page,
 					                   KM_SKB_DATA_SOFTIRQ);
 					memcpy(skb_tail_pointer(skb), vaddr,
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f91f79c..976757b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1363,7 +1363,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 {
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
 	int retvalue = 0, transfer_len = 0;
-	char *buffer;
+	void *buffer;
 	struct scatterlist *sg;
 	uint32_t controlcode = (uint32_t ) cmd->cmnd[5] << 24 |
 						(uint32_t ) cmd->cmnd[6] << 16 |
@@ -1597,7 +1597,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 	switch (cmd->cmnd[0]) {
 	case INQUIRY: {
 		unsigned char inqdata[36];
-		char *buffer;
+		void *buffer;
 		struct scatterlist *sg;
 
 		if (cmd->device->lun) {
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c387c15..bffab0a 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2287,7 +2287,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
     ushort cpcount,i, max_sg = scsi_sg_count(scp);
     ushort cpsum,cpnow;
     struct scatterlist *sl;
-    char *address;
+    void *address;
 
     cpcount = min_t(ushort, count, scsi_bufflen(scp));
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index ef683f0..0431732 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1513,11 +1513,11 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
                 buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
-                        kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                        kunmap_atomic((void *) buffer - sg->offset, KM_IRQ0);
                         local_irq_restore(flags);
                         return 1;
                 }
-                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                kunmap_atomic((void *) buffer - sg->offset, KM_IRQ0);
                 local_irq_restore(flags);
 	}
 	return 0;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 16f9312..cce202c 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -132,9 +132,10 @@ static void sas_phy_control(struct sas_ha_struct *sas_ha, u8 phy_id,
 int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 			 struct request *rsp)
 {
-	u8 *req_data = NULL, *resp_data = NULL, *buf;
+	u8 *req_data = NULL, *resp_data = NULL;
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
 	int error = -EINVAL, resp_data_len = rsp->data_len;
+	void *buf;
 
 	/* eight is the minimum size for request and response frames */
 	if (req->data_len < 8 || rsp->data_len < 8)
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 27c633f..d551466 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1674,7 +1674,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 			*(kaddr + sg->offset + j) ^= *(buf + offset + j);
 
 		offset += sg->length;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic((void *) kaddr, KM_USER0);
 	}
 	ret = 0;
 out:
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 3ebb1f2..437c6c8 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -467,14 +467,14 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 				phys++;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kunmap_atomic((void *) sdt, KM_USER0);
 		}
 	}
 
 	return 0;
 
 error:
-	kunmap_atomic(sdt, KM_USER0);
+	kunmap_atomic((void *) sdt, KM_USER0);
 	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u\n",
 		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag));
 
@@ -518,7 +518,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
 
 				if (sectors == 0) {
-					kunmap_atomic(sdt, KM_USER0);
+					kunmap_atomic((void *) sdt, KM_USER0);
 					return;
 				}
 
@@ -533,7 +533,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 				sectors--;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kunmap_atomic((void *) sdt, KM_USER0);
 		}
 	}
 }
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a0fb5ea..9748f6a 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -125,7 +125,7 @@ static void scrub_page(struct page *page)
 	if (PageHighMem(page)) {
 		void *v = kmap(page);
 		clear_page(v);
-		kunmap(v);
+		kunmap(page);
 	} else {
 		void *v = page_address(page);
 		clear_page(v);
diff --git a/fs/aio.c b/fs/aio.c
index ee81c16..2656ec5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -173,7 +173,7 @@ static int __aio_setup_ring(struct kioctx *ctx, struct aio_ring_info *info)
 	ring->compat_features = AIO_RING_COMPAT_FEATURES;
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
-	kunmap_atomic(ring, KM_USER0);
+	kunmap_atomic((void *) ring, KM_USER0);
 
 	return 0;
 }
@@ -478,7 +478,7 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 		spin_unlock(&ctx->ctx_lock);
 		okay = 1;
 	}
-	kunmap_atomic(ring, KM_IRQ0);
+	kunmap_atomic((void *) ring, KM_IRQ0);
 	local_irq_enable();
 
 	if (!okay) {
@@ -1023,7 +1023,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	ring->tail = tail;
 
 	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
+	kunmap_atomic((void *) ring, KM_IRQ1);
 
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
@@ -1096,7 +1096,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 			 atomic_read(&ring->head), ring->tail, ring->nr);
 
 		ret = __aio_read_evt(info, ring, ent);
-		kunmap_atomic(ring, KM_USER0);
+		kunmap_atomic((void *) ring, KM_USER0);
 		if (ret)
 			break;
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ead1a3b..690942e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1755,7 +1755,7 @@ static void cifs_copy_cache_pages(struct address_space *mapping,
 	struct pagevec *plru_pvec)
 {
 	struct page *page;
-	char *target;
+	void *target;
 
 	while (bytes_read > 0) {
 		if (list_empty(pages))
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 04d7b3f..8837370 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -140,7 +140,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 
 		if (view_extent_num < num_header_extents_at_front) {
 			/* This is a header extent */
-			char *page_virt;
+			void *page_virt;
 
 			page_virt = kmap_atomic(page, KM_USER0);
 			memset(page_virt, 0, PAGE_CACHE_SIZE);
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 75c2ea9..34a0c21 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -117,7 +117,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		   size_t size)
 {
 	struct page *ecryptfs_page;
-	char *ecryptfs_page_virt;
+	void *ecryptfs_page_virt;
 	loff_t ecryptfs_file_size =
 		i_size_read(ecryptfs_file->f_dentry->d_inode);
 	loff_t data_offset = 0;
diff --git a/fs/exec.c b/fs/exec.c
index 4e834f1..82d9f4e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1138,7 +1138,7 @@ int remove_arg_zero(struct linux_binprm *bprm)
 				offset++, bprm->p++)
 			;
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic((void *) kaddr, KM_USER0);
 		put_arg_page(page);
 
 		if (offset == PAGE_SIZE)
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9e4fa52..f6c489a 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -281,7 +281,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	int need_copy_out = 0;
 	int done_copy_out = 0;
 	int do_escape = 0;
-	char *mapped_data;
+	void *mapped_data;
 	struct buffer_head *new_bh;
 	struct journal_head *new_jh;
 	struct page *new_page;
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 60d4c32..e091d53 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -722,7 +722,7 @@ done:
 	if (need_copy) {
 		struct page *page;
 		int offset;
-		char *source;
+		void *source;
 
 		J_EXPECT_JH(jh, buffer_uptodate(jh2bh(jh)),
 			    "Possible IO failure.\n");
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ebc667b..3d2d38a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -297,12 +297,12 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
-	char *addr;
+	void *addr;
 	__u32 checksum;
 
 	addr = kmap_atomic(page, KM_USER0);
 	checksum = crc32_be(crc32_sum,
-		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
+		addr + offset_in_page(bh->b_data), bh->b_size);
 	kunmap_atomic(addr, KM_USER0);
 
 	return checksum;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 783de11..22aa836 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -284,7 +284,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	int need_copy_out = 0;
 	int done_copy_out = 0;
 	int do_escape = 0;
-	char *mapped_data;
+	void *mapped_data;
 	struct buffer_head *new_bh;
 	struct journal_head *new_jh;
 	struct page *new_page;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 39b7805..1a48893 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -732,7 +732,7 @@ done:
 	if (need_copy) {
 		struct page *page;
 		int offset;
-		char *source;
+		void *source;
 
 		J_EXPECT_JH(jh, buffer_uptodate(jh2bh(jh)),
 			    "Possible IO failure.\n");
diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index f704338..a3fe4bc 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -334,7 +334,7 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page = grab_cache_page(mapping, 0);
 	struct minix_sb_info *sbi = minix_sb(inode->i_sb);
-	char *kaddr;
+	void *kaddr;
 	int err;
 
 	if (!page)
diff --git a/fs/namei.c b/fs/namei.c
index 09ce58e..dd5d521 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2793,7 +2793,7 @@ int __page_symlink(struct inode *inode, const char *symname, int len,
 	struct page *page;
 	void *fsdata;
 	int err;
-	char *kaddr;
+	void *kaddr;
 
 retry:
 	err = pagecache_write_begin(NULL, mapping, 0, len-1,
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 3e64b98..1c816bf 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1473,7 +1473,7 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 {
 	struct pagevec lru_pvec;
 	struct page *page;
-	char *kaddr;
+	void *kaddr;
 	struct iattr attr;
 	unsigned int pathlen = strlen(symname);
 	int error;
diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 28bab67..18dbad6 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -429,7 +429,8 @@ nfs_xdr_readdirres(struct rpc_rqst *req, __be32 *p, void *dummy)
 	unsigned int pglen, recvd;
 	u32 len;
 	int status, nr = 0;
-	__be32 *end, *entry, *kaddr;
+	__be32 *end, *entry;
+	void *kaddr;
 
 	if ((status = ntohl(*p++)))
 		return nfs_stat_to_errno(status);
@@ -628,9 +629,9 @@ nfs_xdr_readlinkres(struct rpc_rqst *req, __be32 *p, void *dummy)
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic((void *) kaddr, KM_USER0);
 	return 0;
 }
 
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 11cddde..17f3525 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -509,7 +509,8 @@ nfs3_xdr_readdirres(struct rpc_rqst *req, __be32 *p, struct nfs3_readdirres *res
 	size_t hdrlen;
 	u32 len, recvd, pglen;
 	int status, nr = 0;
-	__be32 *entry, *end, *kaddr;
+	__be32 *entry, *end;
+	void *kaddr;
 
 	status = ntohl(*p++);
 	/* Decode post_op_attrs */
@@ -870,9 +871,9 @@ nfs3_xdr_readlinkres(struct rpc_rqst *req, __be32 *p, struct nfs_fattr *fattr)
 	}
 
 	/* NULL terminate the string we got */
-	kaddr = (char*)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic((void *) kaddr, KM_USER0);
 	return 0;
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 83e700a..9735a07 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -143,7 +143,8 @@ const u32 nfs4_fs_locations_bitmap[2] = {
 static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dentry,
 		struct nfs4_readdir_arg *readdir)
 {
-	__be32 *start, *p;
+	void *start;
+	__be32 *p;
 
 	BUG_ON(readdir->count < 80);
 	if (cookie > 2) {
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index b916297..0935fb5 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3496,7 +3496,8 @@ static int decode_readdir(struct xdr_stream *xdr, struct rpc_rqst *req, struct n
 	struct kvec	*iov = rcvbuf->head;
 	size_t		hdrlen;
 	u32		recvd, pglen = rcvbuf->page_len;
-	__be32		*end, *entry, *p, *kaddr;
+	__be32		*end, *entry, *p;
+	void		*kaddr;
 	unsigned int	nr = 0;
 	int		status;
 
@@ -3620,9 +3621,9 @@ static int decode_readlink(struct xdr_stream *xdr, struct rpc_rqst *req)
 	 * and and null-terminate the text (the VFS expects
 	 * null-termination).
 	 */
-	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(rcvbuf->pages[0], KM_USER0);
 	kaddr[len+rcvbuf->page_base] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic((void *) kaddr, KM_USER0);
 	return 0;
 }
 
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index b38f944..fea63d5 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -137,7 +137,7 @@ static void ntfs_end_buffer_async_read(struct buffer_head *bh, int uptodate)
 		if (likely(page_uptodate && !PageError(page)))
 			SetPageUptodate(page);
 	} else {
-		u8 *kaddr;
+		void *kaddr;
 		unsigned int i, recs;
 		u32 rec_size;
 
@@ -400,7 +400,7 @@ static int ntfs_readpage(struct file *file, struct page *page)
 	loff_t i_size;
 	struct inode *vi;
 	ntfs_inode *ni, *base_ni;
-	u8 *addr;
+	void *addr;
 	ntfs_attr_search_ctx *ctx;
 	MFT_RECORD *mrec;
 	unsigned long flags;
@@ -741,7 +741,7 @@ lock_retry_remap:
 		}
 		/* It is a hole, need to instantiate it. */
 		if (lcn == LCN_HOLE) {
-			u8 *kaddr;
+			void *kaddr;
 			unsigned long *bpos, *bend;
 
 			/* Check if the buffer is zero. */
@@ -923,7 +923,7 @@ static int ntfs_write_mst_block(struct page *page,
 	struct inode *vi = page->mapping->host;
 	ntfs_inode *ni = NTFS_I(vi);
 	ntfs_volume *vol = ni->vol;
-	u8 *kaddr;
+	void *kaddr;
 	unsigned int rec_size = ni->itype.index.block_size;
 	ntfs_inode *locked_nis[PAGE_CACHE_SIZE / rec_size];
 	struct buffer_head *bh, *head, *tbh, *rec_start_bh;
@@ -1355,7 +1355,7 @@ static int ntfs_writepage(struct page *page, struct writeback_control *wbc)
 	loff_t i_size;
 	struct inode *vi = page->mapping->host;
 	ntfs_inode *base_ni = NULL, *ni = NTFS_I(vi);
-	char *addr;
+	void *addr;
 	ntfs_attr_search_ctx *ctx = NULL;
 	MFT_RECORD *m = NULL;
 	u32 attr_len;
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 50d3b0c..bf8d418 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1542,7 +1542,7 @@ int ntfs_attr_make_non_resident(ntfs_inode *ni, const u32 data_size)
 	ntfs_attr_search_ctx *ctx;
 	struct page *page;
 	runlist_element *rl;
-	u8 *kaddr;
+	void *kaddr;
 	unsigned long flags;
 	int mp_size, mp_ofs, name_ofs, arec_size, err, err2;
 	u32 attr_size;
@@ -2495,7 +2495,7 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 	ntfs_volume *vol = ni->vol;
 	struct address_space *mapping;
 	struct page *page;
-	u8 *kaddr;
+	void *kaddr;
 	pgoff_t idx, end;
 	unsigned start_ofs, end_ofs, size;
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 3140a44..d329423 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -712,7 +712,7 @@ map_buffer_cached:
 			set_buffer_new(bh);
 			if (!buffer_uptodate(bh) &&
 					(bh_pos < pos || bh_end > end)) {
-				u8 *kaddr;
+				void *kaddr;
 				unsigned pofs;
 					
 				kaddr = kmap_atomic(page, KM_USER0);
@@ -1289,7 +1289,7 @@ static inline size_t ntfs_copy_from_user(struct page **pages,
 		size_t bytes)
 {
 	struct page **last_page = pages + nr_pages;
-	char *addr;
+	void *addr;
 	size_t total = 0;
 	unsigned len;
 	int left;
@@ -1406,7 +1406,7 @@ static inline size_t ntfs_copy_from_user_iovec(struct page **pages,
 		size_t *iov_ofs, size_t bytes)
 {
 	struct page **last_page = pages + nr_pages;
-	char *addr;
+	void *addr;
 	size_t copied, len, total = 0;
 
 	do {
@@ -1644,7 +1644,8 @@ static int ntfs_commit_pages_after_write(struct page **pages,
 	ntfs_attr_search_ctx *ctx;
 	MFT_RECORD *m;
 	ATTR_RECORD *a;
-	char *kattr, *kaddr;
+	char *kattr;
+	void *kaddr;
 	unsigned long flags;
 	u32 attr_len;
 	int err;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 4a46743..4922704 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2501,7 +2501,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2511,7 +2511,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 		 */
 	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
 			nr_free -= (s64)hweight32(kaddr[i]);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic((void *) kaddr, KM_USER0);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $Bitmap, last index = 0x%lx.", index - 1);
@@ -2572,7 +2572,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
 		 * For each 4 bytes, subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2582,7 +2582,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 		 */
 	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
 			nr_free -= (s64)hweight32(kaddr[i]);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic((void *) kaddr, KM_USER0);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
diff --git a/fs/pipe.c b/fs/pipe.c
index 7aea8b8..3906aaa 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -474,7 +474,7 @@ redo1:
 			int newbuf = (pipe->curbuf + bufs) & (PIPE_BUFFERS-1);
 			struct pipe_buffer *buf = pipe->bufs + newbuf;
 			struct page *page = pipe->tmp_page;
-			char *src;
+			void *src;
 			int error, atomic = 1;
 
 			if (!page) {
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index abbc64d..23c919e 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1260,7 +1260,7 @@ int reiserfs_delete_item(struct reiserfs_transaction_handle *th, struct treepath
 
 	if (p_s_un_bh) {
 		int off;
-		char *data;
+		void *data;
 
 		/* We are in direct2indirect conversion, so move tail contents
 		   to the unformatted node */
diff --git a/fs/reiserfs/tail_conversion.c b/fs/reiserfs/tail_conversion.c
index f8121a1..8035957 100644
--- a/fs/reiserfs/tail_conversion.c
+++ b/fs/reiserfs/tail_conversion.c
@@ -129,7 +129,7 @@ int direct2indirect(struct reiserfs_transaction_handle *th, struct inode *inode,
 	if (up_to_date_bh) {
 		unsigned pgoff =
 		    (tail_offset + total_tail - 1) & (PAGE_CACHE_SIZE - 1);
-		char *kaddr = kmap_atomic(up_to_date_bh->b_page, KM_USER0);
+		void *kaddr = kmap_atomic(up_to_date_bh->b_page, KM_USER0);
 		memset(kaddr + pgoff, 0, n_blk_size - total_tail);
 		kunmap_atomic(kaddr, KM_USER0);
 	}
diff --git a/fs/splice.c b/fs/splice.c
index 1abab5c..f517039 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -585,8 +585,8 @@ static int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		/*
 		 * Careful, ->map() uses KM_USER0!
 		 */
-		char *src = buf->ops->map(pipe, buf, 1);
-		char *dst = kmap_atomic(page, KM_USER1);
+		void *src = buf->ops->map(pipe, buf, 1);
+		void *dst = kmap_atomic(page, KM_USER1);
 
 		memcpy(dst + offset, src + buf->offset, this_len);
 		flush_dcache_page(page);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index eb91f3b..dd47c4b 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -85,7 +85,7 @@ static int udf_adinicb_write_end(struct file *file,
 {
 	struct inode *inode = mapping->host;
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
-	char *kaddr;
+	void *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	kaddr = kmap_atomic(page, KM_USER0);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e89f04d..0e4b941 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -241,7 +241,7 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page, kmtype) +	\
 		bio_iovec_idx((bio), (idx))->bv_offset)
 
-#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr, kmtype)
+#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic((void *) addr, kmtype)
 
 /*
  * merge helpers etc
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7dcbc82..cee388a 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/typecheck.h>
 #include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
@@ -42,7 +43,7 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-#define kunmap(page) do { (void) (page); } while (0)
+#define __kunmap(page) do { (void) (page); } while (0)
 
 #include <asm/kmap_types.h>
 
@@ -53,7 +54,7 @@ static inline void *kmap_atomic(struct page *page, enum km_type idx)
 }
 #define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
 
-#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
+#define __kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
@@ -62,6 +63,28 @@ static inline void *kmap_atomic(struct page *page, enum km_type idx)
 
 #endif /* CONFIG_HIGHMEM */
 
+/*
+ * Unmap the temporarily mapped page. We do a typecheck to ensure that
+ * a page is passed in, not a virtual address.
+ */
+#define kunmap(p)				\
+	do {					\
+		typecheck(struct page *, p);	\
+		__kunmap(p);			\
+	} while (0)
+
+/*
+ * Unmap the temporarily mapped page that 'addr' is a virtual address of.
+ * Note that you must pass the address in, not the page itself. We do a
+ * void * check to enforce that, even though any pointer type will work
+ * in reality. This check should be a 'not struct page pointer' check...
+ */
+#define kunmap_atomic(addr, type)		\
+	do {					\
+		typecheck(void *, addr);	\
+		__kunmap_atomic(addr, type);	\
+	} while (0)
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
@@ -163,7 +186,7 @@ static inline void __deprecated memclear_highpage_flush(struct page *page,
 static inline void copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr, struct vm_area_struct *vma)
 {
-	char *vfrom, *vto;
+	void *vfrom, *vto;
 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
@@ -176,7 +199,7 @@ static inline void copy_user_highpage(struct page *to, struct page *from,
 
 static inline void copy_highpage(struct page *to, struct page *from)
 {
-	char *vfrom, *vto;
+	void *vfrom, *vto;
 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
diff --git a/mm/bounce.c b/mm/bounce.c
index 06722c4..d1e8eed 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -46,7 +46,7 @@ __initcall(init_emergency_pool);
 static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 {
 	unsigned long flags;
-	unsigned char *vto;
+	void *vto;
 
 	local_irq_save(flags);
 	vto = kmap_atomic(to->bv_page, KM_BOUNCE_READ);
diff --git a/mm/filemap.c b/mm/filemap.c
index f3e5f89..739e9b3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1206,7 +1206,7 @@ out:
 int file_read_actor(read_descriptor_t *desc, struct page *page,
 			unsigned long offset, unsigned long size)
 {
-	char *kaddr;
+	void *kaddr;
 	unsigned long left, count = desc->count;
 
 	if (size > count)
@@ -1829,7 +1829,7 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
-	char *kaddr;
+	void *kaddr;
 	size_t copied;
 
 	BUG_ON(!in_atomic());
diff --git a/mm/shmem.c b/mm/shmem.c
index 0ed0752..cd106ae 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -123,7 +123,7 @@ static struct page **shmem_dir_map(struct page *page)
 
 static inline void shmem_dir_unmap(struct page **dir)
 {
-	kunmap_atomic(dir, KM_USER0);
+	kunmap_atomic((void *) dir, KM_USER0);
 }
 
 static swp_entry_t *shmem_swp_map(struct page *page)
@@ -145,7 +145,7 @@ static inline void shmem_swp_balance_unmap(void)
 
 static inline void shmem_swp_unmap(swp_entry_t *entry)
 {
-	kunmap_atomic(entry, KM_USER1);
+	kunmap_atomic((void *) entry, KM_USER1);
 }
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
@@ -1898,7 +1898,7 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 	int len;
 	struct inode *inode;
 	struct page *page = NULL;
-	char *kaddr;
+	void *kaddr;
 	struct shmem_inode_info *info;
 
 	len = strlen(symname) + 1;
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index ae8e69b..7dc9547 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -58,7 +58,7 @@ gss_krb5_remove_padding(struct xdr_buf *buf, int blocksize)
 					& (PAGE_CACHE_SIZE - 1);
 		ptr = kmap_atomic(buf->pages[last], KM_USER0);
 		pad = *(ptr + offset);
-		kunmap_atomic(ptr, KM_USER0);
+		kunmap_atomic((void *) ptr, KM_USER0);
 		goto out;
 	} else
 		len -= buf->page_len;
diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
index a661a3a..b87b50e 100644
--- a/net/sunrpc/socklib.c
+++ b/net/sunrpc/socklib.c
@@ -98,7 +98,7 @@ ssize_t xdr_partial_copy_from_skb(struct xdr_buf *xdr, unsigned int base, struct
 		base &= ~PAGE_CACHE_MASK;
 	}
 	do {
-		char *kaddr;
+		void *kaddr;
 
 		/* ACL likes to be lazy in allocating pages - ACLs
 		 * are small by default but can get huge. */
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 79a55d5..094d085 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -181,7 +181,7 @@ _shift_data_right_pages(struct page **pages, size_t pgto_base,
 		size_t pgfrom_base, size_t len)
 {
 	struct page **pgfrom, **pgto;
-	char *vfrom, *vto;
+	void *vfrom, *vto;
 	size_t copy;
 
 	BUG_ON(pgto_base <= pgfrom_base);
@@ -238,7 +238,7 @@ static void
 _copy_to_pages(struct page **pages, size_t pgbase, const char *p, size_t len)
 {
 	struct page **pgto;
-	char *vto;
+	void *vto;
 	size_t copy;
 
 	pgto = pages + (pgbase >> PAGE_CACHE_SHIFT);
@@ -282,7 +282,7 @@ static void
 _copy_from_pages(char *p, struct page **pages, size_t pgbase, size_t len)
 {
 	struct page **pgfrom;
-	char *vfrom;
+	void *vfrom;
 	size_t copy;
 
 	pgfrom = pages + (pgbase >> PAGE_CACHE_SHIFT);
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 14106d2..84bbdc5 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -292,7 +292,7 @@ rpcrdma_inline_pullup(struct rpc_rqst *rqst, int pad)
 {
 	int i, npages, curlen;
 	int copy_len;
-	unsigned char *srcp, *destp;
+	void *srcp, *destp;
 	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(rqst->rq_xprt);
 
 	destp = rqst->rq_svec[0].iov_base;
@@ -601,7 +601,7 @@ static void
 rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 {
 	int i, npages, curlen, olen;
-	char *destp;
+	void *destp;
 
 	curlen = rqst->rq_rcv_buf.head[0].iov_len;
 	if (curlen > copy_len) {	/* write chunk header fixup */

-- 
Jens Axboe

