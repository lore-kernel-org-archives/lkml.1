Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362Ab0AZN3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0AZN3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590Ab0AZN3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:29:30 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36820 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab0AZN3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:29:30 -0500
Date: Tue, 26 Jan 2010 14:29:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn
	case
Message-ID: <20100126132928.GI13771@kernel.dk>
References: <87hbq980tc.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbq980tc.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26 2010, Dmitry Monakhov wrote:
> Hi, year ago I've sent a patch which fix false bio merge rejects, but
> seems patch was missed. Currently the issue is still present.
> 

> From 92a97ef181e15caa94bd56a1ade5c337db599b79 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Tue, 26 Jan 2010 16:01:34 +0300
> Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case
> 
> We have to properly decrease bi_size in order to merge_bvec_fn return
> right result.  Otherwise this result in false merge rejects for two
> absolutely valid bio_vecs.  This may cause significant performance penalty
> for example Itanium: page_size == 16k, fs_block_size == 1k and block device
> is raid with small chunk_size.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/bio.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 76e6713..9f8e517 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -548,7 +548,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  				struct bvec_merge_data bvm = {
>  					.bi_bdev = bio->bi_bdev,
>  					.bi_sector = bio->bi_sector,
> -					.bi_size = bio->bi_size,
> +					.bi_size = bio->bi_size -
> +							(prev->bv_len - len),
>  					.bi_rw = bio->bi_rw,
>  				};

Hmm confused. why isn't this just bio->bi_size - len?

-- 
Jens Axboe

