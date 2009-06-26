Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbZFZOGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbZFZOGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZFZOGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:06:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38899 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZFZOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:06:03 -0400
Message-ID: <4A44D5C4.2080803@novell.com>
Date: Fri, 26 Jun 2009 10:05:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 3/4] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132826.26748.15607.stgit@dev.haskins.net>
In-Reply-To: <20090625132826.26748.15607.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA475B73476B6AB2D11D69F7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA475B73476B6AB2D11D69F7C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> eventfd currently emits a POLLHUP wakeup on f_ops->release() to generat=
e a
> "release" callback.  This lets eventfd clients know if the eventfd is a=
bout
> to go away and is very useful particularly for in-kernel clients.  Howe=
ver,
> until recently it is not possible to use this feature of eventfd in a
> race-free way.  This patch utilizes a new eventfd interface to rectify
> the problem.
>
> Note that one final race is known to exist: the slow-work thread may ra=
ce
> with module removal.  We are currently working with slow-work upstream
> to fix this issue as well.  Since the code prior to this patch also
> races with module_put(), we are not making anything worse, but rather
> shifting the cause of the race.  Once the slow-work code is patched we
> will be fixing the last remaining issue.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  include/linux/kvm_host.h |    7 +-
>  virt/kvm/Kconfig         |    1=20
>  virt/kvm/eventfd.c       |  199 ++++++++++++++++++++++++++++++++++++++=
++------
>  3 files changed, 179 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2451f48..d94ee72 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -141,7 +141,12 @@ struct kvm {
>  	struct kvm_io_bus mmio_bus;
>  	struct kvm_io_bus pio_bus;
>  #ifdef CONFIG_HAVE_KVM_EVENTFD
> -	struct list_head irqfds;
> +	struct {
> +		spinlock_t        lock;
> +		struct list_head  items;
> +		atomic_t          outstanding;
> +		wait_queue_head_t wqh;
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
> =20
>  config KVM_APIC_ARCHITECTURE
>         bool
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 9656027..ca21e8a 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -28,6 +28,7 @@
>  #include <linux/file.h>
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
> +#include <linux/slow-work.h>
> =20
>  /*
>   * -------------------------------------------------------------------=
-
> @@ -36,17 +37,36 @@
>   * Credit goes to Avi Kivity for the original idea.
>   * -------------------------------------------------------------------=
-
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
> +	struct slow_work          shutdown;
> +	int                       active:1;
>  };
> =20
>  static void
> +irqfd_release(struct _irqfd *irqfd)
> +{
> +	eventfd_ctx_put(irqfd->eventfd);
> +	kfree(irqfd);
> +}
> +
> +/* assumes kvm->irqfds.lock is held */
> +static void
> +irqfd_deactivate(struct _irqfd *irqfd)
> +{
> +	irqfd->active =3D false;
> +	list_del(&irqfd->list);
> +}
> +
> +static void
>  irqfd_inject(struct work_struct *work)
>  {
>  	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject);
> @@ -58,6 +78,55 @@ irqfd_inject(struct work_struct *work)
>  	mutex_unlock(&kvm->irq_lock);
>  }
> =20
> +static struct _irqfd *
> +work_to_irqfd(struct slow_work *work)
> +{
> +	return container_of(work, struct _irqfd, shutdown);
> +}
> +
> +static int
> +irqfd_shutdown_get_ref(struct slow_work *work)
> +{
> +	struct _irqfd *irqfd =3D work_to_irqfd(work);
> +	struct kvm *kvm =3D irqfd->kvm;
> +
> +	atomic_inc(&kvm->irqfds.outstanding);
> +
> +	return 0;
> +}
> +
> +static void
> +irqfd_shutdown_put_ref(struct slow_work *work)
> +{
> +	struct _irqfd *irqfd =3D work_to_irqfd(work);
> +	struct kvm *kvm =3D irqfd->kvm;
> +
> +	irqfd_release(irqfd);
> +
> +	if (atomic_dec_and_test(&kvm->irqfds.outstanding))
> +		wake_up(&kvm->irqfds.wqh);
> +}
> +
> +static void
> +irqfd_shutdown_execute(struct slow_work *work)
> +{
> +	struct _irqfd *irqfd =3D work_to_irqfd(work);
> +
> +	/*
> +	 * Ensure there are no outstanding "inject" work-items before we blow=

> +	 * away our state.  Once this job completes, the slow_work
> +	 * infrastructure will drop the irqfd object completely via put_ref
> +	 */
> +	flush_work(&irqfd->inject);
> +}
> +
> +const static struct slow_work_ops irqfd_shutdown_work_ops =3D {
> +	.get_ref =3D irqfd_shutdown_get_ref,
> +	.put_ref =3D irqfd_shutdown_put_ref,
> +	.execute =3D irqfd_shutdown_execute,
> +};
> +
> +
>  static int
>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  {
> @@ -65,25 +134,39 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, in=
t sync, void *key)
>  	unsigned long flags =3D (unsigned long)key;
> =20
>  	/*
> -	 * Assume we will be called with interrupts disabled
> +	 * Called with interrupts disabled
>  	 */
>  	if (flags & POLLIN)
> -		/*
> -		 * Defer the IRQ injection until later since we need to
> -		 * acquire the kvm->lock to do so.
> -		 */
> +		/* An event has been signaled, inject an interrupt */
>  		schedule_work(&irqfd->inject);
> =20
>  	if (flags & POLLHUP) {
> -		/*
> -		 * for now, just remove ourselves from the list and let
> -		 * the rest dangle.  We will fix this up later once
> -		 * the races in eventfd are fixed
> -		 */
> +		/* The eventfd is closing, detach from KVM */
> +		struct kvm *kvm =3D irqfd->kvm;
> +		unsigned long flags;
> +
>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
> -		irqfd->wqh =3D NULL;
> +
> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
> +
> +		if (irqfd->active) {
> +			/*
> +			 * If the item is still active we can be sure that
> +			 * no-one else is trying to shutdown this object at
> +			 * the same time.
> +			 *
> +			 * Defer the shutdown to a thread so we can flush
> +			 * all remaining inject jobs.  We use a slow-work
> +			 * item to prevent a deadlock against the work-queue
> +			 */
> +			irqfd_deactivate(irqfd);
> +			slow_work_enqueue(&irqfd->shutdown);
> +		}
> +
> +		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
>  	}
> =20
> +
>  	return 0;
>  }
> =20
> @@ -102,6 +185,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fla=
gs)
>  {
>  	struct _irqfd *irqfd;
>  	struct file *file =3D NULL;
> +	struct eventfd_ctx *eventfd =3D NULL;
>  	int ret;
>  	unsigned int events;
> =20
> @@ -113,6 +197,8 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fla=
gs)
>  	irqfd->gsi =3D gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
>  	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	slow_work_init(&irqfd->shutdown, &irqfd_shutdown_work_ops);
> +	irqfd->active =3D true;
> =20
>  	file =3D eventfd_fget(fd);
>  	if (IS_ERR(file)) {
> @@ -129,12 +215,21 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int f=
lags)
> =20
>  	events =3D file->f_op->poll(file, &irqfd->pt);
> =20
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&irqfd->list, &kvm->irqfds);
> -	mutex_unlock(&kvm->lock);
> +	spin_lock_irq(&kvm->irqfds.lock);
> +	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
> +	eventfd =3D eventfd_ctx_fileget(file);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->eventfd =3D eventfd;
>  =20

<sigh> I just noticed this while doing a self review:  I need to assign
the eventfd context *before* putting the item on the list.  Not sure why
I even did that.  I suspect I re-arranged the code at the last minute
and didn't notice what a dumb thing I was doing.

So this will need at least a v6, but I will wait to hear if there are
any other comments from Michael et. al.

-Greg

> =20
>  	/*
> -	 * Check if there was an event already queued
> +	 * Check if there was an event already pending on the eventfd
> +	 * before we registered, and trigger it as if we didn't miss it.
>  	 */
>  	if (events & POLLIN)
>  		schedule_work(&irqfd->inject);
> @@ -148,6 +243,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fla=
gs)
>  	return 0;
> =20
>  fail:
> +	if (eventfd && !IS_ERR(eventfd))
> +		eventfd_ctx_put(eventfd);
> +
>  	if (file && !IS_ERR(file))
>  		fput(file);
> =20
> @@ -158,24 +256,71 @@ fail:
>  void
>  kvm_irqfd_init(struct kvm *kvm)
>  {
> -	INIT_LIST_HEAD(&kvm->irqfds);
> +	slow_work_register_user();
> +
> +	spin_lock_init(&kvm->irqfds.lock);
> +	INIT_LIST_HEAD(&kvm->irqfds.items);
> +	atomic_set(&kvm->irqfds.outstanding, 0);
> +	init_waitqueue_head(&kvm->irqfds.wqh);
> +}
> +
> +static struct _irqfd *
> +irqfd_pop(struct kvm *kvm)
> +{
> +	struct _irqfd *irqfd =3D NULL;
> +
> +	spin_lock_irq(&kvm->irqfds.lock);
> +
> +	if (!list_empty(&kvm->irqfds.items)) {
> +		irqfd =3D list_first_entry(&kvm->irqfds.items,
> +					 struct _irqfd, list);
> +		irqfd_deactivate(irqfd);
> +	}
> +
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
> +	return irqfd;
> +}
> +
> +/*
> + * locally releases the irqfd
> + *
> + * This function is called when KVM won the race with eventfd (signall=
ed by
> + * finding the item active on the kvm->irqfds.item list). We are now g=
uaranteed
> + * that we will never schedule a deferred shutdown task against this o=
bject,
> + * so we take steps to perform the shutdown ourselves.
> + *
> + * 1) We must remove ourselves from the wait-queue to prevent further =
events,
> + *    which will simultaneously act to sync us with eventfd (via wqh->=
lock)
> + * 2) Flush any outstanding inject-tasks to ensure its safe to free me=
mory
> + * 3) Delete the object
> + */
> +static void
> +irqfd_shutdown(struct _irqfd *irqfd)
> +{
> +	remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +	flush_work(&irqfd->inject);
> +	irqfd_release(irqfd);
>  }
> =20
>  void
>  kvm_irqfd_release(struct kvm *kvm)
>  {
> -	struct _irqfd *irqfd, *tmp;
> -
> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
> -		if (irqfd->wqh)
> -			remove_wait_queue(irqfd->wqh, &irqfd->wait);
> +	struct _irqfd *irqfd;
> =20
> -		flush_work(&irqfd->inject);
> +	/*
> +	 * Shutdown all irqfds that still remain
> +	 */
> +	while ((irqfd =3D irqfd_pop(kvm)))
> +		irqfd_shutdown(irqfd);
> =20
> -		mutex_lock(&kvm->lock);
> -		list_del(&irqfd->list);
> -		mutex_unlock(&kvm->lock);
> +	/*
> +	 * irqfds.outstanding tracks the number of outstanding "shutdown"
> +	 * jobs pending at any given time.  Once we get here, we know that
> +	 * no more jobs will get scheduled, so go ahead and block until all
> +	 * of them complete
> +	 */
> +	wait_event(kvm->irqfds.wqh, (!atomic_read(&kvm->irqfds.outstanding)))=
;
> =20
> -		kfree(irqfd);
> -	}
> +	slow_work_unregister_user();
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enigA475B73476B6AB2D11D69F7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpE1cQACgkQlOSOBdgZUxluAwCePhHsnt2bWNCM2Pi6IbBsZnCg
A5kAn2TDFeWqw2oJ7+qjO9tFoNhOwZXw
=0OMW
-----END PGP SIGNATURE-----

--------------enigA475B73476B6AB2D11D69F7C--
