Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZHaHuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZHaHuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZHaHuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:50:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZHaHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aZfX41kF+nPSBwL4eaqGlyOVtMRadVW+WOHfiYZAXoraCRyAGnPN6KCInXTReGhkld
         7L/iKBhfOtEjsROSPMoqkw869yPN5DB6UPf3sjScDKjy9gae7Bmxrx8B7RPL3mYNwuAX
         GLTeF0ULvZCOYbWiHpOfzNbxKtc6emIsSXP20=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Date: Mon, 31 Aug 2009 09:50:11 +0200
Message-Id: <1251705011-18636-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <20090831073429.GA26596@liondog.tnic>
References: <20090831073429.GA26596@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
/proc/cpuinfo. However, a proper/full fix would be to additionally
turn off the bit in the CPUID output so that future callers get
correct CPU features info.

Do that by basically reversing what the BIOS wrongfully does at boot.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 63fddcd..0a717fc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -404,9 +404,18 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
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
+				wrmsrl_amd_safe(0xc001100d, val);
+			}
+		}
+
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-- 
1.6.3.3

