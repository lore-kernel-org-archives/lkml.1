Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXLTQ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXLTQ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbXLTQ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:26:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932989AbXLTQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:26:46 -0500
Date: Thu, 20 Dec 2007 08:25:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
cc: Krzysztof Oledzki <olel@ans.pl>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071220141217.GA4745@atjola.homenet>
Message-ID: <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Bj?rn Steinbrink wrote:
> 
> OK, so I looked for PG_dirty anyway.
> 
> In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0 you made try_to_free_buffers
> bail out if the page is dirty.
> 
> Then in 3e67c0987d7567ad666641164a153dca9a43b11d, Andrew fixed
> truncate_complete_page, because it called cancel_dirty_page (and thus
> cleared PG_dirty) after try_to_free_buffers was called via
> do_invalidatepage.
> 
> Now, if I'm not mistaken, we can end up as follows.
> 
> truncate_complete_page()
>   cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>   do_invalidatepage()
>     ext3_invalidatepage()
>       journal_invalidatepage()
>         journal_unmap_buffer()
>           __dispose_buffer()
>             __journal_unfile_buffer()
>               __journal_temp_unlink_buffer()
>                 mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

Good, this seems to be the exact path that actually triggers it. I got to 
journal_unmap_buffer(), but was too lazy to actually then bother to follow 
it all the way down - I decided that I didn't actually really even care 
what the low-level FS layer did, I had already convinced myself that it 
obviously must be dirtying the page some way, since that matched the 
symptoms exactly (ie only the journaling case was impacted, and this was 
all about the journal).

But perhaps more importantly: regardless of what the low-level filesystem 
did at that point, the VM accounting shouldn't care, and should be robust 
in the face of a low-level filesystem doing strange and wonderful things. 
But thanks for bothering to go through the whole history and figure out 
what exactly is up.

> As try_to_free_buffers got its ext3 hack back in
> ecdfc9787fe527491baefc22dce8b2dbd5b2908d, maybe
> 3e67c0987d7567ad666641164a153dca9a43b11d should be reverted? (Except for
> the accounting fix in cancel_dirty_page, of course).

Yes, I think we have room for cleanups now, and I agree: we ended up 
reinstating some questionable code in the VM just because we didn't really 
know or understand what was going on in the ext3 journal code. 

Of course, it may well be that there is something *else* going on too, but 
I do believe that this whole case is what it was all about, and the hacks 
end up just (a) making the VM harder to understand (because they cause 
non-obvious VM code to work around some very specific filesystem 
behaviour) and (b) the hacks obviously hid the _real_ issue, but I think 
we've established the real cause, and the hacks clearly weren't enough to 
really hide it 100% anyway.

However, there's no way I'll play with that  right now (I'm planning on an 
-rc6 today), but it might be worth it to make a test-cleanup patch for -mm 
which does some VM cleanups:

 - don't touch dirty pages in fs/buffer.c (ie undo the meat of commit 
   ecdfc9787fe527491baefc22dce8b2dbd5b2908d, but not resurrecting the 
   debugging code)

 - remove the calling of "cancel_dirty_page()" entirely from 
   "truncate_complete_page()", and let "remove_from_page_cache()" just 
   always handle it (and probably just add a "ClearPageDirty()" to match 
   the "ClearPageUptodate()").

 - remove "cancel_dirty_page()" from "truncate_huge_page()", which seems 
   to be the exact same issue (ie we should just use the logic in 
   remove_from_page_cache()).

at that point "cancel_dirty_page()" literally is only used for what its 
name implies, and the only in-tree use of it seems to be NFS for when 
the filesystem gets called for ->invalidatepage - which makes tons of 
conceptual sense, but I suspect we could drop it from there too, since the 
VM layer _will_ cancel the dirtiness at a VM level when it then later 
removes it from the page cache.

So we essentially seem to be able to simplify things a bit by getting rid 
of a hack in try_to_free_buffers(), and potentially getting rid of 
cancel_dirty_page() entirely.

It would imply that we need to do the task_io_account_cancelled_write() 
inside "remove_from_page_cache()", but that should be ok (I don't see any 
locking issues there).

> On a side note, before 8368e328dfe1c534957051333a87b3210a12743b the task
> io accounting for cancelled writes happened always happened if the page
> was dirty, regardless of page->mapping. This was also already true for
> the old test_clear_page_dirty code, and the commit log for
> 8368e328dfe1c534957051333a87b3210a12743b doesn't mention that semantic
> change either, so maybe the "if (account_size)" block should be moved
> out of the if "(mapping && ...)" block?

I think the "if (account_size)" thing was *purely* for me being worried 
about hugetlb entries, and I think that's the only thing that passes in a 
zero account size.

But hugetlbfs already has BDI_CAP_NO_ACCT_DIRTY set (exactly because we 
cannot account for those pages *anyway*), so I think we could go further 
than move the account_size outside of the test, I think we could probably 
remove that test entirely and drop the whole thing.

The thing is, task_io_account_cancelled_write() doesn't make sense on 
mappings that don't do dirty accounting, since those mappings are all 
special anyway: they don't actually do any real IO, they are all in-ram 
things. So I think it should stay inside the

	if (mapping && mapping_cap_account_dirty(mapping))
		..

test, simply because I don't think it makes any conceptual sense outside 
of it.

Hmm?

But none of this seems really critical - just simple cleanups.

			Linus
