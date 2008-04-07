Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYDGCwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYDGCwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 22:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYDGCvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 22:51:53 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:61025 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYDGCvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 22:51:52 -0400
To: hugh@veritas.com
Cc: James.Bottomley@HansenPartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, clameter@sgi.com, penberg@cs.helsinki.fi,
       a.p.ziljstra@chello.nl, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080407114859M.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 07 Apr 2008 11:48:59 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008 23:56:57 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

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

Really sorry about the bug.


> Another alternative is to revert the separate sense_slab, using
> cache-line-aligned sense_buffer allocated beyond scsi_cmnd from
> the one kmem_cache; but that might waste more memory, and is
> only a way of diverting around the known problem.

Reverting the separate sense_slab is fine for now but we need the
separation shortly anyway. We need to support larger sense buffer (260
bytes). The current 96 byte sense buffer works for the majority of us,
so we doesn't want to embed 260 byte sense buffer in scsi_cmnd struct.


> While I don't like seeing the allocation failures, and hate the
> idea of all those bios piled up above a scsi host working one by
> one, it does seem to emerge fairly soon with the livelock fix.
> So lacking better ideas, stick with that one clear fix for now.

As you and James agreed, the patch in scsi-misc looks good to me.


Thanks for finding this bug.
