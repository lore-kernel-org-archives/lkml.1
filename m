Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZGTQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZGTQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZGTQPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:15:48 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:39833
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751855AbZGTQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:27 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 8,
X-WSS-ID: 0KN3921-04-7E1-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 05/14] amd64_edac: remove memory and GART TLB error decoders
Date: Mon, 20 Jul 2009 18:12:56 +0200
Message-ID: <1248106385-27514-6-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:12.0812 (UTC) FILETIME=[FB1942C0:01CA0954]
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
index d53f0f6..9db18c8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2150,28 +2150,6 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 	return 1;
 }
 
-static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
-					 struct err_regs *info)
-{
-	u32 ec = ERROR_CODE(info->nbsl);
-
-	amd64_mc_printk(mci, KERN_ERR,
-		     "GART TLB event: transaction type(%s), "
-		     "cache level(%s)\n", TT(ec), LL(ec));
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
-		     RRRR(ec), TT(ec), LL(ec));
-}
-
-
 /*
  * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
  * ADDRESS and process.
@@ -2354,19 +2332,19 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		if (!report_gart_errors)
 			return;
 
-		pr_emerg("GART TLB error\n");
-		amd64_decode_gart_tlb_error(mci, regs);
+		pr_emerg(" GART TLB error, Transaction: %s, Cache Level %s\n",
+			 TT(ec), LL(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg("Memory/Cache error\n");
-		amd64_decode_mem_cache_error(mci, regs);
+		pr_emerg(" Memory/Cache error, Transaction: %s, Type: %s,"
+			 " Cache Level: %s",
+			 RRRR(ec), TT(ec), LL(ec));
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
 
 	pr_emerg("%s.\n", EXT_ERR_DESC(xec));
-- 
1.6.3.3


