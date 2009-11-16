Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZKPOQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZKPOQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZKPOQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:40 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11902 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZKPOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:38 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ2-02-PYY-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 14/21] amd64_edac: remove unneeded extract_error_address wrapper
Date: Mon, 16 Nov 2009 15:16:41 +0100
Message-ID: <1258381008-18783-15-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0125 (UTC) FILETIME=[5A324750:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 202f08e..c403af2 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -763,21 +763,6 @@ static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
 	*input_addr_max = base | mask | pvt->dcs_mask_notused;
 }
 
-/*
- * Extract error address from MCA NB Address Low (section 3.6.4.5) and MCA NB
- * Address High (section 3.6.4.6) register values and return the result. Address
- * is located in the info structure (nbeah and nbeal), the encoding is device
- * specific.
- */
-static u64 extract_error_address(struct mem_ctl_info *mci,
-				 struct err_regs *info)
-{
-	struct amd64_pvt *pvt = mci->pvt_info;
-
-	return pvt->ops->get_error_address(mci, info);
-}
-
-
 /* Map the Error address to a PAGE and PAGE OFFSET. */
 static inline void error_address_to_page_and_offset(u64 error_address,
 						    u32 *page, u32 *offset)
@@ -2118,7 +2103,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	sys_addr = extract_error_address(mci, info);
+	sys_addr = pvt->ops->get_error_address(mci, info);
 
 	amd64_mc_printk(mci, KERN_ERR,
 		"CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
@@ -2130,10 +2115,11 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 static void amd64_handle_ue(struct mem_ctl_info *mci,
 			    struct err_regs *info)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
+	struct mem_ctl_info *log_mci, *src_mci = NULL;
 	int csrow;
 	u64 sys_addr;
 	u32 page, offset;
-	struct mem_ctl_info *log_mci, *src_mci = NULL;
 
 	log_mci = mci;
 
@@ -2144,7 +2130,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 		return;
 	}
 
-	sys_addr = extract_error_address(mci, info);
+	sys_addr = pvt->ops->get_error_address(mci, info);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
-- 
1.6.4.3


