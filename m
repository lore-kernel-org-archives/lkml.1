Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZIALzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZIALzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZIALzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:55:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:41000 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZIALzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:55:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Fix CQE flags reporting
User-Agent: KMail/1.9.1
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com> <48499C11.7030504@gmail.com>
In-Reply-To: <48499C11.7030504@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2361
Date: Tue, 1 Sep 2009 13:55:33 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909011355.34319.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was reporting CQE flags in the wrong bit positions, causing consumers to
miss incoming immediate data.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

Please review and queue for 2.6.32 if you think it's okay. Thanks!
  Joachim

 drivers/infiniband/hw/ehca/ehca_reqs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 5a3d96f..8fd88cd 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -786,7 +786,11 @@ repoll:
 	wc->slid = cqe->rlid;
 	wc->dlid_path_bits = cqe->dlid;
 	wc->src_qp = cqe->remote_qp_number;
-	wc->wc_flags = cqe->w_completion_flags;
+	/*
+	 * HW has "Immed data present" and "GRH present" in bits 6 and 5.
+	 * SW defines those in bits 1 and 0, so we can just shift and mask.
+	 */
+	wc->wc_flags = (cqe->w_completion_flags >> 5) & 3;
 	wc->ex.imm_data = cpu_to_be32(cqe->immediate_data);
 	wc->sl = cqe->service_level;
 
-- 
1.6.0.4




