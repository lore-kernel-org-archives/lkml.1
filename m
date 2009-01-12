Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZALAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZALAXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZALAXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:23:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:56706 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZALAXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:23:34 -0500
Subject: [PATCH] powerpc: Fix cpufreq drivers after cpufreq core changes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Olof Johansson <olof@lixom.net>,
       arndb <arndb@arndb.de>
In-Reply-To: <1231719015.22571.4.camel@pasglop>
References: <20090112104837.69feedec.sfr@canb.auug.org.au>
	 <1231719015.22571.4.camel@pasglop>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 11:22:01 +1100
Message-Id: <1231719721.22571.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the cpufreq drivers in arch/powerpc so they build again
after the core cpufreq changes that broke them in commit
in835481d9bcd65720b473db6b38746a74a3964218.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Tested on a G5. Olof, Arnd, any chance you can test the cell and pasemi
drivers still work ?

Linus, you can probably merge this now to fix the build problems.

diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq.c b/arch/powerpc/platforms/cell/cbe_cpufreq.c
index ec7c8f4..e6506cd 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c
+++ b/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -118,7 +118,7 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cur = cbe_freqs[cur_pmode].frequency;
 
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
diff --git a/arch/powerpc/platforms/cell/cpufreq_spudemand.c b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
index a3c6c01..968c1c0 100644
--- a/arch/powerpc/platforms/cell/cpufreq_spudemand.c
+++ b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
@@ -110,7 +110,7 @@ static int spu_gov_govern(struct cpufreq_policy *policy, unsigned int event)
 		}
 
 		/* initialize spu_gov_info for all affected cpus */
-		for_each_cpu_mask(i, policy->cpus) {
+		for_each_cpu(i, policy->cpus) {
 			affected_info = &per_cpu(spu_gov_info, i);
 			affected_info->policy = policy;
 		}
@@ -127,7 +127,7 @@ static int spu_gov_govern(struct cpufreq_policy *policy, unsigned int event)
 		spu_gov_cancel_work(info);
 
 		/* clean spu_gov_info for all affected cpus */
-		for_each_cpu_mask (i, policy->cpus) {
+		for_each_cpu (i, policy->cpus) {
 			info = &per_cpu(spu_gov_info, i);
 			info->policy = NULL;
 		}
diff --git a/arch/powerpc/platforms/pasemi/cpufreq.c b/arch/powerpc/platforms/pasemi/cpufreq.c
index 86db47c..be2527a 100644
--- a/arch/powerpc/platforms/pasemi/cpufreq.c
+++ b/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -213,7 +213,7 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	pr_debug("current astate is at %d\n",cur_astate);
 
 	policy->cur = pas_freqs[cur_astate].frequency;
-	policy->cpus = cpu_online_map;
+	cpumask_copy(policy->cpus, &cpu_online_map);
 
 	ppc_proc_freq = policy->cur * 1000ul;
 
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/arch/powerpc/platforms/powermac/cpufreq_64.c
index 4dfb4bc..beb3833 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -362,7 +362,7 @@ static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	/* secondary CPUs are tied to the primary one by the
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
-	policy->cpus = cpu_online_map;
+	cpumask_copy(policy->cpus, &cpu_online_map);
 	cpufreq_frequency_table_get_attr(g5_cpu_freqs, policy->cpu);
 
 	return cpufreq_frequency_table_cpuinfo(policy,


