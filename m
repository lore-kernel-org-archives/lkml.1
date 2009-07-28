Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZG1PHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZG1PHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZG1PHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:07:49 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:24302 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754386AbZG1PHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:07:34 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KNHZAQ-02-6PC-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 08/20] amd64_edac: cleanup amd64_process_error_info
Date: Tue, 28 Jul 2009 17:06:08 +0200
Message-ID: <1248793580-29899-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:26.0097 (UTC) FILETIME=[FA371210:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mv amd64_error_info_regs -> err_regs

* remove redundant info ptr

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   44 ++++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h |   10 +++++-----
 2 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 7655ba1..a0afaa8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -750,7 +750,7 @@ static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
  * specific.
  */
 static u64 extract_error_address(struct mem_ctl_info *mci,
-				 struct amd64_error_info_regs *info)
+				 struct err_regs *info)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 
@@ -1104,7 +1104,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 
 /* extract the ERROR ADDRESS for the K8 CPUs */
 static u64 k8_get_error_address(struct mem_ctl_info *mci,
-				struct amd64_error_info_regs *info)
+				struct err_regs *info)
 {
 	return (((u64) (info->nbeah & 0xff)) << 32) +
 			(info->nbeal & ~0x03);
@@ -1147,7 +1147,7 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-					struct amd64_error_info_regs *info,
+					struct err_regs *info,
 					u64 SystemAddress)
 {
 	struct mem_ctl_info *src_mci;
@@ -1366,7 +1366,7 @@ static void amd64_teardown(struct amd64_pvt *pvt)
 }
 
 static u64 f10_get_error_address(struct mem_ctl_info *mci,
-			struct amd64_error_info_regs *info)
+			struct err_regs *info)
 {
 	return (((u64) (info->nbeah & 0xffff)) << 32) +
 			(info->nbeal & ~0x01);
@@ -1743,7 +1743,7 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
  * The @sys_addr is usually an error address received from the hardware.
  */
 static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
-				     struct amd64_error_info_regs *info,
+				     struct err_regs *info,
 				     u64 sys_addr)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
@@ -2100,7 +2100,7 @@ static int get_channel_from_ecc_syndrome(unsigned short syndrome)
  *	- 0: if no valid error is indicated
  */
 static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
-				     struct amd64_error_info_regs *regs)
+				     struct err_regs *regs)
 {
 	struct amd64_pvt *pvt;
 	struct pci_dev *misc_f3_ctl;
@@ -2149,10 +2149,10 @@ err_reg:
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
 
@@ -2208,7 +2208,7 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 }
 
 static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
-					 struct amd64_error_info_regs *info)
+					 struct err_regs *info)
 {
 	u32 ec = ERROR_CODE(info->nbsl);
 
@@ -2218,7 +2218,7 @@ static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
 }
 
 static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
-				      struct amd64_error_info_regs *info)
+				      struct err_regs *info)
 {
 	u32 ec = ERROR_CODE(info->nbsl);
 
@@ -2234,7 +2234,7 @@ static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
  * ADDRESS and process.
  */
 static void amd64_handle_ce(struct mem_ctl_info *mci,
-			    struct amd64_error_info_regs *info)
+			    struct err_regs *info)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 SystemAddress;
@@ -2257,7 +2257,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 
 /* Handle any Un-correctable Errors (UEs) */
 static void amd64_handle_ue(struct mem_ctl_info *mci,
-			    struct amd64_error_info_regs *info)
+			    struct err_regs *info)
 {
 	int csrow;
 	u64 SystemAddress;
@@ -2303,7 +2303,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 }
 
 static void amd64_decode_bus_error(struct mem_ctl_info *mci,
-				   struct amd64_error_info_regs *info)
+				   struct err_regs *info)
 {
 	u32 ec  = ERROR_CODE(info->nbsl);
 	u32 xec = EXT_ERROR_CODE(info->nbsl);
@@ -2354,22 +2354,18 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
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
@@ -2435,13 +2431,13 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
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
@@ -2478,10 +2474,10 @@ EXPORT_SYMBOL_GPL(amd64_process_error_info);
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
index 1ddef8d..bde8f78 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -449,7 +449,7 @@ enum amd64_chipset_families {
  *
  * Depends on entry into the modules
  */
-struct amd64_error_info_regs {
+struct err_regs {
 	u32 nbcfg;
 	u32 nbsh;
 	u32 nbsl;
@@ -527,7 +527,7 @@ struct amd64_pvt {
 	u32 online_spare;               /* On-Line spare Reg */
 
 	/* temp storage for when input is received from sysfs */
-	struct amd64_error_info_regs ctl_error_info;
+	struct err_regs ctl_error_info;
 
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
@@ -586,11 +586,11 @@ struct low_ops {
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
@@ -623,7 +623,7 @@ static inline struct low_ops *family_ops(int index)
 #define F11_MIN_SCRUB_RATE_BITS	0x6
 
 int amd64_process_error_info(struct mem_ctl_info *mci,
-			     struct amd64_error_info_regs *info,
+			     struct err_regs *info,
 			     int handle_errors);
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
-- 
1.6.3.3


