Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbXKZUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbXKZUPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXKZUPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:15:15 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48447 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXKZUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:15:14 -0500
Date: Mon, 26 Nov 2007 20:14:46 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: unionfs: several more problems 
In-Reply-To: <200711261653.lAQGr2Et011553@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0711261953220.2958@blonde.wat.veritas.com>
References: <200711261653.lAQGr2Et011553@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Erez Zadok wrote:
> 
> I just posted a series of patches to unionfs (already in unionfs.git on
> korg), which fix every problem LTP found, as well as other problems
> mentioned in your email.  With this series of patches, the same set of tests
> which pass on ext3 also pass with unionfs mounted over ext3.

Good, I'll give them a try, but not tonight - my own bugs to work on!

> 
> I'd like to call your attention to one small unionfs_writepage fix.  One of
> the ltp fs tests (rwtest04) triggered a BUG_ON(PageWriteback(page)) in
> fs/buffer.c:1706, when we call the lower ->writepage.  This was due to
> multiple writers to the same page.  Looking at other kernel code, it seems
> that the right fix is to use wait_on_page_writeback(lower_page) to serialize
> concurrent writebacks to the same page, no?

Ah, yes.  I believe that's the right thing to do (and you do have the
lower_page locked there, which is necessary for that serialization).

> The small patch below fixed the problem.  Let me know what you think.

I've one issue with it: please move that wait_on_page_writeback before
the clear_page_dirty_for_io instead of after it, then resubmit your 14/16.

As it stands, you're still mixing the end of the previous writeback with
the beginning of the new one (e.g. clear_page_dirty_for_io is clearing
the PageReclaim flag when it shouldn't be interfering at all); and the
page might get dirtied during that wait for the previous writeback to
complete, in which case you'd end up doing an extra unnecessary write
(because page later found "dirty" even though written back long after
last modification).

Whether this is a big deal in any way, I don't know; but if you look
at other instances, you'll find the wait_on_page_writeback is done
before the clear_page_dirty_for_io, so you'll surely be on safer
ground to follow the same ordering.

(And so far as I can see, everyone who calls write_one_page does so
with the wait flag 1: that's the clearest example.  Hmm, I wonder if
its initial wait_on_page_writeback is right to be conditional on wait
at all.  Well, until someone calls it with wait 0, it's hard to tell.)

Hugh

> 
> Thanks,
> Erez.
> 
> 
> diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
> index eef43aa..d0fd4d0 100644
> --- a/fs/unionfs/mmap.c
> +++ b/fs/unionfs/mmap.c
> @@ -73,6 +73,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
>  
>  	BUG_ON(!lower_mapping->a_ops->writepage);
>  	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
> +	wait_on_page_writeback(lower_page); /* prevent multiple writers */
>  	err = lower_mapping->a_ops->writepage(lower_page, wbc);
>  	if (err < 0)
>  		goto out_release;
