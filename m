Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYIEDOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYIEDOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYIEDJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYIEDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GsWFTdhLme8uNfHV7MD0sMA9iYqn2IFRm9Wwu/vAV3Mcl3YzbzJF2mrb+shJtXzKCu
         wWavCtT7MZV9y2N+ppiqhUxdbjJtKUTPlId7faQCb6kU2a+c90j5txtzEZglySBQe876
         ZFQ2pyTtJ4voC32BOg2P7C4h9+7MYLkG2On+U=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 15/16] x86: cpu common merge identify_cpu
Date: Thu,  4 Sep 2008 20:09:13 -0700
Message-Id: <1220584154-32497-15-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   89 ++++++++++++++++++++----------
 arch/x86/kernel/cpu/common_64.c |  116 +++++++++++++++++++++++++++++----------
 2 files changed, 147 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f35baa7..42a26c5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -104,34 +104,6 @@ static int __init cachesize_setup(char *str)
 }
 __setup("cachesize=", cachesize_setup);
 
-/*
- * Naming convention should be: <Name> [(<Codename>)]
- * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
- */
-
-/* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
-{
-	struct cpu_model_info *info;
-
-	if (c->x86_model >= 16)
-		return NULL;	/* Range check */
-
-	if (!this_cpu)
-		return NULL;
-
-	info = this_cpu->c_models;
-
-	while (info && info->family) {
-		if (info->family == c->x86)
-			return info->model_names[c->x86_model];
-		info++;
-	}
-	return NULL;		/* Not found */
-}
-
 static int __init x86_fxsr_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_FXSR);
@@ -197,13 +169,48 @@ static int __init x86_serial_nr_setup(char *s)
 }
 __setup("serialnumber", x86_serial_nr_setup);
 #else
+static inline int flag_is_changeable_p(u32 flag)
+{
+	return 1;
+}
 /* Probe for the CPUID instruction */
 static inline int have_cpuid_p(void)
 {
 	return 1;
 }
+static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+}
 #endif
 
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
+
+/* Look up CPU names by table lookup. */
+static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+{
+	struct cpu_model_info *info;
+
+	if (c->x86_model >= 16)
+		return NULL;	/* Range check */
+
+	if (!this_cpu)
+		return NULL;
+
+	info = this_cpu->c_models;
+
+	while (info && info->family) {
+		if (info->family == c->x86)
+			return info->model_names[c->x86_model];
+		info++;
+	}
+	return NULL;		/* Not found */
+}
+
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
@@ -620,12 +627,18 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
+#ifdef CONFIG_X86_64
+	c->x86_coreid_bits = 0;
+	c->x86_clflush_size = 64;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_clflush_size = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
 	if (!have_cpuid_p()) {
@@ -644,6 +657,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
+#ifdef CONFIG_X86_64
+	c->apicid = phys_pkg_id(0);
+#endif
+
 	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
@@ -677,6 +694,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 				c->x86, c->x86_model);
 	}
 
+#ifdef CONFIG_X86_64
+	detect_ht(c);
+#endif
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -693,24 +714,34 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	for (i = 0; i < NCAPINTS; i++)
 		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
+#ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+#endif
 
 	select_idle_routine(c);
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	numa_add_cpu(smp_processor_id());
+#endif
 }
 
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+#ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#endif
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
+#ifdef CONFIG_X86_32
 	enable_sep_cpu();
+#endif
 	mtrr_ap_init();
 }
 
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 869a6ff..71c28fb 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -103,34 +103,6 @@ static int __init cachesize_setup(char *str)
 }
 __setup("cachesize=", cachesize_setup);
 
-/*
- * Naming convention should be: <Name> [(<Codename>)]
- * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
- */
-
-/* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
-{
-	struct cpu_model_info *info;
-
-	if (c->x86_model >= 16)
-		return NULL;	/* Range check */
-
-	if (!this_cpu)
-		return NULL;
-
-	info = this_cpu->c_models;
-
-	while (info && info->family) {
-		if (info->family == c->x86)
-			return info->model_names[c->x86_model];
-		info++;
-	}
-	return NULL;		/* Not found */
-}
-
 static int __init x86_fxsr_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_FXSR);
@@ -196,13 +168,48 @@ static int __init x86_serial_nr_setup(char *s)
 }
 __setup("serialnumber", x86_serial_nr_setup);
 #else
+static inline int flag_is_changeable_p(u32 flag)
+{
+	return 1;
+}
 /* Probe for the CPUID instruction */
 static inline int have_cpuid_p(void)
 {
 	return 1;
 }
+static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+}
 #endif
 
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
+
+/* Look up CPU names by table lookup. */
+static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+{
+	struct cpu_model_info *info;
+
+	if (c->x86_model >= 16)
+		return NULL;	/* Range check */
+
+	if (!this_cpu)
+		return NULL;
+
+	info = this_cpu->c_models;
+
+	while (info && info->family) {
+		if (info->family == c->x86)
+			return info->model_names[c->x86_model];
+		info++;
+	}
+	return NULL;		/* Not found */
+}
+
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
@@ -628,14 +635,35 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
+#ifdef CONFIG_X86_64
 	c->x86_coreid_bits = 0;
 	c->x86_clflush_size = 64;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
+	c->x86_clflush_size = 32;
+#endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
+	if (!have_cpuid_p()) {
+		/*
+		 * First of all, decide if this is a 486 or higher
+		 * It's a 486 if we can modify the AC flag
+		 */
+		if (flag_is_changeable_p(X86_EFLAGS_AC))
+			c->x86 = 4;
+		else
+			c->x86 = 3;
+	}
+
 	generic_identify(c);
 
+	if (this_cpu->c_identify)
+		this_cpu->c_identify(c);
+
+#ifdef CONFIG_X86_64
 	c->apicid = phys_pkg_id(0);
+#endif
 
 	/*
 	 * Vendor-specific initialization.  In this section we
@@ -650,7 +678,29 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_init)
 		this_cpu->c_init(c);
 
+	/* Disable the PN if appropriate */
+	squash_the_stupid_serial_number(c);
+
+	/*
+	 * The vendor-specific functions might have changed features.  Now
+	 * we do "generic changes."
+	 */
+
+	/* If the model name is still unset, do table lookup. */
+	if (!c->x86_model_id[0]) {
+		char *p;
+		p = table_lookup_model(c);
+		if (p)
+			strcpy(c->x86_model_id, p);
+		else
+			/* Last resort... */
+			sprintf(c->x86_model_id, "%02x/%02x",
+				c->x86, c->x86_model);
+	}
+
+#ifdef CONFIG_X86_64
 	detect_ht(c);
+#endif
 
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
@@ -669,11 +719,12 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 #ifdef CONFIG_X86_MCE
+	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
 #endif
 	select_idle_routine(c);
 
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	numa_add_cpu(smp_processor_id());
 #endif
 
@@ -682,12 +733,19 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+#ifdef CONFIG_X86_32
+	sysenter_setup();
+	enable_sep_cpu();
+#endif
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
+#ifdef CONFIG_X86_32
+	enable_sep_cpu();
+#endif
 	mtrr_ap_init();
 }
 
-- 
1.5.4.5

