Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZJ1HtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZJ1HtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZJ1HtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbZJ1Hs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:48:59 -0400
Date: Wed, 28 Oct 2009 09:46:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 2/3] KVM: export lockless GSI attribute
Message-ID: <20091028074623.GB22784@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162202.23704.8727.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026162202.23704.8727.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 12:22:03PM -0400, Gregory Haskins wrote:
> Certain GSI's support lockless injecton, but we have no way to detect
> which ones at the GSI level.  Knowledge of this attribute will be
> useful later in the series so that we can optimize irqfd injection
> paths for cases where we know the code will not sleep.  Therefore,
> we provide an API to query a specific GSI.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  include/linux/kvm_host.h |    2 ++
>  virt/kvm/irq_comm.c      |   35 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1fe135d..01151a6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -119,6 +119,7 @@ struct kvm_memory_slot {
>  struct kvm_kernel_irq_routing_entry {
>  	u32 gsi;
>  	u32 type;
> +	bool lockless;

So lockless is the same as type == MSI from below?
If the idea is to make it extensible for the future,
let's just add an inline function, we don't need a field for this.

>  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
>  		   struct kvm *kvm, int irq_source_id, int level);
>  	union {
> @@ -420,6 +421,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
>  				   unsigned long *deliver_bitmask);
>  #endif
>  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq);
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
>  void kvm_register_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index db2553f..a7fd487 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -173,6 +173,35 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  	return ret;
>  }
>  
> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
> +{
> +	struct kvm_kernel_irq_routing_entry *e;
> +	struct kvm_irq_routing_table *irq_rt;
> +	struct hlist_node *n;
> +	int ret = -ENOENT;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->irq_routing.srcu);
> +	irq_rt = rcu_dereference(kvm->irq_routing.table);
> +	if (irq < irq_rt->nr_rt_entries)
> +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
> +			if (!e->lockless) {
> +				/*
> +				 * all destinations need to be lockless to
> +				 * declare that the GSI as a whole is also
> +				 * lockless
> +				 */
> +				ret = 0;
> +				break;
> +			}
> +
> +			ret = 1;
> +		}
> +	srcu_read_unlock(&kvm->irq_routing.srcu, idx);
> +
> +	return ret;
> +}
> +
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
>  {
>  	struct kvm_irq_ack_notifier *kian;
> @@ -310,18 +339,22 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
>  	int delta;
>  	struct kvm_kernel_irq_routing_entry *ei;
>  	struct hlist_node *n;
> +	bool lockless = ue->type == KVM_IRQ_ROUTING_MSI;
>  
>  	/*
>  	 * Do not allow GSI to be mapped to the same irqchip more than once.
>  	 * Allow only one to one mapping between GSI and MSI.
> +	 * Do not allow mixed lockless vs locked variants to coexist.

Userspace has no idea which entries are lockless and which are not:
this is an implementation detail - so it might not be able to avoid
illegal combinations.
Since this is called on an ioctl, can the rule be formulated in a way
that makes sense for userspace?

>  	 */
>  	hlist_for_each_entry(ei, n, &rt->map[ue->gsi], link)
>  		if (ei->type == KVM_IRQ_ROUTING_MSI ||
> -		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
> +		    ue->u.irqchip.irqchip == ei->irqchip.irqchip ||
> +		    ei->lockless != lockless)

So this check seems like it does nothing, because lockless is same as
MSI, and MSI is always 1:1? Intentional?

>  			return r;
>  
>  	e->gsi = ue->gsi;
>  	e->type = ue->type;
> +	e->lockless = lockless;
>  	switch (ue->type) {
>  	case KVM_IRQ_ROUTING_IRQCHIP:
>  		delta = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
