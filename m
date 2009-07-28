Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZG1PJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZG1PJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZG1PJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:09:45 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:39735
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753778AbZG1PGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:43 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAQ-03-5WT-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 11/20] amd64_edac: cleanup amd64_decode_bus_error
Date: Tue, 28 Jul 2009 17:06:11 +0200
Message-ID: <1248793580-29899-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:27.0441 (UTC) FILETIME=[FB042610:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   35 +++++++++--------------------------
 1 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 298020e..dcc318e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2281,42 +2281,26 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 }
 
 static void amd64_decode_bus_error(struct mem_ctl_info *mci,
-				   struct err_regs *info)
+				   struct err_regs *info, int ecc_type)
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
 
-	amd64_mc_printk(mci, KERN_ERR,
-		"BUS ERROR:\n"
-		"  time-out(%s) mem or i/o(%s)\n"
-		"  participating processor(%s)\n"
-		"  memory transaction type(%s)\n"
-		"  cache level(%s) Error Found by: %s\n",
-		TO_MSG(ec), II_MSG(ec), PP_MSG(ec), RRRR_MSG(ec), LL_MSG(ec),
-		(info->nbsh & K8_NBSH_ERR_SCRUBER) ?
-			"Scrubber" : "Normal Operation");
+	pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, %s\n",
+		 RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec), PP_MSG(ec));
 
 
 	/* Bail early out if this was an 'observed' error */
 	if (PP(ec) == K8_NBSL_PP_OBS)
 		return;
 
-	/* Parse out the extended error code for ECC events */
-	switch (xec) {
-	/* F10 changed to one Extended ECC error code */
-	case F10_NBSL_EXT_ERR_RES:		/* Reserved field */
-	case F10_NBSL_EXT_ERR_ECC:		/* F10 ECC ext err code */
-		break;
-
-	default:
-		amd64_mc_printk(mci, KERN_ERR, "NOT ECC: no special error "
-					       "handling for this error\n");
+	/* Do only ECC errors */
+	if (xec && xec != F10_NBSL_EXT_ERR_ECC)
 		return;
-	}
 
-	if (info->nbsh & K8_NBSH_CECC)
+	if (ecc_type == 2)
 		amd64_handle_ce(mci, info);
-	else if (info->nbsh & K8_NBSH_UECC)
+	else if (ecc_type == 1)
 		amd64_handle_ue(mci, info);
 
 	/*
@@ -2327,8 +2311,7 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 	 * catastrophic.
 	 */
 	if (info->nbsh & K8_NBSH_OVERFLOW)
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR
-					  "Error Overflow set");
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR "Error Overflow");
 }
 
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
@@ -2395,7 +2378,7 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
 		pr_emerg(" Bus (Link/DRAM) error\n");
-		amd64_decode_bus_error(mci, regs);
+		amd64_decode_bus_error(mci, regs, ecc);
 	} else {
 		/* shouldn't reach here! */
 		amd64_mc_printk(mci, KERN_WARNING,
-- 
1.6.3.3


