Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXJVTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXJVTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJVTn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:43:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60173 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJVTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:43:25 -0400
Date: Mon, 22 Oct 2007 20:42:20 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-Reply-To: <200710141723.l9EHNowh015023@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0710222019020.23513@blonde.wat.veritas.com>
References: <200710141723.l9EHNowh015023@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my delay, here are a few replies.

On Sun, 14 Oct 2007, Erez Zadok wrote:
> In message <84144f020710141009xbc5bb71w64e8288f364ab491@mail.gmail.com>, "Pekka Enberg" writes:
> > 
> > However, I don't think the mapping_cap_writeback_dirty() check in
> > __filemap_fdatawrite_range() works as expected when tmpfs is a lower
> > mount for an unionfs mount. There's no BDI_CAP_NO_WRITEBACK capability
> > for unionfs mappings so do_fsync() will call write_cache_pages() that
> > unconditionally invokes shmem_writepage() via unionfs_writepage().
> > Unless, of course, there's some other unionfs magic I am missing.

Thanks, Pekka, yes that made a lot of sense.

> 
> In unionfs_writepage() I tried to emulate as best possible what the lower
> f/s will have returned to the VFS.  Since tmpfs's ->writepage can return
> AOP_WRITEPAGE_ACTIVATE and re-mark its page as dirty, I did the same in
> unionfs: mark again my page as dirty, and return AOP_WRITEPAGE_ACTIVATE.

I think that's inappropriate.  Why should unionfs_writepage re-mark its
page as dirty when the lower level does so?  Unionfs has successfully
done its write to the lower level, what the lower level then gets up to
(writing then or not) is its own business: needn't be propagated upwards.

The fewer places that supply AOP_WRITEPAGE_ACTIVATE the better.
What I'd like most of all is to eliminate it, in favour of vmscan.c
working out the condition for itself: but I've given that no thought,
it may not be reasonable.

unionfs_writepage also sets AOP_WRITEPAGE_ACTIVATE when it cannot
find_lock_page: that case may be appropriate.  Though I don't really
understand it: seems dangerous to be relying upon the lower level page
just happening to be there already.  Isn't memory pressure then likely
to clog up with lots of upper level dirty pages which cannot get
written out to the lower level?

> 
> Should I be doing something different when unionfs stacks on top of tmpfs?

I think not.

> (BTW, this is probably also relevant to ecryptfs.)

You're both agreed on that, but I don't see how: ecryptfs writes the
lower level via vfs_write, it's not using the lower level's writepage,
is it?

Hugh
