Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZJ0Gpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZJ0Gpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZJ0Gpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258AbZJ0Gpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:45:44 -0400
Date: Tue, 27 Oct 2009 08:45:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
Message-ID: <20091027064529.GJ29477@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net>
 <20091026162157.23704.12420.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026162157.23704.12420.stgit@dev.haskins.net>
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
This is not what happens. irq_rt is never accessed outside read-side
critical section. Data is copied from irq_rt onto the stack and this
copy is accessed outside critical section.

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
> 
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
> +		struct kvm_irq_routing_table *table;
> +	} irq_routing;
>  	struct hlist_head mask_notifier_list;
>  	struct hlist_head irq_ack_notifier_list;
>  #endif
> @@ -541,6 +544,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  			const struct kvm_irq_routing_entry *entries,
>  			unsigned nr,
>  			unsigned flags);
> +void kvm_init_irq_routing(struct kvm *kvm);
>  void kvm_free_irq_routing(struct kvm *kvm);
>  
>  #else
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index 00c68d2..db2553f 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -144,10 +144,11 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>   */
>  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  {
> -	struct kvm_kernel_irq_routing_entry *e, irq_set[KVM_NR_IRQCHIPS];
> -	int ret = -1, i = 0;
> +	struct kvm_kernel_irq_routing_entry *e;
> +	int ret = -1;
>  	struct kvm_irq_routing_table *irq_rt;
>  	struct hlist_node *n;
> +	int idx;
>  
>  	trace_kvm_set_irq(irq, level, irq_source_id);
>  
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
>  			if (kian->gsi == gsi)
>  				kian->irq_acked(kian);
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_routing.srcu, idx);
>  }
>  
>  void kvm_register_irq_ack_notifier(struct kvm *kvm,
> @@ -287,11 +287,19 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
>  	rcu_read_unlock();
>  }
>  
> +void kvm_init_irq_routing(struct kvm *kvm)
> +{
> +	init_srcu_struct(&kvm->irq_routing.srcu);
> +}
> +
>  void kvm_free_irq_routing(struct kvm *kvm)
>  {
>  	/* Called only during vm destruction. Nobody can use the pointer
>  	   at this stage */
> -	kfree(kvm->irq_routing);
> +	synchronize_srcu(&kvm->irq_routing.srcu);
> +	cleanup_srcu_struct(&kvm->irq_routing.srcu);
> +
> +	kfree(kvm->irq_routing.table);
>  }
>  
>  static int setup_routing_entry(struct kvm_irq_routing_table *rt,
> @@ -396,10 +404,10 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  	}
>  
>  	mutex_lock(&kvm->irq_lock);
> -	old = kvm->irq_routing;
> -	rcu_assign_pointer(kvm->irq_routing, new);
> +	old = kvm->irq_routing.table;
> +	rcu_assign_pointer(kvm->irq_routing.table, new);
>  	mutex_unlock(&kvm->irq_lock);
> -	synchronize_rcu();
> +	synchronize_srcu(&kvm->irq_routing.srcu);
>  
>  	new = old;
>  	r = 0;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cac69c4..ba94159 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -388,6 +388,7 @@ static struct kvm *kvm_create_vm(void)
>  	atomic_inc(&kvm->mm->mm_count);
>  	spin_lock_init(&kvm->mmu_lock);
>  	spin_lock_init(&kvm->requests_lock);
> +	kvm_init_irq_routing(kvm);
>  	kvm_io_bus_init(&kvm->pio_bus);
>  	kvm_eventfd_init(kvm);
>  	mutex_init(&kvm->lock);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
