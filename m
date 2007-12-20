Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXLTBFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXLTBFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXLTBFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:05:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbXLTBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:05:10 -0500
Date: Thu, 20 Dec 2007 02:05:08 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-ID: <20071220010508.GA19332@atrey.karlin.mff.cuni.cz>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 16 Dec 2007, Krzysztof Oledzki wrote:
> > 
> > I'll confirm this tomorrow but it seems that even switching to data=ordered
> > (AFAIK default o ext3) is indeed enough to cure this problem.
> 
> Ok, do we actually have any ext3 expert following this? I have no idea 
> about what the journalling code does, but I have painful memories of ext3 
> doing really odd buffer-head-based IO and totally bypassing all the normal 
> page dirty logic.
> 
> Judging by the symptoms (sorry for not following this well, it came up 
> while I was mostly away travelling), something probably *does* clear the 
> dirty bit on the pages, but the dirty *accounting* is not done properly, 
> so the kernel keeps thinking it has dirty pages.
> 
> Now, a simple "grep" shows that ext3 does not actually do any 
> ClearPageDirty() or similar on its own, although maybe I missed some other 
> subtle way this can happen. And the *normal* VFS routines that do 
> ClearPageDirty should all be doing the proper accounting.
> 
> So I see a couple of possible cases:
> 
>  - actually clearing the PG_dirty bit somehow, without doing the 
>    accounting.
> 
>    This looks very unlikely. PG_dirty is always cleared by some variant of 
>    "*ClearPageDirty()", and that bit definition isn't used for anything 
>    else in the whole kernel judging by "grep" (the page allocator tests 
>    the bit, that's it).
> 
>    And there aren't that many hits for ClearPageDirty, and they all seem 
>    to do the proper "dec_zone_page_state(page, NR_FILE_DIRTY);" etc if the 
>    mapping has dirty state accounting.
> 
>    The exceptions seem to be:
>     - the page freeing path, but that path checks that "mapping" is NULL 
>       (so no accounting), and would complain loudly if it wasn't
>     - the swap state stuff ("move_from_swap_cache()"), but that should 
>       only ever trigger for swap cache pages (we have a BUG_ON() in that 
>       path), and those don't do dirty accounting anyway.
>     - pageout(), but again only for pages that have a NULL mapping.
> 
>  - ext3 might be clearing (probably indirectly) the "page->mapping" thing 
>    or similar, which in turn will make the VFS think that even a dirty 
>    page isn't actually to be accounted for - so when the page *turned* 
>    dirty, it was accounted as a dirty page, but then, when it was cleaned, 
>    the accounting wasn't reversed because ->mapping had become NULL.
> 
>    This would be some interaction with the truncation logic, and quite 
>    frankly, that should be all shared with the non-journal case, so I find 
>    this all very unlikely. 
> 
> However, that second case is interesting, because the pageout case 
> actually has a comment like this:
> 
> 	/*
> 	 * Some data journaling orphaned pages can have
> 	 * page->mapping == NULL while being dirty with clean buffers.
> 	 */
> 
> which really sounds like the case in question. 
> 
> I may know the VM, but that special case was added due to insane 
> journaling filesystems, and I don't know what insane things they do. Which 
> is why I'm wondering if there is any ext3 person who knows the journaling 
> code?
  Yes, I'm looking into the problem... I think those orphan pages
without mapping are created because we cannot drop truncated
buffers/pages immediately.  There can be a committing transaction that
still needs the data in those buffers and until it commits we have to
keep the pages (and even maybe write them to disk etc.). But eventually,
we should write the buffers, call try_to_free_buffers() which calls
cancel_dirty_page() and everything should be happy... in theory ;)
  In practice, I have not yet narrowed down where the problem is.
fsx-linux is able to trigger the problem on my test machine so as
suspected it is some bad interaction of writes (plain writes, no mmap),
truncates and probably writeback. Small tests don't seem to trigger the
problem (fsx needs at least few hundreds operations to trigger the
problem) - on the other hand when some sequence of operations causes
lost dirty pages, they are lost deterministically in every run. Also the
file fsx operates on can be fairly small - 2MB was enough - so page
reclaim and such stuff probably isn't the thing we interact with.
  Tomorrow I'll try more...

> How/when does it ever "orphan" pages? Because yes, if it ever does that, 
> and clears the ->mapping field on a mapped page, then that page will have 
> incremented the dirty counts when it became dirty, but will *not* 
> decrement the dirty count when it is an orphan.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
