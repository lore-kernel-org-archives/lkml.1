Return-Path: <linux-kernel-owner+w=401wt.eu-S967595AbXFHDJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967595AbXFHDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966742AbXFHDJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:09:47 -0400
Received: from ns.suse.de ([195.135.220.2]:37113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966901AbXFHDJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:09:46 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 8 Jun 2007 12:48:48 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18024.50064.799102.305585@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
In-Reply-To: message from Andrew Morton on Thursday June 7
References: <20070607114043.26967.patches@notabene>
	<1070607014653.27304@suse.de>
	<20070607181820.6b22bb29.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 7, akpm@linux-foundation.org wrote:
> 
> Is this really worth fixing?

Hard to say.
One could argue that a read should never return data that was never in
the file.  One could also argue that you should always use locking...
But people often look for lock-less solutions.

> 
> The code still has races there - for example, another process can come
> after we've got the page, truncate it off the file then write new data.  So
> this thread ends up copying out-of-date page contents out to userspace.

I don't think "out of date" is a problem.  As long as the data
returned by the "read" matches what was in the file at some moment
between when the syscall started and when the syscall completed, it is
correct.

> 
> The application is being silly, and the silly application gets wrong data:
> either out-of-date or zeroed.

"was in the file when syscall commenced" and "was never in the file"
are two very different things.
"silly" ??  Maybe it is "silly" to return data that was never in the
file.


> 
> afacit the patch shrinks the timing windows significantly, but at a cost:
> moving a bunch of 64-bit arithmetic and seqlock operations into the inner
> loop.

For common cases where truncation is to a page boundary, the window
for seeing data that was never in the file is shrunk to zero.  Partial
truncates can still cause a problem as the changelog comment suggests,
and require a different solution.

Most of the 64-bit arithmetic is already in the main loop, though not
quite all.  In most cases the seqlock will not loop - how expensive is
that?
The following patch will remove the extra seqlock except when we
actually need it and remove the extra arithmetic - but I haven't
tested it or reviewed it properly.  I can do that if you think it is
the right direction.

> 
> We could plug all this in a more predictable fashion by locking the page,
> but then we have another instance of the
> read-a-page-into-a-mmapped-copy-of-itself deadlock (I think - maybe it
> can't happen because of page uptodateness checks).

But do we really want exclusion between multiple readers of the same
page?  Yes, I expect locking the page would remove all the races, but
I suspect it is more expensive that the current alternative.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./mm/filemap.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff .prev/mm/filemap.c ./mm/filemap.c
--- .prev/mm/filemap.c	2007-06-07 16:23:37.000000000 +1000
+++ ./mm/filemap.c	2007-06-08 12:43:36.000000000 +1000
@@ -876,6 +876,7 @@ void do_generic_mapping_read(struct addr
 	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
+	loff_t isize;
 	int error;
 	struct file_ra_state ra = *_ra;
 
@@ -886,13 +887,22 @@ void do_generic_mapping_read(struct addr
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
 		unsigned long end_index;
-		loff_t isize;
 		unsigned long nr, ret;
 
 		cond_resched();
+
+		if (unlikely(index > end_index)) {
+			page_cache_release(page);
+			goto out;
+		}
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
@@ -918,13 +928,25 @@ page_ok:
 		 * the correct value for "nr", which means the zero-filled
 		 * part of the page is not copied back to userspace (unless
 		 * another truncate extends the file - this is desired though).
+		 *
+		 * NOTE: This access of inode->i_size is not protected
+		 *  and if there is a concurrent update on a 32bit machine,
+		 *  it could return the wrong value.  This could only be a problem
+		 *  if i_size has actually changed to a smaller value before the
+		 *  page became uptodate, and at this point it still has a smaller
+		 *  value, but due to a race while reading, it appears unchanged.
+		 *  The chances of this happening are so small and the consequence
+		 *  sufficiently minor, that the cost of the seqlock seems
+		 *  not to be justified.
 		 */
 
-		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (unlikely(!isize || index > end_index)) {
-			page_cache_release(page);
-			goto out;
+		if (unlikely(isize != inode->i_size)) {
+			isize = i_size_read(inode);
+			end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+			if (unlikely(!isize || index > end_index)) {
+				page_cache_release(page);
+				goto out;
+			}
 		}
 
 		/* nr is the maximum number of bytes to copy from this page */
