Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYGBPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYGBPDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYGBPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:03:26 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:29658 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYGBPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:03:25 -0400
Date: Wed, 2 Jul 2008 08:04:16 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/edac: i5100 cleanup addendum
Message-ID: <20080702150416.GA32745@ajones-laptop.nbttech.com>
References: <20080702023345.2554ef15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080702023345.2554ef15.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follow-on cleanup patch fixes the following
compiler warnings found by Andrew Morton:

drivers/edac/i5100_edac.c:258: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c:263: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c: In function 'i5100_ctl_page_to_phys':
drivers/edac/i5100_edac.c:372: warning: left shift count >= width of type

The i5100_ctl_page_to_phys was not used, it will be
re-added when the controller -> cpu address space
translations work.

CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arthur Jones <ajones@riverbed.com>
---
 drivers/edac/i5100_edac.c |   39 +++------------------------------------
 1 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index a2007db..22db05a 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -254,12 +254,12 @@ static inline u32 i5100_recmema_dm_buf_id(u32 a)
 	return i5100_nrecmema_dm_buf_id(a);
 }
 
-static inline u32 i5100_recmemb_cas(a)
+static inline u32 i5100_recmemb_cas(u32 a)
 {
 	return i5100_nrecmemb_cas(a);
 }
 
-static inline u32 i5100_recmemb_ras(a)
+static inline u32 i5100_recmemb_ras(u32 a)
 {
 	return i5100_nrecmemb_ras(a);
 }
@@ -339,39 +339,6 @@ static int i5100_rank_to_slot(const struct mem_ctl_info *mci,
 	return -1;
 }
 
-/*
- * The processor bus memory addresses are broken into three
- * pieces, whereas the controller addresses are contiguous.
- *
- * here we map from the controller address space to the
- * processor address space:
- *
- *    Processor Address Space
- * +-----------------------------+
- * |                             |
- * |  "high" memory addresses    |
- * |                             |
- * +-----------------------------+ <- 4GB on the i5100
- * |                             |
- * |  other non-memory addresses |
- * |                             |
- * +-----------------------------+ <- top of low memory
- * |                             |
- * | "low" memory addresses      |
- * |                             |
- * +-----------------------------+
- */
-static unsigned long i5100_ctl_page_to_phys(struct mem_ctl_info *mci,
-					    unsigned long cntlr_addr)
-{
-	const struct i5100_priv *priv = mci->pvt_info;
-
-	if (cntlr_addr < priv->tolm)
-		return cntlr_addr;
-
-	return (1UL << 32) + (cntlr_addr - priv->tolm);
-}
-
 static const char *i5100_err_msg(unsigned err)
 {
 	static const char *merrs[] = {
@@ -912,7 +879,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 	mci->mod_ver = "not versioned";
 	mci->ctl_name = "i5100";
 	mci->dev_name = pci_name(pdev);
-	mci->ctl_page_to_phys = i5100_ctl_page_to_phys;
+	mci->ctl_page_to_phys = NULL;
 
 	mci->edac_check = i5100_check_error;
 
-- 
1.5.4.3
