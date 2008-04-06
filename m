Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYDFXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYDFXfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 19:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYDFXfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 19:35:45 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56882 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754797AbYDFXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 19:35:44 -0400
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.ziljstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
Content-Type: text/plain
Date: Sun, 06 Apr 2008 18:35:35 -0500
Message-Id: <1207524935.3223.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-06 at 23:56 +0100, Hugh Dickins wrote:
> Since 2.6.25-rc7, I've been seeing an occasional livelock on one
> x86_64 machine, copying kernel trees to tmpfs, paging out to swap.
> 
> Signature: 6000 pages under writeback but never getting written;
> most tasks of interest trying to reclaim, but each get_swap_bio
> waiting for a bio in mempool_alloc's io_schedule_timeout(5*HZ);
> every five seconds an atomic page allocation failure report from
> kblockd failing to allocate a sense_buffer in __scsi_get_command.
> 
> __scsi_get_command has a (one item) free_list to protect against
> this, but rc1's [SCSI] use dynamically allocated sense buffer
> de25deb18016f66dcdede165d07654559bb332bc upset that slightly.
> When it fails to allocate from the separate sense_slab, instead
> of giving up, it must fall back to the command free_list, which
> is sure to have a sense_buffer attached.
> 
> Either my earlier -rc testing missed this, or there's some recent
> contributory factor.  One very significant factor is SLUB, which
> merges slab caches when it can, and on 64-bit happens to merge
> both bio cache and sense_slab cache into kmalloc's 128-byte cache:
> so that under this swapping load, bios above are liable to gobble
> up all the slots needed for scsi_cmnd sense_buffers below.
> 
> That's disturbing behaviour, and I tried a few things to fix it.
> Adding a no-op constructor to the sense_slab inhibits SLUB from
> merging it, and stops all the allocation failures I was seeing;
> but it's rather a hack, and perhaps in different configurations
> we have other caches on the swapout path which are ill-merged.
> 
> Another alternative is to revert the separate sense_slab, using
> cache-line-aligned sense_buffer allocated beyond scsi_cmnd from
> the one kmem_cache; but that might waste more memory, and is
> only a way of diverting around the known problem.
> 
> While I don't like seeing the allocation failures, and hate the
> idea of all those bios piled up above a scsi host working one by
> one, it does seem to emerge fairly soon with the livelock fix.
> So lacking better ideas, stick with that one clear fix for now.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

This was sort of accidentally fixed in scsi-misc by commit 

commit c5f73260b289cb974928eac05f2d84e58ddfc020
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Mar 13 11:16:33 2008 -0500

    [SCSI] consolidate command allocation in a single place

Could you check that:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

and see if it alleviates the problem? ... if so, we can work out which
pieces to backport.

Thanks,

James


