Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZG1PKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZG1PKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZG1PKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:10:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47965 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZG1PGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:41 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAT-01-0OF-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 17/20] EDAC, AMD: decode bus unit MCEs
Date: Tue, 28 Jul 2009 17:06:17 +0200
Message-ID: <1248793580-29899-18-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:30.0003 (UTC) FILETIME=[FC8B1430:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... according to Table 69, Fam10h BKDG (31116, rev. 3.28).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 54d0de3..ab0e6e7 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -218,6 +218,48 @@ wrong_ic_mce:
 	pr_warning("Corrupted IC MCE info?\n");
 }
 
+static void amd_decode_bu_mce(u64 mc2_status)
+{
+	u32 ec = mc2_status & 0xffff;
+	u32 xec = (mc2_status >> 16) & 0xf;
+
+	pr_emerg(" Bus Unit Error");
+
+	if (xec == 0x1)
+		pr_cont(" in the write data buffers.\n");
+	else if (xec == 0x3)
+		pr_cont(" in the victim data buffers.\n");
+	else if (xec == 0x2 && MEM_ERROR(ec))
+		pr_cont(": %s error in the L2 cache tags.\n", RRRR_MSG(ec));
+	else if (xec == 0x0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s error in a Page Descriptor Cache or "
+				"Guest TLB.\n", TT_MSG(ec));
+		else if (BUS_ERROR(ec))
+			pr_cont(": %s/ECC error in data read from NB: %s.\n",
+				RRRR_MSG(ec), PP_MSG(ec));
+		else if (MEM_ERROR(ec)) {
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			if (rrrr >= 0x7)
+				pr_cont(": %s error during data copyback.\n",
+					RRRR_MSG(ec));
+			else if (rrrr <= 0x1)
+				pr_cont(": %s parity/ECC error during data "
+					"access from L2.\n", RRRR_MSG(ec));
+			else
+				goto wrong_bu_mce;
+		} else
+			goto wrong_bu_mce;
+	} else
+		goto wrong_bu_mce;
+
+	return;
+
+wrong_bu_mce:
+	pr_warning("Corrupted BU MCE info?\n");
+}
+
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
@@ -310,6 +352,10 @@ void decode_mce(struct mce *m)
 		amd_decode_ic_mce(m->status);
 		break;
 
+	case 2:
+		amd_decode_bu_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


