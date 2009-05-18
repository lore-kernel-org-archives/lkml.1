Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZERO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZERO1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZERO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:27:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38709 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZERO1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:27:33 -0400
Date: Mon, 18 May 2009 16:27:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090518142707.GA24142@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ron (1):
      sched: Fix fallback sched_clock()'s offset when using jiffies

Rusty Russell (1):
      sched: avoid flexible array member inside struct (gcc extension)


 kernel/sched.c       |   28 +++++++++++++++-------------
 kernel/sched_clock.c |    3 ++-
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..d1ef62c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7756,22 +7756,24 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
  * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
  * for nr_cpu_ids < CONFIG_NR_CPUS.
  */
-struct static_sched_group {
+union static_sched_group {
 	struct sched_group sg;
-	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
+	char _sg_and_cpus[sizeof(struct sched_group) +
+			  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
 };
 
-struct static_sched_domain {
+union static_sched_domain {
 	struct sched_domain sd;
-	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
+	char _sd_and_cpus[sizeof(struct sched_domain) +
+			  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
 };
 
 /*
  * SMT sched-domains:
  */
 #ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
+static DEFINE_PER_CPU(union static_sched_domain, cpu_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_cpus);
 
 static int
 cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
@@ -7787,8 +7789,8 @@ cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
  * multi-core sched-domains:
  */
 #ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+static DEFINE_PER_CPU(union static_sched_domain, core_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_core);
 #endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
@@ -7815,8 +7817,8 @@ cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 }
 #endif
 
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
+static DEFINE_PER_CPU(union static_sched_domain, phys_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_phys);
 
 static int
 cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
@@ -7843,11 +7845,11 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
  * groups, so roll our own. Now each node has its own list of groups which
  * gets dynamically allocated.
  */
-static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
+static DEFINE_PER_CPU(union static_sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
+static DEFINE_PER_CPU(union static_sched_domain, allnodes_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_allnodes);
 
 static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
 				 struct sched_group **sg,
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 819f17a..e1d16c9 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -38,7 +38,8 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+					* (NSEC_PER_SEC / HZ);
 }
 
 static __read_mostly int sched_clock_running;
