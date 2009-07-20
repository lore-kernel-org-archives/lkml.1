Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZGTQNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZGTQNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZGTQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:40 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:3561 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752418AbZGTQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:28 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN3922-04-7E5-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 13/14] amd64_edac: decode load store MCEs
Date: Mon, 20 Jul 2009 18:13:04 +0200
Message-ID: <1248106385-27514-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:15.0843 (UTC) FILETIME=[FCE7C130:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 100.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 603599e..175f95e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2385,6 +2385,27 @@ wrong_bu_mce:
 	pr_warning("Corrupted BU MCE info?\n");
 }
 
+static void amd64_decode_ls_mce(u64 mc3_status)
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
+		pr_cont(" during %s.\n", RRRR(ec));
+	}
+	return;
+
+wrong_ls_mce:
+	pr_warning("Corrupted LS MCE info?\n");
+}
+
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
@@ -2490,6 +2511,10 @@ void decode_mce(struct mce *m)
 		amd64_decode_bu_mce(m->status);
 		break;
 
+	case 3:
+		amd64_decode_ls_mce(m->status);
+		break;
+
 	case 4:
 		regs.nbsl  = (u32) m->status;
 		regs.nbsh  = (u32)(m->status >> 32);
-- 
1.6.3.3


