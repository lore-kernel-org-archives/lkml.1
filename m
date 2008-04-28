Return-Path: <linux-kernel-owner+w=401wt.eu-S936822AbYD1Qxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936822AbYD1Qxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934220AbYD1Qxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:53:33 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38490 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762306AbYD1Qxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:53:32 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org,
       Roel Kluin <12o3l@tiscali.nl>
Subject: IB/ehca: handle negative return value from ibmebus_request_irq() properly in ehca_create_eq()
Date: Mon, 28 Apr 2008 18:47:44 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Christoph Raisch <RAISCH@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281847.44968.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_eq.c |   35 ++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index b4ac617..49660df 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -54,7 +54,8 @@ int ehca_create_eq(struct ehca_shca *shca,
 		   struct ehca_eq *eq,
 		   const enum ehca_eq_type type, const u32 length)
 {
-	u64 ret;
+	int ret;
+	u64 h_ret;
 	u32 nr_pages;
 	u32 i;
 	void *vpage;
@@ -73,15 +74,15 @@ int ehca_create_eq(struct ehca_shca *shca,
 		return -EINVAL;
 	}
 
-	ret = hipz_h_alloc_resource_eq(shca->ipz_hca_handle,
-				       &eq->pf,
-				       type,
-				       length,
-				       &eq->ipz_eq_handle,
-				       &eq->length,
-				       &nr_pages, &eq->ist);
+	h_ret = hipz_h_alloc_resource_eq(shca->ipz_hca_handle,
+					 &eq->pf,
+					 type,
+					 length,
+					 &eq->ipz_eq_handle,
+					 &eq->length,
+					 &nr_pages, &eq->ist);
 
-	if (ret != H_SUCCESS) {
+	if (h_ret != H_SUCCESS) {
 		ehca_err(ib_dev, "Can't allocate EQ/NEQ. eq=%p", eq);
 		return -EINVAL;
 	}
@@ -97,24 +98,22 @@ int ehca_create_eq(struct ehca_shca *shca,
 		u64 rpage;
 
 		vpage = ipz_qpageit_get_inc(&eq->ipz_queue);
-		if (!vpage) {
-			ret = H_RESOURCE;
+		if (!vpage)
 			goto create_eq_exit2;
-		}
 
 		rpage = virt_to_abs(vpage);
-		ret = hipz_h_register_rpage_eq(shca->ipz_hca_handle,
-					       eq->ipz_eq_handle,
-					       &eq->pf,
-					       0, 0, rpage, 1);
+		h_ret = hipz_h_register_rpage_eq(shca->ipz_hca_handle,
+						 eq->ipz_eq_handle,
+						 &eq->pf,
+						 0, 0, rpage, 1);
 
 		if (i == (nr_pages - 1)) {
 			/* last page */
 			vpage = ipz_qpageit_get_inc(&eq->ipz_queue);
-			if (ret != H_SUCCESS || vpage)
+			if (h_ret != H_SUCCESS || vpage)
 				goto create_eq_exit2;
 		} else {
-			if (ret != H_PAGE_REGISTERED || !vpage)
+			if (h_ret != H_PAGE_REGISTERED || !vpage)
 				goto create_eq_exit2;
 		}
 	}
-- 
1.5.5



