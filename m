Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZJIFou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZJIFou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZJIFos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:44:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54183 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZJIFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:44:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECDA1.7020004@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:44:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] mce-inject: make raise_global()
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255053299.5228.28.camel@yhuang-dev.sh.intel.com> <4ACECC49.7000602@jp.fujitsu.com>
In-Reply-To: <4ACECC49.7000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move large block into a function.  No code changed.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   73 ++++++++++++++++++-------------
 1 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index a481291..835c072 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -148,6 +148,45 @@ static int raise_local(void)
 	return ret;
 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
+static void raise_global(void)
+{
+	unsigned long start;
+	int cpu;
+
+	get_online_cpus();
+	mce_inject_cpumask = cpu_online_map;
+	cpu_clear(get_cpu(), mce_inject_cpumask);
+
+	for_each_online_cpu(cpu) {
+		struct mce *m = &per_cpu(mce_fake_banks, cpu).injectm;
+		if (!m->finished || MCE_INJ_CTX(m->inject_flags)
+							!= MCE_INJ_CTX_RANDOM)
+			cpu_clear(cpu, mce_inject_cpumask);
+	}
+	/* make sure mce_inject_cpumask is visible on other CPUs */
+	smp_mb();
+
+	if (!cpus_empty(mce_inject_cpumask))
+		apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
+
+	start = jiffies;
+	while (!cpus_empty(mce_inject_cpumask)) {
+		if (!time_before(jiffies, start + 2*HZ)) {
+			printk(KERN_ERR
+				"Timeout waiting for mce inject NMI %lx\n",
+				*cpus_addr(mce_inject_cpumask));
+			break;
+		}
+		cpu_relax();
+	}
+	raise_local();
+
+	put_cpu();
+	put_online_cpus();
+}
+#endif
+
 static void raise_mce(struct mce *m)
 {
 	/*
@@ -157,37 +196,9 @@ static void raise_mce(struct mce *m)
 	schedule_timeout(2);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & MCE_INJ_NMI_BROADCAST) {
-		unsigned long start;
-		int cpu;
-		get_online_cpus();
-		mce_inject_cpumask = cpu_online_map;
-		cpu_clear(get_cpu(), mce_inject_cpumask);
-		for_each_online_cpu(cpu) {
-			struct mce *m = &per_cpu(mce_fake_banks, cpu).injectm;
-			if (!m->finished || MCE_INJ_CTX(m->inject_flags)
-							!= MCE_INJ_CTX_RANDOM)
-				cpu_clear(cpu, mce_inject_cpumask);
-		}
-		/* make sure mce_inject_cpumask is visible on other CPUs */
-		smp_mb();
-
-		if (!cpus_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
-		start = jiffies;
-		while (!cpus_empty(mce_inject_cpumask)) {
-			if (!time_before(jiffies, start + 2*HZ)) {
-				printk(KERN_ERR
-				"Timeout waiting for mce inject NMI %lx\n",
-					*cpus_addr(mce_inject_cpumask));
-				break;
-			}
-			cpu_relax();
-		}
-		raise_local();
-		put_cpu();
-		put_online_cpus();
-	} else
+	if (m->inject_flags & MCE_INJ_NMI_BROADCAST)
+		raise_global();
+	else
 #endif
 		raise_local();
 }
-- 
1.6.2.2


