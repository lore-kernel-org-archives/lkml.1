Return-Path: <linux-kernel-owner+w=401wt.eu-S2992780AbXBITpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992780AbXBITpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992785AbXBITpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:45:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41239 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992780AbXBITpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:45:43 -0500
Date: Fri, 9 Feb 2007 11:45:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] ext2: use perform_write aop
Message-Id: <20070209114539.8bd15ee0.akpm@linux-foundation.org>
In-Reply-To: <20070209111455.67a69783.akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070208105508.26443.7806.sendpatchset@linux.site>
	<20070209111455.67a69783.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 11:14:55 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu,  8 Feb 2007 14:07:46 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> 
> > +void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
> > +{
> > +	unsigned int block_start, block_end;
> > +	struct buffer_head *head, *bh;
> > +
> > +	BUG_ON(!PageLocked(page));
> > +	if (!page_has_buffers(page))
> > +		return;
> > +
> > +	bh = head = page_buffers(page);
> > +	block_start = 0;
> > +	do {
> > +		block_end = block_start + bh->b_size;
> > +
> > +		if (buffer_new(bh)) {
> > +			if (block_end > from && block_start < to) {
> > +				if (!PageUptodate(page)) {
> > +					unsigned start, end;
> > +					void *kaddr;
> > +
> > +					start = max(from, block_start);
> > +					end = min(to, block_end);
> > +
> > +					kaddr = kmap_atomic(page, KM_USER0);
> > +					memset(kaddr+start, 0, block_end-end);
> > +					flush_dcache_page(page);
> > +					kunmap_atomic(kaddr, KM_USER0);
> > +					set_buffer_uptodate(bh);
> > +				}
> 
> I don't see how this differs from the previous attempts to solve the
> deadlock via atomic copt_from_user().  Here we temporarily zero out the
> pagecache page then block_perform_write() unlocks the page.  So another
> thread can come in, read the page and see the temporary zeroes?  
> 
> If so, that might be preventable by leaving the buffer nonuptodate.

oh, OK, it was buffer_new(), so zeroes are the right thing for a reader to
see.

But if it wasn't buffer_new() then the appropriate thing for the reader to
see is what's on the disk.  But __block_prepare_write() won't read a buffer
which is fully-inside the write area from disk.

And that's seemingly OK, because if a reader gets in there after the short
copy, that reader will see the non-uptodate buffer and will populate it
from disk.

But doing that will overwrite the data which the write() caller managed to
copy into the page before it took a fault.  And that's not OK because
block_perform_write() does iovec_iterator_advance(i, copied) in this case
and hence will not rerun the copy after acquiring the page lock?
