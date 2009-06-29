Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbZF2QMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbZF2QMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZF2QMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:12:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2QMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:12:35 -0400
Date: Mon, 29 Jun 2009 19:11:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v6 3/4] KVM: Fix races in irqfd using new
	eventfd_kref_get interface
Message-ID: <20090629161159.GB22029@redhat.com>
References: <20090629153627.31959.76947.stgit@dev.haskins.net> <20090629154415.31959.2666.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629154415.31959.2666.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look good. A couple of minor nits:

On Mon, Jun 29, 2009 at 11:44:15AM -0400, Gregory Haskins wrote:
> eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
> "release" callback.  This lets eventfd clients know if the eventfd is about
> to go away and is very useful particularly for in-kernel clients.  However,
> until recently it is not possible to use this feature of eventfd in a
> race-free way.  This patch utilizes a new eventfd interface to rectify
> the problem.
> 
> Note that one final race is known to exist: the slow-work thread may race
> with module removal.  We are currently working with slow-work upstream
> to fix this issue as well.  Since the code prior to this patch also
> races with module_put(), we are not making anything worse, but rather
> shifting the cause of the race.  Once the slow-work code is patched we
> will be fixing the last remaining issue.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  include/linux/kvm_host.h |    5 +
>  virt/kvm/Kconfig         |    1 
>  virt/kvm/eventfd.c       |  154 ++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 131 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2451f48..5a90c6a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -141,7 +141,10 @@ struct kvm {
>  	struct kvm_io_bus mmio_bus;
>  	struct kvm_io_bus pio_bus;
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> -	struct list_head irqfds;
> +	struct {
> +		spinlock_t        lock;
> +		struct list_head  items;
> +	} irqfds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index daece36..ab7848a 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -9,6 +9,7 @@ config HAVE_KVM_IRQCHIP
>  config HAVE_KVM_EVENTFD
>         bool
>         select EVENTFD
> +       select SLOW_WORK

not needed in this version?

>  config KVM_APIC_ARCHITECTURE
>         bool
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 9656027..76ad125 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -36,16 +36,22 @@
>   * Credit goes to Avi Kivity for the original idea.
>   * --------------------------------------------------------------------
>   */
> +
>  struct _irqfd {
>  	struct kvm               *kvm;
> +	struct eventfd_ctx       *eventfd;
>  	int                       gsi;
>  	struct list_head          list;
>  	poll_table                pt;
>  	wait_queue_head_t        *wqh;
>  	wait_queue_t              wait;
>  	struct work_struct        inject;
> +	struct work_struct        shutdown;
> +	int                       active:1;

I think we need a comment here that active bit is protected by irqfds
lock.  One idea I had to make it even clearer was to have a shutdown list
of irqfds per-kvm, together with the items list, and make work_struct for
shutdown global, not per-irqfd.  We can then unconditionally do
list_move + schedule_work to shut down an irqfd, and it's safe to do
even if it is already on the shutdown list - it just gets moved to tail.

>  };
>  
> +static struct workqueue_struct *irqfd_cleanup_wq;
> +
>  static void
>  irqfd_inject(struct work_struct *work)
>  {
> @@ -58,32 +64,81 @@ irqfd_inject(struct work_struct *work)
>  	mutex_unlock(&kvm->irq_lock);
>  }
>  
> +/*
> + * Race-free decouple logic (ordering is critical)
> + */
> +static void
> +irqfd_shutdown(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
> +
> +	/*
> +	 * Synchronize with the wait-queue and unhook ourselves to prevent
> +	 * further events.
> +	 */
> +	remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +
> +	/*
> +	 * We know no new events will be scheduled at this point, so block
> +	 * until all previously outstanding events have completed
> +	 */
> +	flush_work(&irqfd->inject);
> +
> +	/*
> +	 * It is now safe to release the object's resources
> +	 */
> +	eventfd_ctx_put(irqfd->eventfd);
> +	kfree(irqfd);
> +}
> +
> +/*
> + * Mark the irqfd as inactive and schedule it for removal
> + *
> + * assumes kvm->irqfds.lock is held
> + */
> +static void
> +irqfd_deactivate(struct _irqfd *irqfd)
> +{
> +	BUG_ON(!irqfd->active);
> +
> +	irqfd->active = false;
> +	list_del(&irqfd->list);
> +
> +	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
> +}
> +
> +/*
> + * Called with wqh->lock held and interrupts disabled
> + */
>  static int
>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
>  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
>  	unsigned long flags = (unsigned long)key;
>  
> -	/*
> -	 * Assume we will be called with interrupts disabled
> -	 */
>  	if (flags & POLLIN)
> -		/*
> -		 * Defer the IRQ injection until later since we need to
> -		 * acquire the kvm->lock to do so.
> -		 */
> +		/* An event has been signaled, inject an interrupt */
>  		schedule_work(&irqfd->inject);
>  
>  	if (flags & POLLHUP) {
> -		/*
> -		 * for now, just remove ourselves from the list and let
> -		 * the rest dangle.  We will fix this up later once
> -		 * the races in eventfd are fixed
> -		 */
> -		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
> -		irqfd->wqh = NULL;
> +		/* The eventfd is closing, detach from KVM */
> +		struct kvm *kvm = irqfd->kvm;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
> +
> +		if (irqfd->active)
> +			/*
> +			 * If we get here, we can be sure no-one else is
> +			 * trying to shutdown this object at the same time
> +			 * since we hold the list lock.
> +			 */
> +			irqfd_deactivate(irqfd);
> +
> +		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
>  	}
>  
> +

extra empty line

>  	return 0;
>  }
>  
> @@ -102,6 +157,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  {
>  	struct _irqfd *irqfd;
>  	struct file *file = NULL;
> +	struct eventfd_ctx *eventfd = NULL;
>  	int ret;
>  	unsigned int events;
>  
> @@ -113,6 +169,8 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  	irqfd->gsi = gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
>  	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
> +	irqfd->active = true;
>  
>  	file = eventfd_fget(fd);
>  	if (IS_ERR(file)) {
> @@ -120,6 +178,14 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  		goto fail;
>  	}
>  
> +	eventfd = eventfd_ctx_fileget(file);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->eventfd = eventfd;
> +
>  	/*
>  	 * Install our own custom wake-up handling so we are notified via
>  	 * a callback whenever someone signals the underlying eventfd
> @@ -129,12 +195,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  
>  	events = file->f_op->poll(file, &irqfd->pt);
>  
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&irqfd->list, &kvm->irqfds);
> -	mutex_unlock(&kvm->lock);
> +	spin_lock_irq(&kvm->irqfds.lock);
> +	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> +	spin_unlock_irq(&kvm->irqfds.lock);
>  
>  	/*
> -	 * Check if there was an event already queued
> +	 * Check if there was an event already pending on the eventfd
> +	 * before we registered, and trigger it as if we didn't miss it.
>  	 */
>  	if (events & POLLIN)
>  		schedule_work(&irqfd->inject);
> @@ -148,6 +215,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  	return 0;
>  
>  fail:
> +	if (eventfd && !IS_ERR(eventfd))
> +		eventfd_ctx_put(eventfd);
> +
>  	if (file && !IS_ERR(file))
>  		fput(file);
>  
> @@ -158,24 +228,52 @@ fail:
>  void
>  kvm_irqfd_init(struct kvm *kvm)
>  {
> -	INIT_LIST_HEAD(&kvm->irqfds);
> +	spin_lock_init(&kvm->irqfds.lock);
> +	INIT_LIST_HEAD(&kvm->irqfds.items);
>  }
>  
> +/*
> + * This function is called as the kvm VM fd is being released. Shutdown all
> + * irqfds that still remain open
> + */
>  void
>  kvm_irqfd_release(struct kvm *kvm)
>  {
>  	struct _irqfd *irqfd, *tmp;
>  
> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> -		if (irqfd->wqh)
> -			remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +	spin_lock_irq(&kvm->irqfds.lock);
>  
> -		flush_work(&irqfd->inject);
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
> +		irqfd_deactivate(irqfd);
>  
> -		mutex_lock(&kvm->lock);
> -		list_del(&irqfd->list);
> -		mutex_unlock(&kvm->lock);
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
> +	/*
> +	 * Block until we know all outstanding shutdown jobs have completed
> +	 * since we do not take a kvm* reference.
> +	 */
> +	flush_workqueue(irqfd_cleanup_wq);
>  
> -		kfree(irqfd);
> -	}
>  }
> +
> +/*
> + * create a host-wide workqueue for issuing deferred shutdown requests
> + * aggregated from all vm* instances. We need our own isolated single-thread
> + * queue to prevent deadlock against flushing the normal work-queue.
> + */
> +static int __init irqfd_module_init(void)
> +{
> +	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
> +	if (!irqfd_cleanup_wq)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static void __exit irqfd_module_exit(void)
> +{
> +	destroy_workqueue(irqfd_cleanup_wq);
> +}
> +
> +module_init(irqfd_module_init);
> +module_exit(irqfd_module_exit);
