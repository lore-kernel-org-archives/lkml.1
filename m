Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZGTQNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZGTQNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZGTQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:35 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6167 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbZGTQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:26 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KN391Y-04-7DP-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 01/14] amd64_edac: simplify error type bits extractors
Date: Mon, 20 Jul 2009 18:12:52 +0200
Message-ID: <1248106385-27514-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:11.0312 (UTC) FILETIME=[FA346100:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach the error code macros to generate the error description strings
and use them in the error type decoders directly which removes a bunch
of code and makes the decoding functions much more readable. Also, fix
strings and shorten macro names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c           |   72 ++++++++++------------------------
 drivers/edac/amd64_edac.h           |   28 +++++++-------
 drivers/edac/amd64_edac_err_types.c |   55 ++++++++++++---------------
 3 files changed, 59 insertions(+), 96 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 858fe60..93b119b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1099,8 +1099,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	u32 page, offset;
 
 	/* Extract the syndrome parts and form a 16-bit syndrome */
-	syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
-	syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+	syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
+	syndrome |= LOW_SYNDROME(info->nbsh);
 
 	/* CHIPKILL enabled */
 	if (info->nbcfg & K8_NBCFG_CHIPKILL) {
@@ -1699,8 +1699,8 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	if (csrow >= 0) {
 		error_address_to_page_and_offset(sys_addr, &page, &offset);
 
-		syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
-		syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+		syndrome  = HIGH_SYNDROME(info->nbsl) << 8;
+		syndrome |= LOW_SYNDROME(info->nbsh);
 
 		/*
 		 * Is CHIPKILL on? If so, then we can attempt to use the
@@ -2153,36 +2153,22 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
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
+		     "cache level(%s)\n", TT(ec), LL(ec));
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
+		     RRRR(ec), TT(ec), LL(ec));
 }
 
 
@@ -2262,21 +2248,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
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
@@ -2284,20 +2257,17 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 		"  participating processor(%s)\n"
 		"  memory transaction type(%s)\n"
 		"  cache level(%s) Error Found by: %s\n",
-		to_msgs[ec_to],
-		ii_msgs[ec_ii],
-		pp_msgs[ec_pp],
-		rrrr_msgs[ec_rrrr],
-		ll_msgs[ec_ll],
+		TO(ec), II(ec), PP(ec), RRRR(ec), LL(ec),
 		(info->nbsh & K8_NBSH_ERR_SCRUBER) ?
 			"Scrubber" : "Normal Operation");
 
-	/* If this was an 'observed' error, early out */
-	if (ec_pp == K8_NBSL_PP_OBS)
-		return;		/* We aren't the node involved */
+
+	/* Bail early out if this was an 'observed' error */
+	if (((ec >> 9) & 0x3) == K8_NBSL_PP_OBS)
+		return;
 
 	/* Parse out the extended error code for ECC events */
-	switch (ext_ec) {
+	switch (xec) {
 	/* F10 changed to one Extended ECC error code */
 	case F10_NBSL_EXT_ERR_RES:		/* Reserved field */
 	case F10_NBSL_EXT_ERR_ECC:		/* F10 ECC ext err code */
@@ -2377,7 +2347,7 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 		(regs->nbsh & K8_NBSH_CORE3) ? "True" : "False");
 
 
-	err_code = EXTRACT_ERROR_CODE(regs->nbsl);
+	err_code = ERROR_CODE(regs->nbsl);
 
 	/* Determine which error type:
 	 *	1) GART errors - non-fatal, developmental events
@@ -2385,7 +2355,7 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 	 *	3) BUS errors
 	 *	4) Unknown error
 	 */
-	if (TEST_TLB_ERROR(err_code)) {
+	if (TLB_ERROR(err_code)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
 		 * to detect bad GART PTEs. It is recommended by AMD to disable
@@ -2409,10 +2379,10 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 
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
@@ -2422,7 +2392,7 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 			     err_code);
 	}
 
-	ext_ec = EXTRACT_EXT_ERROR_CODE(regs->nbsl);
+	ext_ec = EXT_ERROR_CODE(regs->nbsl);
 	amd64_mc_printk(mci, KERN_ERR,
 		"ExtErr=(0x%x) %s\n", ext_ec, ext_msgs[ext_ec]);
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ba73015..e050a92 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -303,9 +303,6 @@ enum {
 #define K8_NBSL				0x48
 
 
-#define EXTRACT_HIGH_SYNDROME(x)	(((x) >> 24) & 0xff)
-#define EXTRACT_EXT_ERROR_CODE(x)	(((x) >> 16) & 0x1f)
-
 /* Family F10h: Normalized Extended Error Codes */
 #define F10_NBSL_EXT_ERR_RES		0x0
 #define F10_NBSL_EXT_ERR_CRC		0x1
@@ -348,16 +345,20 @@ enum {
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
+#define ERROR_CODE(x)			((x) & 0xffff)
+#define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
+#define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
+
+#define	TLB_ERROR(x)			(((x) & 0xFFF0) == 0x0010)
+#define	MEM_ERROR(x)			(((x) & 0xFF00) == 0x0100)
+#define	BUS_ERROR(x)			(((x) & 0xF800) == 0x0800)
+#define	TT(x)				tt_msgs[(((x) >> 2) & 0x3)]
+#define	II(x)				ii_msgs[(((x) >> 2) & 0x3)]
+#define	LL(x)				ll_msgs[(((x) >> 0) & 0x3)]
+#define	RRRR(x)				rrrr_msgs[(((x) >> 4) & 0xf)]
+#define	TO(x)				to_msgs[(((x) >> 8) & 0x1)]
+#define	PP(x)				pp_msgs[(((x) >> 9) & 0x3)]
 
 /*
  * The following are for BUS type errors AFTER values have been normalized by
@@ -388,7 +389,6 @@ enum {
 
 #define EXTRACT_LDT_LINK(x)		(((x) >> 4) & 0x7)
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
-#define EXTRACT_LOW_SYNDROME(x)		(((x) >> 15) & 0xff)
 
 
 #define K8_NBEAL			0x50
diff --git a/drivers/edac/amd64_edac_err_types.c b/drivers/edac/amd64_edac_err_types.c
index f212ff1..cacdd54 100644
--- a/drivers/edac/amd64_edac_err_types.c
+++ b/drivers/edac/amd64_edac_err_types.c
@@ -62,55 +62,48 @@ struct scrubrate scrubrates[] = {
  * or MSR0000_0411.
  */
 const char *tt_msgs[] = {        /* transaction type */
-	"instruction",
-	"data",
-	"generic",
-	"reserved"
+	"Instruction",
+	"Data",
+	"Generic",
+	"Reserved"
 };
 
 const char *ll_msgs[] = {	/* cache level */
-	"L0",
+	"Reserved",
 	"L1",
 	"L2",
-	"L3/generic"
+	"L3/Generic"
 };
 
 const char *rrrr_msgs[] = {
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
+	"Generic",
+	"Generic Read",
+	"Generic Write",
+	"Data Read",
+	"Data Write",
+	"Instruction Fetch",
+	"Prefetch",
+	"Evict",
+	"Snoop (Probe)"
 };
 
 const char *pp_msgs[] = {	/* participating processor */
-	"local node originated (SRC)",
-	"local node responded to request (RES)",
-	"local node observed as 3rd party (OBS)",
+	"local node originated the request",
+	"local node responded to request",
+	"local node observed error as 3rd party",
 	"generic"
 };
 
 const char *to_msgs[] = {
-	"no timeout",
-	"timed out"
+	"No timeout",
+	"Timed out"
 };
 
 const char *ii_msgs[] = {	/* memory or i/o */
-	"mem access",
-	"reserved",
-	"i/o access",
-	"generic"
+	"Memory Access",
+	"Reserved",
+	"IO Access",
+	"Generic"
 };
 
 /* Map the 5 bits of Extended Error code to the string table. */
-- 
1.6.3.3


