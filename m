Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZGTQNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZGTQNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZGTQNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:31 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22935 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZGTQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:26 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KN391Y-04-7DR-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 02/14] amd64_edac: cleanup amd64_process_error_info
Date: Mon, 20 Jul 2009 18:12:53 +0200
Message-ID: <1248106385-27514-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:11.0671 (UTC) FILETIME=[FA6B2870:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mv amd64_error_info_regs -> err_regs

* remove redundant info ptr

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   48 ++++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h |   10 ++++----
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 93b119b..844effd 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -693,7 +693,7 @@ static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
  * specific.
  */
 static u64 extract_error_address(struct mem_ctl_info *mci,
-				 struct amd64_error_info_regs *info)
+				 struct err_regs *info)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 
@@ -1047,7 +1047,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 
 /* extract the ERROR ADDRESS for the K8 CPUs */
 static u64 k8_get_error_address(struct mem_ctl_info *mci,
-				struct amd64_error_info_regs *info)
+				struct err_regs *info)
 {
 	return (((u64) (info->nbeah & 0xff)) << 32) +
 			(info->nbeal & ~0x03);
@@ -1090,7 +1090,7 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-					struct amd64_error_info_regs *info,
+					struct err_regs *info,
 					u64 SystemAddress)
 {
 	struct mem_ctl_info *src_mci;
@@ -1309,7 +1309,7 @@ static void amd64_teardown(struct amd64_pvt *pvt)
 }
 
 static u64 f10_get_error_address(struct mem_ctl_info *mci,
-			struct amd64_error_info_regs *info)
+			struct err_regs *info)
 {
 	return (((u64) (info->nbeah & 0xffff)) << 32) +
 			(info->nbeal & ~0x01);
@@ -1686,7 +1686,7 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
  * The @sys_addr is usually an error address received from the hardware.
  */
 static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-				     struct amd64_error_info_regs *info,
+				     struct err_regs *info,
 				     u64 sys_addr)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
@@ -2043,7 +2043,7 @@ static int get_channel_from_ecc_syndrome(unsigned short syndrome)
  *	- 0: if no valid error is indicated
  */
 static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
-				     struct amd64_error_info_regs *regs)
+				     struct err_regs *regs)
 {
 	struct amd64_pvt *pvt;
 	struct pci_dev *misc_f3_ctl;
@@ -2092,10 +2092,10 @@ err_reg:
  *	- 0: if no error is found
  */
 static int amd64_get_error_info(struct mem_ctl_info *mci,
-				struct amd64_error_info_regs *info)
+				struct err_regs *info)
 {
 	struct amd64_pvt *pvt;
-	struct amd64_error_info_regs regs;
+	struct err_regs regs;
 
 	pvt = mci->pvt_info;
 
@@ -2151,7 +2151,7 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 }
 
 static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
-					 struct amd64_error_info_regs *info)
+					 struct err_regs *info)
 {
 	u32 ec = ERROR_CODE(info->nbsl);
 
@@ -2161,7 +2161,7 @@ static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
 }
 
 static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
-				      struct amd64_error_info_regs *info)
+				      struct err_regs *info)
 {
 	u32 ec = ERROR_CODE(info->nbsl);
 
@@ -2177,7 +2177,7 @@ static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
  * ADDRESS and process.
  */
 static void amd64_handle_ce(struct mem_ctl_info *mci,
-			    struct amd64_error_info_regs *info)
+			    struct err_regs *info)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 SystemAddress;
@@ -2200,7 +2200,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 
 /* Handle any Un-correctable Errors (UEs) */
 static void amd64_handle_ue(struct mem_ctl_info *mci,
-			    struct amd64_error_info_regs *info)
+			    struct err_regs *info)
 {
 	int csrow;
 	u64 SystemAddress;
@@ -2246,7 +2246,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 }
 
 static void amd64_decode_bus_error(struct mem_ctl_info *mci,
-				   struct amd64_error_info_regs *info)
+				   struct err_regs *info)
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
@@ -2297,22 +2297,18 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 }
 
 int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct amd64_error_info_regs *info,
+			     struct err_regs *regs,
 			     int handle_errors)
 {
 	struct amd64_pvt *pvt;
-	struct amd64_error_info_regs *regs;
 	u32 err_code, ext_ec;
 	int gart_tlb_error = 0;
 
 	pvt = mci->pvt_info;
 
-	/* If caller doesn't want us to process the error, return */
 	if (!handle_errors)
 		return 1;
 
-	regs = info;
-
 	debugf1("NorthBridge ERROR: mci(0x%p)\n", mci);
 	debugf1("  MC node(%d) Error-Address(0x%.8x-%.8x)\n",
 		pvt->mc_node_id, regs->nbeah, regs->nbeal);
@@ -2378,13 +2374,13 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 		gart_tlb_error = 1;
 
 		debugf1("GART TLB error\n");
-		amd64_decode_gart_tlb_error(mci, info);
+		amd64_decode_gart_tlb_error(mci, regs);
 	} else if (MEM_ERROR(err_code)) {
 		debugf1("Memory/Cache error\n");
-		amd64_decode_mem_cache_error(mci, info);
+		amd64_decode_mem_cache_error(mci, regs);
 	} else if (BUS_ERROR(err_code)) {
 		debugf1("Bus (Link/DRAM) error\n");
-		amd64_decode_bus_error(mci, info);
+		amd64_decode_bus_error(mci, regs);
 	} else {
 		/* shouldn't reach here! */
 		amd64_mc_printk(mci, KERN_WARNING,
@@ -2399,12 +2395,12 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 	if (((ext_ec >= F10_NBSL_EXT_ERR_CRC &&
 			ext_ec <= F10_NBSL_EXT_ERR_TGT) ||
 			(ext_ec == F10_NBSL_EXT_ERR_RMW)) &&
-			EXTRACT_LDT_LINK(info->nbsh)) {
+			EXTRACT_LDT_LINK(regs->nbsh)) {
 
 		amd64_mc_printk(mci, KERN_ERR,
 			"Error on hypertransport link: %s\n",
 			htlink_msgs[
-			EXTRACT_LDT_LINK(info->nbsh)]);
+			EXTRACT_LDT_LINK(regs->nbsh)]);
 	}
 
 	/*
@@ -2432,10 +2428,10 @@ EXPORT_SYMBOL_GPL(amd64_process_error_info);
  */
 static void amd64_check(struct mem_ctl_info *mci)
 {
-	struct amd64_error_info_regs info;
+	struct err_regs regs;
 
-	if (amd64_get_error_info(mci, &info))
-		amd64_process_error_info(mci, &info, 1);
+	if (amd64_get_error_info(mci, &regs))
+		amd64_process_error_info(mci, &regs, 1);
 }
 
 /*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e050a92..c85a5e7 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -464,7 +464,7 @@ enum amd64_chipset_families {
  *
  * Depends on entry into the modules
  */
-struct amd64_error_info_regs {
+struct err_regs {
 	u32 nbcfg;
 	u32 nbsh;
 	u32 nbsl;
@@ -542,7 +542,7 @@ struct amd64_pvt {
 	u32 online_spare;               /* On-Line spare Reg */
 
 	/* temp storage for when input is received from sysfs */
-	struct amd64_error_info_regs ctl_error_info;
+	struct err_regs ctl_error_info;
 
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
@@ -601,11 +601,11 @@ struct low_ops {
 	int (*early_channel_count)(struct amd64_pvt *pvt);
 
 	u64 (*get_error_address)(struct mem_ctl_info *mci,
-			struct amd64_error_info_regs *info);
+			struct err_regs *info);
 	void (*read_dram_base_limit)(struct amd64_pvt *pvt, int dram);
 	void (*read_dram_ctl_register)(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)(struct mem_ctl_info *mci,
-					struct amd64_error_info_regs *info,
+					struct err_regs *info,
 					u64 SystemAddr);
 	int (*dbam_map_to_pages)(struct amd64_pvt *pvt, int dram_map);
 };
@@ -638,7 +638,7 @@ static inline struct low_ops *family_ops(int index)
 #define F11_MIN_SCRUB_RATE_BITS	0x6
 
 int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct amd64_error_info_regs *info,
+			     struct err_regs *info,
 			     int handle_errors);
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
-- 
1.6.3.3


