Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZGTQOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZGTQOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZGTQOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:14:18 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57533 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZGTQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:14:13 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KN3920-04-7DX-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 03/14] amd64_edac: cleanup/complete NB MCE decoding
Date: Mon, 20 Jul 2009 18:12:54 +0200
Message-ID: <1248106385-27514-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:12.0046 (UTC) FILETIME=[FAA460E0:01CA0954]
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

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |  110 +++++++++++++++--------------------------
 drivers/edac/amd64_edac.h     |   17 +++----
 drivers/edac/amd64_edac_dbg.c |    2 +-
 3 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 844effd..591d28d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2296,61 +2296,47 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 					  "Error Overflow set");
 }
 
-int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct err_regs *regs,
-			     int handle_errors)
+void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
+			 int handle_errors)
 {
-	struct amd64_pvt *pvt;
+	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 err_code, ext_ec;
-	int gart_tlb_error = 0;
-
-	pvt = mci->pvt_info;
+	int ecc;
 
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
+
+	pr_emerg(" Error: %sorrected",
+		 ((regs->nbsh & K8_NBSH_UC_ERR) ? "Unc" : "C"));
+	pr_cont(", Report Error: %s",
+		 ((regs->nbsh & K8_NBSH_ERR_EN) ? "yes" : "no"));
+	pr_cont(", MiscV: %svalid, CPU context corrupt: %s",
+		((regs->nbsh & K8_NBSH_MISCV) ? "" : "In"),
+		((regs->nbsh & K8_NBSH_PCC)   ? "yes" : "no"));
+
+	/* do the two bits[14:13] together */
+	ecc = regs->nbsh & (0x3 << 13);
+	if (ecc)
+		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("\n");
 
 	err_code = ERROR_CODE(regs->nbsl);
 
-	/* Determine which error type:
-	 *	1) GART errors - non-fatal, developmental events
-	 *	2) MEMORY errors
-	 *	3) BUS errors
-	 *	4) Unknown error
-	 */
 	if (TLB_ERROR(err_code)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
@@ -2364,22 +2350,16 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
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
 	} else if (MEM_ERROR(err_code)) {
-		debugf1("Memory/Cache error\n");
+		pr_emerg("Memory/Cache error\n");
 		amd64_decode_mem_cache_error(mci, regs);
 	} else if (BUS_ERROR(err_code)) {
-		debugf1("Bus (Link/DRAM) error\n");
+		pr_emerg("Bus (Link/DRAM) error\n");
 		amd64_decode_bus_error(mci, regs);
 	} else {
 		/* shouldn't reach here! */
@@ -2408,19 +2388,9 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
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
@@ -2431,7 +2401,7 @@ static void amd64_check(struct mem_ctl_info *mci)
 	struct err_regs regs;
 
 	if (amd64_get_error_info(mci, &regs))
-		amd64_process_error_info(mci, &regs, 1);
+		amd64_decode_nb_mce(mci, &regs, 1);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index c85a5e7..a75ba80 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -374,18 +374,15 @@ enum {
 
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
 
 #define EXTRACT_LDT_LINK(x)		(((x) >> 4) & 0x7)
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
@@ -637,8 +634,8 @@ static inline struct low_ops *family_ops(int index)
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
-- 
1.6.3.3


