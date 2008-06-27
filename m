Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYF0Gwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYF0Gwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYF0Gt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:49:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:43158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbYF0Gt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:49:57 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:49:50 +1000
Message-Id: <1080627064950.10364@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 005 of 29] md: use bio_endio instead of a call to bi_end_io
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Turn calls to bi->bi_end_io() into bio_endio(). Apparently bio_endio does
exactly the same error processing as is hardcoded at these places.

bio_endio() avoids recursion (or will soon), so it should be used.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:22:48.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:31:23.000000000 +1000
@@ -115,9 +115,7 @@ static void return_io(struct bio *return
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
 		bi = return_bi;
 	}
 }
@@ -3700,9 +3698,7 @@ static int make_request(struct request_q
 		if ( rw == WRITE )
 			md_write_end(mddev);
 
-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
 	}
 	return 0;
 }
@@ -4005,12 +4001,8 @@ static int  retry_aligned_read(raid5_con
 	spin_lock_irq(&conf->device_lock);
 	remaining = --raid_bio->bi_phys_segments;
 	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0) {
-
-		raid_bio->bi_end_io(raid_bio,
-			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
-			        ? 0 : -EIO);
-	}
+	if (remaining == 0)
+		bio_endio(raid_bio, 0);
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
 	return handled;
