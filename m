Return-Path: <linux-kernel-owner+w=401wt.eu-S1763401AbYBSXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763401AbYBSXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYBSW7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:59:38 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47827 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504AbYBSW7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:59:36 -0500
Date: Wed, 20 Feb 2008 00:59:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
Message-ID: <20080219225900.GR31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c.old	2008-02-20 00:20:47.000000000 +0200
+++ linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c	2008-02-20 00:21:09.000000000 +0200
@@ -916,33 +916,33 @@ static struct ib_pd *nes_alloc_pd(struct
 	if (!nespd) {
 		nes_free_resource(nesadapter, nesadapter->allocated_pds, pd_num);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	nes_debug(NES_DBG_PD, "Allocating PD (%p) for ib device %s\n",
 			nespd, nesvnic->nesibdev->ibdev.name);
 
 	nespd->pd_id = (pd_num << (PAGE_SHIFT-12)) + nesadapter->base_pd;
 
 	if (context) {
 		nesucontext = to_nesucontext(context);
 		nespd->mmap_db_index = find_next_zero_bit(nesucontext->allocated_doorbells,
 				NES_MAX_USER_DB_REGIONS, nesucontext->first_free_db);
 		nes_debug(NES_DBG_PD, "find_first_zero_biton doorbells returned %u, mapping pd_id %u.\n",
 				nespd->mmap_db_index, nespd->pd_id);
-		if (nespd->mmap_db_index > NES_MAX_USER_DB_REGIONS) {
+		if (nespd->mmap_db_index >= NES_MAX_USER_DB_REGIONS) {
 			nes_debug(NES_DBG_PD, "mmap_db_index > MAX\n");
 			nes_free_resource(nesadapter, nesadapter->allocated_pds, pd_num);
 			kfree(nespd);
 			return ERR_PTR(-ENOMEM);
 		}
 
 		uresp.pd_id = nespd->pd_id;
 		uresp.mmap_db_index = nespd->mmap_db_index;
 		if (ib_copy_to_udata(udata, &uresp, sizeof (struct nes_alloc_pd_resp))) {
 			nes_free_resource(nesadapter, nesadapter->allocated_pds, pd_num);
 			kfree(nespd);
 			return ERR_PTR(-EFAULT);
 		}
 
 		set_bit(nespd->mmap_db_index, nesucontext->allocated_doorbells);
 		nesucontext->mmap_db_index[nespd->mmap_db_index] = nespd->pd_id;

