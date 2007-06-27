Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbXF0B5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbXF0B5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbXF0Bv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:51:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:51709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbXF0Bvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,465,1175497200"; 
   d="scan'208";a="261537634"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 15/19] md: remove raid5 compute_block and
	compute_parity5
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Date: Tue, 26 Jun 2007 18:51:50 -0700
Message-ID: <20070627015150.18962.29466.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

replaced by raid5_run_ops

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  124 ----------------------------------------------------
 1 files changed, 0 insertions(+), 124 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a09bc5f..0579d1f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1509,130 +1509,6 @@ static void copy_data(int frombio, struct bio *bio,
 			   }						  \
 			} while(0)
 
-
-static void compute_block(struct stripe_head *sh, int dd_idx)
-{
-	int i, count, disks = sh->disks;
-	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-
-	pr_debug("compute_block, stripe %llu, idx %d\n",
-		(unsigned long long)sh->sector, dd_idx);
-
-	dest = page_address(sh->dev[dd_idx].page);
-	memset(dest, 0, STRIPE_SIZE);
-	count = 0;
-	for (i = disks ; i--; ) {
-		if (i == dd_idx)
-			continue;
-		p = page_address(sh->dev[i].page);
-		if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
-			ptr[count++] = p;
-		else
-			printk(KERN_ERR "compute_block() %d, stripe %llu, %d"
-				" not present\n", dd_idx,
-				(unsigned long long)sh->sector, i);
-
-		check_xor();
-	}
-	if (count)
-		xor_blocks(count, STRIPE_SIZE, dest, ptr);
-	set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
-}
-
-static void compute_parity5(struct stripe_head *sh, int method)
-{
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, disks = sh->disks, count;
-	void *ptr[MAX_XOR_BLOCKS], *dest;
-	struct bio *chosen;
-
-	pr_debug("compute_parity5, stripe %llu, method %d\n",
-		(unsigned long long)sh->sector, method);
-
-	count = 0;
-	dest = page_address(sh->dev[pd_idx].page);
-	switch(method) {
-	case READ_MODIFY_WRITE:
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags));
-		for (i=disks ; i-- ;) {
-			if (i==pd_idx)
-				continue;
-			if (sh->dev[i].towrite &&
-			    test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
-
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-
-				BUG_ON(sh->dev[i].written);
-				sh->dev[i].written = chosen;
-				check_xor();
-			}
-		}
-		break;
-	case RECONSTRUCT_WRITE:
-		memset(dest, 0, STRIPE_SIZE);
-		for (i= disks; i-- ;)
-			if (i!=pd_idx && sh->dev[i].towrite) {
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
-
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-
-				BUG_ON(sh->dev[i].written);
-				sh->dev[i].written = chosen;
-			}
-		break;
-	case CHECK_PARITY:
-		break;
-	}
-	if (count) {
-		xor_blocks(count, STRIPE_SIZE, dest, ptr);
-		count = 0;
-	}
-	
-	for (i = disks; i--;)
-		if (sh->dev[i].written) {
-			sector_t sector = sh->dev[i].sector;
-			struct bio *wbi = sh->dev[i].written;
-			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
-				copy_data(1, wbi, sh->dev[i].page, sector);
-				wbi = r5_next_bio(wbi, sector);
-			}
-
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(R5_UPTODATE, &sh->dev[i].flags);
-		}
-
-	switch(method) {
-	case RECONSTRUCT_WRITE:
-	case CHECK_PARITY:
-		for (i=disks; i--;)
-			if (i != pd_idx) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				check_xor();
-			}
-		break;
-	case READ_MODIFY_WRITE:
-		for (i = disks; i--;)
-			if (sh->dev[i].written) {
-				ptr[count++] = page_address(sh->dev[i].page);
-				check_xor();
-			}
-	}
-	if (count)
-		xor_blocks(count, STRIPE_SIZE, dest, ptr);
-
-	if (method != CHECK_PARITY) {
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
-	} else
-		clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-}
-
 static void compute_parity6(struct stripe_head *sh, int method)
 {
 	raid6_conf_t *conf = sh->raid_conf;
