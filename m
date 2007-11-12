Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbXKLF5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbXKLF5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXKLF4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:56:53 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43552 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXKLF4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:56:52 -0500
Date: Mon, 12 Nov 2007 05:41:30 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Dave Hansen <haveblue@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-Reply-To: <200711090605.lA965B1S024066@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0711120457170.23491@blonde.wat.veritas.com>
References: <200711090605.lA965B1S024066@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Erez Zadok wrote:
> In message <Pine.LNX.4.64.0711051358440.7629@blonde.wat.veritas.com>, Hugh Dickins writes:
> > 
> > One, I think you would be safer to do a set_page_dirty(lower_page)
> > before your clear_page_dirty_for_io(lower_page).  I know that sounds
> > silly, but see Linus' "Yes, Virginia" comment in clear_page_dirty_for_io:
> > there's a lot of subtlety hereabouts, and I think you'd be mimicing the
> > usual path closer if you set_page_dirty first - there's nothing else
> > doing it on that lower_page, is there?  I'm not certain that you need
> > to, but I think you'd do well to look into it and make up your own mind.
> 
> Hugh, my code looks like:
> 
> 	if (wbc->for_reclaim) {
> 		set_page_dirty(lower_page);
> 		unlock_page(lower_page);
> 		goto out_release;
> 	}
> 	BUG_ON(!lower_mapping->a_ops->writepage);
> 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
> 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
> 
> Do you mean I should set_page_dirty(lower_page) unconditionally before
> clear_page_dirty_for_io?  (I already do that in the 'if' statement above it.)

Yes.  Whether you're wrong not to be doing that already, I've not checked;
but I think doing so will make unionfs safer against any future changes
in the relationship between set_page_dirty and clear_page_dirty_for_io.

For example, look at clear_page_dirty_for_io: it's decrementing some
statistics which __set_page_dirty_nobuffers increments.  Does use of
unionfs (over some filesystems) make those numbers wrap increasingly
negative?  Does adding this set_page_dirty(lower_page) correct that?
I suspect so, but may be wrong.

> > Two, I'm unsure of the way you're clearing or setting PageUptodate on
> > the upper page there.  The rules for PageUptodate are fairly obvious
> > when reading, but when a write fails, it's not so obvious.  Again, I'm
> > not saying what you've got is wrong (it may be unavoidable, to keep
> > synch between lower and upper), but it deserves a second thought.
> 
> I looked at all mainline filesystems's ->writepage to see what, if any, they
> do with their page's uptodate flag.  Most f/s don't touch the flag one way
> or another.

I'm not going to try and guess what assorted filesystems are up to,
and not all of them will be bugfree.  The crucial point of PageUptodate
is that we insert a filesystem page into the page cache before it's had
any data read in: it needs to be !PageUptodate until the data is there,
and then marked PageUptodate to say the data is good and others can
start using it.  See mm/filemap.c.

> And finally, unionfs clears the uptodate flag on error from the lower
> ->writepage, and otherwise sets the flag on success from the lower
> ->writepage.  My gut feeling is that unionfs shouldn't change the page
> uptodate flag at all: if the VFS passes unionfs_writepage a page which isn't
> uptodate, then the VFS has a serious problem b/c it'd be asking a f/s to
> write out a page which isn't up-to-date, right?  Otherwise, whether
> unionfs_writepage manages to write the lower page or not, why should that
> invalidate the state of the unionfs page itself?  Come to think of it, I
> think clearing pageuptodate on error from ->writepage(lower_page) may be
> bad.  Imagine if after such a failed unionfs_writepage, I get a
> unionfs_readpage: that ->readpage will get data from the lower f/s page and
> copy it *over* the unionfs page, even if the upper page's data was more
> recent prior to the failed call to unionfs_writepage.  IOW, we could be
> reverting a user-visible mmap'ed page to a previous on-disk version.  What
> do you think: could this happen?  Anyway, I'll run some exhaustive testing
> next and see what happens if I don't set/clear the uptodate flag in
> unionfs_writepage.

That was my point, and I don't really have more to add.  It's unusual
to do anything with PageUptodate when writing.  By clearing it when the
lower level has an error, you're throwing away the changes already made
at the upper level.  You might have some good reason for that, but it's
worth questioning.  If you don't know why you're Set/Clear'ing it there,
better to just take that out.

Hugh
