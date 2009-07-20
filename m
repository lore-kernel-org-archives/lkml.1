Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZGTQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZGTQNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZGTQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:38 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:51728
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236AbZGTQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:27 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KN3922-03-AIM-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 11/14] amd64_edac: decode instruction cache MCEs
Date: Mon, 20 Jul 2009 18:13:02 +0200
Message-ID: <1248106385-27514-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:15.0077 (UTC) FILETIME=[FC72DF50:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 95.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   51 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ee13d59..2a810c1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2296,6 +2296,53 @@ wrong_dc_mce:
 	pr_warning("Corrupted DC MCE info?\n");
 }
 
+static void amd64_decode_ic_mce(u64 mc1_status)
+{
+	u32 ec  = mc1_status & 0xffff;
+	u32 xec = (mc1_status >> 16) & 0xf;
+
+	pr_emerg(" Instruction Cache Error");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL(ec));
+	else if (xec == 0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s TLB Parity error.\n", LL(ec));
+		else if (BUS_ERROR(ec)) {
+			if (boot_cpu_data.x86 == 0xf &&
+			    (mc1_status & (1ULL << 58)))
+				pr_cont(" during system linefill.\n");
+			else
+				pr_cont(" during attempted NB data read.\n");
+		} else if (MEM_ERROR(ec)) {
+			u8 ll   = ec & 0x3;
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			if (ll == 0x2)
+				pr_cont(" during a linefill from L2.\n");
+			else if (ll == 0x1) {
+				if (rrrr == 0x5)
+					pr_cont(": Parity error during "
+					       "data load.\n");
+				else if (rrrr == 0x7)
+					pr_cont(": Copyback Parity/Victim"
+						" error.\n");
+				else if (rrrr == 0x8)
+					pr_cont(": Tag Snoop error.\n");
+				else
+					goto wrong_ic_mce;
+			}
+		} else
+			goto wrong_ic_mce;
+	} else
+		goto wrong_ic_mce;
+
+	return;
+
+wrong_ic_mce:
+	pr_warning("Corrupted IC MCE info?\n");
+}
+
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
@@ -2393,6 +2440,10 @@ void decode_mce(struct mce *m)
 		amd64_decode_dc_mce(m->status);
 		break;
 
+	case 1:
+		amd64_decode_ic_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


