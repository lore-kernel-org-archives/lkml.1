Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab0BDR2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:28:07 -0500
Received: from kroah.org ([198.145.64.141]:34879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333Ab0BDRWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:18 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:19 2010
Message-Id: <20100204171519.290781725@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [55/74] block: fix bio_add_page for non trivial merge_bvec_fn case
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 1d6165851cd8e3f919d446cd6da35dee44e8837e upstream.

We have to properly decrease bi_size in order to merge_bvec_fn return
right result.  Otherwise this result in false merge rejects for two
absolutely valid bio_vecs.  This may cause significant performance
penalty for example fs_block_size == 1k and block device is raid0 with
small chunk_size = 8k. Then it is impossible to merge 7-th fs-block in
to bio which already has 6 fs-blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -542,13 +542,18 @@ static int __bio_add_page(struct request
 
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
+			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
 
 			if (q->merge_bvec_fn) {
 				struct bvec_merge_data bvm = {
+					/* prev_bvec is already charged in
+					   bi_size, discharge it in order to
+					   simulate merging updated prev_bvec
+					   as new bvec. */
 					.bi_bdev = bio->bi_bdev,
 					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size,
+					.bi_size = bio->bi_size - prev_bv_len,
 					.bi_rw = bio->bi_rw,
 				};
 


