Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXKBNe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXKBNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXKBNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:34:19 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:63556 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbXKBNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:34:18 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/2] IB/ehca: Return physical link information in query_port()
Date: Fri, 2 Nov 2007 15:33:51 +0200
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200711021432.50203.fenkes@de.ibm.com>
In-Reply-To: <200711021432.50203.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021433.51565.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Newer firmware versions return physical port information to the partition,
so hand that information to the consumer if it's present.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_hca.c |   20 ++++++++++++++------
 drivers/infiniband/hw/ehca/hipz_hw.h  |    6 +++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 15806d1..5bd7b59 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -151,7 +151,6 @@ int ehca_query_port(struct ib_device *ibdev,
 	}
 
 	memset(props, 0, sizeof(struct ib_port_attr));
-	props->state = rblock->state;
 
 	switch (rblock->max_mtu) {
 	case 0x1:
@@ -188,11 +187,20 @@ int ehca_query_port(struct ib_device *ibdev,
 	props->subnet_timeout  = rblock->subnet_timeout;
 	props->init_type_reply = rblock->init_type_reply;
 
-	props->active_width    = IB_WIDTH_12X;
-	props->active_speed    = 0x1;
-
-	/* at the moment (logical) link state is always LINK_UP */
-	props->phys_state      = 0x5;
+	if (rblock->state && rblock->phys_width) {
+		props->phys_state      = rblock->phys_pstate;
+		props->state           = rblock->phys_state;
+		props->active_width    = rblock->phys_width;
+		props->active_speed    = rblock->phys_speed;
+	} else {
+		/* old firmware releases don't report physical
+		 * port info, so use default values
+		 */
+		props->phys_state      = 5;
+		props->state           = rblock->state;
+		props->active_width    = IB_WIDTH_12X;
+		props->active_speed    = 0x1;
+	}
 
 query_port1:
 	ehca_free_fw_ctrlblock(rblock);
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index d9739e5..485b840 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -402,7 +402,11 @@ struct hipz_query_port {
 	u64 max_msg_sz;
 	u32 max_mtu;
 	u32 vl_cap;
-	u8  reserved2[1900];
+	u32 phys_pstate;
+	u32 phys_state;
+	u32 phys_speed;
+	u32 phys_width;
+	u8  reserved2[1884];
 	u64 guid_entries[255];
 } __attribute__ ((packed));
 
-- 
1.5.2


