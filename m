Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbZEMNxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbZEMNxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZEMNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:53:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:60294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZEMNx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:53:28 -0400
Date: Wed, 13 May 2009 13:51:49 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, jeff@garzik.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, jeff@garzik.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
In-Reply-To: <200905131619.12880.rusty@rustcorp.com.au>
References: <200905131619.12880.rusty@rustcorp.com.au>
Subject: [tip:sched/urgent] sched: avoid flexible array member inside struct (gcc extension)
Message-ID: <tip-61a7bca8b5c277ba35e58009e23a1e582f6748eb@git.kernel.org>
Git-Commit-ID: 61a7bca8b5c277ba35e58009e23a1e582f6748eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 13 May 2009 13:51:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61a7bca8b5c277ba35e58009e23a1e582f6748eb
Gitweb:     http://git.kernel.org/tip/61a7bca8b5c277ba35e58009e23a1e582f6748eb
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 13 May 2009 16:19:12 +0930
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 May 2009 15:17:05 +0200

sched: avoid flexible array member inside struct (gcc extension)

struct sched_group and struct sched_domain end in 'unsigned long
cpumask[]' which Jeff Garzik notes is not legal C to place inside
another struct.  It upsets sparse and clang (LLVM's C front end).

Al Viro pointed out that a union is the Right Way to do this.

[ Impact: use more standard C code ]

Reported-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
LKML-Reference: <200905131619.12880.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

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
