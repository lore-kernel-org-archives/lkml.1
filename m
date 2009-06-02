Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZFBSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZFBSDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZFBSDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:03:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42568 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZFBSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:03:00 -0400
Date: Tue, 2 Jun 2009 11:02:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mst@redhat.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
	of an explicit ioctl
Message-ID: <20090602180256.GD6743@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602151538.29746.40356.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 11:15:38AM -0400, Gregory Haskins wrote:
> Assigning an irqfd object to a kvm object creates a relationship that we
> currently manage by having the kvm oject acquire/hold a file* reference to
> the underlying eventfd.  The lifetime of these objects is properly maintained
> by decoupling the two objects whenever the irqfd is closed or kvm is closed,
> whichever comes first.
> 
> However, the irqfd "close" method is less than ideal since it requires two
> system calls to complete (one for ioctl(kvmfd, IRQFD_DEASSIGN), the other for
> close(eventfd)).  This dual-call approach was utilized because there was no
> notification mechanism on the eventfd side at the time irqfd was implemented.
> 
> Recently, Davide proposed a patch to send a POLLHUP wakeup whenever an
> eventfd is about to close.  So we eliminate the IRQFD_DEASSIGN ioctl (*)
> vector in favor of sensing the desassign automatically when the fd is closed.
> The resulting code is slightly more complex as a result since we need to
> allow either side to sever the relationship independently.  We utilize SRCU
> to guarantee stable concurrent access to the KVM pointer without adding
> additional atomic operations in the fast path.
> 
> At minimum, this design should be acked by both Davide and Paul (cc'd).
> 
> (*) The irqfd patch does not exist in any released tree, so the understanding
> is that we can alter the irqfd specific ABI without taking the normal
> precautions, such as CAP bits.

A few questions and suggestions interspersed below.

							Thanx, Paul

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Davide Libenzi <davidel@xmailserver.org>
> CC: Michael S. Tsirkin <mst@redhat.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/kvm.h |    2 -
>  virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++----------------------------
>  virt/kvm/kvm_main.c |    3 +
>  3 files changed, 81 insertions(+), 101 deletions(-)
> 
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 632a856..29b62cc 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -482,8 +482,6 @@ struct kvm_x86_mce {
>  };
>  #endif
> 
> -#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> -
>  struct kvm_irqfd {
>  	__u32 fd;
>  	__u32 gsi;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index f3f2ea1..6ed62e2 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -37,26 +37,63 @@
>   * --------------------------------------------------------------------
>   */
>  struct _irqfd {
> +	struct mutex              lock;
> +	struct srcu_struct        srcu;
>  	struct kvm               *kvm;
>  	int                       gsi;
> -	struct file              *file;
>  	struct list_head          list;
>  	poll_table                pt;
>  	wait_queue_head_t        *wqh;
>  	wait_queue_t              wait;
> -	struct work_struct        work;
> +	struct work_struct        inject;
>  };
> 
>  static void
>  irqfd_inject(struct work_struct *work)
>  {
> -	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
> -	struct kvm *kvm = irqfd->kvm;
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> +	struct kvm *kvm;
> +	int idx;
> +
> +	idx = srcu_read_lock(&irqfd->srcu);
> +
> +	kvm = rcu_dereference(irqfd->kvm);
> +	if (kvm) {
> +		mutex_lock(&kvm->lock);
> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +		mutex_unlock(&kvm->lock);
> +	}
> +
> +	srcu_read_unlock(&irqfd->srcu, idx);
> +}
> +
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

The lockless references are all harmless even if carried out after the
kvm structure has been removed?  Or does there need to be a ->deleted
field that allows the lockless references to ignore a kvm structure that
has already been deleted?

On the other hand, if it really is somehow OK for kvm_set_irq() to be
called on an already-deleted kvm structure, then this code would be OK
as is.

> +	synchronize_srcu(&irqfd->srcu);
> +	kvm_put_kvm(kvm);
>  }
> 
>  static int
> @@ -64,12 +101,28 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
>  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> 
> -	/*
> -	 * The wake_up is called with interrupts disabled.  Therefore we need
> -	 * to defer the IRQ injection until later since we need to acquire the
> -	 * kvm->lock to do so.
> -	 */
> -	schedule_work(&irqfd->work);
> +	switch ((unsigned long)key) {
> +	case POLLIN:
> +		/*
> +		 * The POLLIN wake_up is called with interrupts disabled.
> +		 * Therefore we need to defer the IRQ injection until later
> +		 * since we need to acquire the kvm->lock to do so.
> +		 */
> +		schedule_work(&irqfd->inject);
> +		break;
> +	case POLLHUP:
> +		/*
> +		 * The POLLHUP is called unlocked, so it theoretically should
> +		 * be safe to remove ourselves from the wqh
> +		 */
> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +		flush_work(&irqfd->inject);
> +		irqfd_disconnect(irqfd);

Good.  The fact that irqfd_disconnect() does a synchronize_srcu()
prevents any readers from trying to do an SRCU operation on an already
cleaned-up srcu_struct, so this does look safe to me.

> +		cleanup_srcu_struct(&irqfd->srcu);
> +		kfree(irqfd);
> +		break;
> +	}
> 
>  	return 0;
>  }
> @@ -84,8 +137,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
>  	add_wait_queue(wqh, &irqfd->wait);
>  }
> 
> -static int
> -kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> +int
> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>  {
>  	struct _irqfd *irqfd;
>  	struct file *file = NULL;
> @@ -95,10 +148,12 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>  	if (!irqfd)
>  		return -ENOMEM;
> 
> +	mutex_init(&irqfd->lock);
> +	init_srcu_struct(&irqfd->srcu);
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->work, irqfd_inject);
> +	INIT_WORK(&irqfd->inject, irqfd_inject);
> 
>  	/*
>  	 * Embed the file* lifetime in the irqfd.
> @@ -120,12 +175,18 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>  	if (ret < 0)
>  		goto fail;
> 
> -	irqfd->file = file;
> +	kvm_get_kvm(kvm);
> 
>  	mutex_lock(&kvm->lock);
>  	list_add_tail(&irqfd->list, &kvm->irqfds);

Doesn't the above need to be list_add_tail_rcu()?  Unless I am confused,
this is the point at which the new SRCU-protected structure is first
made public.  If so, you really do need list_add_tail_rcu() to make sure
that concurrent readers don't see pre-initialized values in the structure.

>  	mutex_unlock(&kvm->lock);
> 
> +	/*
> +	 * do not drop the file until the irqfd is fully initialized, otherwise
> +	 * we might race against the POLLHUP
> +	 */
> +	fput(file);
> +
>  	return 0;
> 
>  fail:
> @@ -139,97 +200,17 @@ fail:
>  	return ret;
>  }
> 
> -static void
> -irqfd_release(struct _irqfd *irqfd)
> -{
> -	/*
> -	 * The ordering is important.  We must remove ourselves from the wqh
> -	 * first to ensure no more event callbacks are issued, and then flush
> -	 * any previously scheduled work prior to freeing the memory
> -	 */
> -	remove_wait_queue(irqfd->wqh, &irqfd->wait);
> -
> -	flush_work(&irqfd->work);
> -
> -	fput(irqfd->file);
> -	kfree(irqfd);
> -}
> -
> -static struct _irqfd *
> -irqfd_remove(struct kvm *kvm, struct file *file, int gsi)
> -{
> -	struct _irqfd *irqfd;
> -
> -	mutex_lock(&kvm->lock);
> -
> -	/*
> -	 * linear search isn't brilliant, but this should be an infrequent
> -	 * slow-path operation, and the list should not grow very large
> -	 */
> -	list_for_each_entry(irqfd, &kvm->irqfds, list) {
> -		if (irqfd->file != file || irqfd->gsi != gsi)
> -			continue;
> -
> -		list_del(&irqfd->list);
> -		mutex_unlock(&kvm->lock);
> -
> -		return irqfd;
> -	}
> -
> -	mutex_unlock(&kvm->lock);
> -
> -	return NULL;
> -}
> -
> -static int
> -kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
> -{
> -	struct _irqfd *irqfd;
> -	struct file *file;
> -	int count = 0;
> -
> -	file = fget(fd);
> -	if (IS_ERR(file))
> -		return PTR_ERR(file);
> -
> -	while ((irqfd = irqfd_remove(kvm, file, gsi))) {
> -		/*
> -		 * We remove the item from the list under the lock, but we
> -		 * free it outside the lock to avoid deadlocking with the
> -		 * flush_work and the work_item taking the lock
> -		 */
> -		irqfd_release(irqfd);
> -		count++;
> -	}
> -
> -	fput(file);
> -
> -	return count ? count : -ENOENT;
> -}
> -
>  void
>  kvm_irqfd_init(struct kvm *kvm)
>  {
>  	INIT_LIST_HEAD(&kvm->irqfds);
>  }
> 
> -int
> -kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> -{
> -	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
> -		return kvm_deassign_irqfd(kvm, fd, gsi);
> -
> -	return kvm_assign_irqfd(kvm, fd, gsi);
> -}
> -
>  void
>  kvm_irqfd_release(struct kvm *kvm)
>  {
>  	struct _irqfd *irqfd, *tmp;
> 
> -	/* don't bother with the lock..we are shutting down */
> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> -		list_del(&irqfd->list);
> -		irqfd_release(irqfd);
> -	}
> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
> +		irqfd_disconnect(irqfd);
>  }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 902fed9..a9f62bb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1029,7 +1029,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	spin_lock(&kvm_lock);
>  	list_del(&kvm->vm_list);
>  	spin_unlock(&kvm_lock);
> -	kvm_irqfd_release(kvm);
>  	kvm_free_irq_routing(kvm);
>  	kvm_io_bus_destroy(&kvm->pio_bus);
>  	kvm_io_bus_destroy(&kvm->mmio_bus);
> @@ -1064,6 +1063,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  {
>  	struct kvm *kvm = filp->private_data;
> 
> +	kvm_irqfd_release(kvm);
> +
>  	kvm_put_kvm(kvm);
>  	return 0;
>  }
> 
