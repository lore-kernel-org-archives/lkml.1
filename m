Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZHRNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZHRNgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZHRNgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:36:39 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:33979 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbZHRNgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:36:38 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eMzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOKR3A-02-0H5-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 15:35:34 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] sched: Separate out allocation/free/goto-hell
	from __build_sched_domains
Message-ID: <20090818133534.GP29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com> <20090818105300.GC29515@alberich.amd.com> <1250600230.7583.278.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1250600230.7583.278.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 13:35:35.0048 (UTC) FILETIME=[C3CFC080:01CA2008]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 02:57:10PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-08-18 at 12:53 +0200, Andreas Herrmann wrote:
> > @@ -8213,6 +8213,23 @@ struct s_data {
> >         struct root_domain      *rd;
> >  };
> >  
> > +enum s_alloc {
> > +       sa_sched_groups = 0,
> > +       sa_rootdomain,
> > +       sa_tmpmask,
> > +       sa_send_covered,
> > +       sa_this_core_map,
> > +       sa_this_sibling_map,
> > +       sa_nodemask,
> > +       sa_sched_group_nodes,
> > +#ifdef CONFIG_NUMA
> > +       sa_notcovered,
> > +       sa_covered,
> > +       sa_domainspan,
> > +#endif
> > +       sa_none,
> > +};
> > +
> >  /*
> >   * SMT sched-domains:
> >   */
> > @@ -8500,6 +8517,77 @@ static void set_domain_attribute(struct sched_domain *sd,
> >         }
> >  }
> >  
> > +static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
> > +                                const struct cpumask *cpu_map)
> > +{
> > +       switch (what) {
> > +       case sa_sched_groups:
> > +               free_sched_groups(cpu_map, d->tmpmask); /* fall through */
> > +               d->sched_group_nodes = NULL;
> > +       case sa_rootdomain:
> > +               free_rootdomain(d->rd); /* fall through */
> > +       case sa_tmpmask:
> > +               free_cpumask_var(d->tmpmask); /* fall through */
> > +       case sa_send_covered:
> > +               free_cpumask_var(d->send_covered); /* fall through */
> > +       case sa_this_core_map:
> > +               free_cpumask_var(d->this_core_map); /* fall through */
> > +       case sa_this_sibling_map:
> > +               free_cpumask_var(d->this_sibling_map); /* fall through */
> > +       case sa_nodemask:
> > +               free_cpumask_var(d->nodemask); /* fall through */
> > +       case sa_sched_group_nodes:
> > +#ifdef CONFIG_NUMA
> > +               kfree(d->sched_group_nodes); /* fall through */
> > +       case sa_notcovered:
> > +               free_cpumask_var(d->notcovered); /* fall through */
> > +       case sa_covered:
> > +               free_cpumask_var(d->covered); /* fall through */
> > +       case sa_domainspan:
> > +               free_cpumask_var(d->domainspan); /* fall through */
> > +#endif
> > +       case sa_none:
> > +               break;
> > +       }
> > +}
> > +
> > +static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
> > +                                                  const struct cpumask *cpu_map)
> > +{
> > +#ifdef CONFIG_NUMA
> > +       if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
> > +               return sa_none;
> > +       if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
> > +               return sa_domainspan;
> > +       if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
> > +               return sa_covered;
> > +       /* Allocate the per-node list of sched groups */
> > +       d->sched_group_nodes = kcalloc(nr_node_ids,
> > +                                     sizeof(struct sched_group *), GFP_KERNEL);
> > +       if (!d->sched_group_nodes) {
> > +               printk(KERN_WARNING "Can not alloc sched group node list\n");
> > +               return sa_notcovered;
> > +       }
> > +       sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
> > +#endif
> > +       if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
> > +               return sa_sched_group_nodes;
> > +       if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
> > +               return sa_nodemask;
> > +       if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
> > +               return sa_this_sibling_map;
> > +       if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
> > +               return sa_this_core_map;
> > +       if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
> > +               return sa_send_covered;
> > +       d->rd = alloc_rootdomain();
> > +       if (!d->rd) {
> > +               printk(KERN_WARNING "Cannot alloc root domain\n");
> > +               return sa_tmpmask;
> > +       }
> > +       return sa_rootdomain;
> > +}
> 
> Code like this makes me wonder if the decomposition you chose is the
> right one.

It was the fastest decomposition to get much stuff out of the way when
working on this huge function -- plus without introducing (too many)
regressions.

> I'd much rather see something that keeps the various domain levels fully
> isolated. That is, the numa code should not need to know anything about
> the multi-core code etc.

The question is how fesible this is.

There are various dependencies in the current code, e.g. the
degeneration step is done at very last.
Not sure at the moment whether all  steps can be intermediately
performed. (i.e. initial creation, building groups, set power)
But probably this could work.

> The above we still have everything mixed in one.

Yep.

> Maybe something along the lines of (skipping lots of fun detail):
> 
> struct domain_constructor {
> 	struct sched_domain *func(const struct cpumask *cpu_map,
> 				  struct sched_domain_attr *attr);
> };
> 
> struct domain_constructor domain_constructors[] = {
> 	{ &construct_numa_domain },
> 	{ &construct_mc_domain },
> 	{ &construct_cpu_domain },
> 	{ &construct_smt_domain },
> };
> 
> static int construct_sched_domains(const struct cpumask *cpu_map,
> 				   struct sched_domain_attr *attr)
> {
> 	int i;
> 	struct sched_domain *top = NULL, *parent = NULL, *sd;
> 
> 	for (i = 0; i < ARRAY_SIZE(domain_constructors); i++) {
> 		sd = domain_constructors[i].func(cpu_map, attr);
> 		if (!sd)
> 			continue;
> 		if (IS_PTR(sd)) {
> 			ret = PTR_ERR(sd);
> 			goto fail;
> 		}
> 		if (!top)
> 			top = sd;
> 
> 		if (degenerate_domain(parent, sd)) {
> 			fold_domain(parent, sd);
> 			sd->destroy();
> 			continue;
> 		}
> 
> 		sd->parent = parent;
> 		parent = sd;
> 	}
> 
> 	ret = attach_domain(sd);
> 	if (ret)
> 		goto fail;
> 
> out:
> 	return ret;
> 	
> fail:
> 	for (sd = parent; sd; sd = parent) {
> 		parent = sd->parent;
> 		sd->destroy();
> 	}
> 
> 	goto out;
> }

Yes, it would be interesting to see this implemented ;-)
At least there's room for improvement in the domain creation code.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


