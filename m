Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYH2Jht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYH2Jht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbYH2JhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:37:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:51959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbYH2JhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:37:12 -0400
Message-ID: <48B7C2D5.2060209@kernel.org>
Date: Fri, 29 Aug 2008 11:35:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: [PATCH] block: don't test for partition size in bdget_disk() and
 blk_lookup_devt()
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com> <20080829070515.GL20055@kernel.dk>
In-Reply-To: <20080829070515.GL20055@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 09:36:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdget_disk() and blk_lookup_devt() never cared whether the specified
partition (or disk) is zero sized or not.  I got confused while
converting those not to depend on consecutive minor numbers in commit
5a6411b1178baf534aa9138052864dfa89d3eada and later when dev0 was added
it broke callers which expected to get valid return for zero sized
disk devices.

So, they never needed nr_sects checks in the first place.  Kill them.

This problem was spotted and debugged by Bartlmoiej Zolnierkiewicz.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Thanks for the good spotting.  I got confused between the meaning of
!part and !part->nr_sects and added the wrong check during conversion.
I audited the rest and it seems those two are the only ones.

Thanks.

 block/genhd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -586,7 +586,7 @@ extern struct block_device *bdget_disk(s
 	struct block_device *bdev = NULL;
 
 	part = disk_get_part(disk, partno);
-	if (part && (part->nr_sects || partno == 0))
+	if (part)
 		bdev = bdget(part_devt(part));
 	disk_put_part(part);
 
@@ -1032,7 +1032,7 @@ dev_t blk_lookup_devt(const char *name,
 			continue;
 
 		part = disk_get_part(disk, partno);
-		if (part && (part->nr_sects || partno == 0)) {
+		if (part) {
 			devt = part_devt(part);
 			disk_put_part(part);
 			break;
