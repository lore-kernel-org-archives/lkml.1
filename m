Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZFNLuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZFNLuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZFNLt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:49:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZFNLt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:49:57 -0400
Date: Sun, 14 Jun 2009 14:49:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davdel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090614114854.GA10269@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604124812.10544.5811.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:48:12AM -0400, Gregory Haskins wrote:
> +static void
> +irqfd_disconnect(struct _irqfd *irqfd)
> +{
> +	struct kvm *kvm;
> +
> +	mutex_lock(&irqfd->lock);
> +
> +	kvm = rcu_dereference(irqfd->kvm);
> +	rcu_assign_pointer(irqfd->kvm, NULL);
> +
> +	mutex_unlock(&irqfd->lock);
> +
> +	if (!kvm)
> +		return;
>  
>  	mutex_lock(&kvm->lock);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +	list_del(&irqfd->list);
>  	mutex_unlock(&kvm->lock);
> +
> +	/*
> +	 * It is important to not drop the kvm reference until the next grace
> +	 * period because there might be lockless references in flight up
> +	 * until then
> +	 */
> +	synchronize_srcu(&irqfd->srcu);
> +	kvm_put_kvm(kvm);
>  }

So irqfd object will persist after kvm goes away, until eventfd is closed?

>  
>  static int
>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
>  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> +	unsigned long flags = (unsigned long)key;
>  
> -	/*
> -	 * The wake_up is called with interrupts disabled.  Therefore we need
> -	 * to defer the IRQ injection until later since we need to acquire the
> -	 * kvm->lock to do so.
> -	 */
> -	schedule_work(&irqfd->work);
> +	if (flags & POLLIN)
> +		/*
> +		 * The POLLIN wake_up is called with interrupts disabled.
> +		 * Therefore we need to defer the IRQ injection until later
> +		 * since we need to acquire the kvm->lock to do so.
> +		 */
> +		schedule_work(&irqfd->inject);
> +
> +	if (flags & POLLHUP) {
> +		/*
> +		 * The POLLHUP is called unlocked, so it theoretically should
> +		 * be safe to remove ourselves from the wqh using the locked
> +		 * variant of remove_wait_queue()
> +		 */
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +		flush_work(&irqfd->inject);
> +		irqfd_disconnect(irqfd);
> +
> +		cleanup_srcu_struct(&irqfd->srcu);
> +		kfree(irqfd);
> +	}
>  
>  	return 0;
>  }

And it is removed by this function when eventfd is closed.
But what prevents the kvm module from going away, meanwhile?

-- 
MST
