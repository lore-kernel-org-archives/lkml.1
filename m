Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYDQGni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYDQGni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYDQGn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:43:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYDQGn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:43:27 -0400
Date: Wed, 16 Apr 2008 23:43:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: clameter@sgi.com, linux-mm@kvack.org, npiggin@suse.de,
       y-goto@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Warning on memory offline (possible in migration ?)
Message-Id: <20080416234303.c6003c08.akpm@linux-foundation.org>
In-Reply-To: <20080417153818.d40ddfd8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080414145806.c921c927.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804141044030.6296@schroedinger.engr.sgi.com>
	<20080416200036.2ea9b5c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20080416113642.8ffd5684.akpm@linux-foundation.org>
	<20080417091930.cbac6286.kamezawa.hiroyu@jp.fujitsu.com>
	<20080417153818.d40ddfd8.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 15:38:18 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 17 Apr 2008 09:19:30 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > I'd expect that you could reproduce this by disabling readahead with
> > > fadvise(POSIX_FADV_RANDOM) and then issuing the above four reads.
> > > 
> > Thank you for advice. I'll try.
> > 
> (Added lkml to CC:)
> 
> What happens:
>   When I do memory offline on ia64/NUMA box, __set_page_dirty_buffers() printed
>   out WARNINGS because the page under migration is not up-to-date.

The warning is in __set_page_dirty().

> Following is my investigation.
> 
> Assume 16k pages / 4 buffers of 4096bytes block (ext3).
> 4 buffers on a page of ext3.
> 
> At page offlining, we can find a page which is not up-to-date.
> But all buffers of the page seems up-to-date.
> 
> buffers on a page by prink().
>     buffer 0, block_nr= some vaule, state= BH_uptodate | BH_Req| BH_Mapped
>     buffer 1, block_nr= -1,         state= BH_uptodate
>     buffer 2, block_nr= -1,         state= BH_uptodate
>     buffer 3, block_nr= -1,         state= BH_uptodate
> 
> It seems no I/O for 3 buffers. It's because the page is the last page of inode
> and blocks for buffer[1,2,3] is not assgined.
> (maybe BH_uptodate is set by block_write_full_page().
> 
> Adding below check can hide the warning....but I can't say this is correct.
> Can we set this page dirty silently in this case ? 
> 
> ===
> +
> +static int check_fragment_page(struct page *page, struct address_space *mapping
> )
> +{
> +       struct inode *inode = mapping->host;
> +       unsigned long lastblock, coverblock;
> +
> +       if (!page_has_buffers(page))
> +               return 0;
> +
> +       lastblock = (i_size_read(inode) - 1) >> inode->i_blkbits;
> +       coverblock = (page->index + 1) << (PAGE_SHIFT - inode->i_blkbits);
> +
> +       return coverblock > lastblock;
> +}
> +
> +
> +
>  static int __set_page_dirty(struct page *page,
>                 struct address_space *mapping, int warn)
>  {
> @@ -717,7 +734,9 @@ static int __set_page_dirty(struct page
> 
>         write_lock_irq(&mapping->tree_lock);
>         if (page->mapping) {    /* Race with truncate? */
> -               WARN_ON_ONCE(warn && !PageUptodate(page));
> +               WARN_ON_ONCE(warn
> +                            && !PageUptodate(page)
> +                            && !check_fragment_page(page, mapping));
> 
>                 if (mapping_cap_account_dirty(mapping)) {
>                         __inc_zone_page_state(page, NR_FILE_DIRTY);
> ==

The warning is just wrong, I think.  We don't nowmally hit it because
write() will use mark_buffer_dirty() which supresses the warning and mmaped
pages are uptodate.

Nick?
