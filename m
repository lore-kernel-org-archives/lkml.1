Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXJVUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXJVUCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXJVUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:02:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34585 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXJVUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:02:14 -0400
Date: Mon, 22 Oct 2007 21:01:11 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-Reply-To: <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0710222042500.23513@blonde.wat.veritas.com>
References: <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007, Erez Zadok wrote:
> In message <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>, Pekka J Enberg writes:
> > 
> > Look at mm/filemap.c:__filemap_fdatawrite_range(). You shouldn't be 
> > calling unionfs_writepage() _at all_ if the lower mapping has 
> > BDI_CAP_NO_WRITEBACK capability set. Perhaps something like the totally 
> > untested patch below?
...

I don't disagree with your unionfs_writepages patch, Pekka, but I think
it should be viewed as an optimization (don't waste time trying to write
a group of pages when we know that nothing will be done) rather than as
essential.

Prior to unionfs's own use of AOP_WRITEPAGE_ACTIVATE, there have only
been ramdisk and shmem generating it.  ramdisk is careful only to
return it in the wbc->for_reclaim case: I think (as in the patch
I sent out before) shmem now ought to do so too for safety.

Back in 2.4 days it was reasonable to assume that ->writepage would
only get called from certain places, but things move faster nowadays,
and the unionfs example shows others are liable to start ab/using it.
I'll send Andrew that patch tomorrow (it's simple enough, but I'd
like at least to try to reproduce the page_mapped bug first).

> 
> Pekka, with a small change to your patch (to handle time-based cache
> coherency), your patch worked well and passed all my tests.  Thanks.
> 
> So now I wonder if we still need the patch to prevent AOP_WRITEPAGE_ACTIVATE
> from being returned to userland.  I guess we still need it, b/c even with
> your patch, generic_writepages() can return AOP_WRITEPAGE_ACTIVATE back to
> the VFS and we need to ensure that doesn't "leak" outside the kernel.

Can it now?  Current git has a patch from Andrew which bears a striking
resemblance to that from Pekka, stopping the leak from write_cache_pages.

Hugh
