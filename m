Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZHUGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZHUGdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZHUGdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:33:36 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:4889 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751440AbZHUGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:33:35 -0400
X-SpamScore: 3
X-BigFish: VPS3(zz10d1Izz1202hzz5a6ciz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOPRJT-04-68M-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>
CC: kjwinchester@gmail.com, mikpe@it.uu.se, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: [RESEND PATCH 2/2] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Date: Fri, 21 Aug 2009 08:33:19 +0200
Message-ID: <1250836399-3274-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250836399-3274-1-git-send-email-borislav.petkov@amd.com>
References: <1250836399-3274-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 21 Aug 2009 06:33:22.0775 (UTC) FILETIME=[47D6E670:01CA2229]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
/proc/cpuinfo. However, a proper/full fix would be to additionally
turn off the bit in the CPUID output so that future callers get
correct CPU features info.

Do that by basically reversing what the BIOS wrongfully does at boot.

Tested-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: kjwinchester@gmail.com
Cc: mikpe@it.uu.se
Cc: brgerst@gmail.com
---
 arch/x86/kernel/cpu/amd.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 63fddcd..0ee63dd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -404,9 +404,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		/*
 		 * Some BIOSes incorrectly force this feature, but only K8
 		 * revision D (model = 0x14) and later actually support it.
+		 * (AMD Erratum #110, docId: 25759).
 		 */
-		if (c->x86_model < 0x14)
+		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
+			u64 val;
+
 			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
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


