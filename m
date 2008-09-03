Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYICNfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYICNfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYICNe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:34:59 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59639 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYICNe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:34:57 -0400
Date: Wed, 3 Sep 2008 15:34:46 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, dwalker@mvista.com
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
 lockless
Message-ID: <20080903153446.44f2cb64@bull.net>
In-Reply-To: <1219209726.21386.23.camel@pasglop>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	<1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	<1219209726.21386.23.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 15:22:06 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-08-06 at 15:30 +0200, Sebastien Dugue wrote:
> > The radix trees used by interrupt controllers for their irq reverse mapping
> > (currently only the XICS found on pSeries) have a complex locking scheme
> > dating back to before the advent of the lockless radix tree.
> > 
> >   Take advantage of this and of the fact that the items of the tree are
> > pointers to a static array (irq_map) elements which can never go under us
> > to simplify the locking.
> > 
> >   Concurrency between readers and writers is handled by the intrinsic
> > properties of the lockless radix tree. Concurrency between writers is handled
> > with a spinlock added to the irq_host structure.
> 
> No need for a spinlock in the irq_host. Make it one global lock, it's
> not like scalability of irq_create_mapping() was a big deal and there's
> usually only one of those type of hosts anyway.

  Right, done.

  Thanks,

  Sebastien.

> 
> > 
> > Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >  arch/powerpc/include/asm/irq.h |    1 +
> >  arch/powerpc/kernel/irq.c      |   74 ++++++----------------------------------
> >  2 files changed, 12 insertions(+), 63 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
> > index 0a51376..72fd036 100644
> > --- a/arch/powerpc/include/asm/irq.h
> > +++ b/arch/powerpc/include/asm/irq.h
> > @@ -119,6 +119,7 @@ struct irq_host {
> >  		} linear;
> >  		struct radix_tree_root tree;
> >  	} revmap_data;
> > +	spinlock_t		tree_lock;
> >  	struct irq_host_ops	*ops;
> >  	void			*host_data;
> >  	irq_hw_number_t		inval_irq;
> > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > index dc8663a..7a19103 100644
> > --- a/arch/powerpc/kernel/irq.c
> > +++ b/arch/powerpc/kernel/irq.c
> > @@ -439,8 +439,6 @@ void do_softirq(void)
> >  
> >  static LIST_HEAD(irq_hosts);
> >  static DEFINE_SPINLOCK(irq_big_lock);
> > -static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
> > -static unsigned int irq_radix_writer;
> >  static atomic_t revmap_trees_allocated = ATOMIC_INIT(0);
> >  struct irq_map_entry irq_map[NR_IRQS];
> >  static unsigned int irq_virq_count = NR_IRQS;
> > @@ -584,57 +582,6 @@ void irq_set_virq_count(unsigned int count)
> >  		irq_virq_count = count;
> >  }
> >  
> > -/* radix tree not lockless safe ! we use a brlock-type mecanism
> > - * for now, until we can use a lockless radix tree
> > - */
> > -static void irq_radix_wrlock(unsigned long *flags)
> > -{
> > -	unsigned int cpu, ok;
> > -
> > -	spin_lock_irqsave(&irq_big_lock, *flags);
> > -	irq_radix_writer = 1;
> > -	smp_mb();
> > -	do {
> > -		barrier();
> > -		ok = 1;
> > -		for_each_possible_cpu(cpu) {
> > -			if (per_cpu(irq_radix_reader, cpu)) {
> > -				ok = 0;
> > -				break;
> > -			}
> > -		}
> > -		if (!ok)
> > -			cpu_relax();
> > -	} while(!ok);
> > -}
> > -
> > -static void irq_radix_wrunlock(unsigned long flags)
> > -{
> > -	smp_wmb();
> > -	irq_radix_writer = 0;
> > -	spin_unlock_irqrestore(&irq_big_lock, flags);
> > -}
> > -
> > -static void irq_radix_rdlock(unsigned long *flags)
> > -{
> > -	local_irq_save(*flags);
> > -	__get_cpu_var(irq_radix_reader) = 1;
> > -	smp_mb();
> > -	if (likely(irq_radix_writer == 0))
> > -		return;
> > -	__get_cpu_var(irq_radix_reader) = 0;
> > -	smp_wmb();
> > -	spin_lock(&irq_big_lock);
> > -	__get_cpu_var(irq_radix_reader) = 1;
> > -	spin_unlock(&irq_big_lock);
> > -}
> > -
> > -static void irq_radix_rdunlock(unsigned long flags)
> > -{
> > -	__get_cpu_var(irq_radix_reader) = 0;
> > -	local_irq_restore(flags);
> > -}
> > -
> >  static int irq_setup_virq(struct irq_host *host, unsigned int virq,
> >  			    irq_hw_number_t hwirq)
> >  {
> > @@ -789,7 +736,6 @@ void irq_dispose_mapping(unsigned int virq)
> >  {
> >  	struct irq_host *host;
> >  	irq_hw_number_t hwirq;
> > -	unsigned long flags;
> >  
> >  	if (virq == NO_IRQ)
> >  		return;
> > @@ -825,9 +771,9 @@ void irq_dispose_mapping(unsigned int virq)
> >  		/* Check if radix tree allocated yet */
> >  		if (atomic_read(&revmap_trees_allocated) == 0)
> >  			break;
> > -		irq_radix_wrlock(&flags);
> > +		spin_lock(&host->tree_lock);
> >  		radix_tree_delete(&host->revmap_data.tree, hwirq);
> > -		irq_radix_wrunlock(flags);
> > +		spin_unlock(&host->tree_lock);
> >  		break;
> >  	}
> >  
> > @@ -881,7 +827,6 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> >  {
> >  	struct irq_map_entry *ptr;
> >  	unsigned int virq = NO_IRQ;
> > -	unsigned long flags;
> >  
> >  	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
> >  
> > @@ -893,9 +838,11 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> >  		return irq_find_mapping(host, hwirq);
> >  
> >  	/* Now try to resolve */
> > -	irq_radix_rdlock(&flags);
> > +	/*
> > +	 * No rcu_read_lock(ing) needed, the ptr returned can't go under us
> > +	 * as it's referencing an entry in the static irq_map table.
> > +	 */
> >  	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
> > -	irq_radix_rdunlock(flags);
> >  
> >  	/* Found it, return */
> >  	if (ptr)
> > @@ -907,7 +854,6 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> >  void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> >  			     irq_hw_number_t hwirq)
> >  {
> > -	unsigned long flags;
> >  
> >  	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
> >  
> > @@ -920,10 +866,10 @@ void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> >  		return;
> >  
> >  	if (virq != NO_IRQ) {
> > -		irq_radix_wrlock(&flags);
> > +		spin_lock(&host->tree_lock);
> >  		radix_tree_insert(&host->revmap_data.tree, hwirq,
> >  				  &irq_map[virq]);
> > -		irq_radix_wrunlock(flags);
> > +		spin_unlock(&host->tree_lock);
> >  	}
> >  }
> >  
> > @@ -1041,8 +987,10 @@ static int irq_late_init(void)
> >  	 * revmap_trees_allocated.
> >  	 */
> >  	list_for_each_entry(h, &irq_hosts, link) {
> > -		if (h->revmap_type == IRQ_HOST_MAP_TREE)
> > +		if (h->revmap_type == IRQ_HOST_MAP_TREE) {
> >  			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
> > +			spin_lock_init(&h->tree_lock);
> > +		}
> >  	}
> >  
> >  	/*
> 
> 
