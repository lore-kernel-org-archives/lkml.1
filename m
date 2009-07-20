Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZGTQOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZGTQOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZGTQOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:14:07 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:1291 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751524AbZGTQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:14:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KN3920-04-7DY-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 06/14] amd64_edac: cleanup amd64_decode_bus_error
Date: Mon, 20 Jul 2009 18:12:57 +0200
Message-ID: <1248106385-27514-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:13.0187 (UTC) FILETIME=[FB527B30:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   36 +++++++++---------------------------
 1 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9db18c8..68c5e6b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2224,42 +2224,25 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
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
-		TO(ec), II(ec), PP(ec), RRRR(ec), LL(ec),
-		(info->nbsh & K8_NBSH_ERR_SCRUBER) ?
-			"Scrubber" : "Normal Operation");
-
+	pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, %s\n",
+		 RRRR(ec), II(ec), TO(ec), LL(ec), PP(ec));
 
 	/* Bail early out if this was an 'observed' error */
 	if (((ec >> 9) & 0x3) == K8_NBSL_PP_OBS)
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
+	if (xec != F10_NBSL_EXT_ERR_ECC)
 		return;
-	}
 
-	if (info->nbsh & K8_NBSH_CECC)
+	if (ecc_type == 2)
 		amd64_handle_ce(mci, info);
-	else if (info->nbsh & K8_NBSH_UECC)
+	else
 		amd64_handle_ue(mci, info);
 
 	/*
@@ -2270,8 +2253,7 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 	 * catastrophic.
 	 */
 	if (info->nbsh & K8_NBSH_OVERFLOW)
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR
-					  "Error Overflow set");
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR "Error Overflow");
 }
 
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
@@ -2340,7 +2322,7 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 RRRR(ec), TT(ec), LL(ec));
 	} else if (BUS_ERROR(ec)) {
 		pr_emerg(" Bus (Link/DRAM) error\n");
-		amd64_decode_bus_error(mci, regs);
+		amd64_decode_bus_error(mci, regs, ecc);
 	} else {
 		/* shouldn't reach here! */
 		amd64_mc_printk(mci, KERN_WARNING,
-- 
1.6.3.3


