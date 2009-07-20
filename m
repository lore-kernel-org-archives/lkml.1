Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZGTQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZGTQNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZGTQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57006 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZGTQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:39 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KN3922-03-AIO-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 12/14] amd64_edac: decode bus unit MCEs
Date: Mon, 20 Jul 2009 18:13:03 +0200
Message-ID: <1248106385-27514-13-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:15.0452 (UTC) FILETIME=[FCAC17C0:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to Table 69, Fam10h BKDG (31116, rev. 3.28).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2a810c1..603599e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2343,6 +2343,48 @@ wrong_ic_mce:
 	pr_warning("Corrupted IC MCE info?\n");
 }
 
+static void amd64_decode_bu_mce(u64 mc2_status)
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
+		pr_cont(": %s error in the L2 cache tags.\n", RRRR(ec));
+	else if (xec == 0x0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s error in a Page Descriptor Cache or "
+				"Guest TLB.\n", TT(ec));
+		else if (BUS_ERROR(ec))
+			pr_cont(": %s/ECC error in data read from NB: %s.\n",
+				RRRR(ec), PP(ec));
+		else if (MEM_ERROR(ec)) {
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			if (rrrr >= 0x7)
+				pr_cont(": %s error during data copyback.\n",
+					RRRR(ec));
+			else if (rrrr <= 0x1)
+				pr_cont(": %s parity/ECC error during data "
+					"access from L2.\n", RRRR(ec));
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
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
@@ -2444,6 +2486,10 @@ void decode_mce(struct mce *m)
 		amd64_decode_ic_mce(m->status);
 		break;
 
+	case 2:
+		amd64_decode_bu_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


