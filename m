Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZG1PIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZG1PIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZG1PIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:08:47 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:9607 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375AbZG1PIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:08:44 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAR-02-6PF-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 09/20] amd64_edac: cleanup/complete NB MCE decoding
Date: Tue, 28 Jul 2009 17:06:09 +0200
Message-ID: <1248793580-29899-10-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:26.0504 (UTC) FILETIME=[FA752C80:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* don't dump info which mcheck already does
* update to newest BKDG
* mv amd64_process_error_info -> amd64_decode_nb_mce
* shorten error struct names
* remove redundant info ptr in amd64_process_error_info
* remove unused ErrorCodeExt[19:16] (MCx_STATUS) defines

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |  125 +++++++++++++++--------------------------
 drivers/edac/amd64_edac.h     |   26 ++------
 drivers/edac/amd64_edac_dbg.c |    2 +-
 drivers/edac/edac_mce_amd.h   |    2 +
 4 files changed, 56 insertions(+), 99 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a0afaa8..455d143 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2353,62 +2353,47 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 					  "Error Overflow set");
 }
 
-int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct err_regs *regs,
-			     int handle_errors)
+void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
+			 int handle_errors)
 {
-	struct amd64_pvt *pvt;
-	u32 err_code, ext_ec;
-	int gart_tlb_error = 0;
-
-	pvt = mci->pvt_info;
+	struct amd64_pvt *pvt = mci->pvt_info;
+	int ecc;
+	u32 ec  = ERROR_CODE(regs->nbsl);
+	u32 xec = EXT_ERROR_CODE(regs->nbsl);
 
 	if (!handle_errors)
-		return 1;
+		return;
 
-	debugf1("NorthBridge ERROR: mci(0x%p)\n", mci);
-	debugf1("  MC node(%d) Error-Address(0x%.8x-%.8x)\n",
-		pvt->mc_node_id, regs->nbeah, regs->nbeal);
-	debugf1("  nbsh(0x%.8x) nbsl(0x%.8x)\n",
-		regs->nbsh, regs->nbsl);
-	debugf1("  Valid Error=%s Overflow=%s\n",
-		(regs->nbsh & K8_NBSH_VALID_BIT) ? "True" : "False",
-		(regs->nbsh & K8_NBSH_OVERFLOW) ? "True" : "False");
-	debugf1("  Err Uncorrected=%s MCA Error Reporting=%s\n",
-		(regs->nbsh & K8_NBSH_UNCORRECTED_ERR) ?
-			"True" : "False",
-		(regs->nbsh & K8_NBSH_ERR_ENABLE) ?
-			"True" : "False");
-	debugf1("  MiscErr Valid=%s ErrAddr Valid=%s PCC=%s\n",
-		(regs->nbsh & K8_NBSH_MISC_ERR_VALID) ?
-			"True" : "False",
-		(regs->nbsh & K8_NBSH_VALID_ERROR_ADDR) ?
-			"True" : "False",
-		(regs->nbsh & K8_NBSH_PCC) ?
-			"True" : "False");
-	debugf1("  CECC=%s UECC=%s Found by Scruber=%s\n",
-		(regs->nbsh & K8_NBSH_CECC) ?
-			"True" : "False",
-		(regs->nbsh & K8_NBSH_UECC) ?
-			"True" : "False",
-		(regs->nbsh & K8_NBSH_ERR_SCRUBER) ?
-			"True" : "False");
-	debugf1("  CORE0=%s CORE1=%s CORE2=%s CORE3=%s\n",
-		(regs->nbsh & K8_NBSH_CORE0) ? "True" : "False",
-		(regs->nbsh & K8_NBSH_CORE1) ? "True" : "False",
-		(regs->nbsh & K8_NBSH_CORE2) ? "True" : "False",
-		(regs->nbsh & K8_NBSH_CORE3) ? "True" : "False");
+	pr_emerg(" Northbridge ERROR, mc node %d", pvt->mc_node_id);
 
+	/*
+	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
+	 * value encoding has changed so interpret those differently
+	 */
+	if ((boot_cpu_data.x86 == 0x10) &&
+	    (boot_cpu_data.x86_model > 8)) {
+		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
+			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
+	} else {
+		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
+	}
 
-	err_code = ERROR_CODE(regs->nbsl);
+	pr_emerg(" Error: %sorrected",
+		 ((regs->nbsh & K8_NBSH_UC_ERR) ? "Unc" : "C"));
+	pr_cont(", Report Error: %s",
+		 ((regs->nbsh & K8_NBSH_ERR_EN) ? "yes" : "no"));
+	pr_cont(", MiscV: %svalid, CPU context corrupt: %s",
+		((regs->nbsh & K8_NBSH_MISCV) ? "" : "In"),
+		((regs->nbsh & K8_NBSH_PCC)   ? "yes" : "no"));
 
-	/* Determine which error type:
-	 *	1) GART errors - non-fatal, developmental events
-	 *	2) MEMORY errors
-	 *	3) BUS errors
-	 *	4) Unknown error
-	 */
-	if (TLB_ERROR(err_code)) {
+	/* do the two bits[14:13] together */
+	ecc = regs->nbsh & (0x3 << 13);
+	if (ecc)
+		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("\n");
+
+	if (TLB_ERROR(ec)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
 		 * to detect bad GART PTEs. It is recommended by AMD to disable
@@ -2421,52 +2406,34 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 		 * [1] section 13.10.1 on BIOS and Kernel Developers Guide for
 		 *     AMD NPT family 0Fh processors
 		 */
-		if (report_gart_errors == 0)
-			return 1;
-
-		/*
-		 * Only if GART error reporting is requested should we generate
-		 * any logs.
-		 */
-		gart_tlb_error = 1;
+		if (!report_gart_errors)
+			return;
 
-		debugf1("GART TLB error\n");
+		pr_emerg("GART TLB error\n");
 		amd64_decode_gart_tlb_error(mci, regs);
-	} else if (MEM_ERROR(err_code)) {
-		debugf1("Memory/Cache error\n");
+	} else if (MEM_ERROR(ec)) {
+		pr_emerg("Memory/Cache error\n");
 		amd64_decode_mem_cache_error(mci, regs);
-	} else if (BUS_ERROR(err_code)) {
-		debugf1("Bus (Link/DRAM) error\n");
+	} else if (BUS_ERROR(ec)) {
+		pr_emerg("Bus (Link/DRAM) error\n");
 		amd64_decode_bus_error(mci, regs);
 	} else {
 		/* shouldn't reach here! */
 		amd64_mc_printk(mci, KERN_WARNING,
 			     "%s(): unknown MCE error 0x%x\n", __func__,
-			     err_code);
+			     ec);
 	}
 
-	ext_ec = EXT_ERROR_CODE(regs->nbsl);
-	amd64_mc_printk(mci, KERN_ERR,
-		"ExtErr=(0x%x) %s\n", ext_ec, ext_msgs[ext_ec]);
+	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
 
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
 	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
 	 * If it was a GART error, skip that process.
 	 */
-	if (regs->nbsh & K8_NBSH_UNCORRECTED_ERR) {
-		amd64_mc_printk(mci, KERN_CRIT, "uncorrected error\n");
-		if (!gart_tlb_error)
-			edac_mc_handle_ue_no_info(mci, "UE bit is set\n");
-	}
-
-	if (regs->nbsh & K8_NBSH_PCC)
-		amd64_mc_printk(mci, KERN_CRIT,
-			"PCC (processor context corrupt) set\n");
-
-	return 1;
+	if (regs->nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
+		edac_mc_handle_ue_no_info(mci, "UE bit is set");
 }
-EXPORT_SYMBOL_GPL(amd64_process_error_info);
 
 /*
  * The main polling 'check' function, called FROM the edac core to perform the
@@ -2477,7 +2444,7 @@ static void amd64_check(struct mem_ctl_info *mci)
 	struct err_regs regs;
 
 	if (amd64_get_error_info(mci, &regs))
-		amd64_process_error_info(mci, &regs, 1);
+		amd64_decode_nb_mce(mci, &regs, 1);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index bde8f78..ecab0c9 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -306,16 +306,7 @@ enum {
 
 /* Family F10h: Normalized Extended Error Codes */
 #define F10_NBSL_EXT_ERR_RES		0x0
-#define F10_NBSL_EXT_ERR_CRC		0x1
-#define F10_NBSL_EXT_ERR_SYNC		0x2
-#define F10_NBSL_EXT_ERR_MST		0x3
-#define F10_NBSL_EXT_ERR_TGT		0x4
-#define F10_NBSL_EXT_ERR_GART		0x5
-#define F10_NBSL_EXT_ERR_RMW		0x6
-#define F10_NBSL_EXT_ERR_WDT		0x7
 #define F10_NBSL_EXT_ERR_ECC		0x8
-#define F10_NBSL_EXT_ERR_DEV		0x9
-#define F10_NBSL_EXT_ERR_LINK_DATA	0xA
 
 /* Next two are overloaded values */
 #define F10_NBSL_EXT_ERR_LINK_PROTO	0xB
@@ -360,18 +351,15 @@ enum {
 
 #define K8_NBSH_VALID_BIT		BIT(31)
 #define K8_NBSH_OVERFLOW		BIT(30)
-#define K8_NBSH_UNCORRECTED_ERR		BIT(29)
-#define K8_NBSH_ERR_ENABLE		BIT(28)
-#define K8_NBSH_MISC_ERR_VALID		BIT(27)
+#define K8_NBSH_UC_ERR			BIT(29)
+#define K8_NBSH_ERR_EN			BIT(28)
+#define K8_NBSH_MISCV			BIT(27)
 #define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
 #define K8_NBSH_PCC			BIT(25)
+#define K8_NBSH_ERR_CPU_VAL		BIT(24)
 #define K8_NBSH_CECC			BIT(14)
 #define K8_NBSH_UECC			BIT(13)
 #define K8_NBSH_ERR_SCRUBER		BIT(8)
-#define K8_NBSH_CORE3			BIT(3)
-#define K8_NBSH_CORE2			BIT(2)
-#define K8_NBSH_CORE1			BIT(1)
-#define K8_NBSH_CORE0			BIT(0)
 
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
 
@@ -622,8 +610,8 @@ static inline struct low_ops *family_ops(int index)
 #define F10_MIN_SCRUB_RATE_BITS	0x5
 #define F11_MIN_SCRUB_RATE_BITS	0x6
 
-int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct err_regs *info,
-			     int handle_errors);
+void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *info,
+			int handle_errors);
+
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index 0a41b24..bcb4e2e 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -24,7 +24,7 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 
 		/* Process the Mapping request */
 		/* TODO: Add race prevention */
-		amd64_process_error_info(mci, &pvt->ctl_error_info, 1);
+		amd64_decode_nb_mce(mci, &pvt->ctl_error_info, 1);
 
 		return count;
 	}
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index aea3863..38c2bc4 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -1,5 +1,7 @@
 #define ERROR_CODE(x)			((x) & 0xffff)
 #define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define EXT_ERR_MSG(x)			ext_msgs[EXT_ERROR_CODE(x)]
+
 #define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
 #define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
 
-- 
1.6.3.3


