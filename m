Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbXIKNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbXIKNec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965295AbXIKNdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:33:45 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59560 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965253AbXIKNdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:33:44 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 09/12] IB/ehca: Add check for max #SGE to create_qp()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:33:40 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111533.41250.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index d2ab84a..7154f62 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -513,7 +513,7 @@ static struct ehca_qp *internal_create_qp(
 			} else if (init_attr->cap.max_send_wr > 255) {
 				ehca_err(pd->device,
 					 "Invalid Number of "
-					 "ax_send_wr=%x for UD QP_TYPE=%x",
+					 "max_send_wr=%x for UD QP_TYPE=%x",
 					 init_attr->cap.max_send_wr, qp_type);
 				return ERR_PTR(-EINVAL);
 			}
@@ -524,6 +524,18 @@ static struct ehca_qp *internal_create_qp(
 			return ERR_PTR(-EINVAL);
 			break;
 		}
+	} else {
+		int max_sge = (qp_type == IB_QPT_UD || qp_type == IB_QPT_SMI
+			       || qp_type == IB_QPT_GSI) ? 250 : 252;
+
+		if (init_attr->cap.max_send_sge > max_sge
+		    || init_attr->cap.max_recv_sge > max_sge) {
+			ehca_err(pd->device, "Invalid number of SGEs requested "
+				 "send_sge=%x recv_sge=%x max_sge=%x",
+				 init_attr->cap.max_send_sge,
+				 init_attr->cap.max_recv_sge, max_sge);
+			return ERR_PTR(-EINVAL);
+		}
 	}
 
 	if (pd->uobject && udata)
-- 
1.5.2


