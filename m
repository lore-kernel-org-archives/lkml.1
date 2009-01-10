Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZAJMFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZAJMFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZAJMEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:04:53 -0500
Received: from ozlabs.org ([203.10.76.45]:42127 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZAJMEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:04:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: bad patch in sched.c
Date: Sat, 10 Jan 2009 22:34:36 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jes Sorensen <jes@sgi.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
References: <496797C4.6000601@sgi.com>
In-Reply-To: <496797C4.6000601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901102234.37460.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009 05:00:28 Mike Travis wrote:
> 
> It appears that 
> 
> commit 6c99e9ad47d9c082bd096f42fb49e397b05d58a8
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Tue Nov 25 02:35:04 2008 +1030
> 
>     sched: convert struct sched_group/sched_domain cpumask_ts to variable bitmaps
> 
>     Impact: (future) size reduction for large NR_CPUS.
> 
>     We move the 'cpumask' member of sched_group to the end, so when we
>     kmalloc it we can do a minimal allocation: saves space for small
>     nr_cpu_ids but big CONFIG_NR_CPUS.  Similar trick for 'span' in
>     sched_domain.
> 
>     This isn't quite as good as converting to a cpumask_var_t, as some
>     sched_groups are actually static, but it's safer: we don't have to
>     figure out where to call alloc_cpumask_var/free_cpumask_var.
> 
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> causes a panic in ia64 with NR_CPUS=1024.

Thanks, that focussed me on the right place.  Does this fix it?

cpumask: fix CONFIG_NUMA=y sched.c

struct sched_domain is now a dangling structure; where we really want
static ones, we need to use static_sched_domain.

(As the FIXME in this file says, cpumask_var_t would be better, but
this code is hairy enough without trying to add initialization code to
the right places).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7282,10 +7282,10 @@ cpu_to_phys_group(int cpu, const struct 
  * groups, so roll our own. Now each node has its own list of groups which
  * gets dynamically allocated.
  */
-static DEFINE_PER_CPU(struct sched_domain, node_domains);
+static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
-static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
+static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
 static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
@@ -7560,7 +7560,7 @@ static int __build_sched_domains(const s
 #ifdef CONFIG_NUMA
 		if (cpumask_weight(cpu_map) >
 				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
-			sd = &per_cpu(allnodes_domains, i);
+			sd = &per_cpu(allnodes_domains, i).sg;
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			cpumask_copy(sched_domain_span(sd), cpu_map);
@@ -7570,7 +7570,7 @@ static int __build_sched_domains(const s
 		} else
 			p = NULL;
 
-		sd = &per_cpu(node_domains, i);
+		sd = &per_cpu(node_domains, i).sd;
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
@@ -7688,7 +7688,7 @@ static int __build_sched_domains(const s
 		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(node_domains, j);
+			sd = &per_cpu(node_domains, j).sd;
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
