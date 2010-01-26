Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755Ab0AZNPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0AZNPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065Ab0AZNPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:15:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:28642 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0AZNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:cc:date:message-id:user-agent:mime-version
         :content-type;
        b=vd3GFyHMACKb6c7sIPH4yy47iMxNM4OMZ7ZO2mt6tDCwgV5h3ScUcbAQvJfq8qpK+m
         g33htLKbqgAysd2uidi0RaGOs27Z8vjDZr+uzNWpcnEOtxa0geshJCv1Z4zzsPo5h3Ul
         0zlRQiL2tOowXgeEDHJDfcbSxjqJC3WsgOypU=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case
CC: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 26 Jan 2010 16:15:11 +0300
Message-ID: <87hbq980tc.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi, year ago I've sent a patch which fix false bio merge rejects, but
seems patch was missed. Currently the issue is still present.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-PATCH-block-fix-bio_add_page-for-non-trivial-merge_b.patch

>From 92a97ef181e15caa94bd56a1ade5c337db599b79 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 26 Jan 2010 16:01:34 +0300
Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case

We have to properly decrease bi_size in order to merge_bvec_fn return
right result.  Otherwise this result in false merge rejects for two
absolutely valid bio_vecs.  This may cause significant performance penalty
for example Itanium: page_size == 16k, fs_block_size == 1k and block device
is raid with small chunk_size.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 76e6713..9f8e517 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -548,7 +548,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 				struct bvec_merge_data bvm = {
 					.bi_bdev = bio->bi_bdev,
 					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size,
+					.bi_size = bio->bi_size -
+							(prev->bv_len - len),
 					.bi_rw = bio->bi_rw,
 				};
 
-- 
1.6.3.3


--=-=-=--
