Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXFCNFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXFCNFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 09:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXFCNFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 09:05:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36734 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759802AbXFCNFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 09:05:14 -0400
Message-ID: <380875906.01702@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 3 Jun 2007 21:05:08 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070603130507.GA11170@mail.ustc.edu.cn>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
	cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de,
	zanussi@us.ibm.com, hch@infradead.org
References: <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <20070602150104.GH32105@kernel.dk> <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 08:40:04AM -0700, Linus Torvalds wrote:
> On Sat, 2 Jun 2007, Jens Axboe wrote:
> Your suggested:
> 
> >       if ((flags & SPLICE_F_NONBLOCK) && spd.nr_pages) {
> >               if (TestSetPageLocked(page))
> >                       break;
> >       } else
> >               lock_page(page);
> > 
> > should do that - always block for the first page and potentially return
> > a partial results for the remaining pages that read-ahead kicked into
> > gear.
> 
> would work, but I suspect that for a server, returning EAGAIN once is 
> actually the best option - if it has a select() loop, and something else 
> is running, the "return EAGAIN once" actually makes tons of sense (it 
> would basically boil down to the kernel effectively saying "ok, try 
> anything else you might have pending in your queues first, if you get back 
> to me, I'll block then").

May be we can settle with "return EAGAIN once" for *all* possible
waits, including I/O submitted by others:

          if ((flags & SPLICE_F_NONBLOCK) &&
                  TestSetPageLocked(page) &&
                  in->f_ra.prev_index != index)
                  break;
          else
                  lock_page(page);

However, the upper layer generic_file_splice_read() may keep
on calling __generic_file_splice_read(), so we need more code to
stop it with flag SPLICE_INTERNAL_WILLBLOCK:

---
(not tested yet; still not sure if it's the best solution.)

In non-block splicing, return EAGAIN once for all possible I/O waits.

It works by checking (ra.prev_index != index) in
__generic_file_splice_read().  Another reader on the same fd will at
worst cause a few more splice syscalls.

If keep calling generic_file_splice_read() in non-block mode, it will
return partial data before the first hole; then return EAGAIN at
second call; at last it will block on the I/O page.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/splice.c               |   38 ++++++++++++++++++++++--------------
 include/linux/pipe_fs_i.h |    2 +
 2 files changed, 26 insertions(+), 14 deletions(-)

--- linux-2.6.22-rc3-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc3-mm1/fs/splice.c
@@ -264,10 +264,11 @@ static ssize_t splice_to_pipe(struct pip
 static int
 __generic_file_splice_read(struct file *in, loff_t *ppos,
 			   struct pipe_inode_info *pipe, size_t len,
-			   unsigned int flags)
+			   unsigned int *flags)
 {
 	struct address_space *mapping = in->f_mapping;
 	unsigned int loff, nr_pages;
+	unsigned int first_hole;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct page *page;
@@ -278,7 +279,7 @@ __generic_file_splice_read(struct file *
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
-		.flags = flags,
+		.flags = *flags,
 		.ops = &page_cache_pipe_buf_ops,
 	};
 
@@ -299,12 +300,17 @@ __generic_file_splice_read(struct file *
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	first_hole = spd.nr_pages;
+	index += spd.nr_pages;
 
 	/*
 	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * allocate the rest.
+	 * readahead/allocate the rest.
 	 */
-	index += spd.nr_pages;
+	if (spd.nr_pages < nr_pages)
+		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+				NULL, index, nr_pages - spd.nr_pages);
+
 	while (spd.nr_pages < nr_pages) {
 		/*
 		 * Page could be there, find_get_pages_contig() breaks on
@@ -312,9 +318,6 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					NULL, index, nr_pages - spd.nr_pages);
-
 			/*
 			 * page didn't exist, allocate one.
 			 */
@@ -369,13 +372,13 @@ __generic_file_splice_read(struct file *
 		 */
 		if (!PageUptodate(page)) {
 			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
+			 * In non-block mode, only block at the second try.
 			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page))
-					break;
-			} else
+			if ((*flags & SPLICE_F_NONBLOCK) &&
+				TestSetPageLocked(page) &&
+				in->f_ra.prev_index != index)
+				break;
+			else
 				lock_page(page);
 
 			/*
@@ -454,6 +457,10 @@ fill_it:
 		page_cache_release(pages[page_nr++]);
 	in->f_ra.prev_index = index;
 
+	if ((*flags & SPLICE_F_NONBLOCK) && (spd.nr_pages > first_hole)) {
+		*flags |= SPLICE_INTERNAL_WILLBLOCK;
+		spd.nr_pages = first_hole;
+	}
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
 
@@ -480,7 +487,7 @@ ssize_t generic_file_splice_read(struct 
 	spliced = 0;
 
 	while (len) {
-		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
+		ret = __generic_file_splice_read(in, ppos, pipe, len, &flags);
 
 		if (ret < 0)
 			break;
@@ -496,6 +503,9 @@ ssize_t generic_file_splice_read(struct 
 		*ppos += ret;
 		len -= ret;
 		spliced += ret;
+
+		if (flags & SPLICE_INTERNAL_WILLBLOCK)
+			break;
 	}
 
 	if (spliced)
--- linux-2.6.22-rc3-mm1.orig/include/linux/pipe_fs_i.h
+++ linux-2.6.22-rc3-mm1/include/linux/pipe_fs_i.h
@@ -82,6 +82,8 @@ int generic_pipe_buf_steal(struct pipe_i
 #define SPLICE_F_MORE	(0x04)	/* expect more data */
 #define SPLICE_F_GIFT	(0x08)	/* pages passed in are a gift */
 
+#define SPLICE_INTERNAL_WILLBLOCK  (0x100) /* read on next page will block */
+
 /*
  * Passed to the actors
  */

