Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZG1PGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZG1PGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZG1PGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:15247 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZG1PGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:35 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAP-04-4GU-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 10/20] amd64_edac: remove memory and GART TLB error decoders
Date: Tue, 28 Jul 2009 17:06:10 +0200
Message-ID: <1248793580-29899-11-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:27.0050 (UTC) FILETIME=[FAC87CA0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   36 +++++++-----------------------------
 1 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 455d143..298020e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2207,28 +2207,6 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 	return 1;
 }
 
-static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
-					 struct err_regs *info)
-{
-	u32 ec = ERROR_CODE(info->nbsl);
-
-	amd64_mc_printk(mci, KERN_ERR,
-		     "GART TLB event: transaction type(%s), "
-		     "cache level(%s)\n", TT_MSG(ec), LL_MSG(ec));
-}
-
-static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
-				      struct err_regs *info)
-{
-	u32 ec = ERROR_CODE(info->nbsl);
-
-	amd64_mc_printk(mci, KERN_ERR,
-		     "cache hierarchy error: memory transaction type(%s), "
-		     "transaction type(%s), cache level(%s)\n",
-		     RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
-}
-
-
 /*
  * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
  * ADDRESS and process.
@@ -2409,19 +2387,19 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		if (!report_gart_errors)
 			return;
 
-		pr_emerg("GART TLB error\n");
-		amd64_decode_gart_tlb_error(mci, regs);
+		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
+			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg("Memory/Cache error\n");
-		amd64_decode_mem_cache_error(mci, regs);
+		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
+			 " Cache Level: %s",
+			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg("Bus (Link/DRAM) error\n");
+		pr_emerg(" Bus (Link/DRAM) error\n");
 		amd64_decode_bus_error(mci, regs);
 	} else {
 		/* shouldn't reach here! */
 		amd64_mc_printk(mci, KERN_WARNING,
-			     "%s(): unknown MCE error 0x%x\n", __func__,
-			     ec);
+				"%s(): unknown MCE error 0x%x\n", __func__, ec);
 	}
 
 	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
-- 
1.6.3.3


