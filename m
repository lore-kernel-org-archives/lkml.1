Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYLPC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYLPC3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLPCY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:27 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752038AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022411.739449000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:23 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, jacob.shin@amd.com
Subject: [PATCH 14/16] x86: use work_on_cpu in x86/kernel/cpu/mcheck/mce_amd_64.c
Content-Disposition: inline; filename=0018-x86-use-work_on_cpu-in-x86-kernel-cpu-mcheck-mce_am.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Remove cpumask_t's from stack.

Simple transition to work_on_cpu(), rather than cpumask games.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>
Cc: jacob.shin@amd.com
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |  108 ++++++++++++++++---------------
 1 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 5eb390a..a1de80f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -83,34 +83,41 @@ static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
  * CPU Initialization
  */
 
+struct thresh_restart {
+	struct threshold_block *b;
+	int reset;
+	u16 old_limit;
+};
+
 /* must be called with correct cpu affinity */
-static void threshold_restart_bank(struct threshold_block *b,
-				   int reset, u16 old_limit)
+static long threshold_restart_bank(void *_tr)
 {
+	struct thresh_restart *tr = _tr;
 	u32 mci_misc_hi, mci_misc_lo;
 
-	rdmsr(b->address, mci_misc_lo, mci_misc_hi);
+	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
 
-	if (b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
-		reset = 1;	/* limit cannot be lower than err count */
+	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
+		tr->reset = 1;	/* limit cannot be lower than err count */
 
-	if (reset) {		/* reset err count and overflow bit */
+	if (tr->reset) {		/* reset err count and overflow bit */
 		mci_misc_hi =
 		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
-		    (THRESHOLD_MAX - b->threshold_limit);
-	} else if (old_limit) {	/* change limit w/o reset */
+		    (THRESHOLD_MAX - tr->b->threshold_limit);
+	} else if (tr->old_limit) {	/* change limit w/o reset */
 		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
-		    (old_limit - b->threshold_limit);
+		    (tr->old_limit - tr->b->threshold_limit);
 		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
 		    (new_count & THRESHOLD_MAX);
 	}
 
-	b->interrupt_enable ?
+	tr->b->interrupt_enable ?
 	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
 	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
 
 	mci_misc_hi |= MASK_COUNT_EN_HI;
-	wrmsr(b->address, mci_misc_lo, mci_misc_hi);
+	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	return 0;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
@@ -120,6 +127,7 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int cpu = smp_processor_id();
 	u8 lvt_off;
 	u32 low = 0, high = 0, address = 0;
+	struct thresh_restart tr;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -162,7 +170,10 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 			wrmsr(address, low, high);
 
 			threshold_defaults.address = address;
-			threshold_restart_bank(&threshold_defaults, 0, 0);
+			tr.b = &threshold_defaults;
+			tr.reset = 0;
+			tr.old_limit = 0;
+			threshold_restart_bank(&tr);
 		}
 	}
 }
@@ -251,20 +262,6 @@ struct threshold_attr {
 	ssize_t(*store) (struct threshold_block *, const char *, size_t count);
 };
 
-static void affinity_set(unsigned int cpu, cpumask_t *oldmask,
-					   cpumask_t *newmask)
-{
-	*oldmask = current->cpus_allowed;
-	cpus_clear(*newmask);
-	cpu_set(cpu, *newmask);
-	set_cpus_allowed_ptr(current, newmask);
-}
-
-static void affinity_restore(const cpumask_t *oldmask)
-{
-	set_cpus_allowed_ptr(current, oldmask);
-}
-
 #define SHOW_FIELDS(name)                                           \
 static ssize_t show_ ## name(struct threshold_block * b, char *buf) \
 {                                                                   \
@@ -277,15 +274,16 @@ static ssize_t store_interrupt_enable(struct threshold_block *b,
 				      const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
+	struct thresh_restart tr;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
 	b->interrupt_enable = !!new;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 0, 0);
-	affinity_restore(&oldmask);
+	tr.b = b;
+	tr.reset = 0;
+	tr.old_limit = 0;
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 
 	return end - buf;
 }
@@ -294,8 +292,7 @@ static ssize_t store_threshold_limit(struct threshold_block *b,
 				     const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
-	u16 old;
+	struct thresh_restart tr;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
@@ -303,34 +300,36 @@ static ssize_t store_threshold_limit(struct threshold_block *b,
 		new = THRESHOLD_MAX;
 	if (new < 1)
 		new = 1;
-	old = b->threshold_limit;
+	tr.old_limit = b->threshold_limit;
 	b->threshold_limit = new;
+	tr.b = b;
+	tr.reset = 0;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 0, old);
-	affinity_restore(&oldmask);
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 
 	return end - buf;
 }
 
-static ssize_t show_error_count(struct threshold_block *b, char *buf)
+static long local_error_count(void *_b)
 {
-	u32 high, low;
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
+	struct threshold_block *b = _b;
+	u32 low, high;
+
 	rdmsr(b->address, low, high);
-	affinity_restore(&oldmask);
-	return sprintf(buf, "%x\n",
-		       (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit));
+	return (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
+}
+
+static ssize_t show_error_count(struct threshold_block *b, char *buf)
+{
+	return sprintf(buf, "%lx\n", work_on_cpu(b->cpu, local_error_count, b));
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
 				 const char *buf, size_t count)
 {
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 1, 0);
-	affinity_restore(&oldmask);
+	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
+
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 	return 1;
 }
 
@@ -463,12 +462,19 @@ out_free:
 	return err;
 }
 
+static long local_allocate_threshold_blocks(void *_bank)
+{
+	unsigned int *bank = _bank;
+
+	return allocate_threshold_blocks(smp_processor_id(), *bank, 0,
+					 MSR_IA32_MC0_MISC + *bank * 4);
+}
+
 /* symlinks sibling shared banks to first core.  first core owns dir/files. */
 static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	cpumask_t oldmask, newmask;
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -519,11 +525,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	affinity_set(cpu, &oldmask, &newmask);
-	err = allocate_threshold_blocks(cpu, bank, 0,
-					MSR_IA32_MC0_MISC + bank * 4);
-	affinity_restore(&oldmask);
-
+	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
 	if (err)
 		goto out_free;
 
-- 
1.6.0

-- 
