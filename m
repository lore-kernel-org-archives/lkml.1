Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZGTQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZGTQNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZGTQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:47 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:21818
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752602AbZGTQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:38 -0400
X-SpamScore: 2
X-BigFish: VPS2(zz1402Izz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KN3922-03-AIN-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 09/14] amd64_edac: carve out decoding of MCi_STATUS ErrorCode
Date: Mon, 20 Jul 2009 18:13:00 +0200
Message-ID: <1248106385-27514-10-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:14.0312 (UTC) FILETIME=[FBFE2480:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MCE error code from the MCi_STATUS banks, bits [15:0] which
describe what type of error was encountered: GART TLB, Memory or Bus
related. The semantics of those bits are the same across all MCE banks
so decode those separately, irrespectively of MCE type.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   56 +++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a691bb8..e4a0c91 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2229,9 +2229,6 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
 
-	pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, %s\n",
-		 RRRR(ec), II(ec), TO(ec), LL(ec), PP(ec));
-
 	/* Bail early out if this was an 'observed' error */
 	if (((ec >> 9) & 0x3) == K8_NBSL_PP_OBS)
 		return;
@@ -2260,7 +2257,8 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u32 ec, xec;
+	u32 ec  = ERROR_CODE(regs->nbsl);
+	u32 xec = EXT_ERROR_CODE(regs->nbsl);
 
 	if (!handle_errors)
 		return;
@@ -2279,9 +2277,22 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
 	}
 
-	ec = ERROR_CODE(regs->nbsl);
-	xec = EXT_ERROR_CODE(regs->nbsl);
+	pr_emerg(" %s.\n", EXT_ERR_DESC(xec));
+
+	if (BUS_ERROR(ec))
+		amd64_decode_bus_error(mci, regs, ecc);
 
+	/*
+	 * Check the UE bit of the NB status high register, if set generate some
+	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
+	 * If it was a GART error, skip that process.
+	 */
+	if (regs->nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
+		edac_mc_handle_ue_no_info(mci, "UE bit is set");
+}
+
+static inline void amd64_decode_err_code(unsigned int ec)
+{
 	if (TLB_ERROR(ec)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
@@ -2298,30 +2309,19 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		if (!report_gart_errors)
 			return;
 
-		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
-			 TT(ec), LL(ec));
+		pr_emerg(" Transaction: %s, Cache Level %s\n", TT(ec), LL(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
-			 " Cache Level: %s",
+		pr_emerg(" Transaction: %s, Type: %s, Cache Level: %s",
 			 RRRR(ec), TT(ec), LL(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg(" Bus (Link/DRAM) error\n");
-		amd64_decode_bus_error(mci, regs, ecc);
+		pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s,"
+			 " Participating Processor: %s\n",
+			 RRRR(ec), II(ec), TO(ec), LL(ec), PP(ec));
+
 	} else {
 		/* shouldn't reach here! */
-		amd64_mc_printk(mci, KERN_WARNING,
-				"%s(): unknown MCE error 0x%x\n", __func__, ec);
+		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 	}
-
-	pr_emerg("%s.\n", EXT_ERR_DESC(xec));
-
-	/*
-	 * Check the UE bit of the NB status high register, if set generate some
-	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
-	 * If it was a GART error, skip that process.
-	 */
-	if (regs->nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
-		edac_mc_handle_ue_no_info(mci, "UE bit is set");
 }
 
 void decode_mce(struct mce *m)
@@ -2329,13 +2329,13 @@ void decode_mce(struct mce *m)
 	struct err_regs regs;
 	int ecc;
 
-	pr_emerg("MC%d_STATUS:\n", m->bank);
+	pr_emerg("MC%d_STATUS: ", m->bank);
 
-	pr_emerg(" Error: %sorrected, Report: %s, MiscV: %svalid, "
+	pr_cont("%sorrected error, report: %s, MiscV: %svalid, "
 		 "CPU context corrupt: %s",
 		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
 		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
-		 ((m->status & MCI_STATUS_MISCV) ? ""  : "In"),
+		 ((m->status & MCI_STATUS_MISCV) ? ""  : "in"),
 		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
 
 	/* do the two bits[14:13] together */
@@ -2345,6 +2345,8 @@ void decode_mce(struct mce *m)
 
 	pr_cont("\n");
 
+	amd64_decode_err_code(m->status & 0xffff);
+
 	if (m->bank == 4) {
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


