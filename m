Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbZA1X5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbZA1X5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbZA1Xog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:37593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbZA1Xof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:35 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 033/114] x86: clean up the APIC_DEST_LOGICAL logic
Date: Wed, 28 Jan 2009 23:41:39 +0000
Message-Id: <1233186180-29883-34-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The bigsmp and es7000 subarchitectures un-defined APIC_DEST_LOGICAL in
a rather nasty way by re-defining it to zero. That is infinitely
fragile and makes it very hard to see what to code really does in
a given context. The very same constant has different meanings and
values - depending on which subarch is enabled.

Untangle this mess by never undefining the constant, but instead
propagating the right values into the genapic driver templates.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    2 --
 arch/x86/include/asm/es7000/apic.h            |    2 --
 arch/x86/include/asm/mach-generic/mach_apic.h |    2 --
 arch/x86/kernel/genapic_flat_64.c             |   12 ++++++------
 arch/x86/kernel/genx2apic_cluster.c           |   10 +++++-----
 arch/x86/kernel/genx2apic_phys.c              |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c              |    4 ++--
 arch/x86/kernel/io_apic.c                     |    2 +-
 arch/x86/kernel/ipi.c                         |    2 +-
 arch/x86/kernel/smpboot.c                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    2 +-
 arch/x86/mach-generic/es7000.c                |    2 +-
 12 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index b550cb1..7e6e33a 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -17,8 +17,6 @@ static inline const cpumask_t *bigsmp_target_cpus(void)
 #endif
 }
 
-#undef APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL	0
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define NO_BALANCE_IRQ		(0)
 
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index aa11c76..0d770fc 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -27,8 +27,6 @@ static inline const cpumask_t *es7000_target_cpus(void)
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define NO_BALANCE_IRQ		(0)
-#undef  APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL	0x0
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 63fe985..00d5fe6 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -4,8 +4,6 @@
 #include <asm/genapic.h>
 
 #define NO_BALANCE_IRQ (apic->no_balance_irq)
-#undef APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL (apic->apic_destination_logical)
 #define init_apic_ldr (apic->init_apic_ldr)
 #define ioapic_phys_id_map (apic->ioapic_phys_id_map)
 #define setup_apic_routing (apic->setup_apic_routing)
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index d437a60..fd242c6 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -74,7 +74,7 @@ static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__send_IPI_dest_field(mask, vector, APIC_DEST_LOGICAL);
+	__send_IPI_dest_field(mask, vector, apic->apic_destination_logical);
 	local_irq_restore(flags);
 }
 
@@ -114,7 +114,7 @@ static void flat_send_IPI_allbutself(int vector)
 			_flat_send_IPI_mask(mask, vector);
 		}
 	} else if (num_online_cpus() > 1) {
-		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
+		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->apic_destination_logical);
 	}
 }
 
@@ -123,7 +123,7 @@ static void flat_send_IPI_all(int vector)
 	if (vector == NMI_VECTOR)
 		flat_send_IPI_mask(cpu_online_mask, vector);
 	else
-		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
+		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->apic_destination_logical);
 }
 
 static unsigned int get_apic_id(unsigned long x)
@@ -181,11 +181,11 @@ struct genapic apic_flat =  {
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
-	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
+	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= flat_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= 0,
+	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
@@ -327,7 +327,7 @@ struct genapic apic_physflat =  {
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= physflat_target_cpus,
 	.disable_esr			= 0,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index c1cffae..a76e75e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -64,7 +64,7 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	for_each_cpu(query_cpu, mask)
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, APIC_DEST_LOGICAL);
+			vector, apic->apic_destination_logical);
 	local_irq_restore(flags);
 }
 
@@ -80,7 +80,7 @@ static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, APIC_DEST_LOGICAL);
+				vector, apic->apic_destination_logical);
 	local_irq_restore(flags);
 }
 
@@ -95,7 +95,7 @@ static void x2apic_send_IPI_allbutself(int vector)
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, APIC_DEST_LOGICAL);
+				vector, apic->apic_destination_logical);
 	local_irq_restore(flags);
 }
 
@@ -183,11 +183,11 @@ struct genapic apic_x2apic_cluster = {
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
-	.irq_dest_mode			= (APIC_DEST_LOGICAL != 0),
+	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= x2apic_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= 0,
+	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index c59602b..9b6d68d 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -179,7 +179,7 @@ struct genapic apic_x2apic_phys = {
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= x2apic_target_cpus,
 	.disable_esr			= 0,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 525b4e4..0a75680 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -244,11 +244,11 @@ struct genapic apic_x2apic_uv_x = {
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= (APIC_DEST_PHYSICAL != 0),
+	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= uv_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= 0,
+	.apic_destination_logical	= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7503285..17526d7 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -806,7 +806,7 @@ void send_IPI_self(int vector)
 	 * Wait for idle.
 	 */
 	apic_wait_icr_idle();
-	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
+	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | apic->apic_destination_logical;
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index 285bbf8..400b7bd 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -30,7 +30,7 @@
 
 static inline int __prepare_ICR(unsigned int shortcut, int vector)
 {
-	unsigned int icr = shortcut | APIC_DEST_LOGICAL;
+	unsigned int icr = shortcut | apic->apic_destination_logical;
 
 	switch (vector) {
 	default:
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f9dbcff..f0a1737 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -583,7 +583,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | APIC_DEST_LOGICAL, logical_apicid);
+	apic_icr_write(APIC_DM_NMI |  apic->apic_destination_logical, logical_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index fe9bf25..13ee7dc 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -70,7 +70,7 @@ struct genapic apic_bigsmp = {
 
 	.target_cpus			= bigsmp_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.apic_destination_logical	= 0,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index b4f8abf..61b5da2 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -113,7 +113,7 @@ struct genapic apic_es7000 = {
 
 	.target_cpus			= es7000_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.apic_destination_logical	= 0,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
-- 
1.6.0.2

