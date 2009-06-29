Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZF2Qwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZF2Qwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZF2Qwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:52:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55125 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZF2Qwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:52:41 -0400
Message-ID: <4A48F148.5030501@novell.com>
Date: Mon, 29 Jun 2009 12:52:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v6 3/4] KVM: Fix races in irqfd using new	eventfd_kref_get
 interface
References: <20090629153627.31959.76947.stgit@dev.haskins.net> <20090629154415.31959.2666.stgit@dev.haskins.net> <20090629161159.GB22029@redhat.com>
In-Reply-To: <20090629161159.GB22029@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59E3250B10C33E8CAA33A1DE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59E3250B10C33E8CAA33A1DE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Look good. A couple of minor nits:
>
> On Mon, Jun 29, 2009 at 11:44:15AM -0400, Gregory Haskins wrote:
>  =20
>> eventfd currently emits a POLLHUP wakeup on f_ops->release() to genera=
te a
>> "release" callback.  This lets eventfd clients know if the eventfd is =
about
>> to go away and is very useful particularly for in-kernel clients.  How=
ever,
>> until recently it is not possible to use this feature of eventfd in a
>> race-free way.  This patch utilizes a new eventfd interface to rectify=

>> the problem.
>>
>> Note that one final race is known to exist: the slow-work thread may r=
ace
>> with module removal.  We are currently working with slow-work upstream=

>> to fix this issue as well.  Since the code prior to this patch also
>> races with module_put(), we are not making anything worse, but rather
>> shifting the cause of the race.  Once the slow-work code is patched we=

>> will be fixing the last remaining issue.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  include/linux/kvm_host.h |    5 +
>>  virt/kvm/Kconfig         |    1=20
>>  virt/kvm/eventfd.c       |  154 +++++++++++++++++++++++++++++++++++++=
+--------
>>  3 files changed, 131 insertions(+), 29 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 2451f48..5a90c6a 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -141,7 +141,10 @@ struct kvm {
>>  	struct kvm_io_bus mmio_bus;
>>  	struct kvm_io_bus pio_bus;
>>  #ifdef CONFIG_HAVE_KVM_EVENTFD
>> -	struct list_head irqfds;
>> +	struct {
>> +		spinlock_t        lock;
>> +		struct list_head  items;
>> +	} irqfds;
>>  #endif
>>  	struct kvm_vm_stat stat;
>>  	struct kvm_arch arch;
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index daece36..ab7848a 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -9,6 +9,7 @@ config HAVE_KVM_IRQCHIP
>>  config HAVE_KVM_EVENTFD
>>         bool
>>         select EVENTFD
>> +       select SLOW_WORK
>>    =20
>
> not needed in this version?
>  =20

Good catch.  Will remove.

>  =20
>>  config KVM_APIC_ARCHITECTURE
>>         bool
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 9656027..76ad125 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -36,16 +36,22 @@
>>   * Credit goes to Avi Kivity for the original idea.
>>   * ------------------------------------------------------------------=
--
>>   */
>> +
>>  struct _irqfd {
>>  	struct kvm               *kvm;
>> +	struct eventfd_ctx       *eventfd;
>>  	int                       gsi;
>>  	struct list_head          list;
>>  	poll_table                pt;
>>  	wait_queue_head_t        *wqh;
>>  	wait_queue_t              wait;
>>  	struct work_struct        inject;
>> +	struct work_struct        shutdown;
>> +	int                       active:1;
>>    =20
>
> I think we need a comment here that active bit is protected by irqfds
> lock.

Ack

>   One idea I had to make it even clearer was to have a shutdown list
> of irqfds per-kvm, together with the items list, and make work_struct f=
or
> shutdown global, not per-irqfd.  We can then unconditionally do
> list_move + schedule_work to shut down an irqfd, and it's safe to do
> even if it is already on the shutdown list - it just gets moved to tail=
=2E
>  =20

Hmm..I'm not sure that churn really buys us anything, tho.  Technically
the "active" bit is redundant with list_del_init()+list_empty() that I
employed in previous versions.  However, I made it explicit with the
active bit to be more self-documenting.  IMO, the latest code is pretty
clear, and the change you are proposing is moving towards a slightly
trickier variant like I originally had.  I'd say "lets leave this as is".=


>  =20
>>  };
>> =20
>> +static struct workqueue_struct *irqfd_cleanup_wq;
>> +
>>  static void
>>  irqfd_inject(struct work_struct *work)
>>  {
>> @@ -58,32 +64,81 @@ irqfd_inject(struct work_struct *work)
>>  	mutex_unlock(&kvm->irq_lock);
>>  }
>> =20
>> +/*
>> + * Race-free decouple logic (ordering is critical)
>> + */
>> +static void
>> +irqfd_shutdown(struct work_struct *work)
>> +{
>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, shutdown)=
;
>> +
>> +	/*
>> +	 * Synchronize with the wait-queue and unhook ourselves to prevent
>> +	 * further events.
>> +	 */
>> +	remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +
>> +	/*
>> +	 * We know no new events will be scheduled at this point, so block
>> +	 * until all previously outstanding events have completed
>> +	 */
>> +	flush_work(&irqfd->inject);
>> +
>> +	/*
>> +	 * It is now safe to release the object's resources
>> +	 */
>> +	eventfd_ctx_put(irqfd->eventfd);
>> +	kfree(irqfd);
>> +}
>> +
>> +/*
>> + * Mark the irqfd as inactive and schedule it for removal
>> + *
>> + * assumes kvm->irqfds.lock is held
>> + */
>> +static void
>> +irqfd_deactivate(struct _irqfd *irqfd)
>> +{
>> +	BUG_ON(!irqfd->active);
>> +
>> +	irqfd->active =3D false;
>> +	list_del(&irqfd->list);
>> +
>> +	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
>> +}
>> +
>> +/*
>> + * Called with wqh->lock held and interrupts disabled
>> + */
>>  static int
>>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>  {
>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>>  	unsigned long flags =3D (unsigned long)key;
>> =20
>> -	/*
>> -	 * Assume we will be called with interrupts disabled
>> -	 */
>>  	if (flags & POLLIN)
>> -		/*
>> -		 * Defer the IRQ injection until later since we need to
>> -		 * acquire the kvm->lock to do so.
>> -		 */
>> +		/* An event has been signaled, inject an interrupt */
>>  		schedule_work(&irqfd->inject);
>> =20
>>  	if (flags & POLLHUP) {
>> -		/*
>> -		 * for now, just remove ourselves from the list and let
>> -		 * the rest dangle.  We will fix this up later once
>> -		 * the races in eventfd are fixed
>> -		 */
>> -		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> -		irqfd->wqh =3D NULL;
>> +		/* The eventfd is closing, detach from KVM */
>> +		struct kvm *kvm =3D irqfd->kvm;
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
>> +
>> +		if (irqfd->active)
>> +			/*
>> +			 * If we get here, we can be sure no-one else is
>> +			 * trying to shutdown this object at the same time
>> +			 * since we hold the list lock.
>> +			 */
>> +			irqfd_deactivate(irqfd);
>> +
>> +		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
>>  	}
>> =20
>> +
>>    =20
>
> extra empty line
>  =20

Ack
>  =20
>>  	return 0;
>>  }
>> =20
>> @@ -102,6 +157,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>  {
>>  	struct _irqfd *irqfd;
>>  	struct file *file =3D NULL;
>> +	struct eventfd_ctx *eventfd =3D NULL;
>>  	int ret;
>>  	unsigned int events;
>> =20
>> @@ -113,6 +169,8 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>  	irqfd->gsi =3D gsi;
>>  	INIT_LIST_HEAD(&irqfd->list);
>>  	INIT_WORK(&irqfd->inject, irqfd_inject);
>> +	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>> +	irqfd->active =3D true;
>> =20
>>  	file =3D eventfd_fget(fd);
>>  	if (IS_ERR(file)) {
>> @@ -120,6 +178,14 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int f=
lags)
>>  		goto fail;
>>  	}
>> =20
>> +	eventfd =3D eventfd_ctx_fileget(file);
>> +	if (IS_ERR(file)) {
>> +		ret =3D PTR_ERR(file);
>> +		goto fail;
>> +	}
>> +
>> +	irqfd->eventfd =3D eventfd;
>> +
>>  	/*
>>  	 * Install our own custom wake-up handling so we are notified via
>>  	 * a callback whenever someone signals the underlying eventfd
>> @@ -129,12 +195,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int =
flags)
>> =20
>>  	events =3D file->f_op->poll(file, &irqfd->pt);
>> =20
>> -	mutex_lock(&kvm->lock);
>> -	list_add_tail(&irqfd->list, &kvm->irqfds);
>> -	mutex_unlock(&kvm->lock);
>> +	spin_lock_irq(&kvm->irqfds.lock);
>> +	list_add_tail(&irqfd->list, &kvm->irqfds.items);
>> +	spin_unlock_irq(&kvm->irqfds.lock);
>> =20
>>  	/*
>> -	 * Check if there was an event already queued
>> +	 * Check if there was an event already pending on the eventfd
>> +	 * before we registered, and trigger it as if we didn't miss it.
>>  	 */
>>  	if (events & POLLIN)
>>  		schedule_work(&irqfd->inject);
>> @@ -148,6 +215,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>  	return 0;
>> =20
>>  fail:
>> +	if (eventfd && !IS_ERR(eventfd))
>> +		eventfd_ctx_put(eventfd);
>> +
>>  	if (file && !IS_ERR(file))
>>  		fput(file);
>> =20
>> @@ -158,24 +228,52 @@ fail:
>>  void
>>  kvm_irqfd_init(struct kvm *kvm)
>>  {
>> -	INIT_LIST_HEAD(&kvm->irqfds);
>> +	spin_lock_init(&kvm->irqfds.lock);
>> +	INIT_LIST_HEAD(&kvm->irqfds.items);
>>  }
>> =20
>> +/*
>> + * This function is called as the kvm VM fd is being released. Shutdo=
wn all
>> + * irqfds that still remain open
>> + */
>>  void
>>  kvm_irqfd_release(struct kvm *kvm)
>>  {
>>  	struct _irqfd *irqfd, *tmp;
>> =20
>> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
>> -		if (irqfd->wqh)
>> -			remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +	spin_lock_irq(&kvm->irqfds.lock);
>> =20
>> -		flush_work(&irqfd->inject);
>> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
>> +		irqfd_deactivate(irqfd);
>> =20
>> -		mutex_lock(&kvm->lock);
>> -		list_del(&irqfd->list);
>> -		mutex_unlock(&kvm->lock);
>> +	spin_unlock_irq(&kvm->irqfds.lock);
>> +
>> +	/*
>> +	 * Block until we know all outstanding shutdown jobs have completed
>> +	 * since we do not take a kvm* reference.
>> +	 */
>> +	flush_workqueue(irqfd_cleanup_wq);
>> =20
>> -		kfree(irqfd);
>> -	}
>>  }
>> +
>> +/*
>> + * create a host-wide workqueue for issuing deferred shutdown request=
s
>> + * aggregated from all vm* instances. We need our own isolated single=
-thread
>> + * queue to prevent deadlock against flushing the normal work-queue.
>> + */
>> +static int __init irqfd_module_init(void)
>> +{
>> +	irqfd_cleanup_wq =3D create_singlethread_workqueue("kvm-irqfd-cleanu=
p");
>> +	if (!irqfd_cleanup_wq)
>> +		return -ENOMEM;
>> +
>> +	return 0;
>> +}
>> +
>> +static void __exit irqfd_module_exit(void)
>> +{
>> +	destroy_workqueue(irqfd_cleanup_wq);
>> +}
>> +
>> +module_init(irqfd_module_init);
>> +module_exit(irqfd_module_exit);
>>    =20



--------------enig59E3250B10C33E8CAA33A1DE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpI8UwACgkQlOSOBdgZUxm2ewCgjRh1ievOdubXZw4tT2BRwB70
/noAn00wUcWmXritrsj9UjI6mxtSi8ZI
=si6S
-----END PGP SIGNATURE-----

--------------enig59E3250B10C33E8CAA33A1DE--
