Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZHZLh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZHZLh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZHZLh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:37:57 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:45838 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZHZLh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:37:56 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Hal Rosenstock <hnrose@comcast.net>
Subject: [PATCH] IB/ehca: Construct MAD redirect replies from request MAD
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Wed, 26 Aug 2009 13:37:55 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908261337.56128.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code used a lot of hardcoded values, which might not be valid in all
environments (especially routed fabrics or partitioned subnets). Copy as
much information as possible from the incoming request to prevent that.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

Hal, Jason -- here's the change I promised. Looks okay to you?
Roland -- if Hal and Jason don't object, please queue this up for the next
kernel. Thanks!

Regards,
  Joachim

 drivers/infiniband/hw/ehca/ehca_sqp.c |   47 ++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index c568b28..8c1213f 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -125,14 +125,30 @@ struct ib_perf {
 	u8 data[192];
 } __attribute__ ((packed));
 
+/* TC/SL/FL packed into 32 bits, as in ClassPortInfo */
+struct tcslfl {
+	u32 tc:8;
+	u32 sl:4;
+	u32 fl:20;
+} __attribute__ ((packed));
+
+/* IP Version/TC/FL packed into 32 bits, as in GRH */
+struct vertcfl {
+	u32 ver:4;
+	u32 tc:8;
+	u32 fl:20;
+} __attribute__ ((packed));
 
 static int ehca_process_perf(struct ib_device *ibdev, u8 port_num,
+			     struct ib_wc *in_wc, struct ib_grh *in_grh,
 			     struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	struct ib_perf *in_perf = (struct ib_perf *)in_mad;
 	struct ib_perf *out_perf = (struct ib_perf *)out_mad;
 	struct ib_class_port_info *poi =
 		(struct ib_class_port_info *)out_perf->data;
+	struct tcslfl *tcslfl =
+		(struct tcslfl *)&poi->redirect_tcslfl;
 	struct ehca_shca *shca =
 		container_of(ibdev, struct ehca_shca, ib_device);
 	struct ehca_sport *sport = &shca->sport[port_num - 1];
@@ -158,10 +174,29 @@ static int ehca_process_perf(struct ib_device *ibdev, u8 port_num,
 		poi->base_version = 1;
 		poi->class_version = 1;
 		poi->resp_time_value = 18;
-		poi->redirect_lid = sport->saved_attr.lid;
-		poi->redirect_qp = sport->pma_qp_nr;
+
+		/* copy local routing information from WC where applicable */
+		tcslfl->sl         = in_wc->sl;
+		poi->redirect_lid  =
+			sport->saved_attr.lid | in_wc->dlid_path_bits;
+		poi->redirect_qp   = sport->pma_qp_nr;
 		poi->redirect_qkey = IB_QP1_QKEY;
-		poi->redirect_pkey = IB_DEFAULT_PKEY_FULL;
+
+		ehca_query_pkey(ibdev, port_num, in_wc->pkey_index,
+				&poi->redirect_pkey);
+
+		/* if request was globally routed, copy route info */
+		if (in_grh) {
+			struct vertcfl *vertcfl =
+				(struct vertcfl *)&in_grh->version_tclass_flow;
+			memcpy(poi->redirect_gid, in_grh->dgid.raw,
+			       sizeof(poi->redirect_gid));
+			tcslfl->tc        = vertcfl->tc;
+			tcslfl->fl        = vertcfl->fl;
+		} else
+			/* else only fill in default GID */
+			ehca_query_gid(ibdev, port_num, 0,
+				       (union ib_gid *)&poi->redirect_gid);
 
 		ehca_dbg(ibdev, "ehca_pma_lid=%x ehca_pma_qp=%x",
 			 sport->saved_attr.lid, sport->pma_qp_nr);
@@ -183,8 +218,7 @@ perf_reply:
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		     struct ib_wc *in_wc, struct ib_grh *in_grh,
-		     struct ib_mad *in_mad,
-		     struct ib_mad *out_mad)
+		     struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	int ret;
 
@@ -196,7 +230,8 @@ int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		return IB_MAD_RESULT_SUCCESS;
 
 	ehca_dbg(ibdev, "port_num=%x src_qp=%x", port_num, in_wc->src_qp);
-	ret = ehca_process_perf(ibdev, port_num, in_mad, out_mad);
+	ret = ehca_process_perf(ibdev, port_num, in_wc, in_grh,
+				in_mad, out_mad);
 
 	return ret;
 }
-- 
1.6.0.4


