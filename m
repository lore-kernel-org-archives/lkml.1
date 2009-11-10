Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZKJFQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZKJFQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZKJFQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:16:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:51703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZKJFQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:16:25 -0500
Date: Tue, 10 Nov 2009 05:15:54 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, gorcunov@gmail.com,
       macro@linux-mips.org, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, gorcunov@gmail.com,
       macro@linux-mips.org, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
In-Reply-To: <20091109220659.GA5568@lenovo>
References: <20091109220659.GA5568@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: apic: Do not use stacked physid_mask_t
Message-ID: <tip-7abc07531383ac7f727cc9d44e1360a829f2082e@git.kernel.org>
Git-Commit-ID: 7abc07531383ac7f727cc9d44e1360a829f2082e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7abc07531383ac7f727cc9d44e1360a829f2082e
Gitweb:     http://git.kernel.org/tip/7abc07531383ac7f727cc9d44e1360a829f2082e
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Tue, 10 Nov 2009 01:06:59 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 05:52:07 +0100

x86: apic: Do not use stacked physid_mask_t

We should not use physid_mask_t as a stack based
variable in apic code. This type depends on MAX_APICS
parameter which may be huge enough.

Especially it became a problem with apic NOOP driver which
is portable between 32 bit and 64 bit environment
(where we have really huge MAX_APICS).

So apic driver should operate with pointers and a caller
in turn should aware of allocation physid_mask_t variable.

As a side (but positive) effect -- we may use already
implemented physid_set_mask_of_physid function eliminating
default_apicid_to_cpu_present completely.

Note that physids_coerce and physids_promote turned into static
inline from macro (since macro hides the fact that parameter is
being interpreted as unsigned long, make it explicit).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20091109220659.GA5568@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h      |   19 +++++++------------
 arch/x86/include/asm/mpspec.h    |   16 +++++++++-------
 arch/x86/kernel/apic/apic_noop.c |   18 ++++--------------
 arch/x86/kernel/apic/bigsmp_32.c |   13 ++++---------
 arch/x86/kernel/apic/es7000_32.c |   16 ++++++----------
 arch/x86/kernel/apic/io_apic.c   |   14 +++++++-------
 arch/x86/kernel/apic/numaq_32.c  |   13 ++++++-------
 arch/x86/kernel/apic/probe_32.c  |    2 +-
 arch/x86/kernel/apic/summit_32.c |   10 +++++-----
 arch/x86/kernel/visws_quirks.c   |    2 +-
 10 files changed, 50 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 08a5f42..b4ac2cd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -297,20 +297,20 @@ struct apic {
 	int disable_esr;
 
 	int dest_logical;
-	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
+	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
-	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
+	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
+	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int phys_apicid);
 	void (*enable_apic_mode)(void);
@@ -534,9 +534,9 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
-static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
 {
-	return physid_isset(apicid, bitmap);
+	return physid_isset(apicid, *map);
 }
 
 static inline unsigned long default_check_apicid_present(int bit)
@@ -544,9 +544,9 @@ static inline unsigned long default_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
+static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
-	return phys_map;
+	*retmap = *phys_map;
 }
 
 /* Mapping from cpu number to logical apicid */
@@ -585,11 +585,6 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
-static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 79c9450..61d90b1 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -163,14 +163,16 @@ typedef struct physid_mask physid_mask_t;
 #define physids_shift_left(d, s, n)				\
 	bitmap_shift_left((d).mask, (s).mask, n, MAX_APICS)
 
-#define physids_coerce(map)			((map).mask[0])
+static inline unsigned long physids_coerce(physid_mask_t *map)
+{
+	return map->mask[0];
+}
 
-#define physids_promote(physids)					\
-	({								\
-		physid_mask_t __physid_mask = PHYSID_MASK_NONE;		\
-		__physid_mask.mask[0] = physids;			\
-		__physid_mask;						\
-	})
+static inline void physids_promote(unsigned long physids, physid_mask_t *map)
+{
+	physids_clear(*map);
+	map->mask[0] = physids;
+}
 
 /* Note: will create very large stack frames if physid_mask_t is big */
 #define physid_mask_of_physid(physid)					\
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 89629f6..d9acc3b 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -54,11 +54,6 @@ static u64 noop_apic_icr_read(void)
 	return 0;
 }
 
-static physid_mask_t noop_ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	return phys_map;
-}
-
 static int noop_cpu_to_logical_apicid(int cpu)
 {
 	return 0;
@@ -100,9 +95,9 @@ static const struct cpumask *noop_target_cpus(void)
 	return cpumask_of(0);
 }
 
-static unsigned long noop_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long noop_check_apicid_used(physid_mask_t *map, int apicid)
 {
-	return physid_isset(apicid, bitmap);
+	return physid_isset(apicid, *map);
 }
 
 static unsigned long noop_check_apicid_present(int bit)
@@ -155,19 +150,14 @@ struct apic apic_noop = {
 	.vector_allocation_domain	= noop_vector_allocation_domain,
 	.init_apic_ldr			= noop_init_apic_ldr,
 
-	.ioapic_phys_id_map		= noop_ioapic_phys_id_map,
+	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= noop_apicid_to_node,
 
 	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-
-#ifdef CONFIG_X86_32
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
-#else
-	.apicid_to_cpu_present		= NULL,
-#endif
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 77a0641..38dcecf 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -35,7 +35,7 @@ static const struct cpumask *bigsmp_target_cpus(void)
 #endif
 }
 
-static unsigned long bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
@@ -93,11 +93,6 @@ static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-static physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
 /* Mapping from cpu number to logical apicid */
 static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 {
@@ -106,10 +101,10 @@ static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 	return cpu_physical_id(cpu);
 }
 
-static physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
+static void bigsmp_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xFFL);
+	physids_promote(0xFFL, retmap);
 }
 
 static int bigsmp_check_phys_apicid_present(int phys_apicid)
@@ -230,7 +225,7 @@ struct apic apic_bigsmp = {
 	.apicid_to_node			= bigsmp_apicid_to_node,
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 89174f8..e85f8fb 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -466,11 +466,11 @@ static const struct cpumask *es7000_target_cpus(void)
 	return cpumask_of(smp_processor_id());
 }
 
-static unsigned long
-es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long es7000_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
+
 static unsigned long es7000_check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
@@ -539,14 +539,10 @@ static int es7000_cpu_present_to_apicid(int mps_cpu)
 
 static int cpu_id;
 
-static physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
+static void es7000_apicid_to_cpu_present(int phys_apicid, physid_mask_t *retmap)
 {
-	physid_mask_t mask;
-
-	mask = physid_mask_of_physid(cpu_id);
+	physid_set_mask_of_physid(cpu_id, retmap);
 	++cpu_id;
-
-	return mask;
 }
 
 /* Mapping from cpu number to logical apicid */
@@ -561,10 +557,10 @@ static int es7000_cpu_to_logical_apicid(int cpu)
 #endif
 }
 
-static physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
+static void es7000_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xff);
+	physids_promote(0xFFL, retmap);
 }
 
 static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 24d1458..20ea839 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2031,7 +2031,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 	 * This is broken; anything with a real cpu count has to
 	 * circumvent this idiocy regardless.
 	 */
-	phys_id_present_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
+	apic->ioapic_phys_id_map(&phys_cpu_present_map, &phys_id_present_map);
 
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
@@ -2058,7 +2058,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 		 * system must have a unique ID or we get lots of nice
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
-		if (apic->check_apicid_used(phys_id_present_map,
+		if (apic->check_apicid_used(&phys_id_present_map,
 					mp_ioapics[apic_id].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
 				apic_id, mp_ioapics[apic_id].apicid);
@@ -2073,7 +2073,7 @@ void __init setup_ioapic_ids_from_mpc(void)
 			mp_ioapics[apic_id].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
+			apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid, &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
 					mp_ioapics[apic_id].apicid);
@@ -3904,7 +3904,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 */
 
 	if (physids_empty(apic_id_map))
-		apic_id_map = apic->ioapic_phys_id_map(phys_cpu_present_map);
+		apic->ioapic_phys_id_map(&phys_cpu_present_map, &apic_id_map);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic, 0);
@@ -3920,10 +3920,10 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 * Every APIC in a system must have a unique ID or we get lots of nice
 	 * 'stuck on smp_invalidate_needed IPI wait' messages.
 	 */
-	if (apic->check_apicid_used(apic_id_map, apic_id)) {
+	if (apic->check_apicid_used(&apic_id_map, apic_id)) {
 
 		for (i = 0; i < get_physical_broadcast(); i++) {
-			if (!apic->check_apicid_used(apic_id_map, i))
+			if (!apic->check_apicid_used(&apic_id_map, i))
 				break;
 		}
 
@@ -3936,7 +3936,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 		apic_id = i;
 	}
 
-	tmp = apic->apicid_to_cpu_present(apic_id);
+	apic->apicid_to_cpu_present(apic_id, &tmp);
 	physids_or(apic_id_map, apic_id_map, tmp);
 
 	if (reg_00.bits.ID != apic_id) {
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..07cdbdc 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -334,10 +334,9 @@ static inline const struct cpumask *numaq_target_cpus(void)
 	return cpu_all_mask;
 }
 
-static inline unsigned long
-numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long numaq_check_apicid_used(physid_mask_t *map, int apicid)
 {
-	return physid_isset(apicid, bitmap);
+	return physid_isset(apicid, *map);
 }
 
 static inline unsigned long numaq_check_apicid_present(int bit)
@@ -371,10 +370,10 @@ static inline int numaq_multi_timer_check(int apic, int irq)
 	return apic != 0 && irq == 0;
 }
 
-static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
+static inline void numaq_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* We don't have a good way to do this yet - hack */
-	return physids_promote(0xFUL);
+	return physids_promote(0xFUL, retmap);
 }
 
 static inline int numaq_cpu_to_logical_apicid(int cpu)
@@ -402,12 +401,12 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 	return logical_apicid >> 4;
 }
 
-static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
+static void numaq_apicid_to_cpu_present(int logical_apicid, physid_mask_t *retmap)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
 	int cpu = __ffs(logical_apicid & 0xf);
 
-	return physid_mask_of_physid(cpu + 4*node);
+	physid_set_mask_of_physid(cpu + 4*node, retmap);
 }
 
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0c0182c..1a6559f 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -108,7 +108,7 @@ struct apic apic_default = {
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 645ecc4..9b41926 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -183,7 +183,7 @@ static const struct cpumask *summit_target_cpus(void)
 	return cpumask_of(0);
 }
 
-static unsigned long summit_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long summit_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return 0;
 }
@@ -261,15 +261,15 @@ static int summit_cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static physid_mask_t summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
+static void summit_ioapic_phys_id_map(physid_mask_t *phys_id_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0x0F);
+	physids_promote(0x0FL, retmap);
 }
 
-static physid_mask_t summit_apicid_to_cpu_present(int apicid)
+static void summit_apicid_to_cpu_present(int apicid, physid_mask_t *retmap)
 {
-	return physid_mask_of_physid(0);
+	physid_set_mask_of_physid(0, retmap);
 }
 
 static int summit_check_phys_apicid_present(int physical_apicid)
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..cff70c8 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -183,7 +183,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 		return;
 	}
 
-	apic_cpus = apic->apicid_to_cpu_present(m->apicid);
+	apic->apicid_to_cpu_present(m->apicid, &apic_cpus);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
