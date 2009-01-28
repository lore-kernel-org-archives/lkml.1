Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbZA2AKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbZA2AKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZA1Xpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:53125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbZA1Xpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:52 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 065/114] x86, smp: remove ->restore_NMI_vector()
Date: Wed, 28 Jan 2009 23:42:11 +0000
Message-Id: <1233186180-29883-66-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing actually restores the NMI vector - so remove this
logic altogether.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h       |    1 -
 arch/x86/include/asm/numaq/wakecpu.h |   10 ----------
 arch/x86/kernel/genapic_flat_64.c    |    2 --
 arch/x86/kernel/genx2apic_cluster.c  |    1 -
 arch/x86/kernel/genx2apic_phys.c     |    1 -
 arch/x86/kernel/genx2apic_uv_x.c     |    1 -
 arch/x86/mach-generic/bigsmp.c       |    1 -
 arch/x86/mach-generic/default.c      |    1 -
 arch/x86/mach-generic/es7000.c       |    1 -
 arch/x86/mach-generic/numaq.c        |    1 -
 arch/x86/mach-generic/summit.c       |    1 -
 11 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 90e83a7..e5f9c56 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -82,7 +82,6 @@ struct genapic {
 	void (*wait_for_init_deassert)(atomic_t *deassert);
 	void (*smp_callin_clear_local_apic)(void);
 	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
-	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
 	void (*inquire_remote_apic)(int apicid);
 };
 
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
index 1232017..920dcfe 100644
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ b/arch/x86/include/asm/numaq/wakecpu.h
@@ -25,16 +25,6 @@ numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
 	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
 }
 
-static inline void
-numaq_restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-	printk("Restoring NMI vector\n");
-	*((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH)) =
-								 *high;
-	*((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW)) =
-								 *low;
-}
-
 static inline void inquire_remote_apic(int apicid)
 {
 }
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 3a28d6a..e9237f5 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -229,7 +229,6 @@ struct genapic apic_flat =  {
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
@@ -375,6 +374,5 @@ struct genapic apic_physflat =  {
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index abc5ee3..7c87156 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -233,6 +233,5 @@ struct genapic apic_x2apic_cluster = {
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index dc815ef..5cbae8a 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -219,6 +219,5 @@ struct genapic apic_x2apic_phys = {
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index b590873..6adb5e6 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -292,7 +292,6 @@ struct genapic apic_x2apic_uv_x = {
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index ecdb230..d9377af 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -111,6 +111,5 @@ struct genapic apic_bigsmp = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 9509256..b004257 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -92,6 +92,5 @@ struct genapic apic_default = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 1319070..62673a8 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -148,6 +148,5 @@ struct genapic apic_es7000 = {
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index d7f7fcf..2c33415 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -112,6 +112,5 @@ struct genapic apic_numaq = {
 
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.store_NMI_vector		= numaq_store_NMI_vector,
-	.restore_NMI_vector		= numaq_restore_NMI_vector,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 46fca79..c2471a9 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -91,6 +91,5 @@ struct genapic apic_summit = {
 
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
-	.restore_NMI_vector		= NULL,
 	.inquire_remote_apic		= inquire_remote_apic,
 };
-- 
1.6.0.2

