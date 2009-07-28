Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZG1PGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZG1PGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZG1PGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:46 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57779 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZG1PGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:41 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1402Izz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAR-04-4GY-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 14/20] EDAC, AMD: carve out decoding of MCi_STATUS ErrorCode
Date: Tue, 28 Jul 2009 17:06:14 +0200
Message-ID: <1248793580-29899-15-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:28.0660 (UTC) FILETIME=[FBBE2740:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MCE error code from the MCi_STATUS banks, bits [15:0] which
describe what type of error was encountered: GART TLB, Memory or Bus
error. The semantics of those bits are identical across all MCE banks so
decode those separately, irrespectively of MCE type.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c   |    4 ----
 drivers/edac/edac_mce_amd.c |   37 ++++++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2684392..69c8e6d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2287,10 +2287,6 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
 	int ecc_type = info->nbsh & (0x3 << 13);
 
-	pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, %s\n",
-		 RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec), PP_MSG(ec));
-
-
 	/* Bail early out if this was an 'observed' error */
 	if (PP(ec) == K8_NBSL_PP_OBS)
 		return;
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 499af60..e332da0 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -140,6 +140,16 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
 	}
 
+
+	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
+
+	if (BUS_ERROR(ec) && nb_bus_decoder)
+		nb_bus_decoder(node_id, regs);
+}
+EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
+
+static inline void amd_decode_err_code(unsigned int ec)
+{
 	if (TLB_ERROR(ec)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
@@ -156,33 +166,28 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		if (!report_gart_errors)
 			return;
 
-		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
+		pr_emerg(" Transaction: %s, Cache Level %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
-			 " Cache Level: %s",
+		pr_emerg(" Transaction: %s, Type: %s, Cache Level: %s",
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg(" Bus (Link/DRAM) error\n");
-		if (nb_bus_decoder)
-			nb_bus_decoder(node_id, regs);
-	} else {
-		/* shouldn't reach here! */
-		pr_warning("%s: unknown MCE error 0x%x\n", __func__, ec);
-	}
-
-	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
+		pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, "
+			 "Participating Processor: %s\n",
+			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
+			  PP_MSG(ec));
+	} else
+		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 }
-EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
 void decode_mce(struct mce *m)
 {
 	struct err_regs regs;
 	int node, ecc;
 
-	pr_emerg("MC%d_STATUS:\n", m->bank);
+	pr_emerg("MC%d_STATUS: ", m->bank);
 
-	pr_emerg(" Error: %sorrected, Report: %s, MiscV: %svalid, "
+	pr_cont("%sorrected error, report: %s, MiscV: %svalid, "
 		 "CPU context corrupt: %s",
 		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
 		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
@@ -196,6 +201,8 @@ void decode_mce(struct mce *m)
 
 	pr_cont("\n");
 
+	amd_decode_err_code(m->status & 0xffff);
+
 	if (m->bank == 4) {
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


