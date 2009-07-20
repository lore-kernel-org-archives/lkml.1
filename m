Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZGTQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZGTQNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZGTQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:42 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:3561 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752525AbZGTQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:29 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KN3921-04-7E4-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 10/14] amd64_edac: decode data cache MCEs
Date: Mon, 20 Jul 2009 18:13:01 +0200
Message-ID: <1248106385-27514-11-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:14.0702 (UTC) FILETIME=[FC39A6E0:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those get reported in MC0_STATUS, see F10h BKDG (31116, rev. 3.28),
Table 92 for more details.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   56 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e4a0c91..ee13d59 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2253,6 +2253,49 @@ static void amd64_decode_bus_error(struct mem_ctl_info *mci,
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR "Error Overflow");
 }
 
+static void amd64_decode_dc_mce(u64 mc0_status)
+{
+	u32 ec  = mc0_status & 0xffff;
+	u32 xec = (mc0_status >> 16) & 0xf;
+
+	pr_emerg(" Data Cache Error");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL(ec));
+	else if (xec == 0) {
+		if (mc0_status & (1ULL << 40))
+			pr_cont(" during Data Scrub.\n");
+		else if (TLB_ERROR(ec))
+			pr_cont(": %s TLB parity error.\n", LL(ec));
+		else if (MEM_ERROR(ec)) {
+			u8 ll   = ec & 0x3;
+			u8 tt   = (ec >> 2) & 0x3;
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			/* see F10h BKDG (31116), Table 92. */
+			if (ll == 0x1) {
+				if (tt != 0x1)
+					goto wrong_dc_mce;
+
+				pr_cont(": Data/Tag %s error.\n", RRRR(ec));
+
+			} else if (ll == 0x2 && rrrr == 0x3)
+				pr_cont(" during L1 linefill from L2.\n");
+			else
+				goto wrong_dc_mce;
+		} else if (BUS_ERROR(ec) && boot_cpu_data.x86 == 0xf)
+			pr_cont(" during system linefill.\n");
+		else
+			goto wrong_dc_mce;
+	} else
+		goto wrong_dc_mce;
+
+	return;
+
+wrong_dc_mce:
+	pr_warning("Corrupted DC MCE info?\n");
+}
+
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
@@ -2345,16 +2388,25 @@ void decode_mce(struct mce *m)
 
 	pr_cont("\n");
 
-	amd64_decode_err_code(m->status & 0xffff);
+	switch (m->bank) {
+	case 0:
+		amd64_decode_dc_mce(m->status);
+		break;
 
-	if (m->bank == 4) {
+	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
 		regs.nbeal = (u32) m->addr;
 		regs.nbeah = (u32)(m->addr >> 32);
 
 		amd64_decode_nb_mce(mci_lookup[0], &regs, 1, ecc);
+		break;
+
+	default:
+		break;
 	}
+
+	amd64_decode_err_code(m->status & 0xffff);
 }
 
 /*
-- 
1.6.3.3


