Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYGCHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYGCHDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYGCG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:28260 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYGCBxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=sqZoMR27juC0Cd/x497grYWvc2bFzu32AxsrQE9Y7/2GBAICHJuFqbRGMRoMw1mjXt
         SHfF95InuzbHXSTSnsN0od824haHgWr5PQYaFjST4HC3YKWGVOhQ8OsJ0dsU09lsCp4+
         dDloT5Y8D1tNy8zRez3U0d5MYkVThm/tTtYwI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move prefill_possible_map calling early
Date: Wed, 2 Jul 2008 18:54:40 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com> <200807021851.02301.yinghai.lu@sun.com>
In-Reply-To: <200807021851.02301.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807021854.40729.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


call it right after we done with MADT/mptable handling, instead of doing that
in setup_per_cpu_areas later...
so for_possible_cpu could be used early.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |    1 +
 arch/x86/kernel/setup_percpu.c |   10 ----------
 arch/x86/kernel/smpboot.c      |    8 ++++++++
 include/asm-x86/smp.h          |    4 ++++
 4 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -788,6 +788,7 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
+	prefill_possible_map();
 #ifdef CONFIG_X86_64
 	init_cpu_to_node();
 #endif
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -162,16 +162,6 @@ void __init setup_per_cpu_areas(void)
 	char *ptr;
 	int cpu;
 
-	/* no processor from mptable or madt */
-	if (!num_processors)
-		num_processors = 1;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	prefill_possible_map();
-#else
-	nr_cpu_ids = num_processors;
-#endif
-
 	/* Setup cpu_pda map */
 	setup_cpu_pda_map();
 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1278,12 +1278,20 @@ __init void prefill_possible_map(void)
 	int i;
 	int possible;
 
+	/* no processor from mptable or madt */
+	if (!num_processors)
+		num_processors = 1;
+
+#ifdef CONFIG_HOTPLUG_CPU
 	if (additional_cpus == -1) {
 		if (disabled_cpus > 0)
 			additional_cpus = disabled_cpus;
 		else
 			additional_cpus = 0;
 	}
+#else
+	additional_cpus = 0;
+#endif
 	possible = num_processors + additional_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
Index: linux-2.6/include/asm-x86/smp.h
===================================================================
--- linux-2.6.orig/include/asm-x86/smp.h
+++ linux-2.6/include/asm-x86/smp.h
@@ -124,6 +124,10 @@ static inline int num_booting_cpus(void)
 {
 	return cpus_weight(cpu_callout_map);
 }
+#else
+static inline void prefill_possible_map(void)
+{
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
