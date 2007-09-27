Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXI0HU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXI0HU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXI0HUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:20:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbXI0HUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:20:19 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Sep 2007 17:20:13 +1000
Message-Id: <1070927072013.4177@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 4] Only call bi_end_io once for any bio.
References: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently bi_end_io can be called multiple times as sub-requests
complete.  However no ->bi_end_io function wants to know about that.
So only call when the bio is complete.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/bio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-09-27 16:36:53.000000000 +1000
+++ ./fs/bio.c	2007-09-27 16:39:02.000000000 +1000
@@ -1018,6 +1018,8 @@ void bio_endio(struct bio *bio, unsigned
 {
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
 
 	if (unlikely(bytes_done > bio->bi_size)) {
 		printk("%s: want %u bytes done, only %u left\n", __FUNCTION__,
@@ -1028,7 +1030,7 @@ void bio_endio(struct bio *bio, unsigned
 	bio->bi_size -= bytes_done;
 	bio->bi_sector += (bytes_done >> 9);
 
-	if (bio->bi_end_io)
+	if (bio->bi_size && bio->bi_end_io)
 		bio->bi_end_io(bio, bytes_done, error);
 }
 
