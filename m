Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZHaXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZHaXh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZHaXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:37:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:57069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZHaXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:37:53 -0400
Date: Mon, 31 Aug 2009 23:37:40 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1251705011-18636-3-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-3-git-send-email-petkovbb@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <tip-6b0f43ddfa358dc71ad2a2d57bce5906c1c5dc1a@git.kernel.org>
Git-Commit-ID: 6b0f43ddfa358dc71ad2a2d57bce5906c1c5dc1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 23:37:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b0f43ddfa358dc71ad2a2d57bce5906c1c5dc1a
Gitweb:     http://git.kernel.org/tip/6b0f43ddfa358dc71ad2a2d57bce5906c1c5dc1a
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 31 Aug 2009 09:50:11 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 31 Aug 2009 15:14:29 -0700

x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit

fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
/proc/cpuinfo. However, a proper/full fix would be to additionally
turn off the bit in the CPUID output so that future callers get
correct CPU features info.

Do that by basically reversing what the BIOS wrongfully does at boot.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1251705011-18636-3-git-send-email-petkovbb@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


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
