Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbXFLBKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbXFLBKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXFLBJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:09:42 -0400
Received: from ns1.suse.de ([195.135.220.2]:57656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbXFLBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:09:41 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Jun 2007 11:09:35 +1000
Message-Id: <1070612010935.25370@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Accetta <maccetta@laurelnetworks.com>
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 002 of 2] md: Fix bug in error handling during raid1 repair.
References: <20070612110634.25171.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mike Accetta <maccetta@laurelnetworks.com>

If raid1/repair (which reads all block and fixes any differences
it finds) hits a read error, it doesn't reset the bio for writing
before writing correct data back, so the read error isn't fixed,
and the device probably gets a zero-length write which it might
complain about.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/raid1.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-06-12 10:48:57.000000000 +1000
+++ ./drivers/md/raid1.c	2007-06-12 10:49:05.000000000 +1000
@@ -1240,17 +1240,24 @@ static void sync_request_write(mddev_t *
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
