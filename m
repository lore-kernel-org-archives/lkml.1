Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZG1PKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZG1PKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZG1PKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:10:14 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21611
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753667AbZG1PGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:41 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAT-03-5WY-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 16/20] EDAC, AMD: decode instruction cache MCEs
Date: Tue, 28 Jul 2009 17:06:16 +0200
Message-ID: <1248793580-29899-17-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:29.0628 (UTC) FILETIME=[FC51DBC0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 95

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   61 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 07875d6..54d0de3 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -161,6 +161,63 @@ wrong_dc_mce:
 	pr_warning("Corrupted DC MCE info?\n");
 }
 
+static void amd_decode_ic_mce(u64 mc1_status)
+{
+	u32 ec  = mc1_status & 0xffff;
+	u32 xec = (mc1_status >> 16) & 0xf;
+
+	pr_emerg(" Instruction Cache Error");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
+	else if (xec == 0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s TLB Parity error.\n", LL_MSG(ec));
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
+
+				switch (rrrr) {
+				case 0x5:
+					pr_cont(": Parity error during "
+					       "data load.\n");
+					break;
+
+				case 0x7:
+					pr_cont(": Copyback Parity/Victim"
+						" error.\n");
+					break;
+
+				case 0x8:
+					pr_cont(": Tag Snoop error.\n");
+					break;
+
+				default:
+					goto wrong_ic_mce;
+					break;
+				}
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
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
@@ -249,6 +306,10 @@ void decode_mce(struct mce *m)
 		amd_decode_dc_mce(m->status);
 		break;
 
+	case 1:
+		amd_decode_ic_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


