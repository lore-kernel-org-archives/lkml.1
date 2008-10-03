Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYJCCyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYJCCyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 22:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYJCCyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 22:54:39 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23153 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753005AbYJCCyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 22:54:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=znTcUqxCKUIBdftbjvdu6pfz00j1IGeAl21X270NI33QFei2HyauNKLqhJj2xvPFyXaTTzSqA2XSHa0xM25eCb7FX1KbluTYCY6YKtnaVneSpn1QklfulKqyTs7Q2/nWHhrfLnSF4RHJ6cqigJooKe82ETvC0gKYoy+ygEdkP64=  ;
X-YMail-OSG: AXITEogVM1l3SFE24Zhvx2a27RIcfw_Ct4ezY1o6jcmhYlFotIGlKUz6HwoXu1BlG7Rvv5Z06Ejgdxb5swWlFLZOJM.JNY4s_vs01f4csauAuu6ZIhL_0v8LuIiVLMuZ3XMaj_4q63DbiX76if38vE_hAbzELsZ7zAnGFF3LHFBcP6oCF3A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 12:54:28 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au>
In-Reply-To: <200810031232.23836.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_llY5I7yhSie1L7M"
Message-Id: <200810031254.29121.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_llY5I7yhSie1L7M
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 03 October 2008 12:32, Nick Piggin wrote:
> On Wednesday 24 September 2008 08:49, Andrew Morton wrote:
> > On Tue, 23 Sep 2008 18:34:20 -0400 (EDT)
> >
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > > On Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
> > > >
> > > > Mikulas Patocka <mpatocka@xxxxxxxxxx> wrote:
> > > > > The bug happens when one process is doing sequential buffered
> > > > > writes to a block device (or file) and another process is
> > > > > attempting to execute sync(), fsync() or direct-IO on that device
> > > > > (or file). This syncing process will wait indefinitelly, until the
> > > > > first writing process finishes.
> > > > >
> > > > > For example, run these two commands:
> > > > > dd if=/dev/zero of=/dev/sda1 bs=65536 &
> > > > > dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> > > > >
> > > > > The bug is caused by sequential walking of address space in
> > > > > write_cache_pages and wait_on_page_writeback_range: if some other
> > > > > process is constantly making dirty and writeback pages while these
> > > > > functions run, the functions will wait on every new page, resulting
> > > > > in indefinite wait.
>
> I think the problem has been misidentified, or else I have misread the
> code. See below. I hope I'm right, because I think the patches are pretty
> heavy on complexity in these already complex paths...
>
> It would help if you explicitly identify the exact livelock. Ie. give a
> sequence of behaviour that leads to our progress rate falling to zero.
>
> > > > Shouldn't happen. All the data-syncing functions should have an upper
> > > > bound on the number of pages which they attempt to write. In the
> > > > example above, we end up in here:
> > > >
> > > > int __filemap_fdatawrite_range(struct address_space *mapping, loff_t
> > > > start,
> > > > loff_t end, int sync_mode)
> > > > {
> > > > int ret;
> > > > struct writeback_control wbc = {
> > > > .sync_mode = sync_mode,
> > > > .nr_to_write = mapping->nrpages * 2, <<--
> > > > .range_start = start,
> > > > .range_end = end,
> > > > };
> > > >
> > > > so generic_file_direct_write()'s filemap_write_and_wait() will
> > > > attempt to write at most 2* the number of pages which are in cache
> > > > for that inode.
> > >
> > > See write_cache_pages:
> > >
> > > if (wbc->sync_mode != WB_SYNC_NONE)
> > >         wait_on_page_writeback(page);	(1)
> > > if (PageWriteback(page) ||
> > >     !clear_page_dirty_for_io(page)) {
> > >         unlock_page(page);		(2)
> > >         continue;
> > > }
> > > ret = (*writepage)(page, wbc, data);
> > > if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
> > >         unlock_page(page);
> > >         ret = 0;
> > > }
> > > if (ret || (--(wbc->nr_to_write) <= 0))
> > >         done = 1;
> > >
> > > --- so if it goes by points (1) and (2), the counter is not
> > > decremented, yet the function waits for the page. If there is constant
> > > stream of writeback pages being generated, it waits on each on them ---
> > > that is, forever.
>
> *What* is, forever? Data integrity syncs should have pages operated on
> in-order, until we get to the end of the range. Circular writeback could
> go through again, possibly, but no more than once.

OK, I have been able to reproduce it somewhat. It is not a livelock,
but what is happening is that direct IO read basically does an fsync
on the file before performing the IO. The fsync gets stuck behind the
dd that is dirtying the pages, and ends up following behind it and
doing all its IO for it.

The following patch avoids the issue for direct IO, by using the range
syncs rather than trying to sync the whole file.

The underlying problem I guess is unchanged. Is it really a problem,
though? The way I'd love to solve it is actually by adding another bit
or two to the pagecache radix tree,  that can be used to transiently tag
the tree for future operations. That way we could record the dirty and
writeback pages up front, and then only bother with operating on them.

That's *if* it really is a problem. I don't have much pity for someone
doing buffered IO and direct IO to the same pages of the same file :)

--Boundary-00=_llY5I7yhSie1L7M
Content-Type: text/x-diff;
  charset="utf-8";
  name="mm-starve-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-starve-fix.patch"

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-10-03 11:21:31.000000000 +1000
+++ linux-2.6/mm/filemap.c	2008-10-03 12:00:17.000000000 +1000
@@ -1304,11 +1304,8 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = filemap_write_and_wait(mapping);
-			if (!retval) {
-				retval = mapping->a_ops->direct_IO(READ, iocb,
+			retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
-			}
 			if (retval > 0)
 				*ppos = pos + retval;
 			if (retval) {
@@ -2110,18 +2107,10 @@ generic_file_direct_write(struct kiocb *
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
 
-	/*
-	 * Unmap all mmappings of the file up-front.
-	 *
-	 * This will cause any pte dirty bits to be propagated into the
-	 * pageframes for the subsequent filemap_write_and_wait().
-	 */
 	write_len = iov_length(iov, *nr_segs);
 	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
-	if (mapping_mapped(mapping))
-		unmap_mapping_range(mapping, pos, write_len, 0);
 
-	written = filemap_write_and_wait(mapping);
+	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
 	if (written)
 		goto out;
 
@@ -2507,7 +2496,8 @@ generic_file_buffered_write(struct kiocb
 	 * the file data here, to try to honour O_DIRECT expectations.
 	 */
 	if (unlikely(file->f_flags & O_DIRECT) && written)
-		status = filemap_write_and_wait(mapping);
+		status = filemap_write_and_wait_range(mapping,
+					pos, pos + written - 1);
 
 	return written ? written : status;
 }

--Boundary-00=_llY5I7yhSie1L7M--
