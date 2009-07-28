Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZG1PG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZG1PG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZG1PGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27573 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZG1PGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAQ-02-6PE-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 06/20] EDAC: move MCE error descriptions to EDAC core
Date: Tue, 28 Jul 2009 17:06:06 +0200
Message-ID: <1248793580-29899-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:25.0066 (UTC) FILETIME=[F999C0A0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of adding AMD-specific MCE decoding functionality
to the EDAC core. The error decoding macros originate from the AMD64
EDAC driver albeit in a simplified and cleaned up version here.

While at it, add macros to generate the error description strings and
use them in the error type decoders directly which removes a bunch of
code and makes the decoding functions much more readable. Also, fix
strings and shorten macro names.

Remove superfluous htlink_msgs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Makefile               |    6 +-
 drivers/edac/amd64_edac.c           |  140 +++++++++++++++++-------------
 drivers/edac/amd64_edac.h           |   17 +----
 drivers/edac/amd64_edac_err_types.c |  161 -----------------------------------
 drivers/edac/edac_mce_amd.c         |  101 ++++++++++++++++++++++
 drivers/edac/edac_mce_amd.h         |   29 ++++++
 6 files changed, 214 insertions(+), 240 deletions(-)
 delete mode 100644 drivers/edac/amd64_edac_err_types.c
 create mode 100644 drivers/edac/edac_mce_amd.c
 create mode 100644 drivers/edac/edac_mce_amd.h

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 98aa4a7..cfa033c 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -17,6 +17,10 @@ ifdef CONFIG_PCI
 edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
 endif
 
+ifdef CONFIG_CPU_SUP_AMD
+edac_core-objs  += edac_mce_amd.o
+endif
+
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
 obj-$(CONFIG_EDAC_I5000)		+= i5000_edac.o
@@ -32,7 +36,7 @@ obj-$(CONFIG_EDAC_X38)			+= x38_edac.o
 obj-$(CONFIG_EDAC_I82860)		+= i82860_edac.o
 obj-$(CONFIG_EDAC_R82600)		+= r82600_edac.o
 
-amd64_edac_mod-y :=  amd64_edac_err_types.o amd64_edac.o
+amd64_edac_mod-y := amd64_edac.o
 amd64_edac_mod-$(CONFIG_EDAC_DEBUG) += amd64_edac_dbg.o
 amd64_edac_mod-$(CONFIG_EDAC_AMD64_ERROR_INJECTION) += amd64_edac_inj.o
 
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 24964c1..7655ba1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -19,6 +19,63 @@ static struct mem_ctl_info *mci_lookup[MAX_NUMNODES];
 static struct amd64_pvt *pvt_lookup[MAX_NUMNODES];
 
 /*
+ * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
+ * for DDR2 DRAM mapping.
+ */
+u32 revf_quad_ddr2_shift[] = {
+	0,	/* 0000b NULL DIMM (128mb) */
+	28,	/* 0001b 256mb */
+	29,	/* 0010b 512mb */
+	29,	/* 0011b 512mb */
+	29,	/* 0100b 512mb */
+	30,	/* 0101b 1gb */
+	30,	/* 0110b 1gb */
+	31,	/* 0111b 2gb */
+	31,	/* 1000b 2gb */
+	32,	/* 1001b 4gb */
+	32,	/* 1010b 4gb */
+	33,	/* 1011b 8gb */
+	0,	/* 1100b future */
+	0,	/* 1101b future */
+	0,	/* 1110b future */
+	0	/* 1111b future */
+};
+
+/*
+ * Valid scrub rates for the K8 hardware memory scrubber. We map the scrubbing
+ * bandwidth to a valid bit pattern. The 'set' operation finds the 'matching-
+ * or higher value'.
+ *
+ *FIXME: Produce a better mapping/linearisation.
+ */
+
+struct scrubrate scrubrates[] = {
+	{ 0x01, 1600000000UL},
+	{ 0x02, 800000000UL},
+	{ 0x03, 400000000UL},
+	{ 0x04, 200000000UL},
+	{ 0x05, 100000000UL},
+	{ 0x06, 50000000UL},
+	{ 0x07, 25000000UL},
+	{ 0x08, 12284069UL},
+	{ 0x09, 6274509UL},
+	{ 0x0A, 3121951UL},
+	{ 0x0B, 1560975UL},
+	{ 0x0C, 781440UL},
+	{ 0x0D, 390720UL},
+	{ 0x0E, 195300UL},
+	{ 0x0F, 97650UL},
+	{ 0x10, 48854UL},
+	{ 0x11, 24427UL},
+	{ 0x12, 12213UL},
+	{ 0x13, 6101UL},
+	{ 0x14, 3051UL},
+	{ 0x15, 1523UL},
+	{ 0x16, 761UL},
+	{ 0x00, 0UL},        /* scrubbing off */
+};
+
+/*
  * Memory scrubber control interface. For K8, memory scrubbing is handled by
  * hardware and can involve L2 cache, dcache as well as the main memory. With
  * F10, this is extended to L3 cache scrubbing on CPU models sporting that
@@ -1099,8 +1156,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	u32 page, offset;
 
 	/* Extract the syndrome parts and form a 16-bit syndrome */
-	syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
-	syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+	syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
+	syndrome |= LOW_SYNDROME(info->nbsh);
 
 	/* CHIPKILL enabled */
 	if (info->nbcfg & K8_NBCFG_CHIPKILL) {
@@ -1699,8 +1756,8 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	if (csrow >= 0) {
 		error_address_to_page_and_offset(sys_addr, &page, &offset);
 
-		syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
-		syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+		syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
+		syndrome |= LOW_SYNDROME(info->nbsh);
 
 		/*
 		 * Is CHIPKILL on? If so, then we can attempt to use the
@@ -2153,36 +2210,22 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
 					 struct amd64_error_info_regs *info)
 {
-	u32 err_code;
-	u32 ec_tt;		/* error code transaction type (2b) */
-	u32 ec_ll;		/* error code cache level (2b) */
-
-	err_code = EXTRACT_ERROR_CODE(info->nbsl);
-	ec_ll = EXTRACT_LL_CODE(err_code);
-	ec_tt = EXTRACT_TT_CODE(err_code);
+	u32 ec = ERROR_CODE(info->nbsl);
 
 	amd64_mc_printk(mci, KERN_ERR,
 		     "GART TLB event: transaction type(%s), "
-		     "cache level(%s)\n", tt_msgs[ec_tt], ll_msgs[ec_ll]);
+		     "cache level(%s)\n", TT_MSG(ec), LL_MSG(ec));
 }
 
 static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
 				      struct amd64_error_info_regs *info)
 {
-	u32 err_code;
-	u32 ec_rrrr;		/* error code memory transaction (4b) */
-	u32 ec_tt;		/* error code transaction type (2b) */
-	u32 ec_ll;		/* error code cache level (2b) */
-
-	err_code = EXTRACT_ERROR_CODE(info->nbsl);
-	ec_ll = EXTRACT_LL_CODE(err_code);
-	ec_tt = EXTRACT_TT_CODE(err_code);
-	ec_rrrr = EXTRACT_RRRR_CODE(err_code);
+	u32 ec = ERROR_CODE(info->nbsl);
 
 	amd64_mc_printk(mci, KERN_ERR,
 		     "cache hierarchy error: memory transaction type(%s), "
 		     "transaction type(%s), cache level(%s)\n",
-		     rrrr_msgs[ec_rrrr], tt_msgs[ec_tt], ll_msgs[ec_ll]);
+		     RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 }
 
 
@@ -2262,21 +2305,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 				   struct amd64_error_info_regs *info)
 {
-	u32 err_code, ext_ec;
-	u32 ec_pp;		/* error code participating processor (2p) */
-	u32 ec_to;		/* error code timed out (1b) */
-	u32 ec_rrrr;		/* error code memory transaction (4b) */
-	u32 ec_ii;		/* error code memory or I/O (2b) */
-	u32 ec_ll;		/* error code cache level (2b) */
-
-	ext_ec = EXTRACT_EXT_ERROR_CODE(info->nbsl);
-	err_code = EXTRACT_ERROR_CODE(info->nbsl);
-
-	ec_ll = EXTRACT_LL_CODE(err_code);
-	ec_ii = EXTRACT_II_CODE(err_code);
-	ec_rrrr = EXTRACT_RRRR_CODE(err_code);
-	ec_to = EXTRACT_TO_CODE(err_code);
-	ec_pp = EXTRACT_PP_CODE(err_code);
+	u32 ec  = ERROR_CODE(info->nbsl);
+	u32 xec = EXT_ERROR_CODE(info->nbsl);
 
 	amd64_mc_printk(mci, KERN_ERR,
 		"BUS ERROR:\n"
@@ -2284,20 +2314,17 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 		"  participating processor(%s)\n"
 		"  memory transaction type(%s)\n"
 		"  cache level(%s) Error Found by: %s\n",
-		to_msgs[ec_to],
-		ii_msgs[ec_ii],
-		pp_msgs[ec_pp],
-		rrrr_msgs[ec_rrrr],
-		ll_msgs[ec_ll],
+		TO_MSG(ec), II_MSG(ec), PP_MSG(ec), RRRR_MSG(ec), LL_MSG(ec),
 		(info->nbsh & K8_NBSH_ERR_SCRUBER) ?
 			"Scrubber" : "Normal Operation");
 
-	/* If this was an 'observed' error, early out */
-	if (ec_pp == K8_NBSL_PP_OBS)
-		return;		/* We aren't the node involved */
+
+	/* Bail early out if this was an 'observed' error */
+	if (PP(ec) == K8_NBSL_PP_OBS)
+		return;
 
 	/* Parse out the extended error code for ECC events */
-	switch (ext_ec) {
+	switch (xec) {
 	/* F10 changed to one Extended ECC error code */
 	case F10_NBSL_EXT_ERR_RES:		/* Reserved field */
 	case F10_NBSL_EXT_ERR_ECC:		/* F10 ECC ext err code */
@@ -2377,7 +2404,7 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 		(regs->nbsh & K8_NBSH_CORE3) ? "True" : "False");
 
 
-	err_code = EXTRACT_ERROR_CODE(regs->nbsl);
+	err_code = ERROR_CODE(regs->nbsl);
 
 	/* Determine which error type:
 	 *	1) GART errors - non-fatal, developmental events
@@ -2385,7 +2412,7 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 	 *	3) BUS errors
 	 *	4) Unknown error
 	 */
-	if (TEST_TLB_ERROR(err_code)) {
+	if (TLB_ERROR(err_code)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
 		 * to detect bad GART PTEs. It is recommended by AMD to disable
@@ -2409,10 +2436,10 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 
 		debugf1("GART TLB error\n");
 		amd64_decode_gart_tlb_error(mci, info);
-	} else if (TEST_MEM_ERROR(err_code)) {
+	} else if (MEM_ERROR(err_code)) {
 		debugf1("Memory/Cache error\n");
 		amd64_decode_mem_cache_error(mci, info);
-	} else if (TEST_BUS_ERROR(err_code)) {
+	} else if (BUS_ERROR(err_code)) {
 		debugf1("Bus (Link/DRAM) error\n");
 		amd64_decode_bus_error(mci, info);
 	} else {
@@ -2422,21 +2449,10 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 			     err_code);
 	}
 
-	ext_ec = EXTRACT_EXT_ERROR_CODE(regs->nbsl);
+	ext_ec = EXT_ERROR_CODE(regs->nbsl);
 	amd64_mc_printk(mci, KERN_ERR,
 		"ExtErr=(0x%x) %s\n", ext_ec, ext_msgs[ext_ec]);
 
-	if (((ext_ec >= F10_NBSL_EXT_ERR_CRC &&
-			ext_ec <= F10_NBSL_EXT_ERR_TGT) ||
-			(ext_ec == F10_NBSL_EXT_ERR_RMW)) &&
-			EXTRACT_LDT_LINK(info->nbsh)) {
-
-		amd64_mc_printk(mci, KERN_ERR,
-			"Error on hypertransport link: %s\n",
-			htlink_msgs[
-			EXTRACT_LDT_LINK(info->nbsh)]);
-	}
-
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
 	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ba73015..1ddef8d 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -72,6 +72,7 @@
 #include <linux/edac.h>
 #include <asm/msr.h>
 #include "edac_core.h"
+#include "edac_mce_amd.h"
 
 #define amd64_printk(level, fmt, arg...) \
 	edac_printk(level, "amd64", fmt, ##arg)
@@ -303,9 +304,6 @@ enum {
 #define K8_NBSL				0x48
 
 
-#define EXTRACT_HIGH_SYNDROME(x)	(((x) >> 24) & 0xff)
-#define EXTRACT_EXT_ERROR_CODE(x)	(((x) >> 16) & 0x1f)
-
 /* Family F10h: Normalized Extended Error Codes */
 #define F10_NBSL_EXT_ERR_RES		0x0
 #define F10_NBSL_EXT_ERR_CRC		0x1
@@ -348,17 +346,6 @@ enum {
 #define K8_NBSL_EXT_ERR_CHIPKILL_ECC	0x8
 #define K8_NBSL_EXT_ERR_DRAM_PARITY	0xD
 
-#define EXTRACT_ERROR_CODE(x)		((x) & 0xffff)
-#define	TEST_TLB_ERROR(x)		(((x) & 0xFFF0) == 0x0010)
-#define	TEST_MEM_ERROR(x)		(((x) & 0xFF00) == 0x0100)
-#define	TEST_BUS_ERROR(x)		(((x) & 0xF800) == 0x0800)
-#define	EXTRACT_TT_CODE(x)		(((x) >> 2) & 0x3)
-#define	EXTRACT_II_CODE(x)		(((x) >> 2) & 0x3)
-#define	EXTRACT_LL_CODE(x)		(((x) >> 0) & 0x3)
-#define	EXTRACT_RRRR_CODE(x)		(((x) >> 4) & 0xf)
-#define	EXTRACT_TO_CODE(x)		(((x) >> 8) & 0x1)
-#define	EXTRACT_PP_CODE(x)		(((x) >> 9) & 0x3)
-
 /*
  * The following are for BUS type errors AFTER values have been normalized by
  * shifting right
@@ -386,9 +373,7 @@ enum {
 #define K8_NBSH_CORE1			BIT(1)
 #define K8_NBSH_CORE0			BIT(0)
 
-#define EXTRACT_LDT_LINK(x)		(((x) >> 4) & 0x7)
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
-#define EXTRACT_LOW_SYNDROME(x)		(((x) >> 15) & 0xff)
 
 
 #define K8_NBEAL			0x50
diff --git a/drivers/edac/amd64_edac_err_types.c b/drivers/edac/amd64_edac_err_types.c
deleted file mode 100644
index f212ff1..0000000
--- a/drivers/edac/amd64_edac_err_types.c
+++ /dev/null
@@ -1,161 +0,0 @@
-#include "amd64_edac.h"
-
-/*
- * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
- * for DDR2 DRAM mapping.
- */
-u32 revf_quad_ddr2_shift[] = {
-	0,	/* 0000b NULL DIMM (128mb) */
-	28,	/* 0001b 256mb */
-	29,	/* 0010b 512mb */
-	29,	/* 0011b 512mb */
-	29,	/* 0100b 512mb */
-	30,	/* 0101b 1gb */
-	30,	/* 0110b 1gb */
-	31,	/* 0111b 2gb */
-	31,	/* 1000b 2gb */
-	32,	/* 1001b 4gb */
-	32,	/* 1010b 4gb */
-	33,	/* 1011b 8gb */
-	0,	/* 1100b future */
-	0,	/* 1101b future */
-	0,	/* 1110b future */
-	0	/* 1111b future */
-};
-
-/*
- * Valid scrub rates for the K8 hardware memory scrubber. We map the scrubbing
- * bandwidth to a valid bit pattern. The 'set' operation finds the 'matching-
- * or higher value'.
- *
- *FIXME: Produce a better mapping/linearisation.
- */
-
-struct scrubrate scrubrates[] = {
-	{ 0x01, 1600000000UL},
-	{ 0x02, 800000000UL},
-	{ 0x03, 400000000UL},
-	{ 0x04, 200000000UL},
-	{ 0x05, 100000000UL},
-	{ 0x06, 50000000UL},
-	{ 0x07, 25000000UL},
-	{ 0x08, 12284069UL},
-	{ 0x09, 6274509UL},
-	{ 0x0A, 3121951UL},
-	{ 0x0B, 1560975UL},
-	{ 0x0C, 781440UL},
-	{ 0x0D, 390720UL},
-	{ 0x0E, 195300UL},
-	{ 0x0F, 97650UL},
-	{ 0x10, 48854UL},
-	{ 0x11, 24427UL},
-	{ 0x12, 12213UL},
-	{ 0x13, 6101UL},
-	{ 0x14, 3051UL},
-	{ 0x15, 1523UL},
-	{ 0x16, 761UL},
-	{ 0x00, 0UL},        /* scrubbing off */
-};
-
-/*
- * string representation for the different MCA reported error types, see F3x48
- * or MSR0000_0411.
- */
-const char *tt_msgs[] = {        /* transaction type */
-	"instruction",
-	"data",
-	"generic",
-	"reserved"
-};
-
-const char *ll_msgs[] = {	/* cache level */
-	"L0",
-	"L1",
-	"L2",
-	"L3/generic"
-};
-
-const char *rrrr_msgs[] = {
-	"generic",
-	"generic read",
-	"generic write",
-	"data read",
-	"data write",
-	"inst fetch",
-	"prefetch",
-	"evict",
-	"snoop",
-	"reserved RRRR= 9",
-	"reserved RRRR= 10",
-	"reserved RRRR= 11",
-	"reserved RRRR= 12",
-	"reserved RRRR= 13",
-	"reserved RRRR= 14",
-	"reserved RRRR= 15"
-};
-
-const char *pp_msgs[] = {	/* participating processor */
-	"local node originated (SRC)",
-	"local node responded to request (RES)",
-	"local node observed as 3rd party (OBS)",
-	"generic"
-};
-
-const char *to_msgs[] = {
-	"no timeout",
-	"timed out"
-};
-
-const char *ii_msgs[] = {	/* memory or i/o */
-	"mem access",
-	"reserved",
-	"i/o access",
-	"generic"
-};
-
-/* Map the 5 bits of Extended Error code to the string table. */
-const char *ext_msgs[] = {	/* extended error */
-	"K8 ECC error/F10 reserved",	/* 0_0000b */
-	"CRC error",			/* 0_0001b */
-	"sync error",			/* 0_0010b */
-	"mst abort",			/* 0_0011b */
-	"tgt abort",			/* 0_0100b */
-	"GART error",			/* 0_0101b */
-	"RMW error",			/* 0_0110b */
-	"Wdog timer error",		/* 0_0111b */
-	"F10-ECC/K8-Chipkill error",	/* 0_1000b */
-	"DEV Error",			/* 0_1001b */
-	"Link Data error",		/* 0_1010b */
-	"Link or L3 Protocol error",	/* 0_1011b */
-	"NB Array error",		/* 0_1100b */
-	"DRAM Parity error",		/* 0_1101b */
-	"Link Retry/GART Table Walk/DEV Table Walk error", /* 0_1110b */
-	"Res 0x0ff error",		/* 0_1111b */
-	"Res 0x100 error",		/* 1_0000b */
-	"Res 0x101 error",		/* 1_0001b */
-	"Res 0x102 error",		/* 1_0010b */
-	"Res 0x103 error",		/* 1_0011b */
-	"Res 0x104 error",		/* 1_0100b */
-	"Res 0x105 error",		/* 1_0101b */
-	"Res 0x106 error",		/* 1_0110b */
-	"Res 0x107 error",		/* 1_0111b */
-	"Res 0x108 error",		/* 1_1000b */
-	"Res 0x109 error",		/* 1_1001b */
-	"Res 0x10A error",		/* 1_1010b */
-	"Res 0x10B error",		/* 1_1011b */
-	"L3 Cache Data error",		/* 1_1100b */
-	"L3 CacheTag error",		/* 1_1101b */
-	"L3 Cache LRU error",		/* 1_1110b */
-	"Res 0x1FF error"		/* 1_1111b */
-};
-
-const char *htlink_msgs[] = {
-	"none",
-	"1",
-	"2",
-	"1 2",
-	"3",
-	"1 3",
-	"2 3",
-	"1 2 3"
-};
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
new file mode 100644
index 0000000..cf84654
--- /dev/null
+++ b/drivers/edac/edac_mce_amd.c
@@ -0,0 +1,101 @@
+#include <linux/module.h>
+#include "edac_mce_amd.h"
+
+/*
+ * string representation for the different MCA reported error types, see F3x48
+ * or MSR0000_0411.
+ */
+const char *tt_msgs[] = {        /* transaction type */
+	"instruction",
+	"data",
+	"generic",
+	"reserved"
+};
+EXPORT_SYMBOL_GPL(tt_msgs);
+
+const char *ll_msgs[] = {	/* cache level */
+	"L0",
+	"L1",
+	"L2",
+	"L3/generic"
+};
+EXPORT_SYMBOL_GPL(ll_msgs);
+
+const char *rrrr_msgs[] = {
+	"generic",
+	"generic read",
+	"generic write",
+	"data read",
+	"data write",
+	"inst fetch",
+	"prefetch",
+	"evict",
+	"snoop",
+	"reserved RRRR= 9",
+	"reserved RRRR= 10",
+	"reserved RRRR= 11",
+	"reserved RRRR= 12",
+	"reserved RRRR= 13",
+	"reserved RRRR= 14",
+	"reserved RRRR= 15"
+};
+EXPORT_SYMBOL_GPL(rrrr_msgs);
+
+const char *pp_msgs[] = {	/* participating processor */
+	"local node originated (SRC)",
+	"local node responded to request (RES)",
+	"local node observed as 3rd party (OBS)",
+	"generic"
+};
+EXPORT_SYMBOL_GPL(pp_msgs);
+
+const char *to_msgs[] = {
+	"no timeout",
+	"timed out"
+};
+EXPORT_SYMBOL_GPL(to_msgs);
+
+const char *ii_msgs[] = {	/* memory or i/o */
+	"mem access",
+	"reserved",
+	"i/o access",
+	"generic"
+};
+EXPORT_SYMBOL_GPL(ii_msgs);
+
+/* Map the 5 bits of Extended Error code to the string table. */
+const char *ext_msgs[] = {	/* extended error */
+	"K8 ECC error/F10 reserved",	/* 0_0000b */
+	"CRC error",			/* 0_0001b */
+	"sync error",			/* 0_0010b */
+	"mst abort",			/* 0_0011b */
+	"tgt abort",			/* 0_0100b */
+	"GART error",			/* 0_0101b */
+	"RMW error",			/* 0_0110b */
+	"Wdog timer error",		/* 0_0111b */
+	"F10-ECC/K8-Chipkill error",	/* 0_1000b */
+	"DEV Error",			/* 0_1001b */
+	"Link Data error",		/* 0_1010b */
+	"Link or L3 Protocol error",	/* 0_1011b */
+	"NB Array error",		/* 0_1100b */
+	"DRAM Parity error",		/* 0_1101b */
+	"Link Retry/GART Table Walk/DEV Table Walk error", /* 0_1110b */
+	"Res 0x0ff error",		/* 0_1111b */
+	"Res 0x100 error",		/* 1_0000b */
+	"Res 0x101 error",		/* 1_0001b */
+	"Res 0x102 error",		/* 1_0010b */
+	"Res 0x103 error",		/* 1_0011b */
+	"Res 0x104 error",		/* 1_0100b */
+	"Res 0x105 error",		/* 1_0101b */
+	"Res 0x106 error",		/* 1_0110b */
+	"Res 0x107 error",		/* 1_0111b */
+	"Res 0x108 error",		/* 1_1000b */
+	"Res 0x109 error",		/* 1_1001b */
+	"Res 0x10A error",		/* 1_1010b */
+	"Res 0x10B error",		/* 1_1011b */
+	"L3 Cache Data error",		/* 1_1100b */
+	"L3 CacheTag error",		/* 1_1101b */
+	"L3 Cache LRU error",		/* 1_1110b */
+	"Res 0x1FF error"		/* 1_1111b */
+};
+EXPORT_SYMBOL_GPL(ext_msgs);
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
new file mode 100644
index 0000000..aea3863
--- /dev/null
+++ b/drivers/edac/edac_mce_amd.h
@@ -0,0 +1,29 @@
+#define ERROR_CODE(x)			((x) & 0xffff)
+#define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
+#define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
+
+#define	TLB_ERROR(x)			(((x) & 0xFFF0) == 0x0010)
+#define	MEM_ERROR(x)			(((x) & 0xFF00) == 0x0100)
+#define	BUS_ERROR(x)			(((x) & 0xF800) == 0x0800)
+
+#define	TT(x)				(((x) >> 2) & 0x3)
+#define	TT_MSG(x)			tt_msgs[TT(x)]
+#define	II(x)				(((x) >> 2) & 0x3)
+#define	II_MSG(x)			ii_msgs[II(x)]
+#define	LL(x)				(((x) >> 0) & 0x3)
+#define	LL_MSG(x)			ll_msgs[LL(x)]
+#define	RRRR(x)				(((x) >> 4) & 0xf)
+#define	RRRR_MSG(x)			rrrr_msgs[RRRR(x)]
+#define	TO(x)				(((x) >> 8) & 0x1)
+#define	TO_MSG(x)			to_msgs[TO(x)]
+#define	PP(x)				(((x) >> 9) & 0x3)
+#define	PP_MSG(x)			pp_msgs[PP(x)]
+
+extern const char *tt_msgs[];
+extern const char *ll_msgs[];
+extern const char *rrrr_msgs[];
+extern const char *pp_msgs[];
+extern const char *to_msgs[];
+extern const char *ii_msgs[];
+extern const char *ext_msgs[];
-- 
1.6.3.3


