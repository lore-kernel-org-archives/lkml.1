Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYIAXkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYIAXkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYIAXim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:38:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYIAXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bxq505lbK1FA2cbXw5V17tJ5j0k0hQ6juJ1Yi9Oq6Ft2uxSoqbya459BXzQyvBLUzg
         C6tUVqDKlq21e+P+1O+d6awvG4np0TOEBhlmVkMJsYfVEgk550Se3YUE0mIrCf1KvV+E
         phSVnBRhvUxj6+f7xkD0fYL0zBbcrNAX8WwHc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 6/6] x86: make (early)_identify_cpu more the same between 32bit and 64 bit
Date: Mon,  1 Sep 2008 16:37:26 -0700
Message-Id: <1220312246-30879-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. add extended_cpuid_level for 32bit
2. add generic_identify for 64bit
3. add early_identify_cpu for 32bit
4. early_identify_cpu not be called by identify_cpu
5. remove early in get_cpu_vendor for 32bit
6. add get_cpu_cap
7. add cpu_detect for 64bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c    |  136 ++++++++++++++-------------------------
 arch/x86/kernel/cpu/common_64.c |  139 +++++++++++++++++++++++++---------------
 include/asm-x86/processor.h     |    2 
 3 files changed, 141 insertions(+), 136 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -96,7 +96,7 @@ int __cpuinit get_model_name(struct cpui
 	unsigned int *v;
 	char *p, *q;
 
-	if (cpuid_eax(0x80000000) < 0x80000004)
+	if (c->extended_cpuid_level < 0x80000004)
 		return 0;
 
 	v = (unsigned int *) c->x86_model_id;
@@ -125,7 +125,7 @@ void __cpuinit display_cacheinfo(struct
 {
 	unsigned int n, dummy, ecx, edx, l2size;
 
-	n = cpuid_eax(0x80000000);
+	n = c->extended_cpuid_level;
 
 	if (n >= 0x80000005) {
 		cpuid(0x80000005, &dummy, &dummy, &ecx, &edx);
@@ -186,7 +186,7 @@ static char __cpuinit *table_lookup_mode
 }
 
 
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
+static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
@@ -198,8 +198,7 @@ static void __cpuinit get_cpu_vendor(str
 			    (cpu_devs[i]->c_ident[1] &&
 			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
 				c->x86_vendor = i;
-				if (!early)
-					this_cpu = cpu_devs[i];
+				this_cpu = cpu_devs[i];
 				return;
 			}
 		}
@@ -284,34 +283,30 @@ void __init cpu_detect(struct cpuinfo_x8
 		}
 	}
 }
-static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
+
+static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
-	unsigned int ebx;
+	u32 ebx;
 
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-	if (have_cpuid_p()) {
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-		}
+	/* Intel-defined flags: level 0x00000001 */
+	if (c->cpuid_level >= 0x00000001) {
+		u32 capability, excap;
+		cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
+		c->x86_capability[0] = capability;
+		c->x86_capability[4] = excap;
+	}
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
+	/* AMD-defined flags: level 0x80000001 */
+	xlvl = cpuid_eax(0x80000000);
+	c->extended_cpuid_level = xlvl;
+	if ((xlvl & 0xffff0000) == 0x80000000) {
+		if (xlvl >= 0x80000001) {
+			c->x86_capability[1] = cpuid_edx(0x80000001);
+			c->x86_capability[6] = cpuid_ecx(0x80000001);
 		}
-
 	}
-
 }
-
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
@@ -321,25 +316,29 @@ static void __cpuinit early_get_cap(stru
  * WARNING: this function is only called on the BP.  Don't add code here
  * that is supposed to run on all CPUs.
  */
-static void __init early_cpu_detect(void)
+static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
 	c->x86_cache_alignment = 32;
 	c->x86_clflush_size = 32;
 
 	if (!have_cpuid_p())
 		return;
 
+	c->extended_cpuid_level = 0;
+
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+
 	cpu_detect(c);
 
-	get_cpu_vendor(c, 1);
+	get_cpu_vendor(c);
 
-	early_get_cap(c);
+	get_cpu_cap(c);
 
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
+
+	validate_pat_support(c);
 }
 
 /*
@@ -373,60 +372,32 @@ static void __cpuinit detect_nopl(struct
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
-	u32 tfms, xlvl;
-	unsigned int ebx;
+	if (!have_cpuid_p())
+		return;
+
+	c->extended_cpuid_level = 0;
+
+	cpu_detect(c);
+
+	get_cpu_vendor(c);
+
+	get_cpu_cap(c);
 
-	if (have_cpuid_p()) {
-		/* Get vendor name */
-		cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
-		      (unsigned int *)&c->x86_vendor_id[0],
-		      (unsigned int *)&c->x86_vendor_id[8],
-		      (unsigned int *)&c->x86_vendor_id[4]);
-
-		get_cpu_vendor(c, 0);
-		/* Initialize the standard set of capabilities */
-		/* Note that the vendor-specific code below might override */
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-			c->x86 = (tfms >> 8) & 15;
-			c->x86_model = (tfms >> 4) & 15;
-			if (c->x86 == 0xf)
-				c->x86 += (tfms >> 20) & 0xff;
-			if (c->x86 >= 0x6)
-				c->x86_model += ((tfms >> 16) & 0xF) << 4;
-			c->x86_mask = tfms & 15;
-			c->initial_apicid = (ebx >> 24) & 0xFF;
+	if (c->cpuid_level >= 0x00000001) {
+		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_HT
-			c->apicid = phys_pkg_id(c->initial_apicid, 0);
-			c->phys_proc_id = c->initial_apicid;
+		c->apicid = phys_pkg_id(c->initial_apicid, 0);
+		c->phys_proc_id = c->initial_apicid;
 #else
-			c->apicid = c->initial_apicid;
+		c->apicid = c->initial_apicid;
 #endif
-			if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
-				c->x86_clflush_size = ((ebx >> 8) & 0xff) * 8;
-		} else {
-			/* Have CPUID level 0 only - unheard of */
-			c->x86 = 4;
-		}
+	}
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
-			if (xlvl >= 0x80000004)
-				get_model_name(c); /* Default name */
-		}
+	if (c->extended_cpuid_level >= 0x80000004)
+		get_model_name(c); /* Default name */
 
-		init_scattered_cpuid_features(c);
-		detect_nopl(c);
-	}
+	init_scattered_cpuid_features(c);
+	detect_nopl(c);
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
@@ -651,13 +622,10 @@ void __init early_cpu_init(void)
 {
 	struct cpu_vendor_dev *cvdev;
 
-	for (cvdev = __x86cpuvendor_start ;
-	     cvdev < __x86cpuvendor_end   ;
-	     cvdev++)
+	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
-	early_cpu_detect();
-	validate_pat_support(&boot_cpu_data);
+	early_identify_cpu(&boot_cpu_data);
 }
 
 /* Make sure %fs is initialized properly in idle threads */
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -198,6 +198,7 @@ static void __cpuinit get_cpu_vendor(str
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
+	this_cpu = &default_cpu;
 }
 
 static void __init early_cpu_support_print(void)
@@ -252,56 +253,18 @@ static void __cpuinit detect_nopl(struct
 	}
 }
 
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
-
-void __init early_cpu_init(void)
+void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
-        struct cpu_vendor_dev *cvdev;
-
-        for (cvdev = __x86cpuvendor_start ;
-             cvdev < __x86cpuvendor_end   ;
-             cvdev++)
-                cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
-	early_cpu_support_print();
-	early_identify_cpu(&boot_cpu_data);
-}
-
-/* Do some early cpuid on the boot CPU to get some parameter that are
-   needed before check_bugs. Everything advanced is in identify_cpu
-   below. */
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
-{
-	u32 tfms, xlvl;
-
-	c->loops_per_jiffy = loops_per_jiffy;
-	c->x86_cache_size = -1;
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
-	c->x86_vendor_id[0] = '\0'; /* Unset */
-	c->x86_model_id[0] = '\0';  /* Unset */
-	c->x86_clflush_size = 64;
-	c->x86_cache_alignment = c->x86_clflush_size;
-	c->x86_max_cores = 1;
-	c->x86_coreid_bits = 0;
-	c->extended_cpuid_level = 0;
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
 	      (unsigned int *)&c->x86_vendor_id[0],
 	      (unsigned int *)&c->x86_vendor_id[8],
 	      (unsigned int *)&c->x86_vendor_id[4]);
 
-	get_cpu_vendor(c);
-
-	/* Initialize the standard set of capabilities */
-	/* Note that the vendor-specific code below might override */
-
 	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
-		__u32 misc;
-		cpuid(0x00000001, &tfms, &misc, &c->x86_capability[4],
-		      &c->x86_capability[0]);
+		u32 junk, tfms, cap0, misc;
+		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
 		c->x86 = (tfms >> 8) & 0xf;
 		c->x86_model = (tfms >> 4) & 0xf;
 		c->x86_mask = tfms & 0xf;
@@ -309,17 +272,32 @@ static void __cpuinit early_identify_cpu
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
 			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
+		if (cap0 & (1<<19))
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
 	} else {
 		/* Have CPUID level 0 only - unheard of */
 		c->x86 = 4;
 	}
+}
+
+
+static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+{
+	u32 tfms, xlvl;
+	u32 ebx;
+
+	/* Initialize the standard set of capabilities */
+	/* Note that the vendor-specific code below might override */
+
+	/* Intel-defined flags: level 0x00000001 */
+	if (c->cpuid_level >= 0x00000001) {
+		u32 capability, excap;
+
+		cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
+		c->x86_capability[0] = capability;
+		c->x86_capability[4] = excap;
+	}
 
-	c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xff;
-#ifdef CONFIG_SMP
-	c->phys_proc_id = c->initial_apicid;
-#endif
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
@@ -328,8 +306,6 @@ static void __cpuinit early_identify_cpu
 			c->x86_capability[1] = cpuid_edx(0x80000001);
 			c->x86_capability[6] = cpuid_ecx(0x80000001);
 		}
-		if (xlvl >= 0x80000004)
-			get_model_name(c); /* Default name */
 	}
 
 	/* Transmeta-defined flags: level 0x80860001 */
@@ -349,8 +325,26 @@ static void __cpuinit early_identify_cpu
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
 	}
+}
 
-	detect_nopl(c);
+/* Do some early cpuid on the boot CPU to get some parameter that are
+   needed before check_bugs. Everything advanced is in identify_cpu
+   below. */
+static void __init early_identify_cpu(struct cpuinfo_x86 *c)
+{
+
+	c->x86_clflush_size = 64;
+	c->x86_cache_alignment = c->x86_clflush_size;
+
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+
+	c->extended_cpuid_level = 0;
+
+	cpu_detect(c);
+
+	get_cpu_vendor(c);
+
+	get_cpu_cap(c);
 
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
@@ -359,6 +353,39 @@ static void __cpuinit early_identify_cpu
 	validate_pat_support(c);
 }
 
+void __init early_cpu_init(void)
+{
+	struct cpu_vendor_dev *cvdev;
+
+	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
+		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+
+	early_cpu_support_print();
+	early_identify_cpu(&boot_cpu_data);
+}
+
+static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
+{
+	c->extended_cpuid_level = 0;
+
+	cpu_detect(c);
+
+	get_cpu_vendor(c);
+
+	get_cpu_cap(c);
+
+	c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xff;
+#ifdef CONFIG_SMP
+	c->phys_proc_id = c->initial_apicid;
+#endif
+
+	if (c->extended_cpuid_level >= 0x80000004)
+		get_model_name(c); /* Default name */
+
+	init_scattered_cpuid_features(c);
+	detect_nopl(c);
+}
+
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
@@ -366,9 +393,19 @@ static void __cpuinit identify_cpu(struc
 {
 	int i;
 
-	early_identify_cpu(c);
+	c->loops_per_jiffy = loops_per_jiffy;
+	c->x86_cache_size = -1;
+	c->x86_vendor = X86_VENDOR_UNKNOWN;
+	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
+	c->x86_vendor_id[0] = '\0'; /* Unset */
+	c->x86_model_id[0] = '\0';  /* Unset */
+	c->x86_clflush_size = 64;
+	c->x86_cache_alignment = c->x86_clflush_size;
+	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
-	init_scattered_cpuid_features(c);
+	generic_identify(c);
 
 	c->apicid = phys_pkg_id(0);
 
Index: linux-2.6/include/asm-x86/processor.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor.h
+++ linux-2.6/include/asm-x86/processor.h
@@ -78,9 +78,9 @@ struct cpuinfo_x86 {
 	__u8			x86_phys_bits;
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
+#endif
 	/* Max extended CPUID function supported: */
 	__u32			extended_cpuid_level;
-#endif
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
 	__u32			x86_capability[NCAPINTS];
