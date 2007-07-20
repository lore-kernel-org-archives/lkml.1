Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXGTNvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXGTNvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXGTNvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:51:06 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41954 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbXGTNvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:51:03 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 3/5] ehca: Make ehca2ib_return_code() non-inline
Date: Fri, 20 Jul 2007 16:02:46 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201602.46415.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Fenkes <fenkes@de.ibm.com>
Date: Thu, 19 Jul 2007 21:13:57 +0200
Subject: [PATCH 3/5] IB/ehca: Make ehca2ib_return_code() non-inline

It's nowhere in the main path and making it non-inline saves ~1.5K of code.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c  |   17 +++++++++++++++++
 drivers/infiniband/hw/ehca/ehca_tools.h |   19 +------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 34661c3..3bd7afb 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -130,6 +130,23 @@ void ehca_free_fw_ctrlblock(void *ptr)
 }
 #endif
 
+int ehca2ib_return_code(u64 ehca_rc)
+{
+	switch (ehca_rc) {
+	case H_SUCCESS:
+		return 0;
+	case H_RESOURCE:             /* Resource in use */
+	case H_BUSY:
+		return -EBUSY;
+	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
+	case H_CONSTRAINED:          /* resource constraint */
+	case H_NO_MEM:
+		return -ENOMEM;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int ehca_create_slab_caches(void)
 {
 	int ret;
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 678b813..57c77a7 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -154,24 +154,7 @@ extern int ehca_debug_level;
 #define EHCA_BMASK_GET(mask, value) \
 	(EHCA_BMASK_MASK(mask) & (((u64)(value)) >> EHCA_BMASK_SHIFTPOS(mask)))
 
-
 /* Converts ehca to ib return code */
-static inline int ehca2ib_return_code(u64 ehca_rc)
-{
-	switch (ehca_rc) {
-	case H_SUCCESS:
-		return 0;
-	case H_RESOURCE:             /* Resource in use */
-	case H_BUSY:
-		return -EBUSY;
-	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
-	case H_CONSTRAINED:          /* resource constraint */
-	case H_NO_MEM:
-		return -ENOMEM;
-	default:
-		return -EINVAL;
-	}
-}
-
+int ehca2ib_return_code(u64 ehca_rc);
 
 #endif /* EHCA_TOOLS_H */
-- 
1.5.2


