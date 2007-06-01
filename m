Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXFAICs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXFAICs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXFAICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:02:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20355 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXFAICf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:02:35 -0400
Date: Fri, 1 Jun 2007 10:01:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] sendfile removal (nfsd update)
Message-ID: <20070601080125.GM32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531105543.GA25676@infradead.org> <20070531110550.GR32105@kernel.dk> <18014.48878.442628.260297@notabene.brown> <20070531122723.GT32105@kernel.dk> <18015.34830.401191.916084@notabene.brown> <20070601054424.GJ32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601054424.GJ32105@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, Jens Axboe wrote:
> On Fri, Jun 01 2007, Neil Brown wrote:
> > 
> > Ok, here is a patch that makes nfsd use splice instead of sendfile.
> > It appears to both compile and work.
> > 
> > Some observations:
> >   - __splice_from_pipe wants a "struct file*" and I wanted to pass a
> >     "struct svcrqst *".  Maybe it should take a void * ?
> >   - It also wants a *ppos which I had no use for.. It that really
> >     need?  Cannot &file->f_pos be used?
> 
> See:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=c73a9509ef7877d31e0c97c684ee8b7ed13ecbbe;hp=07f0e716250d4a3a550b2f39bd0a7e4e6566b3c2
> 
> I'll rebase the conversion on top of this one, loop will need the same
> change.
> 
> >   - I copied do_splice_to from splice.c as it wasn't exported, and
> >     then found I couldn't compile because rw_verify_area wasn't
> >     exported. As nfsd doesn't need that (we never export
> >     mandatory-locking files) I just remove it and some other cruft
> >     that I didn't need.... Not sure if that was the best approach.
> >   - I needed to export alloc_pipe_info.  Maybe there should be a 
> >     get_current_pipe instead which does the alloc if needed.
> >   - I would much rather have something like free_pipe_info exported
> >     than open code it in do_splice_read (which is based heavily on
> >     do_splice_direct).
> 
> I need the same thing for loop. I think I'll add do_splice_foo() to
> fs/splice.c in a way that loop can use instead of do_splice_direct(),
> then nfsd should be able to do the same.

I rebased and added a splice_direct_to_actor() helper that nfsd can then
use. This makes the nfsd diff look like the below, which I think you'll
agree is a lot more pleasant. You can view the tree here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=splice

The vmsplice patch probably needs to be split in two, for now it is the
one introducing the framework that nfsd (and next, loop) can use.

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7e6aa24..96f76e2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -23,7 +23,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/major.h>
-#include <linux/ext2_fs.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -801,26 +801,32 @@ found:
 }
 
 /*
- * Grab and keep cached pages assosiated with a file in the svc_rqst
- * so that they can be passed to the netowork sendmsg/sendpage routines
- * directrly. They will be released after the sending has completed.
+ * Grab and keep cached pages associated with a file in the svc_rqst
+ * so that they can be passed to the network sendmsg/sendpage routines
+ * directly. They will be released after the sending has completed.
  */
 static int
-nfsd_read_actor(read_descriptor_t *desc, struct page *page, unsigned long offset , unsigned long size)
+nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		  struct splice_desc *sd)
 {
-	unsigned long count = desc->count;
-	struct svc_rqst *rqstp = desc->arg.data;
+	struct svc_rqst *rqstp = sd->data;
 	struct page **pp = rqstp->rq_respages + rqstp->rq_resused;
+	struct page *page = buf->page;
+	size_t size;
+	int ret;
+
+	ret = buf->ops->pin(pipe, buf);
+	if (unlikely(ret))
+		return ret;
 
-	if (size > count)
-		size = count;
+	size = sd->len;
 
 	if (rqstp->rq_res.page_len == 0) {
 		get_page(page);
 		put_page(*pp);
 		*pp = page;
 		rqstp->rq_resused++;
-		rqstp->rq_res.page_base = offset;
+		rqstp->rq_res.page_base = buf->offset;
 		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
@@ -832,11 +838,15 @@ nfsd_read_actor(read_descriptor_t *desc, struct page *page, unsigned long offset
 	} else
 		rqstp->rq_res.page_len += size;
 
-	desc->count = count - size;
-	desc->written += size;
 	return size;
 }
 
+static int nfsd_direct_splice_actor(struct pipe_inode_info *pipe,
+				    struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, nfsd_splice_actor);
+}
+
 static __be32
 nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
               loff_t offset, struct kvec *vec, int vlen, unsigned long *count)
@@ -861,10 +871,15 @@ nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	if (ra && ra->p_set)
 		file->f_ra = ra->p_ra;
 
-	if (file->f_op->sendfile && rqstp->rq_sendfile_ok) {
-		rqstp->rq_resused = 1;
-		host_err = file->f_op->sendfile(file, &offset, *count,
-						 nfsd_read_actor, rqstp);
+	if (file->f_op->splice_read && rqstp->rq_splice_ok) {
+		struct splice_desc sd = {
+			.len		= 0,
+			.total_len	= *count,
+			.pos		= offset,
+		};
+
+		sd.data = rqstp;
+		host_err = splice_direct_to_actor(file, &sd, nfsd_direct_splice_actor);
 	} else {
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);


-- 
Jens Axboe

