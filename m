Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYLWBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYLWBIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYLWBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:08:10 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55404 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYLWBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:08:09 -0500
Date: Tue, 23 Dec 2008 01:08:27 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [PATCH next] bio: zero inlined bio_vec
Message-ID: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bvec_alloc_bs() zeroes its bio_vec, and at least __blk_queue_bounce()
relies upon that: therefore bio_alloc_bioset() must zero the inlined
bio_vec - without that, lots of nastiness occurs in bounce_end_io and
blk_rq_map_sg and other places when booting up my PAE box.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/bio.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next/fs/bio.c	2008-12-21 20:49:25.000000000 +0000
+++ fixed/fs/bio.c	2008-12-22 21:10:06.000000000 +0000
@@ -324,6 +324,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 			if (nr_iovecs <= BIO_INLINE_VECS) {
 				idx = 0;
 				bvl = bio->bi_inline_vecs;
+				memset(bvl, 0, BIO_INLINE_VECS *
+							sizeof(struct bio_vec));
 				nr_iovecs = BIO_INLINE_VECS;
 			} else {
 				bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx,
