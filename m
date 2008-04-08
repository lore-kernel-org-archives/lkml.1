Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYDHOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYDHOGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYDHOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:06:40 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45191 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYDHOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:06:39 -0400
Date: Tue, 8 Apr 2008 23:04:55 +0900
To: hugh@veritas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, clameter@sgi.com, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0804071851230.14273@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
	<20080407114859M.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0804071851230.14273@blonde.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080408230354U.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008 19:07:56 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 7 Apr 2008, FUJITA Tomonori wrote:
> > On Sun, 6 Apr 2008 23:56:57 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > Really sorry about the bug.
> 
> No, it's brought attention to this interesting slab merge issue;
> even if in the end we decide that's a non-issue.

Yeah, seems that it led to an interesting discussion (using cache
behavior like ephemeral sounds useful, I think) though surely this is
a bug.


> > > Another alternative is to revert the separate sense_slab, using
> > > cache-line-aligned sense_buffer allocated beyond scsi_cmnd from
> > > the one kmem_cache; but that might waste more memory, and is
> > > only a way of diverting around the known problem.
> > 
> > Reverting the separate sense_slab is fine for now but we need the
> > separation shortly anyway. We need to support larger sense buffer (260
> > bytes). The current 96 byte sense buffer works for the majority of us,
> > so we doesn't want to embed 260 byte sense buffer in scsi_cmnd struct.
> 
> I don't believe you _need_ a separate sense_slab even for that:
> what I meant was that you just need something like
> 	pool->cmd_slab = kmem_cache_create(pool->cmd_name,
> 					   cache_line_align(
> 					   sizeof(struct scsi_cmnd)) +
> 					   max_scsi_sense_buffersize,
> 					   0, pool->slab_flags, NULL);
> then point cmd->sense_buffer to (unsigned char *) cmd +
> 			cache_line_align(sizeof(struct scsi_cmnd));
> where cache_line_align and max_scsi_sense_buffersize are preferably
> determined at runtime.

Yes, if we have only 96 and 260 bytes sense buffers, it would be a
solution. Well, evne if we have various length sense buffers, we can
have a pool per driver (or device, scsi_host, etc).

Another reason why we separated them is that we could allocate a sense
buffer only when it's necessary (though I'm not sure we will do it
actually).


> Now, it may well be that over the different configurations, at least
> some would waste significant memory by putting it all in the one big
> buffer, and you're better off with the separate slabs: so I didn't
> want to interfere with your direction on that.

Yes, this was about wasting memory (with the one big buffer)
vs. overheads due to allocating two buffers. After some performance
tests, we chose the latter but we might change this again in the
future.
