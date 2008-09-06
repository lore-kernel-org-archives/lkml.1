Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYIFXyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYIFXyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYIFXuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59429 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753372AbYIFXuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:40 -0400
Message-Id: <20080906235038.710364000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:49 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 13/13] genapic: reduce stack pressuge in io_apic.c step 5 cpu_mask_to_apicid
Content-Disposition: inline; filename=stack-hogs-io_apic_c-step-5-cpu_mask_to_apicid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Step 5 "cpu_mask_to_apicid" of cleaning up io_apic.c modifies the
    cpu_mask_to_apicid genapic interface to pass a pointer to incoming
    cpumask_t argument removing yet another "cpumask_t variable on the stack".

	apicid = cpu_mask_to_apicid(cpumask);

    becomes:

	apicid = cpu_mask_to_apicid(&cpumask);

  * All the appropriate genapic "cpu_mask_to_apicid" functions
    are modified to use this new interface.

  * Total stack savings are:

    ====== Stack (-l 100)

	1 - initial
	2 - stack-hogs-io_apic_c-step-1-temp-cpumask_ts
	3 - stack-hogs-io_apic_c-step-2-internal-abi
	4 - stack-hogs-io_apic_c-step-3-target_cpus
	5 - stack-hogs-io_apic_c-step-4-vector_allocation_domain
	6 - stack-hogs-io_apic_c-step-5-cpu_mask_to_apicid

       .1.    .2.   .3.   .4.    .5.   .6.    ..final..
      1576   -512     .  -512      .  -552   .  -100%  setup_IO_APIC_irq
      1560   -512     .  -528      .  -520   .  -100%  msi_compose_msg
      1560   -512     .  -512      .  -536   .  -100%  arch_setup_ht_irq
      1560  -1008     .     .   -552     .   .  -100%  __assign_irq_vector
      1144      .  -512  -632      .     .   .  -100%  setup_IO_APIC
      1048      .     .  -512      .  -536   .  -100%  setup_timer_IRQ0_pin
      1048      .  -512  -536      .     .   .  -100%  setup_ioapic_dest
      1048   -512  -536     .      .     .   .  -100%  set_ioapic_affinity_irq
      1040   -512     .     .      .  -528   .  -100%  set_msi_irq_affinity
      1040   -512     .     .      .  -528   .  -100%  set_ht_irq_affinity
      1040   -512     .     .      .  -528   .  -100%  dmar_msi_set_affinity
      1032     -8  -512  -512      .     .   .  -100%  create_irq_nr
      1024      .     .     .  -1024     .   .  -100%  x2apic_vector_allocation_domain
      1024      .     .     .  -1024     .   .  -100%  uv_vector_allocation_domain
       520   -520     .     .      .     .   .  -100%  __clear_irq_vector
       512   -512     .     .      .     .   .  -100%  irq_complete_move
       512      .  -512     .      .     .   .  -100%  assign_irq_vector
	 0      .  +536     .      .  -536   .      .  set_ioapic_affinity_irq_p
    18288 -5632 -2048 -3744 -2600 -4264   . -100%  Totals

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genapic_flat_64.c        |    8 ++++----
 arch/x86/kernel/genx2apic_cluster.c      |    4 ++--
 arch/x86/kernel/genx2apic_phys.c         |    4 ++--
 arch/x86/kernel/genx2apic_uv_x.c         |    4 ++--
 arch/x86/kernel/io_apic.c                |   20 ++++++++++----------
 include/asm-x86/bigsmp/apic.h            |    4 ++--
 include/asm-x86/es7000/apic.h            |    8 ++++----
 include/asm-x86/genapic_32.h             |    2 +-
 include/asm-x86/genapic_64.h             |    2 +-
 include/asm-x86/mach-default/mach_apic.h |    4 ++--
 include/asm-x86/numaq/apic.h             |    2 +-
 include/asm-x86/summit/apic.h            |    8 ++++----
 12 files changed, 35 insertions(+), 35 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -140,9 +140,9 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	return cpus_addr(cpumask)[0] & APIC_ALL_CPUS;
+	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static unsigned int phys_pkg_id(int index_msb)
@@ -227,7 +227,7 @@ static void physflat_send_IPI_all(int ve
 	physflat_send_IPI_mask(&cpu_online_map, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -235,7 +235,7 @@ static unsigned int physflat_cpu_mask_to
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_cluster.c
@@ -92,7 +92,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -100,7 +100,7 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < NR_CPUS)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_phys.c
@@ -85,7 +85,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -93,7 +93,7 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < NR_CPUS)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -160,7 +160,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 
@@ -168,7 +168,7 @@ static unsigned int uv_cpu_mask_to_apici
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
--- linux-2.6.tip.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic.c
@@ -602,7 +602,7 @@ static void set_ioapic_affinity_irq_p(un
 	}
 
 	cpus_and(*tmp, cfg->domain, *mask);
-	dest = cpu_mask_to_apicid(*tmp);
+	dest = cpu_mask_to_apicid(tmp);
 	/*
 	 * Only the high 8 bits are valid.
 	 */
@@ -1546,7 +1546,7 @@ static void setup_IO_APIC_irq(int apic, 
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(*mask), trigger, polarity,
+			       cpu_mask_to_apicid(mask), trigger, polarity,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
@@ -1626,7 +1626,7 @@ static void __init setup_timer_IRQ0_pin(
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest = cpu_mask_to_apicid(*tgt_cpus);
+	entry.dest = cpu_mask_to_apicid(tgt_cpus);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -2322,7 +2322,7 @@ static void migrate_ioapic_irq(int irq, 
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tmpmask, cfg->domain, *mask);
-	dest = cpu_mask_to_apicid(*tmpmask);
+	dest = cpu_mask_to_apicid(tmpmask);
 
 	desc = irq_to_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
@@ -3204,7 +3204,7 @@ static int msi_compose_msg(struct pci_de
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tgt_cpus, cfg->domain, *tgt_cpus);
-	dest = cpu_mask_to_apicid(*tgt_cpus);
+	dest = cpu_mask_to_apicid(tgt_cpus);
 	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 
 #ifdef CONFIG_INTR_REMAP
@@ -3277,7 +3277,7 @@ static void set_msi_irq_affinity(unsigne
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(*tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	read_msi_msg(irq, &msg);
 
@@ -3319,7 +3319,7 @@ static void ir_set_msi_irq_affinity(unsi
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(*tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3561,7 +3561,7 @@ static void dmar_msi_set_affinity(unsign
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(*tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3643,7 +3643,7 @@ static void set_ht_irq_affinity(unsigned
 
 	cfg = irq_cfg(irq);
 	cpus_and(*tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(*tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	desc = irq_to_desc(irq);
@@ -3679,7 +3679,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 		cfg = irq_cfg(irq);
 		cpus_and(*tgt_cpus, cfg->domain, *tgt_cpus);
-		dest = cpu_mask_to_apicid(*tgt_cpus);
+		dest = cpu_mask_to_apicid(tgt_cpus);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
--- linux-2.6.tip.orig/include/asm-x86/bigsmp/apic.h
+++ linux-2.6.tip/include/asm-x86/bigsmp/apic.h
@@ -121,12 +121,12 @@ static inline int check_phys_apicid_pres
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 	int apicid;	
 
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	return apicid;
 }
--- linux-2.6.tip.orig/include/asm-x86/es7000/apic.h
+++ linux-2.6.tip/include/asm-x86/es7000/apic.h
@@ -144,14 +144,14 @@ static inline int check_phys_apicid_pres
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 #if defined CONFIG_ES7000_CLUSTERED_APIC
@@ -163,10 +163,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
--- linux-2.6.tip.orig/include/asm-x86/genapic_32.h
+++ linux-2.6.tip/include/asm-x86/genapic_32.h
@@ -57,7 +57,7 @@ struct genapic {
 
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
 	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -29,7 +29,7 @@ struct genapic {
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 	/* */
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
--- linux-2.6.tip.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6.tip/include/asm-x86/mach-default/mach_apic.h
@@ -65,9 +65,9 @@ static inline int apic_id_registered(voi
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
-	return cpus_addr(cpumask)[0];
+	return cpus_addr(*cpumask)[0];
 }
 
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
--- linux-2.6.tip.orig/include/asm-x86/numaq/apic.h
+++ linux-2.6.tip/include/asm-x86/numaq/apic.h
@@ -122,7 +122,7 @@ static inline void enable_apic_mode(void
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	return (int) 0xF;
 }
--- linux-2.6.tip.orig/include/asm-x86/summit/apic.h
+++ linux-2.6.tip/include/asm-x86/summit/apic.h
@@ -137,14 +137,14 @@ static inline void enable_apic_mode(void
 {
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return (int) 0xFF;
@@ -152,10 +152,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){

-- 
