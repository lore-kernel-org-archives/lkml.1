Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXHPLWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXHPLWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933642AbXHPLVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:21:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:47863 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582AbXHPLVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:21:16 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:21:09 +1000
Message-Id: <1070816112109.12200@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 003 of 6] Fix various abuse of bio fields in umem.c
References: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


umem.c:
  advances bi_idx and bi_sector to track where it is up to.
   But it is only ever doing this on one bio, so the updated
   fields can easily be kept elsewhere (current_*).
  updates bi_size, but never uses the updated values, so
   this isn't needed.
  reuses bi_phys_segments to count how many iovecs have been
   completely.  As the completion happens sequentiually, we
   can store this information outside the bio too.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/block/umem.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff .prev/drivers/block/umem.c ./drivers/block/umem.c
--- .prev/drivers/block/umem.c	2007-08-16 21:10:00.000000000 +1000
+++ ./drivers/block/umem.c	2007-08-16 21:10:12.000000000 +1000
@@ -113,6 +113,8 @@ struct cardinfo {
 				    * have been written
 				    */
 	struct bio	*bio, *currentbio, **biotail;
+	int		current_idx;
+	sector_t	current_sector;
 
 	struct request_queue *queue;
 
@@ -121,6 +123,7 @@ struct cardinfo {
 		struct mm_dma_desc	*desc;
 		int	 		cnt, headcnt;
 		struct bio		*bio, **biotail;
+		int			idx;
 	} mm_pages[2];
 #define DESC_PER_PAGE ((PAGE_SIZE*2)/sizeof(struct mm_dma_desc))
 
@@ -380,12 +383,16 @@ static int add_bio(struct cardinfo *card
 	dma_addr_t dma_handle;
 	int offset;
 	struct bio *bio;
+	struct bio_vec *vec;
+	int idx;
 	int rw;
 	int len;
 
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
+		card->current_idx = card->bio->bi_idx;
+		card->current_sector = card->bio->bi_sector;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
 			card->biotail = &card->bio;
@@ -394,15 +401,17 @@ static int add_bio(struct cardinfo *card
 	}
 	if (!bio)
 		return 0;
+	idx = card->current_idx;
 
 	rw = bio_rw(bio);
 	if (card->mm_pages[card->Ready].cnt >= DESC_PER_PAGE)
 		return 0;
 
-	len = bio_iovec(bio)->bv_len;
-	dma_handle = pci_map_page(card->dev, 
-				  bio_page(bio),
-				  bio_offset(bio),
+	vec = bio_iovec_idx(bio, idx);
+	len = vec->bv_len;
+	dma_handle = pci_map_page(card->dev,
+				  vec->bv_page,
+				  vec->bv_offset,
 				  len,
 				  (rw==READ) ?
 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
@@ -410,6 +419,8 @@ static int add_bio(struct cardinfo *card
 	p = &card->mm_pages[card->Ready];
 	desc = &p->desc[p->cnt];
 	p->cnt++;
+	if (p->bio == NULL)
+		p->idx = idx;
 	if ((p->biotail) != &bio->bi_next) {
 		*(p->biotail) = bio;
 		p->biotail = &(bio->bi_next);
@@ -419,7 +430,7 @@ static int add_bio(struct cardinfo *card
 	desc->data_dma_handle = dma_handle;
 
 	desc->pci_addr = cpu_to_le64((u64)desc->data_dma_handle);
-	desc->local_addr= cpu_to_le64(bio->bi_sector << 9);
+	desc->local_addr = cpu_to_le64(card->current_sector << 9);
 	desc->transfer_size = cpu_to_le32(len);
 	offset = ( ((char*)&desc->sem_control_bits) - ((char*)p->desc));
 	desc->sem_addr = cpu_to_le64((u64)(p->page_dma+offset));
@@ -435,10 +446,10 @@ static int add_bio(struct cardinfo *card
 		desc->control_bits |= cpu_to_le32(DMASCR_TRANSFER_READ);
 	desc->sem_control_bits = desc->control_bits;
 
-	bio->bi_sector += (len>>9);
-	bio->bi_size -= len;
-	bio->bi_idx++;
-	if (bio->bi_idx >= bio->bi_vcnt) 
+	card->current_sector += (len >> 9);
+	idx++;
+	card->current_idx = idx;
+	if (idx >= bio->bi_vcnt)
 		card->currentbio = NULL;
 
 	return 1;
@@ -474,10 +485,12 @@ static void process_page(unsigned long d
 			last=1; 
 		}
 		page->headcnt++;
-		idx = bio->bi_phys_segments;
-		bio->bi_phys_segments++;
-		if (bio->bi_phys_segments >= bio->bi_vcnt)
+		idx = page->idx;
+		page->idx++;
+		if (page->idx >= bio->bi_vcnt) {
 			page->bio = bio->bi_next;
+			page->idx = page->bio->bi_idx;
+		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle, 
 			       bio_iovec_idx(bio,idx)->bv_len,
@@ -547,7 +560,6 @@ static int mm_make_request(struct reques
 	pr_debug("mm_make_request %llu %u\n",
 		 (unsigned long long)bio->bi_sector, bio->bi_size);
 
-	bio->bi_phys_segments = bio->bi_idx; /* count of completed segments*/
 	spin_lock_irq(&card->lock);
 	*card->biotail = bio;
 	bio->bi_next = NULL;
