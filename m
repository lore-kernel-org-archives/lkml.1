Return-Path: <linux-kernel-owner+w=401wt.eu-S1763212AbZAGWgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763212AbZAGWgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZAGWdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:33:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33499 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932422AbZAGWc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:32:58 -0500
Message-ID: <49652D92.8020105@sgi.com>
Date: Wed, 07 Jan 2009 14:32:50 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/5] cpumask: update irq_desc to use cpumask_var_t
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>	 <20090107195832.465094000@polaris-admin.engr.sgi.com> <86802c440901071227n2d110757ye1bd12e689502ebc@mail.gmail.com>
In-Reply-To: <86802c440901071227n2d110757ye1bd12e689502ebc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jan 7, 2009 at 11:58 AM, Mike Travis <travis@sgi.com> wrote:
> | --- linux-2.6-for-ingo.orig/kernel/irq/numa_migrate.c
> | +++ linux-2.6-for-ingo/kernel/irq/numa_migrate.c
> | @@ -46,6 +46,7 @@ static void init_copy_one_irq_desc(int i
> | 	desc->cpu = cpu;
> | 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
> | 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
> |+	init_copy_desc_masks(old_desc, desc);
> | 	arch_init_copy_chip_data(old_desc, desc, cpu);
> | }
> |
> |@@ -76,11 +77,20 @@ static struct irq_desc *__real_move_irq_
> | 	node = cpu_to_node(cpu);
> | 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> | 	if (!desc) {
> |-		printk(KERN_ERR "irq %d: can not get new irq_desc for migration.\n", irq);
> |+		printk(KERN_ERR "irq %d: can not get new irq_desc "
> |+				"for migration.\n", irq);
> | 		/* still use old one */
> | 		desc = old_desc;
> | 		goto out_unlock;
> | 	}
> |+	if (!init_alloc_desc_masks(desc, node, false)) {
> |+		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
> |+				"for migration.\n", irq);
> |+		/* still use old one */
> |+		kfree(desc);
> |+		desc = old_desc;
> |+		goto out_unlock;
> |+	}
> | 	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
> 
> desc new mask_var (allocated) aka the pointer is overwritten here...
> you may need to calling move init_alloc_desc_masks() into
> init_copy_one_irq_desc()

Wouldn't this in init_copy_one_irq_desc() take care  of that?

@@ -46,6 +46,7 @@ static void init_copy_one_irq_desc(int i
        desc->cpu = cpu;
        lockdep_set_class(&desc->lock, &irq_desc_lock_class);
        init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+       init_copy_desc_masks(old_desc, desc);
        arch_init_copy_chip_data(old_desc, desc, cpu);

where:

static inline void init_copy_desc_masks(struct irq_desc *old_desc,
                                        struct irq_desc *new_desc)
{
#ifdef CONFIG_CPUMASKS_OFFSTACK
        cpumask_copy(new_desc->affinity, old_desc->affinity);

#ifdef CONFIG_GENERIC_PENDING_IRQ
        cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
#endif
#endif
}

In other words if the masks are not a cpumask[1] but instead a
*cpumask pointer, then the old masks are copied to the new desc/

Or am I missing your point?

Thanks!
Mike

> 
> | 	irq_desc_ptrs[irq] = desc;
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

