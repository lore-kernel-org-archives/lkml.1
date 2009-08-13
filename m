Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZHMMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZHMMbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZHMMbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:31:42 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:22056
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498AbZHMMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:31:42 -0400
X-SpamScore: 11
X-BigFish: VPS11(zza4b1ozz1202hzz5a6ciz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOBESJ-03-GL6-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: kjwinchester@gmail.com
CC: mikpe@it.uu.se, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM flag
Date: Thu, 13 Aug 2009 14:31:27 +0200
Message-ID: <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090813122337.GB7029@aftab>
References: <20090813122337.GB7029@aftab>
X-OriginalArrivalTime: 13 Aug 2009 12:31:29.0082 (UTC) FILETIME=[FB5F29A0:01CA1C11]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Winchester <kjwinchester@gmail.com>

Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
need to force enable the LAHF_LM capability.  Unfortunately, in at
least one case, the BIOS does this even for processors that do not
support the functionality.

Add a specific check that will clear the feature bit for processors
known not to support the LAHF/SAHF instructions.

Borislav: turn off cpuid bit.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..9cd6fc7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,22 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly force this feature, but only K8
+		 * revision D (model = 0x14) and later actually support it.
+		 */
+		if (c->x86_model < 0x14) {
+			u64 val;
+
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
+			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
+				val &= ~(1ULL << 32);
+				wrmsr_amd_safe(0xc001100d, (u32) val,
+							   (u32)(val >> 32));
+			}
+		}
+
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-- 
1.6.3.3


