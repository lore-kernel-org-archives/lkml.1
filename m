Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0A0VOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0A0VOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846Ab0A0VOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:14:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40940 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0A0VOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:14:43 -0500
Date: Wed, 27 Jan 2010 22:14:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn
	case
Message-ID: <20100127211442.GS13771@kernel.dk>
References: <87hbq980tc.fsf@openvz.org> <20100126132928.GI13771@kernel.dk> <c18d6aa21001260617y3ddad4deq139bf2afbc37d0be@mail.gmail.com> <874om7jlrq.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874om7jlrq.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28 2010, Dmitry Monakhov wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > On Tue, Jan 26, 2010 at 4:29 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> On Tue, Jan 26 2010, Dmitry Monakhov wrote:
> >>> Hi, year ago I've sent a patch which fix false bio merge rejects, but
> >>> seems patch was missed. Currently the issue is still present.
> >>>
> >>
> >>> From 92a97ef181e15caa94bd56a1ade5c337db599b79 Mon Sep 17 00:00:00 2001
> >>> From: Dmitry Monakhov <dmonakhov@openvz.org>
> >>> Date: Tue, 26 Jan 2010 16:01:34 +0300
> >>> Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case
> >>>
> >>> We have to properly decrease bi_size in order to merge_bvec_fn return
> >>> right result.  Otherwise this result in false merge rejects for two
> >>> absolutely valid bio_vecs.  This may cause significant performance penalty
> >>> for example Itanium: page_size == 16k, fs_block_size == 1k and block device
> >>> is raid with small chunk_size.
> >>>
> >>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >>> ---
> >>>  fs/bio.c |    3 ++-
> >>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/fs/bio.c b/fs/bio.c
> >>> index 76e6713..9f8e517 100644
> >>> --- a/fs/bio.c
> >>> +++ b/fs/bio.c
> >>> @@ -548,7 +548,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
> >>>                               struct bvec_merge_data bvm = {
> >>>                                       .bi_bdev = bio->bi_bdev,
> >>>                                       .bi_sector = bio->bi_sector,
> >>> -                                     .bi_size = bio->bi_size,
> >>> +                                     .bi_size = bio->bi_size -
> >>> +                                                     (prev->bv_len - len),
> >>>                                       .bi_rw = bio->bi_rw,
> >>>                               };
> >>
> >> Hmm confused. why isn't this just bio->bi_size - len?
> I've attached more descriptive  version of the patch. Jens, please
> clarify your opinion to the patch( do you like it or not?)
> I don't want it miss again.

Yes thanks, I agree with your evaluation, it's definitely correct. I'll
add it.

-- 
Jens Axboe

