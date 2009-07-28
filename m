Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZG1PJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZG1PJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZG1PGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:43 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21611
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753682AbZG1PGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAT-03-5WZ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 18/20] EDAC, AMD: decode load store MCEs
Date: Tue, 28 Jul 2009 17:06:18 +0200
Message-ID: <1248793580-29899-19-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:30.0394 (UTC) FILETIME=[FCC6BDA0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 100.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index ab0e6e7..1c4468f 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -260,6 +260,27 @@ wrong_bu_mce:
 	pr_warning("Corrupted BU MCE info?\n");
 }
 
+static void amd_decode_ls_mce(u64 mc3_status)
+{
+	u32 ec  = mc3_status & 0xffff;
+	u32 xec = (mc3_status >> 16) & 0xf;
+
+	pr_emerg(" Load Store Error");
+
+	if (xec == 0x0) {
+		u8 rrrr = (ec >> 4) & 0xf;
+
+		if (!BUS_ERROR(ec) || (rrrr != 0x3 && rrrr != 0x4))
+			goto wrong_ls_mce;
+
+		pr_cont(" during %s.\n", RRRR_MSG(ec));
+	}
+	return;
+
+wrong_ls_mce:
+	pr_warning("Corrupted LS MCE info?\n");
+}
+
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
@@ -356,6 +377,10 @@ void decode_mce(struct mce *m)
 		amd_decode_bu_mce(m->status);
 		break;
 
+	case 3:
+		amd_decode_ls_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


