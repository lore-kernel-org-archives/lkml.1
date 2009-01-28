Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZA2AII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZA2AII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbZA1Xpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:53093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758414AbZA1Xpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:42 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 061/114] x86: set ->trampoline_phys_low/high on 64-bit too
Date: Wed, 28 Jan 2009 23:42:07 +0000
Message-Id: <1233186180-29883-62-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit x86 has zero for ->trampoline_phys_low/high, but the smpboot
code can use these values - so it's better to set them up to their
correct values.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h                   |    6 ++++++
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    3 ---
 arch/x86/kernel/genapic_flat_64.c                |    8 ++++----
 arch/x86/kernel/genx2apic_cluster.c              |    4 ++--
 arch/x86/kernel/genx2apic_phys.c                 |    4 ++--
 arch/x86/kernel/genx2apic_uv_x.c                 |    4 ++--
 6 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 8bb1c73..90e83a7 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -88,6 +88,12 @@ struct genapic {
 
 extern struct genapic *apic;
 
+/*
+ * Warm reset vector default position:
+ */
+#define DEFAULT_TRAMPOLINE_PHYS_LOW		0x467
+#define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
+
 #ifdef CONFIG_X86_32
 extern void es7000_update_genapic_to_cluster(void);
 #else
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index 0a8d786..a327a67 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -1,9 +1,6 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 #define _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H
 
-#define DEFAULT_TRAMPOLINE_PHYS_LOW (0x467)
-#define DEFAULT_TRAMPOLINE_PHYS_HIGH (0x469)
-
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 7c648cc..3a28d6a 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -224,8 +224,8 @@ struct genapic apic_flat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= 0,
-	.trampoline_phys_high		= 0,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
@@ -370,8 +370,8 @@ struct genapic apic_physflat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= 0,
-	.trampoline_phys_high		= 0,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 2d97726..abc5ee3 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -228,8 +228,8 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= 0,
-	.trampoline_phys_high		= 0,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 74777c2..dc815ef 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -214,8 +214,8 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= 0,
-	.trampoline_phys_high		= 0,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 24b9f42..b590873 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -287,8 +287,8 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_self			= uv_send_IPI_self,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= 0,
-	.trampoline_phys_high		= 0,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-- 
1.6.0.2

