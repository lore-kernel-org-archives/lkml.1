Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZHKSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZHKSA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZHKSA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:00:29 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48452 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZHKSA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:00:28 -0400
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] [resend] OOPS in identify_cpu() on CPUs without CPUID
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 11 Aug 2009 20:00:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908112000.15993.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel is broken for x86 CPUs without CPUID since 2.6.28. It crashes with NULL
pointer dereference in identify_cpu():

766        generic_identify(c);
767
768-->     if (this_cpu->c_identify)
769                this_cpu->c_identify(c);

this_cpu is NULL. This is because it's only initialized in get_cpu_vendor()
function, which is not called if the CPU has no CPUID instruction.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
--- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-09 13:33:04.000000000 +0200
@@ -58,7 +58,30 @@
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
-static const struct cpu_dev *this_cpu __cpuinitdata;
+static void __cpuinit default_init(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
+	/* Not much we can do here... */
+	/* Check if at least it has cpuid */
+	if (c->cpuid_level == -1) {
+		/* No cpuid. It must be an ancient CPU */
+		if (c->x86 == 4)
+			strcpy(c->x86_model_id, "486");
+		else if (c->x86 == 3)
+			strcpy(c->x86_model_id, "386");
+	}
+#endif
+}
+
+static const struct cpu_dev __cpuinitconst default_cpu = {
+	.c_init	= default_init,
+	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
+};
+
+static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -330,29 +353,6 @@
 
 static const struct cpu_dev *__cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_X86_64
-	display_cacheinfo(c);
-#else
-	/* Not much we can do here... */
-	/* Check if at least it has cpuid */
-	if (c->cpuid_level == -1) {
-		/* No cpuid. It must be an ancient CPU */
-		if (c->x86 == 4)
-			strcpy(c->x86_model_id, "486");
-		else if (c->x86 == 3)
-			strcpy(c->x86_model_id, "386");
-	}
-#endif
-}
-
-static const struct cpu_dev __cpuinitconst default_cpu = {
-	.c_init	= default_init,
-	.c_vendor = "Unknown",
-	.c_x86_vendor = X86_VENDOR_UNKNOWN,
-};
-
 static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;


-- 
Ondrej Zary
