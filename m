Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbXGLPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbXGLPtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbXGLPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:49:06 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:15421 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbXGLPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:49:05 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 02/10] IB/ehca: Fix HW level autodetection
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:47:45 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121747.46618.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Autodetection was missing a few HW revisions, causing certain eHCA1
revisions to be treated like eHCA2. Fixed.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index d9a37dc..57c551e 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -282,22 +282,27 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 
 		ehca_gen_dbg(" ... hardware version=%x:%x", hcaaver, revid);
 
-		if ((hcaaver == 1) && (revid == 0))
-			shca->hw_level = 0x11;
-		else if ((hcaaver == 1) && (revid == 1))
-			shca->hw_level = 0x12;
-		else if ((hcaaver == 1) && (revid == 2))
-			shca->hw_level = 0x13;
-		else if ((hcaaver == 2) && (revid == 0))
-			shca->hw_level = 0x21;
-		else if ((hcaaver == 2) && (revid == 0x10))
-			shca->hw_level = 0x22;
-		else {
+		if (hcaaver == 1) {
+			if (revid <= 3)
+				shca->hw_level = 0x10 | (revid + 1);
+			else
+				shca->hw_level = 0x14;
+		} else if (hcaaver == 2) {
+			if (revid == 0)
+				shca->hw_level = 0x21;
+			else if (revid == 0x10)
+				shca->hw_level = 0x22;
+			else if (revid == 0x20 || revid == 0x21)
+				shca->hw_level = 0x23;
+		}
+
+		if (!shca->hw_level) {
 			ehca_gen_warn("unknown hardware version"
 				      " - assuming default level");
 			shca->hw_level = 0x22;
 		}
-	}
+	} else
+		shca->hw_level = ehca_hw_level;
 	ehca_gen_dbg(" ... hardware level=%x", shca->hw_level);
 
 	shca->sport[0].rate = IB_RATE_30_GBPS;
-- 
1.5.2


