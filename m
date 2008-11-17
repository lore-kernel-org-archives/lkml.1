Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYKQJgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYKQJgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYKQJgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:36:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51747 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYKQJgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:36:12 -0500
Date: Mon, 17 Nov 2008 10:34:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117093425.GG26778@kernel.dk>
References: <20081115112751.1d38c072@infradead.org> <Pine.LNX.4.64.0811152003360.1618@blonde.site> <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com> <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk> <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117085807.GF26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Jens Axboe wrote:
> On Mon, Nov 17 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Mon, Nov 17 2008, Ingo Molnar wrote:
> > > > 
> > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > +#define kunmap(p)			\
> > > > > +	do {				\
> > > > > +		struct page *__p;	\
> > > > > +		(void) (&__p == &(p));	\
> > > > > +		__kunmap(p);		\
> > > > > +	} while (0)
> > > > > +
> > > > > +#define kunmap_atomic(a, t)		\
> > > > > +	do {				\
> > > > > +		void *__p;		\
> > > > > +		(void) (&__p == &(a));	\
> > > > > +		__kunmap_atomic(a, t);	\
> > > > > +	} while (0)
> > > > 
> > > > Agreed - but please use the typecheck() primitive. (linux/typecheck.h)
> > > 
> > > Neat, didn't know about that, thanks.
> > 
> > and ack on your patch obviously. Feel free to push it via the block 
> > tree straight away, it doesnt collide with anything pending in the x86 
> > tree.
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> The kunmap() bit is easy to do as I mentioned, but the kunmap_atomic()
> gets a bit more ugly. Lots of users can just be switched to void *
> types, but some get ugly like:
> 
> static struct page **shmem_dir_map(struct page *page)
>         return (struct page **)kmap_atomic(page, KM_USER0);
>  }
>  
> -static inline void shmem_dir_unmap(struct page **dir)
> +static inline void shmem_dir_unmap(void *dir)
>  {
>         kunmap_atomic(dir, KM_USER0);
>  }
> 
> and others again like fs/exec.c:remove_arg_zero() would really like to
> use a char * type since it dereferences it.
> 
> I think the kunmap_atomic() change it the most needed part of the patch,
> but I don't think it can come for free (eg, we have to add variable to
> the above function).

OK, (void *) cast works fine when I fixed it. Here's a normal build diff
to show approximately how bad it is. I expected it to be worse, so it
looks quite doable I think.

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

-- 
Jens Axboe

