Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZHORHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZHORHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZHORH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:07:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbZHORH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:07:26 -0400
Date: Sat, 15 Aug 2009 17:06:52 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kjwinchester@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
Subject: [tip:x86/urgent] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
Git-Commit-ID: c74cb13b94118ec89e48849806356b67caa5ff86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c74cb13b94118ec89e48849806356b67caa5ff86
Gitweb:     http://git.kernel.org/tip/c74cb13b94118ec89e48849806356b67caa5ff86
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 14 Aug 2009 14:06:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 18:43:59 +0200

x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit

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
LKML-Reference: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
