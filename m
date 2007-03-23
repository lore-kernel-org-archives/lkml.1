Return-Path: <linux-kernel-owner+w=401wt.eu-S964769AbXCWGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964769AbXCWGxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933820AbXCWGxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:53:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:7586 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXCWGwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:52:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,317,1170662400"; 
   d="scan'208"; a="214678782:sNHT27334783"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc4 12/15] md: remove raid5 compute_block and
	compute_parity5
To: neilb@suse.de, christopher.leech@intel.com, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, yur@emcraft.com,
       wd@denx.de, arjan@linux.intel.com, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Mar 2007 23:52:38 -0700
Message-ID: <20070323065238.15570.28924.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

replaced by raid5_run_ops

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |  124 ----------------------------------------------------
 1 files changed, 0 insertions(+), 124 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0be26c2..062df02 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1482,130 +1482,6 @@ static void copy_data(int frombio, struct bio *bio,
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
