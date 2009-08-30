Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZH3Luf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZH3Luf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 07:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZH3Lue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 07:50:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44791 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbZH3Lud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 07:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fwU8NXaWwhgM1JQObMxzKyYkH7kZgFgyA1dsNW/K1SlHT+X75oMHofk9+srwpYYTzA
         RAZ2wrelgtFTpeI4f70DbNknjsE4BufNFryEKLtydN/JZfnGyLSmPvMr5u3IQ8RPmt2R
         RB1ubYVU231roaUh4TMhoaOdI+Ezj3OQ05FR4=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Date: Sun, 30 Aug 2009 13:50:31 +0200
Message-Id: <1251633031-2244-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <20090830114329.GA9038@liondog.tnic>
References: <20090830114329.GA9038@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

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

