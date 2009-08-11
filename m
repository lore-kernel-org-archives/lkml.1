Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZHKL7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZHKL7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZHKL7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZHKL73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:29 -0400
Date: Tue, 11 Aug 2009 11:36:39 GMT
From: tip-bot for Kevin Winchester <kjwinchester@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, kjwinchester@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, kjwinchester@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A80A5AD.2000209@gmail.com>
References: <4A80A5AD.2000209@gmail.com>
Subject: [tip:x86/urgent] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM flag
Message-ID: <tip-fbd8b1819e80ac5a176d085fdddc3a34d1499318@git.kernel.org>
Git-Commit-ID: fbd8b1819e80ac5a176d085fdddc3a34d1499318
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 11 Aug 2009 11:36:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbd8b1819e80ac5a176d085fdddc3a34d1499318
Gitweb:     http://git.kernel.org/tip/fbd8b1819e80ac5a176d085fdddc3a34d1499318
Author:     Kevin Winchester <kjwinchester@gmail.com>
AuthorDate: Mon, 10 Aug 2009 19:56:45 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Aug 2009 13:34:54 +0200

x86: Clear incorrectly forced X86_FEATURE_LAHF_LM flag

Due to an erratum with certain AMD Athlon 64 processors, the
BIOS may need to force enable the LAHF_LM capability.
Unfortunately, in at least one case, the BIOS does this even
for processors that do not support the functionality.

Add a specific check that will clear the feature bit for
processors known not to support the LAHF/SAHF instructions.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Acked-by: Borislav Petkov <petkovbb@googlemail.com>
LKML-Reference: <4A80A5AD.2000209@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/amd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..63fddcd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly force this feature, but only K8
+		 * revision D (model = 0x14) and later actually support it.
+		 */
+		if (c->x86_model < 0x14)
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
