Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZGFP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZGFP7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGFP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:59:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbZGFP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:59:30 -0400
Date: Mon, 6 Jul 2009 18:58:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
Message-ID: <20090706155850.GA12399@redhat.com>
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702153821.20186.9344.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 11:38:22AM -0400, Gregory Haskins wrote:
> We currently create this wq on module_init, which may be wasteful if the
> host never creates a guest that uses irqfd.  This patch changes the
> algorithm so that the workqueue is only created when at least one guest
> is using irqfd.  The queue is cleaned up when the last guest using irqfd
> is shutdown.
> 
> To keep things simple, we only check whether the guest has tried to create
> an irqfd, not whether there are actually irqfds active.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  include/linux/kvm_host.h |    1 
>  virt/kvm/eventfd.c       |  100 ++++++++++++++++++++++++++++++++++------------
>  2 files changed, 75 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8e04a34..cd1a0f3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -149,6 +149,7 @@ struct kvm {
>  	struct {
>  		spinlock_t        lock;
>  		struct list_head  items;
> +		bool              init;
>  	} irqfds;
>  #endif
>  	struct kvm_vm_stat stat;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 4092b8d..fcc3469 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -49,7 +49,16 @@ struct _irqfd {
>  	struct work_struct        shutdown;
>  };
>  
> -static struct workqueue_struct *irqfd_cleanup_wq;
> +struct _irqfd_cleanup {
> +	struct mutex             lock;
> +	int                      refs;
> +	struct workqueue_struct *wq;
> +};
> +
> +static struct _irqfd_cleanup irqfd_cleanup = {
> +	.lock = __MUTEX_INITIALIZER(irqfd_cleanup.lock),
> +	.refs = 0,
> +};
>  
>  static void
>  irqfd_inject(struct work_struct *work)
> @@ -110,7 +119,7 @@ irqfd_deactivate(struct _irqfd *irqfd)
>  
>  	list_del_init(&irqfd->list);
>  
> -	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
> +	queue_work(irqfd_cleanup.wq, &irqfd->shutdown);
>  }
>  
>  /*
> @@ -161,6 +170,62 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
>  	add_wait_queue(wqh, &irqfd->wait);
>  }
>  
> +/*
> + * create a host-wide workqueue for issuing deferred shutdown requests
> + * aggregated from all vm* instances. We need our own isolated single-thread
> + * queue to prevent deadlock against flushing the normal work-queue.
> + */
> +static int
> +irqfd_cleanup_init(struct kvm *kvm)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&irqfd_cleanup.lock);
> +
> +	/*
> +	 * Check the current init state from within the lock so that we
> +	 * sync all users to the thread creation.
> +	 */
> +	if (kvm->irqfds.init)
> +		goto out;
> +
> +	if (!irqfd_cleanup.refs) {
> +		struct workqueue_struct *wq;
> +
> +		wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
> +		if (!wq) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		irqfd_cleanup.wq = wq;
> +	}
> +
> +	irqfd_cleanup.refs++;
> +	kvm->irqfds.init = true;
> +
> +out:
> +	mutex_unlock(&irqfd_cleanup.lock);
> +
> +	return ret;
> +}
> +
> +static void
> +irqfd_cleanup_release(struct kvm *kvm)
> +{
> +	if (!kvm->irqfds.init)
> +		return;

init is checked outside the lock here.
Why?

> +
> +	mutex_lock(&irqfd_cleanup.lock);
> +
> +	if (!(--irqfd_cleanup.refs))
> +		destroy_workqueue(irqfd_cleanup.wq);
> +
> +	mutex_unlock(&irqfd_cleanup.lock);
> +
> +	kvm->irqfds.init = false;

... and cleaned outside the lock as well.

> +}
> +
>  static int
>  kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  {
> @@ -170,6 +235,10 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	int ret;
>  	unsigned int events;
>  
> +	ret = irqfd_cleanup_init(kvm);
> +	if (ret < 0)
> +		return ret;
> +
>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>  	if (!irqfd)
>  		return -ENOMEM;
> @@ -268,7 +337,7 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
>  	 * so that we guarantee there will not be any more interrupts on this
>  	 * gsi once this deassign function returns.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> +	flush_workqueue(irqfd_cleanup.wq);
>  
>  	return 0;
>  }
> @@ -302,28 +371,7 @@ kvm_irqfd_release(struct kvm *kvm)
>  	 * Block until we know all outstanding shutdown jobs have completed
>  	 * since we do not take a kvm* reference.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> -
> -}
> -
> -/*
> - * create a host-wide workqueue for issuing deferred shutdown requests
> - * aggregated from all vm* instances. We need our own isolated single-thread
> - * queue to prevent deadlock against flushing the normal work-queue.
> - */
> -static int __init irqfd_module_init(void)
> -{
> -	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
> -	if (!irqfd_cleanup_wq)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> +	flush_workqueue(irqfd_cleanup.wq);
> +	irqfd_cleanup_release(kvm);
>  
> -static void __exit irqfd_module_exit(void)
> -{
> -	destroy_workqueue(irqfd_cleanup_wq);
>  }
> -
> -module_init(irqfd_module_init);
> -module_exit(irqfd_module_exit);
