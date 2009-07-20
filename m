Return-Path: <linux-kernel-owner+w=401wt.eu-S1750998AbZGTQO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbZGTQO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZGTQOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:14:55 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:18802
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752670AbZGTQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:40 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KN3920-04-7DW-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 04/14] amd64_edac: fixup ExtError decoding
Date: Mon, 20 Jul 2009 18:12:55 +0200
Message-ID: <1248106385-27514-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:12.0437 (UTC) FILETIME=[FAE00A50:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beef up NB error signatures too. Remove unneeded/unused fragments while
at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c           |   28 ++++----------
 drivers/edac/amd64_edac.h           |   11 +-----
 drivers/edac/amd64_edac_err_types.c |   71 ++++++++++++++++++-----------------
 3 files changed, 46 insertions(+), 64 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 591d28d..d53f0f6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2300,7 +2300,7 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u32 err_code, ext_ec;
+	u32 ec, xec;
 	int ecc;
 
 	if (!handle_errors)
@@ -2335,9 +2335,10 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 
 	pr_cont("\n");
 
-	err_code = ERROR_CODE(regs->nbsl);
+	ec = ERROR_CODE(regs->nbsl);
+	xec = EXT_ERROR_CODE(regs->nbsl);
 
-	if (TLB_ERROR(err_code)) {
+	if (TLB_ERROR(ec)) {
 		/*
 		 * GART errors are intended to help graphics driver developers
 		 * to detect bad GART PTEs. It is recommended by AMD to disable
@@ -2355,33 +2356,20 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 
 		pr_emerg("GART TLB error\n");
 		amd64_decode_gart_tlb_error(mci, regs);
-	} else if (MEM_ERROR(err_code)) {
+	} else if (MEM_ERROR(ec)) {
 		pr_emerg("Memory/Cache error\n");
 		amd64_decode_mem_cache_error(mci, regs);
-	} else if (BUS_ERROR(err_code)) {
+	} else if (BUS_ERROR(ec)) {
 		pr_emerg("Bus (Link/DRAM) error\n");
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
-
-	if (((ext_ec >= F10_NBSL_EXT_ERR_CRC &&
-			ext_ec <= F10_NBSL_EXT_ERR_TGT) ||
-			(ext_ec == F10_NBSL_EXT_ERR_RMW)) &&
-			EXTRACT_LDT_LINK(regs->nbsh)) {
-
-		amd64_mc_printk(mci, KERN_ERR,
-			"Error on hypertransport link: %s\n",
-			htlink_msgs[
-			EXTRACT_LDT_LINK(regs->nbsh)]);
-	}
+	pr_emerg("%s.\n", EXT_ERR_DESC(xec));
 
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index a75ba80..6e3a9a7 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -305,16 +305,7 @@ enum {
 
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
@@ -347,6 +338,7 @@ enum {
 
 #define ERROR_CODE(x)			((x) & 0xffff)
 #define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define EXT_ERR_DESC(x)			ext_msgs[(EXT_ERROR_CODE((x)))]
 #define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
 #define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
 
@@ -384,7 +376,6 @@ enum {
 #define K8_NBSH_UECC			BIT(13)
 #define K8_NBSH_ERR_SCRUBER		BIT(8)
 
-#define EXTRACT_LDT_LINK(x)		(((x) >> 4) & 0x7)
 #define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
 
 
diff --git a/drivers/edac/amd64_edac_err_types.c b/drivers/edac/amd64_edac_err_types.c
index cacdd54..19aa756 100644
--- a/drivers/edac/amd64_edac_err_types.c
+++ b/drivers/edac/amd64_edac_err_types.c
@@ -106,40 +106,43 @@ const char *ii_msgs[] = {	/* memory or i/o */
 	"Generic"
 };
 
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
+/*
+ * Map the 4 or 5 (family-specific) bits of Extended Error code to the
+ * string table.
+ */
+const char *ext_msgs[] = {
+	"K8 ECC error",					/* 0_0000b */
+	"CRC error on link",				/* 0_0001b */
+	"Sync error packets on link",			/* 0_0010b */
+	"Master Abort during link operation",		/* 0_0011b */
+	"Target Abort during link operation",		/* 0_0100b */
+	"Invalid GART PTE entry during table walk",	/* 0_0101b */
+	"Unsupported atomic RMW command received",	/* 0_0110b */
+	"WDT error: NB transaction timeout",		/* 0_0111b */
+	"ECC/ChipKill ECC error",			/* 0_1000b */
+	"SVM DEV Error",				/* 0_1001b */
+	"Link Data error",				/* 0_1010b */
+	"Link/L3/Probe Filter Protocol error",		/* 0_1011b */
+	"NB Internal Arrays Parity error",		/* 0_1100b */
+	"DRAM Address/Control Parity error",		/* 0_1101b */
+	"Link Transmission error",			/* 0_1110b */
+	"GART/DEV Table Walk Data error"		/* 0_1111b */
+	"Res 0x100 error",				/* 1_0000b */
+	"Res 0x101 error",				/* 1_0001b */
+	"Res 0x102 error",				/* 1_0010b */
+	"Res 0x103 error",				/* 1_0011b */
+	"Res 0x104 error",				/* 1_0100b */
+	"Res 0x105 error",				/* 1_0101b */
+	"Res 0x106 error",				/* 1_0110b */
+	"Res 0x107 error",				/* 1_0111b */
+	"Res 0x108 error",				/* 1_1000b */
+	"Res 0x109 error",				/* 1_1001b */
+	"Res 0x10A error",				/* 1_1010b */
+	"Res 0x10B error",				/* 1_1011b */
+	"ECC error in L3 Cache Data",			/* 1_1100b */
+	"L3 Cache Tag error",				/* 1_1101b */
+	"L3 Cache LRU Parity error",			/* 1_1110b */
+	"Probe Filter error"				/* 1_1111b */
 };
 
 const char *htlink_msgs[] = {
-- 
1.6.3.3


