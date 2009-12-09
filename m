Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZLIHzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZLIHzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZLIHya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:30 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44284 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403AbZLIHyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:11 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <4-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 06:00:33 +0100
Subject: [PATCH 3/7] mtrr: Remove use_intel()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove use_intel() and use is_cpu(INTEL) instead.

.use_intel_if is duplicating information already found in .vendor, as
the only combinations used are:
    generic: use_intel_if == 1, vendor == INTEL
    amd/cyrix/centaur: use_intel_if == 0, vendor != INTEL

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    1 -
 arch/x86/kernel/cpu/mtrr/main.c    |   14 +++++++-------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    2 --
 arch/x86/kernel/cpu/mtrr/state.c   |   10 +++++-----
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 4d75584..1651877 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -753,7 +753,6 @@ int positive_have_wrcomb(void)
  * Generic structure...
  */
 const struct mtrr_ops generic_mtrr_ops = {
-	.use_intel_if		= 1,
 	.set_all		= generic_set_all,
 	.get			= generic_get_mtrr,
 	.get_free_region	= generic_get_free_region,
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 628f3dd..bc3436e 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -107,7 +107,7 @@ static void __init set_num_var_ranges(void)
 {
 	unsigned long config = 0, dummy;
 
-	if (use_intel())
+	if (is_cpu(INTEL))
 		rdmsr(MSR_MTRRcap, config, dummy);
 	else if (is_cpu(AMD))
 		config = 2;
@@ -692,7 +692,7 @@ void __init mtrr_bp_init(void)
 	if (mtrr_if) {
 		set_num_var_ranges();
 		init_table();
-		if (use_intel()) {
+		if (is_cpu(INTEL)) {
 			get_mtrr_state();
 
 			if (mtrr_cleanup(phys_addr)) {
@@ -705,7 +705,7 @@ void __init mtrr_bp_init(void)
 
 void mtrr_ap_init(void)
 {
-	if (!use_intel() || mtrr_aps_delayed_init)
+	if (!is_cpu(INTEL) || mtrr_aps_delayed_init)
 		return;
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
@@ -733,7 +733,7 @@ void mtrr_save_state(void)
 
 void set_mtrr_aps_delayed_init(void)
 {
-	if (!use_intel())
+	if (!is_cpu(INTEL))
 		return;
 
 	mtrr_aps_delayed_init = true;
@@ -744,7 +744,7 @@ void set_mtrr_aps_delayed_init(void)
  */
 void mtrr_aps_init(void)
 {
-	if (!use_intel())
+	if (!is_cpu(INTEL))
 		return;
 
 	set_mtrr(~0U, 0, 0, 0);
@@ -753,7 +753,7 @@ void mtrr_aps_init(void)
 
 void mtrr_bp_restore(void)
 {
-	if (!use_intel())
+	if (!is_cpu(INTEL))
 		return;
 
 	mtrr_if->set_all();
@@ -764,7 +764,7 @@ static int __init mtrr_init_finialize(void)
 	if (!mtrr_if)
 		return 0;
 
-	if (use_intel()) {
+	if (is_cpu(INTEL)) {
 		if (!changed_by_mtrr_cleanup)
 			mtrr_state_warn();
 		return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index be2867c..562e2e3 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -13,7 +13,6 @@ extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 
 struct mtrr_ops {
 	u32	vendor;
-	u32	use_intel_if;
 	void	(*set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
 	void	(*set_all)(void);
@@ -62,7 +61,6 @@ extern u64 size_or_mask, size_and_mask;
 extern const struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
-#define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
 
 extern unsigned int num_var_ranges;
 extern u64 mtrr_tom2;
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index dfc80b4..3bdbf50 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -17,7 +17,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 	/* Disable interrupts locally */
 	local_irq_save(ctxt->flags);
 
-	if (use_intel() || is_cpu(CYRIX)) {
+	if (is_cpu(INTEL) || is_cpu(CYRIX)) {
 
 		/* Save value of CR4 and clear Page Global Enable (bit 7) */
 		if (cpu_has_pge) {
@@ -34,7 +34,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 		write_cr0(cr0);
 		wbinvd();
 
-		if (use_intel()) {
+		if (is_cpu(INTEL)) {
 			/* Save MTRR state */
 			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
 		} else {
@@ -49,7 +49,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
-	if (use_intel()) {
+	if (is_cpu(INTEL)) {
 		/* Disable MTRRs, and set the default type to uncached */
 		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
@@ -64,13 +64,13 @@ void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 /* Restore the processor after a set_mtrr_prepare */
 void set_mtrr_done(struct set_mtrr_context *ctxt)
 {
-	if (use_intel() || is_cpu(CYRIX)) {
+	if (is_cpu(INTEL) || is_cpu(CYRIX)) {
 
 		/* Flush caches and TLBs */
 		wbinvd();
 
 		/* Restore MTRRdefType */
-		if (use_intel()) {
+		if (is_cpu(INTEL)) {
 			/* Intel (P6) standard MTRRs */
 			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
 				   ctxt->deftype_hi);
-- 
1.6.4.4

