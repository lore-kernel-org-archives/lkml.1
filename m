Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXAWDaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXAWDaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXAWDax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:30:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:18047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbXAWD3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:29:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,223,1167638400"; 
   d="scan'208"; a="171792571:sNHT19538442"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/12] md: remove raid5 compute_block and compute_parity5
Date: Mon, 22 Jan 2007 20:29:50 -0700
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, christopher.leech@intel.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Message-Id: <20070123032950.29114.31058.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <1169522364.8362.113.camel@dwillia2-linux.ch.intel.com>
References: <1169522364.8362.113.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

replaced by raid5_run_ops

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |  124 ----------------------------------------------------
 1 files changed, 0 insertions(+), 124 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8af084f..a981c35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1480,130 +1480,6 @@ static void copy_data(int frombio, struct bio *bio,
 			   }						       \
 			} while(0)
 
-
-static void compute_block(struct stripe_head *sh, int dd_idx)
-{
-	int i, count, disks = sh->disks;
-	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-
-	PRINTK("compute_block, stripe %llu, idx %d\n", 
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
-		xor_block(count, STRIPE_SIZE, dest, ptr);
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
-	PRINTK("compute_parity5, stripe %llu, method %d\n",
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
-		xor_block(count, STRIPE_SIZE, dest, ptr);
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
-		xor_block(count, STRIPE_SIZE, dest, ptr);
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
