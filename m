Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYFRWi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYFRWi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYFRWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:38:49 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:14256 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYFRWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:38:48 -0400
X-IronPort-AV: E=Sophos;i="4.27,667,1204531200"; 
   d="scan'208";a="33048817"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 18 Jun 2008 15:38:47 -0700
Message-ID: <ada3anaz7uw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jun 2008 22:38:47.0218 (UTC) FILETIME=[1248B920:01C8D194]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a couple of small fixes:

Jack Morgenstein (1):
      IB/uverbs: Fix check of is_closed flag check in ib_uverbs_async_handler()

Roland Dreier (1):
      RDMA/nes: Fix off-by-one in nes_reg_user_mr() error path

 drivers/infiniband/core/uverbs_main.c |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f806da1..caed42b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -423,7 +423,7 @@ static void ib_uverbs_async_handler(struct ib_uverbs_file *file,
 	unsigned long flags;
 
 	spin_lock_irqsave(&file->async_file->lock, flags);
-	if (!file->async_file->is_closed) {
+	if (file->async_file->is_closed) {
 		spin_unlock_irqrestore(&file->async_file->lock, flags);
 		return;
 	}
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 99b3c4a..d617da9 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2456,10 +2456,8 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 						if ((page_count!=0)&&(page_count<<12)-(region->offset&(4096-1))>=region->length)
 							goto enough_pages;
 						if ((page_count&0x01FF) == 0) {
-							if (page_count>(1024*512)) {
+							if (page_count >= 1024 * 512) {
 								ib_umem_release(region);
-								pci_free_consistent(nesdev->pcidev, 4096, vpbl.pbl_vbase,
-										vpbl.pbl_pbase);
 								nes_free_resource(nesadapter,
 										nesadapter->allocated_mrs, stag_index);
 								kfree(nesmr);
