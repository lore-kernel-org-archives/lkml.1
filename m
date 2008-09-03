Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYICNee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYICNee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYICNe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:34:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59588 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYICNeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:34:24 -0400
Date: Wed, 3 Sep 2008 15:34:12 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, dwalker@mvista.com
Subject: Re: [PATCH 1/2] powerpc - Separate the irq radix tree insertion and
 lookup
Message-ID: <20080903153412.6f5f0f5a@bull.net>
In-Reply-To: <1219209684.21386.21.camel@pasglop>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	<1218029429-21114-2-git-send-email-sebastien.dugue@bull.net>
	<1219209684.21386.21.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Benjamin,

  sorry for the (long) delay, just came back from vacation.

On Wed, 20 Aug 2008 15:21:24 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-08-06 at 15:30 +0200, Sebastien Dugue wrote:
> > irq_radix_revmap() currently serves 2 purposes, irq mapping lookup
> > and insertion which happen in interrupt and process context respectively.
> 
> Sounds good, a few nits and it should be good to go.

  Cool 8)

> 
> >   Separate the function into its 2 components, one for lookup only and one
> > for insertion only.
> > 
> >   Fix the only user of the revmap tree (XICS) to use the new functions.
> > 
> >   Also, move the insertion into the radix tree of those irqs that were
> > requested before it was initialized at said tree initialization.
> > 
> >   Mutual exclusion between the tree initialization and readers/writers is
> > handled via an atomic variable (revmap_trees_allocated) set when the tree
> > has been initialized and checked before any reader or writer access just
> > like we used to check for tree.gfp_mask != 0 before.
> 
> The atomic doesn't need to be such. Could just be a global. In fact, I
> don't like your synchronization too much between the init and _insert. 

  Yep, it mainly relies on some (hidden) assumptions about stuff ordering
during kernel init.

> 
> What I'd do is, turn your atomic into a simple int
> 
>  - do smp_wmb() and set it to 1 after the tree is initialized, then
>    smb_wmb() again and set it to 2 after the tree has been filled
>    by the init code 
>  - in the revmap_lookup path just test that it's >1, no need for a
> barrier. At worst you'll use the slow path instead of the fast path some
> time during boot, no big deal.
>  - in the insert path, do an smp_rb() and if it's >0 do the insert with
> the lock
>  - in the init pre-insert path, use the lock inside the loop for each
> insertion.

  Just tried that, it's running equally well

> 
> that means you may get concurrent attempt to insert but the lock will
> help there and turn them into 2 insertions of the same translation. Is
> that a big deal ? If it is, make it be a lookup+insert.

  No problem with that, radix_tree_insert() will return EEXIST.

  Thanks,

  Sebastien.

> 
> Ben.
> 
> > 
> > Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >  arch/powerpc/include/asm/irq.h        |   18 ++++++-
> >  arch/powerpc/kernel/irq.c             |   76 ++++++++++++++++++++++++---------
> >  arch/powerpc/platforms/pseries/xics.c |   11 ++---
> >  3 files changed, 74 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
> > index a372f76..0a51376 100644
> > --- a/arch/powerpc/include/asm/irq.h
> > +++ b/arch/powerpc/include/asm/irq.h
> > @@ -236,15 +236,27 @@ extern unsigned int irq_find_mapping(struct irq_host *host,
> >  extern unsigned int irq_create_direct_mapping(struct irq_host *host);
> >  
> >  /**
> > - * irq_radix_revmap - Find a linux virq from a hw irq number.
> > + * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
> > + * @host: host owning this hardware interrupt
> > + * @virq: linux irq number
> > + * @hwirq: hardware irq number in that host space
> > + *
> > + * This is for use by irq controllers that use a radix tree reverse
> > + * mapping for fast lookup.
> > + */
> > +extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> > +				    irq_hw_number_t hwirq);
> > +
> > +/**
> > + * irq_radix_revmap_lookup - Find a linux virq from a hw irq number.
> >   * @host: host owning this hardware interrupt
> >   * @hwirq: hardware irq number in that host space
> >   *
> >   * This is a fast path, for use by irq controller code that uses radix tree
> >   * revmaps
> >   */
> > -extern unsigned int irq_radix_revmap(struct irq_host *host,
> > -				     irq_hw_number_t hwirq);
> > +extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> > +					    irq_hw_number_t hwirq);
> >  
> >  /**
> >   * irq_linear_revmap - Find a linux virq from a hw irq number.
> > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > index d972dec..dc8663a 100644
> > --- a/arch/powerpc/kernel/irq.c
> > +++ b/arch/powerpc/kernel/irq.c
> > @@ -441,6 +441,7 @@ static LIST_HEAD(irq_hosts);
> >  static DEFINE_SPINLOCK(irq_big_lock);
> >  static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
> >  static unsigned int irq_radix_writer;
> > +static atomic_t revmap_trees_allocated = ATOMIC_INIT(0);
> >  struct irq_map_entry irq_map[NR_IRQS];
> >  static unsigned int irq_virq_count = NR_IRQS;
> >  static struct irq_host *irq_default_host;
> > @@ -822,7 +823,7 @@ void irq_dispose_mapping(unsigned int virq)
> >  		break;
> >  	case IRQ_HOST_MAP_TREE:
> >  		/* Check if radix tree allocated yet */
> > -		if (host->revmap_data.tree.gfp_mask == 0)
> > +		if (atomic_read(&revmap_trees_allocated) == 0)
> >  			break;
> >  		irq_radix_wrlock(&flags);
> >  		radix_tree_delete(&host->revmap_data.tree, hwirq);
> > @@ -875,43 +876,55 @@ unsigned int irq_find_mapping(struct irq_host *host,
> >  EXPORT_SYMBOL_GPL(irq_find_mapping);
> >  
> > 
> > -unsigned int irq_radix_revmap(struct irq_host *host,
> > -			      irq_hw_number_t hwirq)
> > +unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> > +				     irq_hw_number_t hwirq)
> >  {
> > -	struct radix_tree_root *tree;
> >  	struct irq_map_entry *ptr;
> > -	unsigned int virq;
> > +	unsigned int virq = NO_IRQ;
> >  	unsigned long flags;
> >  
> >  	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
> >  
> > -	/* Check if the radix tree exist yet. We test the value of
> > -	 * the gfp_mask for that. Sneaky but saves another int in the
> > -	 * structure. If not, we fallback to slow mode
> > +	/*
> > +	 * Check if the radix tree exist yet.
> > +	 * If not, we fallback to slow mode
> >  	 */
> > -	tree = &host->revmap_data.tree;
> > -	if (tree->gfp_mask == 0)
> > +	if (atomic_read(&revmap_trees_allocated) == 0)
> >  		return irq_find_mapping(host, hwirq);
> >  
> >  	/* Now try to resolve */
> >  	irq_radix_rdlock(&flags);
> > -	ptr = radix_tree_lookup(tree, hwirq);
> > +	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
> >  	irq_radix_rdunlock(flags);
> >  
> >  	/* Found it, return */
> > -	if (ptr) {
> > +	if (ptr)
> >  		virq = ptr - irq_map;
> > -		return virq;
> > -	}
> >  
> > -	/* If not there, try to insert it */
> > -	virq = irq_find_mapping(host, hwirq);
> > +	return virq;
> > +}
> > +
> > +void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> > +			     irq_hw_number_t hwirq)
> > +{
> > +	unsigned long flags;
> > +
> > +	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
> > +
> > +	/*
> > +	 * Check if the radix tree exist yet.
> > +	 * If not, then the irq will be inserted into the tree when it gets
> > +	 * initialized.
> > +	 */
> > +	if (atomic_read(&revmap_trees_allocated) == 0)
> > +		return;
> > +
> >  	if (virq != NO_IRQ) {
> >  		irq_radix_wrlock(&flags);
> > -		radix_tree_insert(tree, hwirq, &irq_map[virq]);
> > +		radix_tree_insert(&host->revmap_data.tree, hwirq,
> > +				  &irq_map[virq]);
> >  		irq_radix_wrunlock(flags);
> >  	}
> > -	return virq;
> >  }
> >  
> >  unsigned int irq_linear_revmap(struct irq_host *host,
> > @@ -1020,14 +1033,35 @@ void irq_early_init(void)
> >  static int irq_late_init(void)
> >  {
> >  	struct irq_host *h;
> > -	unsigned long flags;
> > +	unsigned int i;
> >  
> > -	irq_radix_wrlock(&flags);
> > +	/*
> > +	 * No mutual exclusion with respect to accessors of the tree is needed
> > +	 * here as the synchronization is done via the atomic variable
> > +	 * revmap_trees_allocated.
> > +	 */
> >  	list_for_each_entry(h, &irq_hosts, link) {
> >  		if (h->revmap_type == IRQ_HOST_MAP_TREE)
> >  			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
> >  	}
> > -	irq_radix_wrunlock(flags);
> > +
> > +	/*
> > +	 * Insert the reverse mapping for those interrupts already present
> > +	 * in irq_map[].
> > +	 */
> > +	for (i = 0; i < irq_virq_count; i++) {
> > +		if (irq_map[i].host &&
> > +		    (irq_map[i].host->revmap_type == IRQ_HOST_MAP_TREE))
> > +			radix_tree_insert(&irq_map[i].host->revmap_data.tree,
> > +					  irq_map[i].hwirq, &irq_map[i]);
> > +	}
> > +
> > +	/*
> > +	 * Make sure the radix trees inits are visible before setting
> > +	 * the flag
> > +	 */
> > +	smp_mb();
> > +	atomic_set(&revmap_trees_allocated, 1);
> >  
> >  	return 0;
> >  }
> > diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
> > index 0fc830f..6b1a005 100644
> > --- a/arch/powerpc/platforms/pseries/xics.c
> > +++ b/arch/powerpc/platforms/pseries/xics.c
> > @@ -310,12 +310,6 @@ static void xics_mask_irq(unsigned int virq)
> >  
> >  static unsigned int xics_startup(unsigned int virq)
> >  {
> > -	unsigned int irq;
> > -
> > -	/* force a reverse mapping of the interrupt so it gets in the cache */
> > -	irq = (unsigned int)irq_map[virq].hwirq;
> > -	irq_radix_revmap(xics_host, irq);
> > -
> >  	/* unmask it */
> >  	xics_unmask_irq(virq);
> >  	return 0;
> > @@ -346,7 +340,7 @@ static inline unsigned int xics_remap_irq(unsigned int vec)
> >  
> >  	if (vec == XICS_IRQ_SPURIOUS)
> >  		return NO_IRQ;
> > -	irq = irq_radix_revmap(xics_host, vec);
> > +	irq = irq_radix_revmap_lookup(xics_host, vec);
> >  	if (likely(irq != NO_IRQ))
> >  		return irq;
> >  
> > @@ -530,6 +524,9 @@ static int xics_host_map(struct irq_host *h, unsigned int virq,
> >  {
> >  	pr_debug("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
> >  
> > +	/* Insert the interrupt mapping into the radix tree for fast lookup */
> > +	irq_radix_revmap_insert(xics_host, virq, hw);
> > +
> >  	get_irq_desc(virq)->status |= IRQ_LEVEL;
> >  	set_irq_chip_and_handler(virq, xics_irq_chip, handle_fasteoi_irq);
> >  	return 0;
> 
> 
