Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZLIHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZLIHyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZLIHyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:11 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44281 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbZLIHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:09 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <6-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 06:10:43 +0100
Subject: [PATCH 5/7] mtrr: use CONFIG_CPU_SUP_* to select MTRR implementations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_CPU_SUP_* to select MTRR implementations. We let gcc
optimize out the empty switch statement if only generic implementation
is wanted.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/kernel/cpu/mtrr/Makefile |    4 +++-
 arch/x86/kernel/cpu/mtrr/main.c   |   10 ++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..d6e8a92 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,5 @@
 obj-y		:= main.o if.o generic.o state.o cleanup.o
-obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
+obj-$(CONFIG_CPU_SUP_AMD_32) += amd.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_32) += centaur.o
+obj-$(CONFIG_CPU_SUP_CYRIX_32) += cyrix.o
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index bc3436e..737780a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -648,6 +648,7 @@ void __init mtrr_bp_init(void)
 
 			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
+#ifdef CONFIG_CPU_SUP_CENTAUR
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
 			/*
@@ -657,10 +658,11 @@ void __init mtrr_bp_init(void)
 			size_or_mask = 0xfff00000;		/* 32 bits */
 			size_and_mask = 0;
 			phys_addr = 32;
+#endif
 		}
 	} else {
-#ifdef CONFIG_X86_32
 		switch (boot_cpu_data.x86_vendor) {
+#ifdef CONFIG_CPU_SUP_AMD_32
 		case X86_VENDOR_AMD:
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
@@ -669,6 +671,8 @@ void __init mtrr_bp_init(void)
 				size_and_mask = 0;
 			}
 			break;
+#endif
+#ifdef CONFIG_CPU_SUP_CENTAUR_32
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
 				mtrr_if = &centaur_mtrr_ops;
@@ -676,6 +680,8 @@ void __init mtrr_bp_init(void)
 				size_and_mask = 0;
 			}
 			break;
+#endif
+#ifdef CONFIG_CPU_SUP_CYRIX_32
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
 				mtrr_if = &cyrix_mtrr_ops;
@@ -683,10 +689,10 @@ void __init mtrr_bp_init(void)
 				size_and_mask = 0;
 			}
 			break;
+#endif
 		default:
 			break;
 		}
-#endif
 	}
 
 	if (mtrr_if) {
-- 
1.6.4.4

