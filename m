Return-Path: <linux-kernel-owner+w=401wt.eu-S940920AbXGaCZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940920AbXGaCZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937364AbXGaCRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:52809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940502AbXGaCRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:51 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:39 +1000
Message-Id: <1070731021739.25411@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 021 of 35] Teach umem.c about bi_offset and to limit to bi_size.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/block/umem.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff .prev/drivers/block/umem.c ./drivers/block/umem.c
--- .prev/drivers/block/umem.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/block/umem.c	2007-07-31 11:21:11.000000000 +1000
@@ -115,6 +115,7 @@ struct cardinfo {
 	struct bio	*bio, *currentbio, **biotail;
 	int		current_idx;
 	sector_t	current_sector;
+	int		current_size;
 
 	struct request_queue *queue;
 
@@ -387,12 +388,14 @@ static int add_bio(struct cardinfo *card
 	int idx;
 	int rw;
 	int len;
+	int bvoffset = 0;
 
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
 		card->current_idx = 0;
 		card->current_sector = card->bio->bi_sector;
+		card->current_size = bio->bi_size;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
 			card->biotail = &card->bio;
@@ -408,10 +411,14 @@ static int add_bio(struct cardinfo *card
 		return 0;
 
 	vec = bio_iovec_idx(bio, idx);
-	len = vec->bv_len;
+	if (idx == 0)
+		bvoffset = bio->bi_offset;
+	len = vec->bv_len - bvoffset;
+	if (len > card->current_size)
+		len = card->current_size;
 	dma_handle = pci_map_page(card->dev,
 				  vec->bv_page,
-				  vec->bv_offset,
+				  vec->bv_offset + bvoffset,
 				  len,
 				  (rw==READ) ?
 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
@@ -446,11 +453,14 @@ static int add_bio(struct cardinfo *card
 		desc->control_bits |= cpu_to_le32(DMASCR_TRANSFER_READ);
 	desc->sem_control_bits = desc->control_bits;
 
+	card->current_size -= len;
 	card->current_sector += (len >> 9);
 	idx++;
 	card->current_idx = idx;
-	if (idx >= bio->bi_vcnt)
+	if (idx >= bio->bi_vcnt) {
+		BUG_ON(card->current_size);
 		card->currentbio = NULL;
+	}
 
 	return 1;
 }
