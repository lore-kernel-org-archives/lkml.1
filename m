Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZAZGQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZAZGQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZAZGPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:40 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:50781 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZAZGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wBCY0JBN6r+p//ZKOPnAlIUQg8CBoLBxC3UODPWk4Cb2BYJ75+KW6OaKuOxaJO+/HV
         hLDrSTdu9BPGgkz/Z9lyL3z8RsnZKwfAHF+ZwYJV/f35iOvvwDHM6YzOjG6wopB2IPOk
         QbmFhVMhoKR/pV9alMQFiD1+ojmX2L/6gP3Lg=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] x86: Move setup_cpu_local_masks()
Date: Mon, 26 Jan 2009 01:15:23 -0500
Message-Id: <1232950532-22923-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Code movement, no functional change.

Move setup_cpu_local_masks() to kernel/cpu/common.c, where the
masks are defined.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/cpumask.h |    4 ++++
 arch/x86/kernel/cpu/common.c   |    9 +++++++++
 arch/x86/kernel/setup_percpu.c |   19 -------------------
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
index 26c6dad..a7f3c75 100644
--- a/arch/x86/include/asm/cpumask.h
+++ b/arch/x86/include/asm/cpumask.h
@@ -10,6 +10,8 @@ extern cpumask_var_t cpu_callout_mask;
 extern cpumask_var_t cpu_initialized_mask;
 extern cpumask_var_t cpu_sibling_setup_mask;
 
+extern void setup_cpu_local_masks(void);
+
 #else /* CONFIG_X86_32 */
 
 extern cpumask_t cpu_callin_map;
@@ -22,6 +24,8 @@ extern cpumask_t cpu_sibling_setup_map;
 #define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
 #define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
 
+static inline void setup_cpu_local_masks(void) { }
+
 #endif /* CONFIG_X86_32 */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 99904f2..67e30c8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -52,6 +52,15 @@ cpumask_var_t cpu_initialized_mask;
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
 
+/* correctly size the local cpu masks */
+void setup_cpu_local_masks(void)
+{
+	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
+	alloc_bootmem_cpumask_var(&cpu_callin_mask);
+	alloc_bootmem_cpumask_var(&cpu_callout_mask);
+	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
+}
+
 #else /* CONFIG_X86_32 */
 
 cpumask_t cpu_callin_map;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index cb6d622..7bebdba 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -51,25 +51,6 @@ DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
-#ifdef CONFIG_X86_64
-
-/* correctly size the local cpu masks */
-static void setup_cpu_local_masks(void)
-{
-	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
-	alloc_bootmem_cpumask_var(&cpu_callin_mask);
-	alloc_bootmem_cpumask_var(&cpu_callout_mask);
-	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
-}
-
-#else /* CONFIG_X86_32 */
-
-static inline void setup_cpu_local_masks(void)
-{
-}
-
-#endif /* CONFIG_X86_32 */
-
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 
 #ifdef CONFIG_X86_64
-- 
1.6.1

