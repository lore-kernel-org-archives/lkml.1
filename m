Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYLWKPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYLWKPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYLWKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:15:07 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55383 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYLWKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:15:05 -0500
Date: Tue, 23 Dec 2008 10:15:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] bio: zero inlined bio_vec
In-Reply-To: <20081223080747.GE32491@kernel.dk>
Message-ID: <Pine.LNX.4.64.0812230951100.3062@blonde.anvils>
References: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils>
 <20081223080747.GE32491@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Jens Axboe wrote:
> On Tue, Dec 23 2008, Hugh Dickins wrote:
> > bvec_alloc_bs() zeroes its bio_vec, and at least __blk_queue_bounce()
> > relies upon that: therefore bio_alloc_bioset() must zero the inlined
> > bio_vec - without that, lots of nastiness occurs in bounce_end_io and
> > blk_rq_map_sg and other places when booting up my PAE box.
> 
> Hmm, where does it die? Nobody should look at the bio_vec index beyond
> bio->bi_vcnt, and 0...bio->bi_vcnt-1 should always be initialized due to
> the way we fill the entries.

It dies in a great variety of places, different mmotms and different
nexts and different configs on that box preferring to collapse in
different places all over the blk/bounce/scsi/map_sg stack.

bounce_end_io() and blk_rq_map_sg() and nommu_map_sg() stick in my
mind as among the locations seen, though perhaps the actual oopses
and BUGs were sometimes a level below.

__blk_queue_bounce() does one transit of the bio skipping any
segments which don't need bouncing, then a second transit of the
newly allocated bounce bio assuming
		if (!to->bv_page) {
means that it needs to copy from orig_bio: so if the new bio was
not zeroed there, it'll skip that segment and leave junk?

Doesn't that explain it?  If there are no other places, then you
could fix that instead.  But in that case, why have we been memset'
ting the allocated bio_vec all this time?  Perhaps there are other
traps lurking.

I've not seen the problem on the newer machine I run (usually x86_64
but occasionally) x86_32 with highmem, only on that P4 Xeon which
tips above 4GB.  I was a little surprised to find it happening also
with mem=700M yesterday, had come to think it was likely a problem
with bouncing; but later in the night found Rusty has broken mem=.

Hugh
