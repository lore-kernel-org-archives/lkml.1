Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZFWLnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZFWLnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZFWLnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:43:14 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:34747
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754116AbZFWLnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:43:13 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KLOWJT-01-IXV-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH 1/3] amd64_edac: check only ECC bit in amd64_determine_edac_cap
Date: Tue, 23 Jun 2009 13:43:01 +0200
Message-ID: <1245757383-21333-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 23 Jun 2009 11:43:06.0810 (UTC) FILETIME=[C66A59A0:01C9F3F7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking whether the machine is using ECC enabled DRAM is done through
testing the DimmEccEn bit in the DRAM Cfg Low register (F2x[1,0]90). Do
that instead of testing all bits from the DimmEccEn upwards.

Also, remove mci->edac_cap assignment and use value returned from
amd64_determine_edac_cap().

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c36bf40..3b76605 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -754,13 +754,13 @@ static void amd64_cpu_display_info(struct amd64_pvt *pvt)
 static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 {
 	int bit;
-	enum dev_type edac_cap = EDAC_NONE;
+	enum dev_type edac_cap = EDAC_FLAG_NONE;
 
 	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= OPTERON_CPU_REV_F)
 		? 19
 		: 17;
 
-	if (pvt->dclr0 >> BIT(bit))
+	if (pvt->dclr0 & BIT(bit))
 		edac_cap = EDAC_FLAG_SECDED;
 
 	return edac_cap;
@@ -3006,7 +3006,6 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 
 	mci->mtype_cap		= MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
 	mci->edac_ctl_cap	= EDAC_FLAG_NONE;
-	mci->edac_cap		= EDAC_FLAG_NONE;
 
 	if (pvt->nbcap & K8_NBCAP_SECDED)
 		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
-- 
1.6.3.1


