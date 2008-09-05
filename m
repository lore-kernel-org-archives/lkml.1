Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYIEDKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYIEDKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYIEDJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYIEDJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=me41HvqJBa0WHmiNNKBGoSVgxwmx/esrQVGzuN7L+g1nd4UJCVWLqmHKaPJYHYgxwn
         LeUxV7SUjwXT2i4JmFReX8Ay7rmbdYlGXcL7DG9qeosCDVVjkHtu97hziUPPMmjTp7up
         1NUGJic2R8cXfjQbqbfti+GTkoJPztRv4INxA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 04/16] x86: cpu common let 64bit code have 32bit only func
Date: Thu,  4 Sep 2008 20:09:02 -0700
Message-Id: <1220584154-32497-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    8 +++
 arch/x86/kernel/cpu/common_64.c |  111 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e0ca51f..9128ba0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -93,6 +93,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+#ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
@@ -195,6 +196,13 @@ static int __init x86_serial_nr_setup(char *s)
 	return 1;
 }
 __setup("serialnumber", x86_serial_nr_setup);
+#else
+/* Probe for the CPUID instruction */
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+#endif
 
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index b489050..40c9d89 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -92,6 +92,117 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+#ifdef CONFIG_X86_32
+static int cachesize_override __cpuinitdata = -1;
+static int disable_x86_serial_nr __cpuinitdata = 1;
+
+static int __init cachesize_setup(char *str)
+{
+	get_option(&str, &cachesize_override);
+	return 1;
+}
+__setup("cachesize=", cachesize_setup);
+
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
+static int __init x86_fxsr_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_FXSR);
+	setup_clear_cpu_cap(X86_FEATURE_XMM);
+	return 1;
+}
+__setup("nofxsr", x86_fxsr_setup);
+
+static int __init x86_sep_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SEP);
+	return 1;
+}
+__setup("nosep", x86_sep_setup);
+
+/* Standard macro to see if a specific flag is changeable */
+static inline int flag_is_changeable_p(u32 flag)
+{
+	u32 f1, f2;
+
+	asm("pushfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "movl %0,%1\n\t"
+	    "xorl %2,%0\n\t"
+	    "pushl %0\n\t"
+	    "popfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "popfl\n\t"
+	    : "=&r" (f1), "=&r" (f2)
+	    : "ir" (flag));
+
+	return ((f1^f2) & flag) != 0;
+}
+
+/* Probe for the CPUID instruction */
+static int __cpuinit have_cpuid_p(void)
+{
+	return flag_is_changeable_p(X86_EFLAGS_ID);
+}
+
+static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
+		/* Disable processor serial number */
+		unsigned long lo, hi;
+		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		lo |= 0x200000;
+		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		printk(KERN_NOTICE "CPU serial number disabled.\n");
+		clear_cpu_cap(c, X86_FEATURE_PN);
+
+		/* Disabling the serial number may affect the cpuid level */
+		c->cpuid_level = cpuid_eax(0);
+	}
+}
+
+static int __init x86_serial_nr_setup(char *s)
+{
+	disable_x86_serial_nr = 0;
+	return 1;
+}
+__setup("serialnumber", x86_serial_nr_setup);
+#else
+/* Probe for the CPUID instruction */
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+#endif
+
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
-- 
1.5.4.5

