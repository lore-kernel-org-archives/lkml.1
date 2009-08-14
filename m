Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZHNMHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZHNMHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZHNMG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:06:59 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:26749 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754684AbZHNMG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:06:58 -0400
X-SpamScore: 3
X-BigFish: VPS3(zz10d1Izz1202hzz5a6ciz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOD8B3-04-UI5-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>
CC: kjwinchester@gmail.com, mikpe@it.uu.se, brgerst@gmail.com,
       <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 2/2] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Date: Fri, 14 Aug 2009 14:06:34 +0200
Message-ID: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090814120031.GA7197@aftab>
References: <20090814120031.GA7197@aftab>
X-OriginalArrivalTime: 14 Aug 2009 12:06:39.0577 (UTC) FILETIME=[ADF87C90:01CA1CD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
/proc/cpuinfo. However, a proper fix would be to additionally turn off
the bit in the CPUID output so that future callers get correct CPU
features info. Do that by basically reversing what the BIOS wrongfully
does at boot.

Tested-by: Kevin Winchester <kjwinchester@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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


