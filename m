Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYJQLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYJQLtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYJQLtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:49:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58987 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYJQLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:49:35 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IB/ehca: Fix problem with max number of QPs and CQs in systems with different adapters
Date: Fri, 17 Oct 2008 13:49:10 +0200
User-Agent: KMail/1.9.9
Cc: raisch@de.ibm.com, hnguyen@de.ibm.com, fenkes@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810171349.12686.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because ehca adapters can differ in the maximum number of QPs and CQs
we have to save the maximum number of these ressources per adapter and not
globally per ehca driver. This fix introduces 2 new members to the shca
structure to store the maximum value for QPs and CQs per adapter.
The module parameters are now used as initial values for those variables.
If a user selects an invalid number of CQs or QPs we don't print an error any
longer, instead we will inform the user with a warning and set the values to
the respective maximum supported by the HW.

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +
 drivers/infiniband/hw/ehca/ehca_cq.c      |    4 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |   35 ++++++++++++++++------------
 drivers/infiniband/hw/ehca/ehca_qp.c      |    4 +-
 4 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 5d7b785..4df887a 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -128,6 +128,8 @@ struct ehca_shca {
 	/* MR pgsize: bit 0-3 means 4K, 64K, 1M, 16M respectively */
 	u32 hca_cap_mr_pgsize;
 	int max_mtu;
+	int max_num_qps;
+	int max_num_cqs;
 	atomic_t num_cqs;
 	atomic_t num_qps;
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 33647a9..2f4c28a 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -132,9 +132,9 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
 		return ERR_PTR(-EINVAL);
 
-	if (!atomic_add_unless(&shca->num_cqs, 1, ehca_max_cq)) {
+	if (!atomic_add_unless(&shca->num_cqs, 1, shca->max_num_cqs)) {
 		ehca_err(device, "Unable to create CQ, max number of %i "
-			"CQs reached.", ehca_max_cq);
+			"CQs reached.", shca->max_num_cqs);
 		ehca_err(device, "To increase the maximum number of CQs "
 			"use the number_of_cqs module parameter.\n");
 		return ERR_PTR(-ENOSPC);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 598844d..086959a 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -366,22 +366,23 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 			shca->hca_cap_mr_pgsize |= pgsize_map[i + 1];
 
 	/* Set maximum number of CQs and QPs to calculate EQ size */
-	if (ehca_max_qp == -1)
-		ehca_max_qp = min_t(int, rblock->max_qp, EHCA_MAX_NUM_QUEUES);
-	else if (ehca_max_qp < 1 || ehca_max_qp > rblock->max_qp) {
-		ehca_gen_err("Requested number of QPs is out of range (1 - %i) "
-			"specified by HW", rblock->max_qp);
-		ret = -EINVAL;
-		goto sense_attributes1;
+	if (shca->max_num_qps == -1)
+		shca->max_num_qps = min_t(int, rblock->max_qp,
+					  EHCA_MAX_NUM_QUEUES);
+	else if (shca->max_num_qps < 1 || shca->max_num_qps > rblock->max_qp) {
+		ehca_gen_warn("The requested number of QPs is out of range "
+			      "(1 - %i) specified by HW. Value is set to %i",
+			      rblock->max_qp, rblock->max_qp);
+		shca->max_num_qps = rblock->max_qp;
 	}
 
-	if (ehca_max_cq == -1)
-		ehca_max_cq = min_t(int, rblock->max_cq, EHCA_MAX_NUM_QUEUES);
-	else if (ehca_max_cq < 1 || ehca_max_cq > rblock->max_cq) {
-		ehca_gen_err("Requested number of CQs is out of range (1 - %i) "
-			"specified by HW", rblock->max_cq);
-		ret = -EINVAL;
-		goto sense_attributes1;
+	if (shca->max_num_cqs == -1)
+		shca->max_num_cqs = min_t(int, rblock->max_cq,
+					  EHCA_MAX_NUM_QUEUES);
+	else if (shca->max_num_cqs < 1 || shca->max_num_cqs > rblock->max_cq) {
+		ehca_gen_warn("The requested number of CQs is out of range "
+			      "(1 - %i) specified by HW. Value is set to %i",
+			      rblock->max_cq, rblock->max_cq);
 	}
 
 	/* query max MTU from first port -- it's the same for all ports */
@@ -733,9 +734,13 @@ static int __devinit ehca_probe(struct of_device *dev,
 		ehca_gen_err("Cannot allocate shca memory.");
 		return -ENOMEM;
 	}
+
 	mutex_init(&shca->modify_mutex);
 	atomic_set(&shca->num_cqs, 0);
 	atomic_set(&shca->num_qps, 0);
+	shca->max_num_qps = ehca_max_qp;
+	shca->max_num_cqs = ehca_max_cq;
+
 	for (i = 0; i < ARRAY_SIZE(shca->sport); i++)
 		spin_lock_init(&shca->sport[i].mod_sqp_lock);
 
@@ -755,7 +760,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 		goto probe1;
 	}
 
-	eq_size = 2 * ehca_max_cq + 4 * ehca_max_qp;
+	eq_size = 2 * shca->max_num_cqs + 4 * shca->max_num_qps;
 	/* create event queues */
 	ret = ehca_create_eq(shca, &shca->eq, EHCA_EQ, eq_size);
 	if (ret) {
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 40b578d..4d54b9f 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -465,9 +465,9 @@ static struct ehca_qp *internal_create_qp(
 	u32 swqe_size = 0, rwqe_size = 0, ib_qp_num;
 	unsigned long flags;
 
-	if (!atomic_add_unless(&shca->num_qps, 1, ehca_max_qp)) {
+	if (!atomic_add_unless(&shca->num_qps, 1, shca->max_num_qps)) {
 		ehca_err(pd->device, "Unable to create QP, max number of %i "
-			 "QPs reached.", ehca_max_qp);
+			 "QPs reached.", shca->max_num_qps);
 		ehca_err(pd->device, "To increase the maximum number of QPs "
 			 "use the number_of_qps module parameter.\n");
 		return ERR_PTR(-ENOSPC);
-- 
1.5.5

