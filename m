Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbZA1X4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbZA1X4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbZA1XoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:37563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbZA1XoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:23 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 032/114] x86: rename ->ESR_DISABLE to ->disable_esr
Date: Wed, 28 Jan 2009 23:41:38 +0000
Message-Id: <1233186180-29883-33-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the ->ESR_DISABLE shouting variant was used to enable the esr_disable
macro wrappers. Those ugly macros are removed now so we can rename
->ESR_DISABLE to ->disable_esr

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h      |    2 +-
 arch/x86/kernel/apic.c              |    4 ++--
 arch/x86/kernel/genapic_flat_64.c   |    4 ++--
 arch/x86/kernel/genx2apic_cluster.c |    2 +-
 arch/x86/kernel/genx2apic_phys.c    |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c    |    2 +-
 arch/x86/mach-generic/bigsmp.c      |    2 +-
 arch/x86/mach-generic/default.c     |    2 +-
 arch/x86/mach-generic/es7000.c      |    2 +-
 arch/x86/mach-generic/numaq.c       |    2 +-
 arch/x86/mach-generic/summit.c      |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index e998e3d..7aee4a4 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -28,7 +28,7 @@ struct genapic {
 
 	const struct cpumask *(*target_cpus)(void);
 
-	int ESR_DISABLE;
+	int disable_esr;
 
 	int apic_destination_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 69d8c30..3853ed7 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1107,7 +1107,7 @@ static void __cpuinit lapic_setup_esr(void)
 		return;
 	}
 
-	if (apic->ESR_DISABLE) {
+	if (apic->disable_esr) {
 		/*
 		 * Something untraceable is creating bad interrupts on
 		 * secondary quads ... for the moment, just leave the
@@ -1157,7 +1157,7 @@ void __cpuinit setup_local_APIC(void)
 
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
-	if (lapic_is_integrated() && apic->ESR_DISABLE) {
+	if (lapic_is_integrated() && apic->disable_esr) {
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
 		apic_write(APIC_ESR, 0);
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 0a263d6..d437a60 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -184,7 +184,7 @@ struct genapic apic_flat =  {
 	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
 
 	.target_cpus			= flat_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
@@ -330,7 +330,7 @@ struct genapic apic_physflat =  {
 	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= physflat_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index e9ff7dc..c1cffae 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -186,7 +186,7 @@ struct genapic apic_x2apic_cluster = {
 	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
 
 	.target_cpus			= x2apic_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 8141b5a..c59602b 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -182,7 +182,7 @@ struct genapic apic_x2apic_phys = {
 	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= x2apic_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 6a73cad..525b4e4 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -247,7 +247,7 @@ struct genapic apic_x2apic_uv_x = {
 	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
 
 	.target_cpus			= uv_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index f0bb726..fe9bf25 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -69,7 +69,7 @@ struct genapic apic_bigsmp = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= bigsmp_target_cpus,
-	.ESR_DISABLE			= 1,
+	.disable_esr			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index c30141a..d3fe801 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -36,7 +36,7 @@ struct genapic apic_default = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= default_target_cpus,
-	.ESR_DISABLE			= 0,
+	.disable_esr			= 0,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index e8aa8fd..b4f8abf 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -112,7 +112,7 @@ struct genapic apic_es7000 = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= es7000_target_cpus,
-	.ESR_DISABLE			= 1,
+	.disable_esr			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 860edc8..f3b7840 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -56,7 +56,7 @@ struct genapic apic_numaq = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= numaq_target_cpus,
-	.ESR_DISABLE			= 1,
+	.disable_esr			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index cd5ef11..95e075b 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -49,7 +49,7 @@ struct genapic apic_summit = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= summit_target_cpus,
-	.ESR_DISABLE			= 1,
+	.disable_esr			= 1,
 	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
-- 
1.6.0.2

