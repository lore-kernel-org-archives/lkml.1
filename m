Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZFVQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZFVQ6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZFVQ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:57:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZFVQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:57:50 -0400
Date: Mon, 22 Jun 2009 19:57:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v3 3/3] KVM: Fix races in irqfd using new
	eventfd_kref_get interface
Message-ID: <20090622165708.GB15228@redhat.com>
References: <20090622155504.22967.50532.stgit@dev.haskins.net> <20090622160556.22967.76273.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622160556.22967.76273.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 12:05:57PM -0400, Gregory Haskins wrote:
> This patch fixes all known races in irqfd, and paves the way to restore
> DEASSIGN support.  For details of the eventfd races, please see the patch
> presumably commited immediately prior to this one.
> 
> In a nutshell, we use eventfd_kref_get/put() to properly manage the
> lifetime of the underlying eventfd.  We also use careful coordination
> with our workqueue to ensure that all irqfd objects have terminated
> before we allow kvm to shutdown.  The logic used for shutdown walks
> all open irqfds and releases them.  This logic can be generalized in
> the future to allow a subset of irqfds to be released, thus allowing
> DEASSIGN support.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

I think this patch is a shade too tricky. Some explanation why below.

But I think irqfd_pop is a good idea.
Here's an alternative design sketch: add a list of irqfds to be shutdown
in kvm, and create a single-threaded workqueue. To kill an irqfd, move
it from list of live irqfds to list of dead irqfds, then schedule work
on a workqueue that walks this list and kills irqfds.

> ---
> 
>  virt/kvm/eventfd.c |  144 ++++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 110 insertions(+), 34 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 9656027..67985cd 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -28,6 +28,7 @@
>  #include <linux/file.h>
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
> +#include <linux/kref.h>
>  
>  /*
>   * --------------------------------------------------------------------
> @@ -36,26 +37,68 @@
>   * Credit goes to Avi Kivity for the original idea.
>   * --------------------------------------------------------------------
>   */
> +
> +enum {
> +	irqfd_flags_shutdown,
> +};
> +
>  struct _irqfd {
>  	struct kvm               *kvm;
> +	struct kref              *eventfd;


Yay, kref.

>  	int                       gsi;
>  	struct list_head          list;
>  	poll_table                pt;
>  	wait_queue_head_t        *wqh;
>  	wait_queue_t              wait;
> -	struct work_struct        inject;
> +	struct work_struct        work;
> +	unsigned long             flags;

Just make it "int shutdown"?

>  };
>  
>  static void
> -irqfd_inject(struct work_struct *work)
> +irqfd_release(struct _irqfd *irqfd)
> +{
> +	eventfd_kref_put(irqfd->eventfd);
> +	kfree(irqfd);
> +}
> +
> +static void
> +irqfd_work(struct work_struct *work)
>  {
> -	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
>  	struct kvm *kvm = irqfd->kvm;
>  
> -	mutex_lock(&kvm->irq_lock);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> -	mutex_unlock(&kvm->irq_lock);
> +	if (!test_bit(irqfd_flags_shutdown, &irqfd->flags)) {

Why is it safe to test this bit outside of any lock?

> +		/* Inject an interrupt */
> +		mutex_lock(&kvm->irq_lock);
> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +		mutex_unlock(&kvm->irq_lock);
> +	} else {


Not much shared code here - create a separate showdown work struct?
They are cheap ...

> +		/* shutdown the irqfd */
> +		struct _irqfd *_irqfd = NULL;
> +
> +		mutex_lock(&kvm->lock);
> +
> +		if (!list_empty(&irqfd->list))
> +			_irqfd = irqfd;
> +
> +		if (_irqfd)
> +			list_del(&_irqfd->list);
> +
> +		mutex_unlock(&kvm->lock);
> +
> +		/*
> +		 * If the item is not currently on the irqfds list, we know
> +		 * we are running concurrently with the KVM side trying to
> +		 * remove this item as well.

We do? How? As far as I can see list is only empty after it has been
created.  Generally, it would be better to either use a flag or use
list_empty as an indication of going down, but not both.

>  Since the KVM side should be
> +		 * holding the reference now, and will block behind a
> +		 * flush_work(), lets just let them do the release() for us
> +		 */
> +		if (!_irqfd)
> +			return;
> +
> +		irqfd_release(_irqfd);
> +	}
>  }
>  
>  static int
> @@ -65,25 +108,20 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  	unsigned long flags = (unsigned long)key;
>  
>  	/*
> -	 * Assume we will be called with interrupts disabled
> +	 * called with interrupts disabled
>  	 */
> -	if (flags & POLLIN)
> -		/*
> -		 * Defer the IRQ injection until later since we need to
> -		 * acquire the kvm->lock to do so.
> -		 */
> -		schedule_work(&irqfd->inject);
> -
>  	if (flags & POLLHUP) {
>  		/*
> -		 * for now, just remove ourselves from the list and let
> -		 * the rest dangle.  We will fix this up later once
> -		 * the races in eventfd are fixed
> +		 * ordering is important: shutdown flag must be visible
> +		 * before we schedule
>  		 */
>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
> -		irqfd->wqh = NULL;
> +		set_bit(irqfd_flags_shutdown, &irqfd->flags);

So what happens if a previously scheduled work runs on irqfd
and sees this flag? And note that multiple works can run on irqfd
in parallel.

>  	}
>  
> +	if (flags & (POLLHUP | POLLIN))
> +		schedule_work(&irqfd->work);
> +
>  	return 0;
>  }
>  
> @@ -102,6 +140,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  {
>  	struct _irqfd *irqfd;
>  	struct file *file = NULL;
> +	struct kref *kref = NULL;
>  	int ret;
>  	unsigned int events;
>  
> @@ -112,7 +151,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	INIT_WORK(&irqfd->work, irqfd_work);
>  
>  	file = eventfd_fget(fd);
>  	if (IS_ERR(file)) {
> @@ -133,11 +172,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  	list_add_tail(&irqfd->list, &kvm->irqfds);
>  	mutex_unlock(&kvm->lock);
>  
> -	/*
> -	 * Check if there was an event already queued
> -	 */
> -	if (events & POLLIN)
> -		schedule_work(&irqfd->inject);
> +	kref = eventfd_kref_get(file);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->eventfd = kref;
>  
>  	/*
>  	 * do not drop the file until the irqfd is fully initialized, otherwise
> @@ -145,9 +186,18 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  	 */
>  	fput(file);
>  
> +	/*
> +	 * Check if there was an event already queued
> +	 */

This comment seems to confuse more that it clarifies:
queued where? eventfd only counts... Just kill the comment?

> +	if (events & POLLIN)
> +		schedule_work(&irqfd->work);
> +
>  	return 0;
>  
>  fail:
> +	if (kref && !IS_ERR(kref))
> +		eventfd_kref_put(kref);
> +
>  	if (file && !IS_ERR(file))
>  		fput(file);

let's add a couple more labels and avoid the kref/file check
and the initialization above?

>  
> @@ -161,21 +211,47 @@ kvm_irqfd_init(struct kvm *kvm)
>  	INIT_LIST_HEAD(&kvm->irqfds);
>  }
>  
> +static struct _irqfd *
> +irqfd_pop(struct kvm *kvm)
> +{
> +	struct _irqfd *irqfd = NULL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (!list_empty(&kvm->irqfds)) {
> +		irqfd = list_first_entry(&kvm->irqfds, struct _irqfd, list);
> +		list_del(&irqfd->list);
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +
> +	return irqfd;
> +}
> +
>  void
>  kvm_irqfd_release(struct kvm *kvm)
>  {
> -	struct _irqfd *irqfd, *tmp;
> +	struct _irqfd *irqfd;
>  
> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> -		if (irqfd->wqh)
> -			remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +	while ((irqfd = irqfd_pop(kvm))) {
>  
> -		flush_work(&irqfd->inject);
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>  
> -		mutex_lock(&kvm->lock);
> -		list_del(&irqfd->list);
> -		mutex_unlock(&kvm->lock);
> +		/*
> +		 * We guarantee there will be no more notifications after
> +		 * the remove_wait_queue returns.  Now lets make sure we
> +		 * synchronize behind any outstanding work items before
> +		 * releasing the resources
> +		 */
> +		flush_work(&irqfd->work);
>  
> -		kfree(irqfd);
> +		irqfd_release(irqfd);
>  	}
> +
> +	/*
> +	 * We need to wait in case there are any outstanding work-items
> +	 * in flight that had already removed themselves from the list
> +	 * prior to entry to this function
> +	 */

Looks scary. Why doesn't the flush above cover all cases?

> +	flush_scheduled_work();
>  }
