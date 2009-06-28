Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZF1KrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZF1KrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZF1Kqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:46:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbZF1Kqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:46:51 -0400
Date: Sun, 28 Jun 2009 13:46:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 4/4] KVM: add irqfd DEASSIGN feature
Message-ID: <20090628104615.GA8020@redhat.com>
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132832.26748.35406.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625132832.26748.35406.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 09:28:32AM -0400, Gregory Haskins wrote:
> DEASSIGN allows us to optionally disassociate an IRQFD from its underlying
> eventfd without destroying the eventfd in the process.  This is useful
> for conditions like live-migration which may have an eventfd associated
> with a device and an IRQFD.  We need to be able to decouple the guest
> from the event source while not perturbing the event source itself.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
>  include/linux/kvm.h |    2 ++
>  virt/kvm/eventfd.c  |   56 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 38ff31e..6710518 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -490,6 +490,8 @@ struct kvm_x86_mce {
>  };
>  #endif
>  
> +#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> +
>  struct kvm_irqfd {
>  	__u32 fd;
>  	__u32 gsi;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index ca21e8a..2d4549c 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -180,8 +180,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
>  	add_wait_queue(wqh, &irqfd->wait);
>  }
>  
> -int
> -kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> +static int
> +kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  {
>  	struct _irqfd *irqfd;
>  	struct file *file = NULL;
> @@ -303,6 +303,58 @@ irqfd_shutdown(struct _irqfd *irqfd)
>  	irqfd_release(irqfd);
>  }
>  
> +/*
> + * assumes kvm->irqfds.lock is held
> + */
> +static struct _irqfd *
> +irqfd_find(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd, *tmp, *ret = ERR_PTR(-ENOENT);
> +	struct eventfd_ctx *eventfd;
> +
> +	eventfd = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(eventfd))
> +		return ERR_PTR(PTR_ERR(eventfd));
> +
> +	spin_lock_irq(&kvm->irqfds.lock);
> +
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
> +		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
> +			irqfd_deactivate(irqfd);
> +			ret = irqfd;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;
> +}
> +
> +static int
> +kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
> +{
> +	struct _irqfd *irqfd;
> +
> +	irqfd = irqfd_find(kvm, fd, gsi);
> +	if (IS_ERR(irqfd))
> +		return PTR_ERR(irqfd);
> +
> +	irqfd_shutdown(irqfd);
> +
> +	return 0;
> +}


I think that, to make this work properly, you must
add irqfd to list the last thing so do.
As it is, when you assign irqfd, the last thing you do is

        irqfd->eventfd = eventfd;

I think you should move this to within a spinlock.

> +
> +int
> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> +{
> +	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
> +		return kvm_irqfd_deassign(kvm, fd, gsi);
> +
> +	return kvm_irqfd_assign(kvm, fd, gsi);
> +}
> +


At some point we discussed limiting the number of
irqfds that can be created in some way, so that userspace
can not consume unlimited amount of kernel memory.

What happened to that idea?

This will happen naturally if
- we keep fget on the file until irqfd goes away
- we allow the same file be bound to only one irqfd
but there might be other ways to do this

-- 
MST
