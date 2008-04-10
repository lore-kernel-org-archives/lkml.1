Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYDJOxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYDJOxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbYDJOxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:53:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47747 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbYDJOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:53:20 -0400
Subject: Re: [PATCH 2/2] Customize sched domain via cpuset (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <47F5F0BB.1080804@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	 <47F5F0BB.1080804@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 16:53:15 +0200
Message-Id: <1207839195.7074.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 18:11 +0900, Hidetoshi Seto wrote:
> The implementation has some updates...
> 
> >  - Add 2 new cpuset files:
> >      sched_wake_idle_far
> >      sched_balance_newidle_far
>     -> Merged into 1 file, having levels:
>          sched_relax_domain_level
> 
> >  - Modify partition_sched_domains() and build_sched_domains()
> >    to take flags parameter passed from cpuset.
>     -> Changed to "attributes" rather than "flags."
> 
> >  - Fill newidle_idx for node domains which currently unused but
> >    might be required for sched_balance_newidle_far.
> 
>    + We can change the "default" level by boot option 'relax_domain_level='.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

This seems like a sufficiently flexible interface. Paul, have you got
any outstanding objections?

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  include/asm-ia64/topology.h |    2 -
>  include/asm-sh/topology.h   |    2 -
>  include/asm-x86/topology.h  |    2 -
>  include/linux/sched.h       |   23 +++++++++++-
>  kernel/cpuset.c             |   61 ++++++++++++++++++++++++++++++++
>  kernel/sched.c              |   82 +++++++++++++++++++++++++++++++++++++++++---
>  kernel/sched_fair.c         |    4 +-
>  7 files changed, 165 insertions(+), 11 deletions(-)
> 
> Index: GIT-torvalds/include/linux/sched.h
> ===================================================================
> --- GIT-torvalds.orig/include/linux/sched.h
> +++ GIT-torvalds/include/linux/sched.h
> @@ -704,6 +704,7 @@ enum cpu_idle_type {
>  #define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
>  #define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
>  #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
> +#define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
> 
>  #define BALANCE_FOR_MC_POWER	\
>  	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
> @@ -733,6 +734,24 @@ struct sched_group {
>  	u32 reciprocal_cpu_power;
>  };
> 
> +enum sched_domain_level {
> +	SD_LV_NONE = 0,
> +	SD_LV_SIBLING,
> +	SD_LV_MC,
> +	SD_LV_CPU,
> +	SD_LV_NODE,
> +	SD_LV_ALLNODES,
> +	SD_LV_MAX
> +};
> +
> +struct sched_domain_attr {
> +	int relax_domain_level;
> +};
> +
> +#define SD_ATTR_INIT	(struct sched_domain_attr) {	\
> +	.relax_domain_level = -1,			\
> +}
> +
>  struct sched_domain {
>  	/* These fields must be setup */
>  	struct sched_domain *parent;	/* top domain must be null terminated */
> @@ -750,6 +769,7 @@ struct sched_domain {
>  	unsigned int wake_idx;
>  	unsigned int forkexec_idx;
>  	int flags;			/* See SD_* */
> +	enum sched_domain_level level;
> 
>  	/* Runtime fields. */
>  	unsigned long last_balance;	/* init to jiffies. units in jiffies */
> @@ -789,7 +809,8 @@ struct sched_domain {
>  #endif
>  };
> 
> -extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new);
> +extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
> +				    struct sched_domain_attr *dattr_new);
>  extern int arch_reinit_sched_domains(void);
> 
>  #endif	/* CONFIG_SMP */
> Index: GIT-torvalds/kernel/sched.c
> ===================================================================
> --- GIT-torvalds.orig/kernel/sched.c
> +++ GIT-torvalds/kernel/sched.c
> @@ -6582,11 +6582,42 @@ static void init_sched_groups_power(int
>  	} while (group != child->groups);
>  }
> 
> +static int default_relax_domain_level = -1;
> +
> +static int __init setup_relax_domain_level(char *str)
> +{
> +	default_relax_domain_level = simple_strtoul(str, NULL, 0);
> +	return 1;
> +}
> +__setup("relax_domain_level=", setup_relax_domain_level);
> +
> +static void set_domain_attribute(struct sched_domain *sd,
> +				 struct sched_domain_attr *attr)
> +{
> +	int request;
> +
> +	if (!attr || attr->relax_domain_level < 0) {
> +		if (default_relax_domain_level < 0)
> +			return;
> +		else
> +			request = default_relax_domain_level;
> +	} else
> +		request = attr->relax_domain_level;
> +	if (request < sd->level) {
> +		/* turn off idle balance on this domain */
> +		sd->flags &= ~(SD_WAKE_IDLE|SD_BALANCE_NEWIDLE);
> +	} else {
> +		/* turn on idle balance on this domain */
> +		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
> +	}
> +}
> +
>  /*
>   * Build sched domains for a given set of cpus and attach the sched domains
>   * to the individual cpus
>   */
> -static int build_sched_domains(const cpumask_t *cpu_map)
> +static int __build_sched_domains(const cpumask_t *cpu_map,
> +				 struct sched_domain_attr *attr)
>  {
>  	int i;
>  	struct root_domain *rd;
> @@ -6626,7 +6657,9 @@ static int build_sched_domains(const cpu
>  				SD_NODES_PER_DOMAIN*cpus_weight(nodemask)) {
>  			sd = &per_cpu(allnodes_domains, i);
>  			*sd = SD_ALLNODES_INIT;
> +			sd->level = SD_LV_ALLNODES;
>  			sd->span = *cpu_map;
> +			set_domain_attribute(sd, attr);
>  			cpu_to_allnodes_group(i, cpu_map, &sd->groups);
>  			p = sd;
>  			sd_allnodes = 1;
> @@ -6635,7 +6668,9 @@ static int build_sched_domains(const cpu
> 
>  		sd = &per_cpu(node_domains, i);
>  		*sd = SD_NODE_INIT;
> +		sd->level = SD_LV_NODE;
>  		sd->span = sched_domain_node_span(cpu_to_node(i));
> +		set_domain_attribute(sd, attr);
>  		sd->parent = p;
>  		if (p)
>  			p->child = sd;
> @@ -6645,7 +6680,9 @@ static int build_sched_domains(const cpu
>  		p = sd;
>  		sd = &per_cpu(phys_domains, i);
>  		*sd = SD_CPU_INIT;
> +		sd->level = SD_LV_CPU;
>  		sd->span = nodemask;
> +		set_domain_attribute(sd, attr);
>  		sd->parent = p;
>  		if (p)
>  			p->child = sd;
> @@ -6655,8 +6692,10 @@ static int build_sched_domains(const cpu
>  		p = sd;
>  		sd = &per_cpu(core_domains, i);
>  		*sd = SD_MC_INIT;
> +		sd->level = SD_LV_MC;
>  		sd->span = cpu_coregroup_map(i);
>  		cpus_and(sd->span, sd->span, *cpu_map);
> +		set_domain_attribute(sd, attr);
>  		sd->parent = p;
>  		p->child = sd;
>  		cpu_to_core_group(i, cpu_map, &sd->groups);
> @@ -6666,8 +6705,10 @@ static int build_sched_domains(const cpu
>  		p = sd;
>  		sd = &per_cpu(cpu_domains, i);
>  		*sd = SD_SIBLING_INIT;
> +		sd->level = SD_LV_SIBLING;
>  		sd->span = per_cpu(cpu_sibling_map, i);
>  		cpus_and(sd->span, sd->span, *cpu_map);
> +		set_domain_attribute(sd, attr);
>  		sd->parent = p;
>  		p->child = sd;
>  		cpu_to_cpu_group(i, cpu_map, &sd->groups);
> @@ -6840,8 +6881,15 @@ error:
>  #endif
>  }
> 
> +static int build_sched_domains(const cpumask_t *cpu_map)
> +{
> +	return __build_sched_domains(cpu_map, NULL);
> +}
> +
>  static cpumask_t *doms_cur;	/* current sched domains */
>  static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
> +static struct sched_domain_attr *dattr_cur;	/* attribues of custom domains
> +						   in 'doms_cur' */
> 
>  /*
>   * Special case: If a kmalloc of a doms_cur partition (array of
> @@ -6868,6 +6916,7 @@ static int arch_init_sched_domains(const
>  	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>  	if (!doms_cur)
>  		doms_cur = &fallback_doms;
> +	dattr_cur = NULL;
>  	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
>  	err = build_sched_domains(doms_cur);
>  	register_sched_domain_sysctl();
> @@ -6896,6 +6945,22 @@ static void detach_destroy_domains(const
>  	arch_destroy_sched_domains(cpu_map);
>  }
> 
> +/* handle null as "default" */
> +static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
> +			struct sched_domain_attr *new, int idx_new)
> +{
> +	struct sched_domain_attr tmp;
> +
> +	/* fast path */
> +	if (!new && !cur)
> +		return 1;
> +
> +	tmp = SD_ATTR_INIT;
> +	return !memcmp(cur ? (cur + idx_cur) : &tmp,
> +			new ? (new + idx_new) : &tmp,
> +			sizeof(struct sched_domain_attr));
> +}
> +
>  /*
>   * Partition sched domains as specified by the 'ndoms_new'
>   * cpumasks in the array doms_new[] of cpumasks. This compares
> @@ -6917,7 +6982,8 @@ static void detach_destroy_domains(const
>   *
>   * Call with hotplug lock held
>   */
> -void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
> +void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
> +			     struct sched_domain_attr *dattr_new)
>  {
>  	int i, j;
> 
> @@ -6929,13 +6995,15 @@ void partition_sched_domains(int ndoms_n
>  	if (doms_new == NULL) {
>  		ndoms_new = 1;
>  		doms_new = &fallback_doms;
> +		dattr_new = NULL;
>  		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
>  	}
> 
>  	/* Destroy deleted domains */
>  	for (i = 0; i < ndoms_cur; i++) {
>  		for (j = 0; j < ndoms_new; j++) {
> -			if (cpus_equal(doms_cur[i], doms_new[j]))
> +			if (cpus_equal(doms_cur[i], doms_new[j])
> +			    && dattrs_equal(dattr_cur, i, dattr_new, j))
>  				goto match1;
>  		}
>  		/* no match - a current sched domain not in new doms_new[] */
> @@ -6947,11 +7015,13 @@ match1:
>  	/* Build new domains */
>  	for (i = 0; i < ndoms_new; i++) {
>  		for (j = 0; j < ndoms_cur; j++) {
> -			if (cpus_equal(doms_new[i], doms_cur[j]))
> +			if (cpus_equal(doms_new[i], doms_cur[j])
> +			    && dattrs_equal(dattr_new, i, dattr_cur, j))
>  				goto match2;
>  		}
>  		/* no match - add a new doms_new */
> -		build_sched_domains(doms_new + i);
> +		__build_sched_domains(doms_new + i,
> +					dattr_new ? dattr_new + i : NULL);
>  match2:
>  		;
>  	}
> @@ -6959,7 +7029,9 @@ match2:
>  	/* Remember the new sched domains */
>  	if (doms_cur != &fallback_doms)
>  		kfree(doms_cur);
> +	kfree(dattr_cur);	/* kfree(NULL) is safe */
>  	doms_cur = doms_new;
> +	dattr_cur = dattr_new;
>  	ndoms_cur = ndoms_new;
> 
>  	register_sched_domain_sysctl();
> Index: GIT-torvalds/kernel/sched_fair.c
> ===================================================================
> --- GIT-torvalds.orig/kernel/sched_fair.c
> +++ GIT-torvalds/kernel/sched_fair.c
> @@ -957,7 +957,9 @@ static int wake_idle(int cpu, struct tas
>  		return cpu;
> 
>  	for_each_domain(cpu, sd) {
> -		if (sd->flags & SD_WAKE_IDLE) {
> +		if ((sd->flags & SD_WAKE_IDLE)
> +		    || ((sd->flags & SD_WAKE_IDLE_FAR)
> +			&& !task_hot(p, task_rq(p)->clock, sd))) {
>  			cpus_and(tmp, sd->span, p->cpus_allowed);
>  			for_each_cpu_mask(i, tmp) {
>  				if (idle_cpu(i)) {
> Index: GIT-torvalds/kernel/cpuset.c
> ===================================================================
> --- GIT-torvalds.orig/kernel/cpuset.c
> +++ GIT-torvalds/kernel/cpuset.c
> @@ -98,6 +98,9 @@ struct cpuset {
>  	/* partition number for rebuild_sched_domains() */
>  	int pn;
> 
> +	/* for custom sched domain */
> +	int relax_domain_level;
> +
>  	/* used for walking a cpuset heirarchy */
>  	struct list_head stack_list;
>  };
> @@ -478,6 +481,16 @@ static int cpusets_overlap(struct cpuset
>  	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
>  }
> 
> +static void
> +update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
> +{
> +	if (!dattr)
> +		return;
> +	if (dattr->relax_domain_level < c->relax_domain_level)
> +		dattr->relax_domain_level = c->relax_domain_level;
> +	return;
> +}
> +
>  /*
>   * rebuild_sched_domains()
>   *
> @@ -553,12 +566,14 @@ static void rebuild_sched_domains(void)
>  	int csn;		/* how many cpuset ptrs in csa so far */
>  	int i, j, k;		/* indices for partition finding loops */
>  	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
> +	struct sched_domain_attr *dattr;  /* attributes for custom domains */
>  	int ndoms;		/* number of sched domains in result */
>  	int nslot;		/* next empty doms[] cpumask_t slot */
> 
>  	q = NULL;
>  	csa = NULL;
>  	doms = NULL;
> +	dattr = NULL;
> 
>  	/* Special case for the 99% of systems with one, full, sched domain */
>  	if (is_sched_load_balance(&top_cpuset)) {
> @@ -566,6 +581,11 @@ static void rebuild_sched_domains(void)
>  		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>  		if (!doms)
>  			goto rebuild;
> +		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
> +		if (dattr) {
> +			*dattr = SD_ATTR_INIT;
> +			update_domain_attr(dattr, &top_cpuset);
> +		}
>  		*doms = top_cpuset.cpus_allowed;
>  		goto rebuild;
>  	}
> @@ -622,6 +642,7 @@ restart:
>  	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
>  	if (!doms)
>  		goto rebuild;
> +	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
> 
>  	for (nslot = 0, i = 0; i < csn; i++) {
>  		struct cpuset *a = csa[i];
> @@ -644,12 +665,15 @@ restart:
>  			}
> 
>  			cpus_clear(*dp);
> +			if (dattr)
> +				*(dattr + nslot) = SD_ATTR_INIT;
>  			for (j = i; j < csn; j++) {
>  				struct cpuset *b = csa[j];
> 
>  				if (apn == b->pn) {
>  					cpus_or(*dp, *dp, b->cpus_allowed);
>  					b->pn = -1;
> +					update_domain_attr(dattr, b);
>  				}
>  			}
>  			nslot++;
> @@ -660,7 +684,7 @@ restart:
>  rebuild:
>  	/* Have scheduler rebuild sched domains */
>  	get_online_cpus();
> -	partition_sched_domains(ndoms, doms);
> +	partition_sched_domains(ndoms, doms, dattr);
>  	put_online_cpus();
> 
>  done:
> @@ -668,6 +692,7 @@ done:
>  		kfifo_free(q);
>  	kfree(csa);
>  	/* Don't kfree(doms) -- partition_sched_domains() does that. */
> +	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
>  }
> 
>  static inline int started_after_time(struct task_struct *t1,
> @@ -1011,6 +1036,21 @@ static int update_memory_pressure_enable
>  	return 0;
>  }
> 
> +static int update_relax_domain_level(struct cpuset *cs, char *buf)
> +{
> +	int val = simple_strtol(buf, NULL, 10);
> +
> +	if (val < 0)
> +		val = -1;
> +
> +	if (val != cs->relax_domain_level) {
> +		cs->relax_domain_level = val;
> +		rebuild_sched_domains();
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * update_flag - read a 0 or a 1 in a file and update associated flag
>   * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
> @@ -1202,6 +1242,7 @@ typedef enum {
>  	FILE_CPU_EXCLUSIVE,
>  	FILE_MEM_EXCLUSIVE,
>  	FILE_SCHED_LOAD_BALANCE,
> +	FILE_SCHED_RELAX_DOMAIN_LEVEL,
>  	FILE_MEMORY_PRESSURE_ENABLED,
>  	FILE_MEMORY_PRESSURE,
>  	FILE_SPREAD_PAGE,
> @@ -1256,6 +1297,9 @@ static ssize_t cpuset_common_file_write(
>  	case FILE_SCHED_LOAD_BALANCE:
>  		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, buffer);
>  		break;
> +	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
> +		retval = update_relax_domain_level(cs, buffer);
> +		break;
>  	case FILE_MEMORY_MIGRATE:
>  		retval = update_flag(CS_MEMORY_MIGRATE, cs, buffer);
>  		break;
> @@ -1354,6 +1398,9 @@ static ssize_t cpuset_common_file_read(s
>  	case FILE_SCHED_LOAD_BALANCE:
>  		*s++ = is_sched_load_balance(cs) ? '1' : '0';
>  		break;
> +	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
> +		s += sprintf(s, "%d", cs->relax_domain_level);
> +		break;
>  	case FILE_MEMORY_MIGRATE:
>  		*s++ = is_memory_migrate(cs) ? '1' : '0';
>  		break;
> @@ -1424,6 +1471,13 @@ static struct cftype cft_sched_load_bala
>  	.private = FILE_SCHED_LOAD_BALANCE,
>  };
> 
> +static struct cftype cft_sched_relax_domain_level = {
> +	.name = "sched_relax_domain_level",
> +	.read = cpuset_common_file_read,
> +	.write = cpuset_common_file_write,
> +	.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
> +};
> +
>  static struct cftype cft_memory_migrate = {
>  	.name = "memory_migrate",
>  	.read = cpuset_common_file_read,
> @@ -1475,6 +1529,9 @@ static int cpuset_populate(struct cgroup
>  		return err;
>  	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
>  		return err;
> +	if ((err = cgroup_add_file(cont, ss,
> +					&cft_sched_relax_domain_level)) < 0)
> +		return err;
>  	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
>  		return err;
>  	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
> @@ -1559,6 +1616,7 @@ static struct cgroup_subsys_state *cpuse
>  	cs->mems_allowed = NODE_MASK_NONE;
>  	cs->mems_generation = cpuset_mems_generation++;
>  	fmeter_init(&cs->fmeter);
> +	cs->relax_domain_level = -1;
> 
>  	cs->parent = parent;
>  	number_of_cpusets++;
> @@ -1631,6 +1689,7 @@ int __init cpuset_init(void)
>  	fmeter_init(&top_cpuset.fmeter);
>  	top_cpuset.mems_generation = cpuset_mems_generation++;
>  	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
> +	top_cpuset.relax_domain_level = -1;
> 
>  	err = register_filesystem(&cpuset_fs_type);
>  	if (err < 0)
> Index: GIT-torvalds/include/asm-ia64/topology.h
> ===================================================================
> --- GIT-torvalds.orig/include/asm-ia64/topology.h
> +++ GIT-torvalds/include/asm-ia64/topology.h
> @@ -93,7 +93,7 @@ void build_cpu_to_node_map(void);
>  	.cache_nice_tries	= 2,			\
>  	.busy_idx		= 3,			\
>  	.idle_idx		= 2,			\
> -	.newidle_idx		= 0, /* unused */	\
> +	.newidle_idx		= 2,			\
>  	.wake_idx		= 1,			\
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
> Index: GIT-torvalds/include/asm-sh/topology.h
> ===================================================================
> --- GIT-torvalds.orig/include/asm-sh/topology.h
> +++ GIT-torvalds/include/asm-sh/topology.h
> @@ -16,7 +16,7 @@
>  	.cache_nice_tries	= 2,			\
>  	.busy_idx		= 3,			\
>  	.idle_idx		= 2,			\
> -	.newidle_idx		= 0,			\
> +	.newidle_idx		= 2,			\
>  	.wake_idx		= 1,			\
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
> Index: GIT-torvalds/include/asm-x86/topology.h
> ===================================================================
> --- GIT-torvalds.orig/include/asm-x86/topology.h
> +++ GIT-torvalds/include/asm-x86/topology.h
> @@ -129,7 +129,7 @@ extern unsigned long node_remap_size[];
> 
>  # define SD_CACHE_NICE_TRIES	2
>  # define SD_IDLE_IDX		2
> -# define SD_NEWIDLE_IDX		0
> +# define SD_NEWIDLE_IDX		2
>  # define SD_FORKEXEC_IDX	1
> 
>  #endif
> 

