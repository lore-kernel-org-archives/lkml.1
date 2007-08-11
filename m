Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbXHKTAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbXHKTAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbXHKS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:15 -0400
Received: from 1wt.eu ([62.212.114.60]:1519 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762310AbXHKS6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:12 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184842.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:06 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Neil Brown <neilb@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 14/28] md: Fix bug in error handling during raid1 repair.
Content-Disposition: inline; filename=0014-md-Fix-bug-in-error-handling-during-raid1-repair.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If raid1/repair (which reads all block and fixes any differences
it finds) hits a read error, it doesn't reset the bio for writing
before writing correct data back, so the read error isn't fixed,
and the device probably gets a zero-length write which it might
complain about.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/raid1.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 97ee870..b20c6e9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1235,17 +1235,24 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 			}
 		r1_bio->read_disk = primary;
 		for (i=0; i<mddev->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read &&
-			    test_bit(BIO_UPTODATE, &r1_bio->bios[i]->bi_flags)) {
+			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
 				int j;
 				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 				struct bio *pbio = r1_bio->bios[primary];
 				struct bio *sbio = r1_bio->bios[i];
-				for (j = vcnt; j-- ; )
-					if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
-						   page_address(sbio->bi_io_vec[j].bv_page),
-						   PAGE_SIZE))
-						break;
+
+				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+					for (j = vcnt; j-- ; ) {
+						struct page *p, *s;
+						p = pbio->bi_io_vec[j].bv_page;
+						s = sbio->bi_io_vec[j].bv_page;
+						if (memcmp(page_address(p),
+							   page_address(s),
+							   PAGE_SIZE))
+							break;
+					}
+				} else
+					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
-- 
1.5.2.4

-- 
