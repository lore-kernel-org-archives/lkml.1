Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbXKOQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbXKOQRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbXKOQRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:17:25 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43001 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751750AbXKOQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:17:25 -0500
Date: Thu, 15 Nov 2007 17:17:03 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071115161703.GR4250@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 unification resulted in CONFIG_X86_HT no longer being
set if (X86_32 && MK8).

After grep'ing through the tree I think the problem is that different 
places have different assumptions about the semantics of CONFIG_X86_HT,
either:
- hyperthreading or
- multicore
and the SCHED_SMT and SCHED_MC dependencies are just one of the 
symptoms.

This should be sorted out properly, but until then we should keep the 
2.6.23 status quo.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

18fef247715449d36438fe4de59fdf430f1b5c37 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1eb5997..2c357f0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -148,7 +148,8 @@ config X86_SMP
 
 config X86_HT
 	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
+	depends on SMP
+	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
 	default y
 
 config X86_BIOS_REBOOT
@@ -476,7 +477,7 @@ config NR_CPUS
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
-	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
+	depends on X86_HT
 	help
 	  SMT scheduler support improves the CPU scheduler's decision making
 	  when dealing with Intel Pentium 4 chips with HyperThreading at a
@@ -485,7 +486,7 @@ config SCHED_SMT
 
 config SCHED_MC
 	bool "Multi-core scheduler support"
-	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
+	depends on X86_HT
 	default y
 	help
 	  Multi-core scheduler support improves the CPU scheduler's decision

