Return-Path: <linux-kernel-owner+w=401wt.eu-S1422984AbXDXTtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422984AbXDXTtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423066AbXDXTtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:49:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422984AbXDXTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:49:51 -0400
Date: Tue, 24 Apr 2007 12:49:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424124922.d406aac1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 12:34:53 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > Not as metadata, no.  But someone (let's hope only root, though I may
> > be wrong on that) can map any part of the block device into userspace.
> 
> Concurrent access to a block device by a filesystem and the user? That 
> cannot go over well. If one just reads then I would expect that a copy
> of the metadata becomes available to the user. Also you cannot migrate 
> pages that have multiple references (which is the case here if the 
> filesystem uses the page cache for the metadata) unless the user has 
> special priviledges and uses special command options.
> 
> A page that has references that cannot be accounted for by page migration 
> is never migrated. I would assume that the filesystem at minimum takes a 
> refcount on the page used for metadata.
> 
> If the filesystem would not take a refcount then it would already be in 
> trouble because the page may then be evicted at any time.

No, think of the following scenario:

- file I/O causes a read of an ext2 file's bitmap.  The bitmap is
  brought into /dev/hda1's pagecache using !__GFP_HIGHMEM

- references are released against that page and it's now just clean
  reclaimable pagecache

- someone (say, an online filesystem checker or something) mmaps
  /dev/hda1 and reads that page.

- migration comes alnog and migrates that page into highmem

- file I/O causes a read of that bitmap again.  We find it in
  /dev/hda's pagecache.

  Here's set_bh_page().

	void set_bh_page(struct buffer_head *bh,
			struct page *page, unsigned long offset)
	{
		bh->b_page = page;
		BUG_ON(offset >= PAGE_SIZE);
		if (PageHighMem(page))
			/*
			 * This catches illegal uses and preserves the offset:
			 */
			bh->b_data = (char *)(0 + offset);
		else
			bh->b_data = page_address(page) + offset;
	}

- ext2 now tries to access the bits in the bitmap via page->bh->b_data

- game over
