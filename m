Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZG1PGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZG1PGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZG1PGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:44 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12074 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbZG1PGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAS-03-5WW-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 15/20] EDAC, AMD: decode data cache MCEs
Date: Tue, 28 Jul 2009 17:06:15 +0200
Message-ID: <1248793580-29899-16-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:29.0269 (UTC) FILETIME=[FC1B1450:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those get reported in MC0_STATUS, see Table 92, F10h BKDG (31116, rev.
3.28) for more details.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   56 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index e332da0..07875d6 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -118,6 +118,49 @@ const char *ext_msgs[] = {
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
 
+static void amd_decode_dc_mce(u64 mc0_status)
+{
+	u32 ec  = mc0_status & 0xffff;
+	u32 xec = (mc0_status >> 16) & 0xf;
+
+	pr_emerg(" Data Cache Error");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
+	else if (xec == 0) {
+		if (mc0_status & (1ULL << 40))
+			pr_cont(" during Data Scrub.\n");
+		else if (TLB_ERROR(ec))
+			pr_cont(": %s TLB parity error.\n", LL_MSG(ec));
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
+				pr_cont(": Data/Tag %s error.\n", RRRR_MSG(ec));
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
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
@@ -201,9 +244,12 @@ void decode_mce(struct mce *m)
 
 	pr_cont("\n");
 
-	amd_decode_err_code(m->status & 0xffff);
+	switch (m->bank) {
+	case 0:
+		amd_decode_dc_mce(m->status);
+		break;
 
-	if (m->bank == 4) {
+	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
 		regs.nbeal = (u32) m->addr;
@@ -211,5 +257,11 @@ void decode_mce(struct mce *m)
 		node       = cpu_data(m->extcpu).cpu_node_id;
 
 		amd_decode_nb_mce(node, &regs, 1);
+		break;
+
+	default:
+		break;
 	}
+
+	amd_decode_err_code(m->status & 0xffff);
 }
-- 
1.6.3.3


