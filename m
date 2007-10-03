Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXJCCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXJCCvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbXJCCvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:51:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51191 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755643AbXJCCvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:51:07 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:50:07 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mthca: allow setting "dmabarrier" on user-allocated memory
Message-ID: <20071003025007.GJ26752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow setting a "dmabarrier" when the mthca driver registers user-
allocated memory.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 mthca_provider.c |    7 ++++++-
 mthca_user.h     |   10 +++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 17486a4..c818708 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1017,17 +1017,22 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct ib_umem_chunk *chunk;
 	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
 	u64 *pages;
 	int shift, n, len;
 	int i, j, k;
 	int err = 0;
 	int write_mtt_size;
 
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) 
+		return ERR_PTR(-EFAULT);
+
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       ucmd.mr_attrs & MTHCA_MR_DMAFLUSH);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..5662aea 100644
--- a/drivers/infiniband/hw/mthca/mthca_user.h
+++ b/drivers/infiniband/hw/mthca/mthca_user.h
@@ -41,7 +41,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MTHCA_UVERBS_ABI_VERSION	1
+#define MTHCA_UVERBS_ABI_VERSION	2
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -61,6 +61,14 @@ struct mthca_alloc_pd_resp {
 	__u32 reserved;
 };
 
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+#define MTHCA_MR_DMAFLUSH 0x1	/* flush in-flight DMA on a write to 
+				 * memory region */
+	__u32 reserved;
+};
+
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
