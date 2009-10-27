Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZJ0Rru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZJ0Rru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZJ0Rru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbZJ0Rrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:47:49 -0400
Date: Tue, 27 Oct 2009 19:45:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 3/3] KVM: Directly inject interrupts if they
	support lockless operation
Message-ID: <20091027174515.GA14421@redhat.com>
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162208.23704.19953.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026162208.23704.19953.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 12:22:08PM -0400, Gregory Haskins wrote:
> IRQFD currently uses a deferred workqueue item to execute the injection
> operation.  It was originally designed this way because kvm_set_irq()
> required the caller to hold the irq_lock mutex, and the eventfd callback
> is invoked from within a non-preemptible critical section.
> 
> With the advent of lockless injection support for certain GSIs, the
> deferment mechanism is no longer technically needed in all cases.
> Since context switching to the workqueue is a source of interrupt
> latency, lets switch to a direct method whenever possible.  Fortunately
> for us, the most common use of irqfd (MSI-based GSIs) readily support
> lockless injection.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

This is a useful optimization I think.
Some comments below.

> ---
> 
>  virt/kvm/eventfd.c |   31 +++++++++++++++++++++++++++----
>  1 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 30f70fd..e6cc958 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -51,20 +51,34 @@ struct _irqfd {
>  	wait_queue_t              wait;
>  	struct work_struct        inject;
>  	struct work_struct        shutdown;
> +	void (*execute)(struct _irqfd *);
>  };
>  
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
>  static void
> -irqfd_inject(struct work_struct *work)
> +irqfd_inject(struct _irqfd *irqfd)
>  {
> -	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
>  	struct kvm *kvm = irqfd->kvm;
>  
>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>  }
>  
> +static void
> +irqfd_deferred_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> +
> +	irqfd_inject(irqfd);
> +}
> +
> +static void
> +irqfd_schedule(struct _irqfd *irqfd)
> +{
> +	schedule_work(&irqfd->inject);
> +}
> +
>  /*
>   * Race-free decouple logic (ordering is critical)
>   */
> @@ -126,7 +140,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  
>  	if (flags & POLLIN)
>  		/* An event has been signaled, inject an interrupt */
> -		schedule_work(&irqfd->inject);
> +		irqfd->execute(irqfd);
>  
>  	if (flags & POLLHUP) {
>  		/* The eventfd is closing, detach from KVM */
> @@ -179,7 +193,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	INIT_WORK(&irqfd->inject, irqfd_deferred_inject);
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>  
>  	file = eventfd_fget(fd);
> @@ -209,6 +223,15 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  
> +	ret = kvm_irq_check_lockless(kvm, gsi);
> +	if (ret < 0)
> +		goto fail;
> +
> +	if (ret)
> +		irqfd->execute = &irqfd_inject;
> +	else
> +		irqfd->execute = &irqfd_schedule;
> +

Can't gsi get converted from lockless to non-lockless
after it's checked (by the routing ioctl)?  Kernel will crash then.

How about, each time we get event from eventfd, we implement
kvm_irqfd_toggle_lockless, which does a single scan, and returns
true/false status (and I really mean toggle, let's not do set 1 / set 0
as well) telling us whether interrupts could be delivered in a lockless
manner?

Then we can either just ignore the error (no one uses eventfd this way),
or handle the mostly irrelevant case of level by means of the workqueue,
like we did previously.


>  	/*
>  	 * Check if there was an event already pending on the eventfd
>  	 * before we registered, and trigger it as if we didn't miss it.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
