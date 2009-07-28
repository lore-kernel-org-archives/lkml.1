Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZG1PG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZG1PG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZG1PG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:37621
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754153AbZG1PGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:53 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAR-04-4GZ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 12/20] x86, mce: pass mce info to EDAC for decoding
Date: Tue, 28 Jul 2009 17:06:12 +0200
Message-ID: <1248793580-29899-13-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:27.0863 (UTC) FILETIME=[FB448A70:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move NB decoder along with required defines to EDAC MCE core. Add
registration routines for further decoding of the MCE info in the AMD64
EDAC module.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    7 +++
 drivers/edac/amd64_edac.c        |   94 +++++++--------------------------
 drivers/edac/amd64_edac.h        |   36 -------------
 drivers/edac/amd64_edac_dbg.c    |    2 +-
 drivers/edac/edac_mce_amd.c      |  105 ++++++++++++++++++++++++++++++++++++++
 drivers/edac/edac_mce_amd.h      |   37 +++++++++++++
 6 files changed, 170 insertions(+), 111 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1cfb623..69e7d8e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -183,6 +183,11 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+void __attribute__((weak)) decode_mce(struct mce *m)
+{
+	return;
+}
+
 static void print_mce(struct mce *m)
 {
 	printk(KERN_EMERG
@@ -205,6 +210,8 @@ static void print_mce(struct mce *m)
 	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
+
+	decode_mce(m);
 }
 
 static void print_mce_head(void)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index dcc318e..776d761 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2280,8 +2280,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 	}
 }
 
-static void amd64_decode_bus_error(struct mem_ctl_info *mci,
-				   struct err_regs *info, int ecc_type)
+static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
+					    struct err_regs *info, int ecc_type)
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
@@ -2314,86 +2314,23 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR "Error Overflow");
 }
 
-void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
-			 int handle_errors)
+void amd64_decode_bus_error(int node_id, struct err_regs *regs,
+				   int ecc_type)
 {
-	struct amd64_pvt *pvt = mci->pvt_info;
-	int ecc;
-	u32 ec  = ERROR_CODE(regs->nbsl);
-	u32 xec = EXT_ERROR_CODE(regs->nbsl);
-
-	if (!handle_errors)
-		return;
+	struct mem_ctl_info *mci = mci_lookup[node_id];
 
-	pr_emerg(" Northbridge ERROR, mc node %d", pvt->mc_node_id);
-
-	/*
-	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
-	 * value encoding has changed so interpret those differently
-	 */
-	if ((boot_cpu_data.x86 == 0x10) &&
-	    (boot_cpu_data.x86_model > 8)) {
-		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
-			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
-	} else {
-		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
-	}
-
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
-	if (TLB_ERROR(ec)) {
-		/*
-		 * GART errors are intended to help graphics driver developers
-		 * to detect bad GART PTEs. It is recommended by AMD to disable
-		 * GART table walk error reporting by default[1] (currently
-		 * being disabled in mce_cpu_quirks()) and according to the
-		 * comment in mce_cpu_quirks(), such GART errors can be
-		 * incorrectly triggered. We may see these errors anyway and
-		 * unless requested by the user, they won't be reported.
-		 *
-		 * [1] section 13.10.1 on BIOS and Kernel Developers Guide for
-		 *     AMD NPT family 0Fh processors
-		 */
-		if (!report_gart_errors)
-			return;
-
-		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
-			 TT_MSG(ec), LL_MSG(ec));
-	} else if (MEM_ERROR(ec)) {
-		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
-			 " Cache Level: %s",
-			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
-	} else if (BUS_ERROR(ec)) {
-		pr_emerg(" Bus (Link/DRAM) error\n");
-		amd64_decode_bus_error(mci, regs, ecc);
-	} else {
-		/* shouldn't reach here! */
-		amd64_mc_printk(mci, KERN_WARNING,
-				"%s(): unknown MCE error 0x%x\n", __func__, ec);
-	}
-
-	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
+	__amd64_decode_bus_error(mci, regs, ecc_type);
 
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
 	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
 	 * If it was a GART error, skip that process.
+	 *
+	 * FIXME: this should go somewhere else, if at all.
 	 */
 	if (regs->nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
 		edac_mc_handle_ue_no_info(mci, "UE bit is set");
+
 }
 
 /*
@@ -2404,8 +2341,10 @@ static void amd64_check(struct mem_ctl_info *mci)
 {
 	struct err_regs regs;
 
-	if (amd64_get_error_info(mci, &regs))
-		amd64_decode_nb_mce(mci, &regs, 1);
+	if (amd64_get_error_info(mci, &regs)) {
+		struct amd64_pvt *pvt = mci->pvt_info;
+		amd_decode_nb_mce(pvt->mc_node_id, &regs, 1);
+	}
 }
 
 /*
@@ -3096,6 +3035,13 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 
 	mci_lookup[node_id] = mci;
 	pvt_lookup[node_id] = NULL;
+
+	/* register stuff with EDAC MCE */
+	if (report_gart_errors)
+		amd_report_gart_errors(true);
+
+	amd_set_nb_bus_decoder(amd64_decode_bus_error);
+
 	return 0;
 
 err_add_mc:
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ecab0c9..8ea07e2 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -346,24 +346,8 @@ enum {
 #define K8_NBSL_PP_OBS			0x2
 #define K8_NBSL_PP_GENERIC		0x3
 
-
-#define K8_NBSH				0x4C
-
-#define K8_NBSH_VALID_BIT		BIT(31)
-#define K8_NBSH_OVERFLOW		BIT(30)
-#define K8_NBSH_UC_ERR			BIT(29)
-#define K8_NBSH_ERR_EN			BIT(28)
-#define K8_NBSH_MISCV			BIT(27)
-#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
-#define K8_NBSH_PCC			BIT(25)
-#define K8_NBSH_ERR_CPU_VAL		BIT(24)
-#define K8_NBSH_CECC			BIT(14)
-#define K8_NBSH_UECC			BIT(13)
-#define K8_NBSH_ERR_SCRUBER		BIT(8)
-
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
 
-
 #define K8_NBEAL			0x50
 #define K8_NBEAH			0x54
 #define K8_SCRCTRL			0x58
@@ -428,23 +412,6 @@ enum amd64_chipset_families {
 	F11_CPUS,
 };
 
-/*
- * Structure to hold:
- *
- * 1) dynamically read status and error address HW registers
- * 2) sysfs entered values
- * 3) MCE values
- *
- * Depends on entry into the modules
- */
-struct err_regs {
-	u32 nbcfg;
-	u32 nbsh;
-	u32 nbsl;
-	u32 nbeah;
-	u32 nbeal;
-};
-
 /* Error injection control structure */
 struct error_injection {
 	u32	section;
@@ -610,8 +577,5 @@ static inline struct low_ops *family_ops(int index)
 #define F10_MIN_SCRUB_RATE_BITS	0x5
 #define F11_MIN_SCRUB_RATE_BITS	0x6
 
-void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *info,
-			int handle_errors);
-
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index bcb4e2e..59cf2cf 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -24,7 +24,7 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 
 		/* Process the Mapping request */
 		/* TODO: Add race prevention */
-		amd64_decode_nb_mce(mci, &pvt->ctl_error_info, 1);
+		amd_decode_nb_mce(pvt->mc_node_id, &pvt->ctl_error_info, 1);
 
 		return count;
 	}
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 918567e..ef18880 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -1,6 +1,21 @@
 #include <linux/module.h>
 #include "edac_mce_amd.h"
 
+static bool report_gart_errors;
+static void (*nb_bus_decoder)(int node_id, struct err_regs *regs, int ecc_type);
+
+void amd_report_gart_errors(bool v)
+{
+	report_gart_errors = v;
+}
+EXPORT_SYMBOL_GPL(amd_report_gart_errors);
+
+void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *, int))
+{
+	nb_bus_decoder = f;
+}
+EXPORT_SYMBOL_GPL(amd_set_nb_bus_decoder);
+
 /*
  * string representation for the different MCA reported error types, see F3x48
  * or MSR0000_0411.
@@ -102,3 +117,93 @@ const char *ext_msgs[] = {
 	"Probe Filter error"				/* 1_1111b */
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
+
+void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
+{
+	int ecc;
+	u32 ec  = ERROR_CODE(regs->nbsl);
+	u32 xec = EXT_ERROR_CODE(regs->nbsl);
+
+	if (!handle_errors)
+		return;
+
+	pr_emerg(" Northbridge Error, node %d", node_id);
+
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
+
+	if (TLB_ERROR(ec)) {
+		/*
+		 * GART errors are intended to help graphics driver developers
+		 * to detect bad GART PTEs. It is recommended by AMD to disable
+		 * GART table walk error reporting by default[1] (currently
+		 * being disabled in mce_cpu_quirks()) and according to the
+		 * comment in mce_cpu_quirks(), such GART errors can be
+		 * incorrectly triggered. We may see these errors anyway and
+		 * unless requested by the user, they won't be reported.
+		 *
+		 * [1] section 13.10.1 on BIOS and Kernel Developers Guide for
+		 *     AMD NPT family 0Fh processors
+		 */
+		if (!report_gart_errors)
+			return;
+
+		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
+			 TT_MSG(ec), LL_MSG(ec));
+	} else if (MEM_ERROR(ec)) {
+		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
+			 " Cache Level: %s",
+			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
+	} else if (BUS_ERROR(ec)) {
+		pr_emerg(" Bus (Link/DRAM) error\n");
+		if (nb_bus_decoder)
+			nb_bus_decoder(node_id, regs, ecc);
+	} else {
+		/* shouldn't reach here! */
+		pr_warning("%s: unknown MCE error 0x%x\n", __func__, ec);
+	}
+
+	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
+}
+EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
+
+void decode_mce(struct mce *m)
+{
+	struct err_regs regs;
+	int node;
+
+	if (m->bank != 4)
+		return;
+
+	regs.nbsl  = (u32) m->status;
+	regs.nbsh  = (u32)(m->status >> 32);
+	regs.nbeal = (u32) m->addr;
+	regs.nbeah = (u32)(m->addr >> 32);
+	node       = cpu_data(m->extcpu).cpu_node_id;
+
+	amd_decode_nb_mce(node, &regs, 1);
+}
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index 38c2bc4..3825697 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -1,3 +1,8 @@
+#ifndef _EDAC_MCE_AMD_H
+#define _EDAC_MCE_AMD_H
+
+#include <asm/mce.h>
+
 #define ERROR_CODE(x)			((x) & 0xffff)
 #define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
 #define EXT_ERR_MSG(x)			ext_msgs[EXT_ERROR_CODE(x)]
@@ -22,6 +27,20 @@
 #define	PP(x)				(((x) >> 9) & 0x3)
 #define	PP_MSG(x)			pp_msgs[PP(x)]
 
+#define K8_NBSH				0x4C
+
+#define K8_NBSH_VALID_BIT		BIT(31)
+#define K8_NBSH_OVERFLOW		BIT(30)
+#define K8_NBSH_UC_ERR			BIT(29)
+#define K8_NBSH_ERR_EN			BIT(28)
+#define K8_NBSH_MISCV			BIT(27)
+#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
+#define K8_NBSH_PCC			BIT(25)
+#define K8_NBSH_ERR_CPU_VAL		BIT(24)
+#define K8_NBSH_CECC			BIT(14)
+#define K8_NBSH_UECC			BIT(13)
+#define K8_NBSH_ERR_SCRUBER		BIT(8)
+
 extern const char *tt_msgs[];
 extern const char *ll_msgs[];
 extern const char *rrrr_msgs[];
@@ -29,3 +48,21 @@ extern const char *pp_msgs[];
 extern const char *to_msgs[];
 extern const char *ii_msgs[];
 extern const char *ext_msgs[];
+
+/*
+ * relevant NB regs
+ */
+struct err_regs {
+	u32 nbcfg;
+	u32 nbsh;
+	u32 nbsl;
+	u32 nbeah;
+	u32 nbeal;
+};
+
+
+void amd_report_gart_errors(bool);
+void amd_set_nb_bus_decoder(void (*f)(int, struct err_regs *, int));
+void amd_decode_nb_mce(int, struct err_regs *, int);
+
+#endif /* _EDAC_MCE_AMD_H */
-- 
1.6.3.3


