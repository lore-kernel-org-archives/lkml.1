Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZAJRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZAJRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZAJRPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:15:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33337 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752531AbZAJRPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:15:11 -0500
Message-ID: <4968D79C.10602@sgi.com>
Date: Sat, 10 Jan 2009 09:15:08 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jes Sorensen <jes@sgi.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bad patch in sched.c
References: <496797C4.6000601@sgi.com> <200901102234.37460.rusty@rustcorp.com.au> <20090110121847.GA26459@elte.hu>
In-Reply-To: <20090110121847.GA26459@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> cpumask: fix CONFIG_NUMA=y sched.c
> 
> doesnt build:
> 
> kernel/sched.c: In function ‘__build_sched_domains’:
> kernel/sched.c:7701: error: ‘struct static_sched_domain’ has no member named ‘sg’
> 
> 	Ingo
Hi,

This one does compile and fix it.

Thanks,
Mike
---
cpumask: fix CONFIG_NUMA=y sched.c

struct sched_domain is now a dangling structure; where we really want
static ones, we need to use static_sched_domain.

(As the FIXME in this file says, cpumask_var_t would be better, but
this code is hairy enough without trying to add initialization code to
the right places).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.8.orig/kernel/sched.c
+++ linux-2.8/kernel/sched.c
@@ -7278,10 +7278,10 @@ cpu_to_phys_group(int cpu, const struct 
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
@@ -7556,7 +7556,7 @@ static int __build_sched_domains(const s
 #ifdef CONFIG_NUMA
 		if (cpumask_weight(cpu_map) >
 				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
-			sd = &per_cpu(allnodes_domains, i);
+			sd = &per_cpu(allnodes_domains, i).sd;
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			cpumask_copy(sched_domain_span(sd), cpu_map);
@@ -7566,7 +7566,7 @@ static int __build_sched_domains(const s
 		} else
 			p = NULL;
 
-		sd = &per_cpu(node_domains, i);
+		sd = &per_cpu(node_domains, i).sd;
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
@@ -7684,7 +7684,7 @@ static int __build_sched_domains(const s
 		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(node_domains, j);
+			sd = &per_cpu(node_domains, j).sd;
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
