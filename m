Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYESBLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYESBLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbYESBLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:02 -0400
Received: from mx1.suse.de ([195.135.220.2]:35873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbYESBKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:18 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:11 +1000
Message-Id: <1080519011011.7627@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 10] md: Fix possible oops when removing a bitmap from an active array
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is possible to add a write-intent bitmap to an active array, or remove
the bitmap that is there.
When we do with the 'quiesce' the array, which causes make_request to
block in "wait_barrier()".
However we are sampling the value of "mddev->bitmap" before the
wait_barrier call, and using it afterwards.  This can result in
using a bitmap structure that has been freed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-05-19 11:02:04.000000000 +1000
+++ ./drivers/md/raid1.c	2008-05-19 11:02:15.000000000 +1000
@@ -773,7 +773,7 @@ static int make_request(struct request_q
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
 	int i, targets = 0, disks;
-	struct bitmap *bitmap = mddev->bitmap;
+	struct bitmap *bitmap;
 	unsigned long flags;
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
@@ -802,6 +802,8 @@ static int make_request(struct request_q
 
 	wait_barrier(conf);
 
+	bitmap = mddev->bitmap;
+
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 
