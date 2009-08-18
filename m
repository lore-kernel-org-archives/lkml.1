Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbZHRM5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbZHRM5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbZHRM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:57:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZHRM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:57:13 -0400
Subject: Re: [PATCH 02/12] sched: Separate out allocation/free/goto-hell
 from __build_sched_domains
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090818105300.GC29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
	 <20090818105300.GC29515@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Aug 2009 14:57:10 +0200
Message-Id: <1250600230.7583.278.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 12:53 +0200, Andreas Herrmann wrote:
> @@ -8213,6 +8213,23 @@ struct s_data {
>         struct root_domain      *rd;
>  };
>  
> +enum s_alloc {
> +       sa_sched_groups = 0,
> +       sa_rootdomain,
> +       sa_tmpmask,
> +       sa_send_covered,
> +       sa_this_core_map,
> +       sa_this_sibling_map,
> +       sa_nodemask,
> +       sa_sched_group_nodes,
> +#ifdef CONFIG_NUMA
> +       sa_notcovered,
> +       sa_covered,
> +       sa_domainspan,
> +#endif
> +       sa_none,
> +};
> +
>  /*
>   * SMT sched-domains:
>   */
> @@ -8500,6 +8517,77 @@ static void set_domain_attribute(struct sched_domain *sd,
>         }
>  }
>  
> +static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
> +                                const struct cpumask *cpu_map)
> +{
> +       switch (what) {
> +       case sa_sched_groups:
> +               free_sched_groups(cpu_map, d->tmpmask); /* fall through */
> +               d->sched_group_nodes = NULL;
> +       case sa_rootdomain:
> +               free_rootdomain(d->rd); /* fall through */
> +       case sa_tmpmask:
> +               free_cpumask_var(d->tmpmask); /* fall through */
> +       case sa_send_covered:
> +               free_cpumask_var(d->send_covered); /* fall through */
> +       case sa_this_core_map:
> +               free_cpumask_var(d->this_core_map); /* fall through */
> +       case sa_this_sibling_map:
> +               free_cpumask_var(d->this_sibling_map); /* fall through */
> +       case sa_nodemask:
> +               free_cpumask_var(d->nodemask); /* fall through */
> +       case sa_sched_group_nodes:
> +#ifdef CONFIG_NUMA
> +               kfree(d->sched_group_nodes); /* fall through */
> +       case sa_notcovered:
> +               free_cpumask_var(d->notcovered); /* fall through */
> +       case sa_covered:
> +               free_cpumask_var(d->covered); /* fall through */
> +       case sa_domainspan:
> +               free_cpumask_var(d->domainspan); /* fall through */
> +#endif
> +       case sa_none:
> +               break;
> +       }
> +}
> +
> +static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
> +                                                  const struct cpumask *cpu_map)
> +{
> +#ifdef CONFIG_NUMA
> +       if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
> +               return sa_none;
> +       if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
> +               return sa_domainspan;
> +       if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
> +               return sa_covered;
> +       /* Allocate the per-node list of sched groups */
> +       d->sched_group_nodes = kcalloc(nr_node_ids,
> +                                     sizeof(struct sched_group *), GFP_KERNEL);
> +       if (!d->sched_group_nodes) {
> +               printk(KERN_WARNING "Can not alloc sched group node list\n");
> +               return sa_notcovered;
> +       }
> +       sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
> +#endif
> +       if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
> +               return sa_sched_group_nodes;
> +       if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
> +               return sa_nodemask;
> +       if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
> +               return sa_this_sibling_map;
> +       if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
> +               return sa_this_core_map;
> +       if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
> +               return sa_send_covered;
> +       d->rd = alloc_rootdomain();
> +       if (!d->rd) {
> +               printk(KERN_WARNING "Cannot alloc root domain\n");
> +               return sa_tmpmask;
> +       }
> +       return sa_rootdomain;
> +}

Code like this makes me wonder if the decomposition you chose is the
right one.

I'd much rather see something that keeps the various domain levels fully
isolated. That is, the numa code should not need to know anything about
the multi-core code etc.

The above we still have everything mixed in one.

Maybe something along the lines of (skipping lots of fun detail):

struct domain_constructor {
	struct sched_domain *func(const struct cpumask *cpu_map,
				  struct sched_domain_attr *attr);
};

struct domain_constructor domain_constructors[] = {
	{ &construct_numa_domain },
	{ &construct_mc_domain },
	{ &construct_cpu_domain },
	{ &construct_smt_domain },
};

static int construct_sched_domains(const struct cpumask *cpu_map,
				   struct sched_domain_attr *attr)
{
	int i;
	struct sched_domain *top = NULL, *parent = NULL, *sd;

	for (i = 0; i < ARRAY_SIZE(domain_constructors); i++) {
		sd = domain_constructors[i].func(cpu_map, attr);
		if (!sd)
			continue;
		if (IS_PTR(sd)) {
			ret = PTR_ERR(sd);
			goto fail;
		}
		if (!top)
			top = sd;

		if (degenerate_domain(parent, sd)) {
			fold_domain(parent, sd);
			sd->destroy();
			continue;
		}

		sd->parent = parent;
		parent = sd;
	}

	ret = attach_domain(sd);
	if (ret)
		goto fail;

out:
	return ret;
	
fail:
	for (sd = parent; sd; sd = parent) {
		parent = sd->parent;
		sd->destroy();
	}

	goto out;
}


