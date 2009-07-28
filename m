Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZG1PJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZG1PJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZG1PJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:09:04 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:41816 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754362AbZG1PJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:09:01 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1402Izz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNHZAQ-04-4GX-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 13/20] EDAC, AMD: carve out MCi_STATUS decoding
Date: Tue, 28 Jul 2009 17:06:13 +0200
Message-ID: <1248793580-29899-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:28.0269 (UTC) FILETIME=[FB827DD0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCi_STATUS registers have most field definitions in common so decode
them in the general path. Do not pass ecc_type along and compute it in
__amd64_decode_bus_error instead.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c   |    8 +++---
 drivers/edac/edac_mce_amd.c |   55 +++++++++++++++++++++----------------------
 drivers/edac/edac_mce_amd.h |    2 +-
 3 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 776d761..2684392 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2281,10 +2281,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 }
 
 static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
-					    struct err_regs *info, int ecc_type)
+					    struct err_regs *info)
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
+	int ecc_type = info->nbsh & (0x3 << 13);
 
 	pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, %s\n",
 		 RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec), PP_MSG(ec));
@@ -2314,12 +2315,11 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR "Error Overflow");
 }
 
-void amd64_decode_bus_error(int node_id, struct err_regs *regs,
-				   int ecc_type)
+void amd64_decode_bus_error(int node_id, struct err_regs *regs)
 {
 	struct mem_ctl_info *mci = mci_lookup[node_id];
 
-	__amd64_decode_bus_error(mci, regs, ecc_type);
+	__amd64_decode_bus_error(mci, regs);
 
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index ef18880..499af60 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -2,7 +2,7 @@
 #include "edac_mce_amd.h"
 
 static bool report_gart_errors;
-static void (*nb_bus_decoder)(int node_id, struct err_regs *regs, int ecc_type);
+static void (*nb_bus_decoder)(int node_id, struct err_regs *regs);
 
 void amd_report_gart_errors(bool v)
 {
@@ -10,7 +10,7 @@ void amd_report_gart_errors(bool v)
 }
 EXPORT_SYMBOL_GPL(amd_report_gart_errors);
 
-void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *, int))
+void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *))
 {
 	nb_bus_decoder = f;
 }
@@ -120,7 +120,6 @@ EXPORT_SYMBOL_GPL(ext_msgs);
 
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
-	int ecc;
 	u32 ec  = ERROR_CODE(regs->nbsl);
 	u32 xec = EXT_ERROR_CODE(regs->nbsl);
 
@@ -141,21 +140,6 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
 	}
 
-	pr_emerg(" Error: %sorrected",
-		 ((regs->nbsh & K8_NBSH_UC_ERR) ? "Unc" : "C"));
-	pr_cont(", Report Error: %s",
-		 ((regs->nbsh & K8_NBSH_ERR_EN) ? "yes" : "no"));
-	pr_cont(", MiscV: %svalid, CPU context corrupt: %s",
-		((regs->nbsh & K8_NBSH_MISCV) ? "" : "In"),
-		((regs->nbsh & K8_NBSH_PCC)   ? "yes" : "no"));
-
-	/* do the two bits[14:13] together */
-	ecc = regs->nbsh & (0x3 << 13);
-	if (ecc)
-		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
-
-	pr_cont("\n");
-
 	if (TLB_ERROR(ec)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
@@ -181,7 +165,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	} else if (BUS_ERROR(ec)) {
 		pr_emerg(" Bus (Link/DRAM) error\n");
 		if (nb_bus_decoder)
-			nb_bus_decoder(node_id, regs, ecc);
+			nb_bus_decoder(node_id, regs);
 	} else {
 		/* shouldn't reach here! */
 		pr_warning("%s: unknown MCE error 0x%x\n", __func__, ec);
@@ -194,16 +178,31 @@ EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 void decode_mce(struct mce *m)
 {
 	struct err_regs regs;
-	int node;
+	int node, ecc;
 
-	if (m->bank != 4)
-		return;
+	pr_emerg("MC%d_STATUS:\n", m->bank);
 
-	regs.nbsl  = (u32) m->status;
-	regs.nbsh  = (u32)(m->status >> 32);
-	regs.nbeal = (u32) m->addr;
-	regs.nbeah = (u32)(m->addr >> 32);
-	node       = cpu_data(m->extcpu).cpu_node_id;
+	pr_emerg(" Error: %sorrected, Report: %s, MiscV: %svalid, "
+		 "CPU context corrupt: %s",
+		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
+		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
+		 ((m->status & MCI_STATUS_MISCV) ? ""  : "in"),
+		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
 
-	amd_decode_nb_mce(node, &regs, 1);
+	/* do the two bits[14:13] together */
+	ecc = m->status & (3ULL << 45);
+	if (ecc)
+		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("\n");
+
+	if (m->bank == 4) {
+		regs.nbsl  = (u32) m->status;
+		regs.nbsh  = (u32)(m->status >> 32);
+		regs.nbeal = (u32) m->addr;
+		regs.nbeah = (u32)(m->addr >> 32);
+		node       = cpu_data(m->extcpu).cpu_node_id;
+
+		amd_decode_nb_mce(node, &regs, 1);
+	}
 }
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index 3825697..8651962 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -62,7 +62,7 @@ struct err_regs {
 
 
 void amd_report_gart_errors(bool);
-void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *, int));
+void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *));
 void amd_decode_nb_mce(int, struct err_regs *, int);
 
 #endif /* _EDAC_MCE_AMD_H */
-- 
1.6.3.3


