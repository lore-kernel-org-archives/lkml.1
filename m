Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZEMCMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZEMCMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZEMCMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:12:40 -0400
Received: from ozlabs.org ([203.10.76.45]:45045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZEMCMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:12:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Date: Wed, 13 May 2009 11:42:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
References: <20090508184838.GA11157@havoc.gtf.org> <200905122304.52395.rusty@rustcorp.com.au> <20090512140344.GO8633@ZenIV.linux.org.uk>
In-Reply-To: <20090512140344.GO8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905131142.27484.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 11:33:44 pm Al Viro wrote:
> On Tue, May 12, 2009 at 11:04:51PM +0930, Rusty Russell wrote:
> > ... you're not normally allowed to embed structs with them in another
> > struct (according to the  gcc docs; I can't actually find this clearly
> > stated in the standard).
>
> 6.7.2.1p2.

Ah, thanks.

> > Anyway, since [] is C99, I thought it preferable to [0] which is a gcc
> > extension.  However, if C99 is really so braindead as to disallow this
> > fairly standard trick, so I'm happy to go with the gcc extension.[1]
>
> No.  There's a standard way to do that in C99; you can put a struct with
> that thing into a union.

Ah, thanks for the clue.

How's this:

sched: avoid flexible array member inside struct (gcc extension)

struct sched_group and struct sched_domain end in 'unsigned long
cpumask[]' which Jeff Garzik notes is not legal to place inside
another struct.  It upsets sparse and clang (LLVM's C front end).

Al Viro pointed out that a union is the Right Way to do this.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Jeff Garzik <jeff@garzik.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/sched.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7756,22 +7756,24 @@ int sched_smt_power_savings = 0, sched_m
  * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
  * for nr_cpu_ids < CONFIG_NR_CPUS.
  */
-struct static_sched_group {
+union static_sched_group {
 	struct sched_group sg;
-	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
-};
-
-struct static_sched_domain {
+	char _sg_and_cpus[sizeof(struct sched_group) +
+			  BITS_TO_LONGS(CONFIG_NR_CPUS) * sizeof(long)];
+};
+
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
@@ -7787,8 +7789,8 @@ cpu_to_cpu_group(int cpu, const struct c
  * multi-core sched-domains:
  */
 #ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+static DEFINE_PER_CPU(union static_sched_domain, core_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_core);
 #endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
@@ -7815,8 +7817,8 @@ cpu_to_core_group(int cpu, const struct 
 }
 #endif
 
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
+static DEFINE_PER_CPU(union static_sched_domain, phys_domains);
+static DEFINE_PER_CPU(union static_sched_group, sched_group_phys);
 
 static int
 cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
@@ -7843,11 +7845,11 @@ cpu_to_phys_group(int cpu, const struct 
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

