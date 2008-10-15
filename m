Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYJOVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYJOVFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYJOVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:02:59 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4482 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYJOVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:57 -0400
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K8ST4A-02-I74-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 8/8] x86/oprofile: add the logic for enabling additional IBS bits
Date: Wed, 15 Oct 2008 22:09:10 +0200
Message-ID: <1224101350-12877-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0971 (UTC) FILETIME=[5B4C54B0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch adds the logic for enabling additional IBS control bits :
* IBS-Fetch IbsRandEn bit (bit 57)
* IBS-Op IbsOpCntCtl bit (bit 19)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index a2e83af..5095137 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -310,12 +310,15 @@ static void op_amd_start(struct op_msrs const * const msrs)
 #ifdef CONFIG_OPROFILE_IBS
 	if (ibs_allowed && ibs_config.fetch_enabled) {
 		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
-		high = IBS_FETCH_HIGH_ENABLE;
+		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
+			+ IBS_FETCH_HIGH_ENABLE;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
 	if (ibs_allowed && ibs_config.op_enabled) {
-		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_LOW_ENABLE;
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
+			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
+			+ IBS_OP_LOW_ENABLE;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
-- 
1.6.0.1


