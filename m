Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZKPORM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZKPORM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZKPOQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:37 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:38218 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZKPOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:35 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ1-02-PYX-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 08/21] amd64_edac: cleanup rest of amd64_dump_misc_regs
Date: Mon, 16 Nov 2009 15:16:35 +0100
Message-ID: <1258381008-18783-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0969 (UTC) FILETIME=[5A1A7990:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify bitfields description, add PCI config function/offset names to
registers for easy reference, simplify code layout, remove unneeded
info.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cdda8d4..c65ad2d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -862,32 +862,23 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 
 	amd64_dump_dramcfg_low(pvt->dclr0, 0);
 
-	debugf1("  online-spare: 0x%8.08x\n", pvt->online_spare);
+	debugf1("F3xB0 (Online Spare): 0x%08x\n", pvt->online_spare);
 
-	if (boot_cpu_data.x86 == 0xf) {
-		debugf1("  dhar: 0x%8.08x Base=0x%08x Offset=0x%08x\n",
-			pvt->dhar, dhar_base(pvt->dhar),
-			k8_dhar_offset(pvt->dhar));
-		debugf1("      DramHoleValid=%s\n",
-			(pvt->dhar & DHAR_VALID) ?  "True" : "False");
+	debugf1("F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, "
+			"offset: 0x%08x\n",
+			pvt->dhar,
+			dhar_base(pvt->dhar),
+			(boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt->dhar)
+						   : f10_dhar_offset(pvt->dhar));
 
-		debugf1("  dbam-dkt: 0x%8.08x\n", pvt->dbam0);
+	debugf1("  DramHoleValid: %s\n",
+		(pvt->dhar & DHAR_VALID) ? "yes" : "no");
 
-		/* everything below this point is Fam10h and above */
+	/* everything below this point is Fam10h and above */
+	if (boot_cpu_data.x86 == 0xf)
 		return;
 
-	} else {
-		debugf1("  dhar: 0x%8.08x Base=0x%08x Offset=0x%08x\n",
-			pvt->dhar, dhar_base(pvt->dhar),
-			f10_dhar_offset(pvt->dhar));
-		debugf1("    DramMemHoistValid=%s DramHoleValid=%s\n",
-			(pvt->dhar & F10_DRAM_MEM_HOIST_VALID) ?
-			"True" : "False",
-			(pvt->dhar & DHAR_VALID) ?
-			"True" : "False");
-	}
-
-	/* Only if NOT ganged does dcl1 have valid info */
+	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
 		amd64_dump_dramcfg_low(pvt->dclr1, 1);
 
-- 
1.6.4.3


