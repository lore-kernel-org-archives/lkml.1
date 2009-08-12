Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbZHLJzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbZHLJzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZHLJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:55:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZHLJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:55:34 -0400
Date: Wed, 12 Aug 2009 09:54:41 GMT
From: tip-bot for Ondrej Zary <linux@rainbow-software.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@rainbow-software.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux@rainbow-software.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200908112000.15993.linux@rainbow-software.org>
References: <200908112000.15993.linux@rainbow-software.org>
Subject: [tip:x86/urgent] x86: Fix oops in identify_cpu() on CPUs without CPUID
Message-ID: <tip-e8055139d996e85722984968472868d6dccb1490@git.kernel.org>
Git-Commit-ID: e8055139d996e85722984968472868d6dccb1490
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Aug 2009 09:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8055139d996e85722984968472868d6dccb1490
Gitweb:     http://git.kernel.org/tip/e8055139d996e85722984968472868d6dccb1490
Author:     Ondrej Zary <linux@rainbow-software.org>
AuthorDate: Tue, 11 Aug 2009 20:00:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 12 Aug 2009 11:49:41 +0200

x86: Fix oops in identify_cpu() on CPUs without CPUID

Kernel is broken for x86 CPUs without CPUID since 2.6.28. It
crashes with NULL pointer dereference in identify_cpu():

766        generic_identify(c);
767
768-->     if (this_cpu->c_identify)
769               this_cpu->c_identify(c);

this_cpu is NULL. This is because it's only initialized in
get_cpu_vendor() function, which is not called if the CPU has
no CPUID instruction.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
LKML-Reference: <200908112000.15993.linux@rainbow-software.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/common.c |   48 +++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..5ce60a8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,7 +59,30 @@ void __init setup_cpu_local_masks(void)
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
+	.c_init		= default_init,
+	.c_vendor	= "Unknown",
+	.c_x86_vendor	= X86_VENDOR_UNKNOWN,
+};
+
+static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -332,29 +355,6 @@ void switch_to_new_gdt(int cpu)
 
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
