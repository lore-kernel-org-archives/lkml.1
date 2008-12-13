Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYLMXCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYLMXCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYLMXCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:02:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:55139 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYLMXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:02:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bx2KtJ0N1tbAffC5tF+agAq3fNekSSZj6voVpME8Ey5WAGH1yi7oETKk/rAN1+ZnM2
         EgqPriXaLNjS/fL1YvlfsravmgGWRk7Ct9m0bvkQ7Ntac0NaXOUpcKcpScjGn84jVumu
         UFSRSj+ERmCt4/WbsM07SX8uw9LSH1nVBDpxA=
Subject: [PATCH 2/4] ieee1394: replace CSR_SET_BUS_INFO_GENERATION macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:02:21 -0800
Message-Id: <1229209341.11257.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/csr.h   |   10 +++++-----
 drivers/ieee1394/hosts.c |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ieee1394/csr.h b/drivers/ieee1394/csr.h
index f115465..90fb3f2 100644
--- a/drivers/ieee1394/csr.h
+++ b/drivers/ieee1394/csr.h
@@ -50,11 +50,11 @@
 #define CSR_MAX_ROM_SHIFT		8
 #define CSR_GENERATION_SHIFT		4
 
-#define CSR_SET_BUS_INFO_GENERATION(csr, gen)				\
-	((csr)->bus_info_data[2] =					\
-		cpu_to_be32((be32_to_cpu((csr)->bus_info_data[2]) &	\
-			     ~(0xf << CSR_GENERATION_SHIFT)) |		\
-			    (gen) << CSR_GENERATION_SHIFT))
+static inline void csr_set_bus_info_generation(struct csr1212_csr *csr, u8 gen)
+{
+	csr->bus_info_data[2] &= ~cpu_to_be32(0xf << CSR_GENERATION_SHIFT);
+	csr->bus_info_data[2] |= cpu_to_be32((u32)gen << CSR_GENERATION_SHIFT);
+}
 
 struct csr_control {
 	spinlock_t lock;
diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
index 237d0c9..e947d8f 100644
--- a/drivers/ieee1394/hosts.c
+++ b/drivers/ieee1394/hosts.c
@@ -34,18 +34,18 @@ static void delayed_reset_bus(struct work_struct *work)
 {
 	struct hpsb_host *host =
 		container_of(work, struct hpsb_host, delayed_reset.work);
-	int generation = host->csr.generation + 1;
+	u8 generation = host->csr.generation + 1;
 
 	/* The generation field rolls over to 2 rather than 0 per IEEE
 	 * 1394a-2000. */
 	if (generation > 0xf || generation < 2)
 		generation = 2;
 
-	CSR_SET_BUS_INFO_GENERATION(host->csr.rom, generation);
+	csr_set_bus_info_generation(host->csr.rom, generation);
 	if (csr1212_generate_csr_image(host->csr.rom) != CSR1212_SUCCESS) {
 		/* CSR image creation failed.
 		 * Reset generation field and do not issue a bus reset. */
-		CSR_SET_BUS_INFO_GENERATION(host->csr.rom,
+		csr_set_bus_info_generation(host->csr.rom,
 					    host->csr.generation);
 		return;
 	}
-- 
1.6.1.rc2.306.ge5d5e


