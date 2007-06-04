Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbXFDAq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbXFDAq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 20:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXFDAqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 20:46:49 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36001 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750877AbXFDAqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 20:46:49 -0400
Message-ID: <380918004.03707@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 4 Jun 2007 08:46:47 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070604004647.GA8076@mail.ustc.edu.cn>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
	cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de,
	zanussi@us.ibm.com, hch@infradead.org
References: <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <20070602150104.GH32105@kernel.dk> <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org> <20070603130507.GA11170@mail.ustc.edu.cn> <20070603142931.GA5916@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603142931.GA5916@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This is another try, still not in a comfortable state though.
//Busy waiting is possible for interleaved reads.

Fengguang
---

In non-block splicing read, return EAGAIN once for possible I/O waits.

It avoids busy waiting by checking (ra.prev_index != index) in
__generic_file_splice_read().  If there are other readers on the same
fd, busy waiting is still possible.

If keep calling generic_file_splice_read() in non-blocking mode, it
will return partial data before the first wait point; then return
EAGAIN at second call; at last it will block on the I/O page.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/splice.c               |   41 +++++++++++++++++++++---------------
 include/linux/pipe_fs_i.h |    2 +
 2 files changed, 27 insertions(+), 16 deletions(-)

--- linux-2.6.22-rc3-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc3-mm1/fs/splice.c
@@ -264,7 +264,7 @@ static ssize_t splice_to_pipe(struct pip
 static int
 __generic_file_splice_read(struct file *in, loff_t *ppos,
 			   struct pipe_inode_info *pipe, size_t len,
-			   unsigned int flags)
+			   unsigned int *flags)
 {
 	struct address_space *mapping = in->f_mapping;
 	unsigned int loff, nr_pages;
@@ -278,7 +278,7 @@ __generic_file_splice_read(struct file *
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
-		.flags = flags,
+		.flags = *flags,
 		.ops = &page_cache_pipe_buf_ops,
 	};
 
@@ -299,12 +299,16 @@ __generic_file_splice_read(struct file *
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
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
@@ -312,9 +316,6 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					NULL, index, nr_pages - spd.nr_pages);
-
 			/*
 			 * page didn't exist, allocate one.
 			 */
@@ -326,8 +327,6 @@ __generic_file_splice_read(struct file *
 					      GFP_KERNEL);
 			if (unlikely(error)) {
 				page_cache_release(page);
-				if (error == -EEXIST)
-					continue;
 				break;
 			}
 			/*
@@ -369,12 +368,19 @@ __generic_file_splice_read(struct file *
 		 */
 		if (!PageUptodate(page)) {
 			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
+			 * On retrying sequential reads in non-blocking mode:
+			 * 1. (prev_index <= index - 2)  => return partial data
+			 * 2. (prev_index == index - 1)  => return EAGAIN
+			 * 3. (prev_index == index)      => wait on I/O
+			 * This works nicely for page aligned reads.
 			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page))
-					break;
+			if ((*flags & SPLICE_F_NONBLOCK) &&
+				TestSetPageLocked(page) &&
+				in->f_ra.prev_index != index) {
+				if (in->f_ra.prev_index != index - 1)
+					index--;
+				*flags |= SPLICE_INTERNAL_WILLBLOCK;
+				break;
 			} else
 				lock_page(page);
 
@@ -452,7 +458,6 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_index = index;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
@@ -480,7 +485,7 @@ ssize_t generic_file_splice_read(struct 
 	spliced = 0;
 
 	while (len) {
-		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
+		ret = __generic_file_splice_read(in, ppos, pipe, len, &flags);
 
 		if (ret < 0)
 			break;
@@ -496,8 +501,12 @@ ssize_t generic_file_splice_read(struct 
 		*ppos += ret;
 		len -= ret;
 		spliced += ret;
+
+		if (flags & SPLICE_INTERNAL_WILLBLOCK)
+			break;
 	}
 
+	in->f_ra.prev_index = (*ppos - 1) >> PAGE_CACHE_SHIFT;
 	if (spliced)
 		return spliced;
 
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

