Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZJ0DqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZJ0DqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZJ0DqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:46:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41338 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZJ0DqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:46:08 -0400
Date: Mon, 26 Oct 2009 20:36:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
Message-ID: <20091027033601.GA6645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026162157.23704.12420.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
> The current code suffers from the following race condition:
> 
> thread-1                                    thread-2
> -----------------------------------------------------------
> 
> kvm_set_irq() {
>    rcu_read_lock()
>    irq_rt = rcu_dereference(table);
>    rcu_read_unlock();
> 
>                                        kvm_set_irq_routing() {
>                                           mutex_lock();
>                                           irq_rt = table;
>                                           rcu_assign_pointer();
>                                           mutex_unlock();
>                                           synchronize_rcu();
> 
>                                           kfree(irq_rt);
> 
>    irq_rt->entry->set(); /* bad */
> 
> -------------------------------------------------------------
> 
> Because the pointer is accessed outside of the read-side critical
> section.  There are two basic patterns we can use to fix this bug:
> 
> 1) Switch to sleeping-rcu and encompass the ->set() access within the
>    read-side critical section,
> 
>    OR
> 
> 2) Add reference counting to the irq_rt structure, and simply acquire
>    the reference from within the RSCS.
> 
> This patch implements solution (1).

Looks like a good transformation!  A few questions interspersed below.

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  include/linux/kvm_host.h |    6 +++++-
>  virt/kvm/irq_comm.c      |   50 +++++++++++++++++++++++++++-------------------
>  virt/kvm/kvm_main.c      |    1 +
>  3 files changed, 35 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bd5a616..1fe135d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -185,7 +185,10 @@ struct kvm {
> 
>  	struct mutex irq_lock;
>  #ifdef CONFIG_HAVE_KVM_IRQCHIP
> -	struct kvm_irq_routing_table *irq_routing;
> +	struct {
> +		struct srcu_struct            srcu;

Each structure has its own SRCU domain.  This is OK, but just asking
if that is the intent.  It does look like the SRCU primitives are
passed a pointer to the correct structure, and that the return value
from srcu_read_lock() gets passed into the matching srcu_read_unlock()
like it needs to be, so that is good.

> +		struct kvm_irq_routing_table *table;
> +	} irq_routing;
>  	struct hlist_head mask_notifier_list;
>  	struct hlist_head irq_ack_notifier_list;
>  #endif

[ . . . ]

> @@ -155,21 +156,19 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  	 * IOAPIC.  So set the bit in both. The guest will ignore
>  	 * writes to the unused one.
>  	 */
> -	rcu_read_lock();
> -	irq_rt = rcu_dereference(kvm->irq_routing);
> +	idx = srcu_read_lock(&kvm->irq_routing.srcu);
> +	irq_rt = rcu_dereference(kvm->irq_routing.table);
>  	if (irq < irq_rt->nr_rt_entries)
> -		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
> -			irq_set[i++] = *e;
> -	rcu_read_unlock();
> +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {

What prevents the above list from changing while we are traversing it?
(Yes, presumably whatever was preventing it from changing before this
patch, but what?)

Mostly kvm->lock is held, but not always.  And if kvm->lock were held
all the time, there would be no point in using SRCU.  ;-)

> +			int r;
> 
> -	while(i--) {
> -		int r;
> -		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level);
> -		if (r < 0)
> -			continue;
> +			r = e->set(e, kvm, irq_source_id, level);
> +			if (r < 0)
> +				continue;
> 
> -		ret = r + ((ret < 0) ? 0 : ret);
> -	}
> +			ret = r + ((ret < 0) ? 0 : ret);
> +		}
> +	srcu_read_unlock(&kvm->irq_routing.srcu, idx);
> 
>  	return ret;
>  }
> @@ -179,17 +178,18 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
>  	struct kvm_irq_ack_notifier *kian;
>  	struct hlist_node *n;
>  	int gsi;
> +	int idx;
> 
>  	trace_kvm_ack_irq(irqchip, pin);
> 
> -	rcu_read_lock();
> -	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
> +	idx = srcu_read_lock(&kvm->irq_routing.srcu);
> +	gsi = rcu_dereference(kvm->irq_routing.table)->chip[irqchip][pin];
>  	if (gsi != -1)
>  		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
>  					 link)

And same question here -- what keeps the above list from changing while
we are traversing it?

							Thanx, Paul
