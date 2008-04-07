Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYDGSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYDGSEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDGSEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:04:33 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47551 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYDGSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:04:33 -0400
Date: Mon, 7 Apr 2008 19:07:56 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: James.Bottomley@HansenPartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, clameter@sgi.com,
       penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <20080407114859M.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.0804071851230.14273@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
 <20080407114859M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, FUJITA Tomonori wrote:
> On Sun, 6 Apr 2008 23:56:57 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> Really sorry about the bug.

No, it's brought attention to this interesting slab merge issue;
even if in the end we decide that's a non-issue.

> > Another alternative is to revert the separate sense_slab, using
> > cache-line-aligned sense_buffer allocated beyond scsi_cmnd from
> > the one kmem_cache; but that might waste more memory, and is
> > only a way of diverting around the known problem.
> 
> Reverting the separate sense_slab is fine for now but we need the
> separation shortly anyway. We need to support larger sense buffer (260
> bytes). The current 96 byte sense buffer works for the majority of us,
> so we doesn't want to embed 260 byte sense buffer in scsi_cmnd struct.

I don't believe you _need_ a separate sense_slab even for that:
what I meant was that you just need something like
	pool->cmd_slab = kmem_cache_create(pool->cmd_name,
					   cache_line_align(
					   sizeof(struct scsi_cmnd)) +
					   max_scsi_sense_buffersize,
					   0, pool->slab_flags, NULL);
then point cmd->sense_buffer to (unsigned char *) cmd +
			cache_line_align(sizeof(struct scsi_cmnd));
where cache_line_align and max_scsi_sense_buffersize are preferably
determined at runtime.

Now, it may well be that over the different configurations, at least
some would waste significant memory by putting it all in the one big
buffer, and you're better off with the separate slabs: so I didn't
want to interfere with your direction on that.

Hugh
