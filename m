Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGFQDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGFQDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZGFQDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:03:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56535 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZGFQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:03:42 -0400
Message-ID: <4A522050.7030200@novell.com>
Date: Mon, 06 Jul 2009 12:03:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net> <20090706155850.GA12399@redhat.com>
In-Reply-To: <20090706155850.GA12399@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0085E8F29342442E554F080C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0085E8F29342442E554F080C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jul 02, 2009 at 11:38:22AM -0400, Gregory Haskins wrote:
>  =20
>> We currently create this wq on module_init, which may be wasteful if t=
he
>> host never creates a guest that uses irqfd.  This patch changes the
>> algorithm so that the workqueue is only created when at least one gues=
t
>> is using irqfd.  The queue is cleaned up when the last guest using irq=
fd
>> is shutdown.
>>
>> To keep things simple, we only check whether the guest has tried to cr=
eate
>> an irqfd, not whether there are actually irqfds active.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  include/linux/kvm_host.h |    1=20
>>  virt/kvm/eventfd.c       |  100 ++++++++++++++++++++++++++++++++++---=
---------
>>  2 files changed, 75 insertions(+), 26 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 8e04a34..cd1a0f3 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -149,6 +149,7 @@ struct kvm {
>>  	struct {
>>  		spinlock_t        lock;
>>  		struct list_head  items;
>> +		bool              init;
>>  	} irqfds;
>>  #endif
>>  	struct kvm_vm_stat stat;
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 4092b8d..fcc3469 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -49,7 +49,16 @@ struct _irqfd {
>>  	struct work_struct        shutdown;
>>  };
>> =20
>> -static struct workqueue_struct *irqfd_cleanup_wq;
>> +struct _irqfd_cleanup {
>> +	struct mutex             lock;
>> +	int                      refs;
>> +	struct workqueue_struct *wq;
>> +};
>> +
>> +static struct _irqfd_cleanup irqfd_cleanup =3D {
>> +	.lock =3D __MUTEX_INITIALIZER(irqfd_cleanup.lock),
>> +	.refs =3D 0,
>> +};
>> =20
>>  static void
>>  irqfd_inject(struct work_struct *work)
>> @@ -110,7 +119,7 @@ irqfd_deactivate(struct _irqfd *irqfd)
>> =20
>>  	list_del_init(&irqfd->list);
>> =20
>> -	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
>> +	queue_work(irqfd_cleanup.wq, &irqfd->shutdown);
>>  }
>> =20
>>  /*
>> @@ -161,6 +170,62 @@ irqfd_ptable_queue_proc(struct file *file, wait_q=
ueue_head_t *wqh,
>>  	add_wait_queue(wqh, &irqfd->wait);
>>  }
>> =20
>> +/*
>> + * create a host-wide workqueue for issuing deferred shutdown request=
s
>> + * aggregated from all vm* instances. We need our own isolated single=
-thread
>> + * queue to prevent deadlock against flushing the normal work-queue.
>> + */
>> +static int
>> +irqfd_cleanup_init(struct kvm *kvm)
>> +{
>> +	int ret =3D 0;
>> +
>> +	mutex_lock(&irqfd_cleanup.lock);
>> +
>> +	/*
>> +	 * Check the current init state from within the lock so that we
>> +	 * sync all users to the thread creation.
>> +	 */
>> +	if (kvm->irqfds.init)
>> +		goto out;
>> +
>> +	if (!irqfd_cleanup.refs) {
>> +		struct workqueue_struct *wq;
>> +
>> +		wq =3D create_singlethread_workqueue("kvm-irqfd-cleanup");
>> +		if (!wq) {
>> +			ret =3D -ENOMEM;
>> +			goto out;
>> +		}
>> +
>> +		irqfd_cleanup.wq =3D wq;
>> +	}
>> +
>> +	irqfd_cleanup.refs++;
>> +	kvm->irqfds.init =3D true;
>> +
>> +out:
>> +	mutex_unlock(&irqfd_cleanup.lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static void
>> +irqfd_cleanup_release(struct kvm *kvm)
>> +{
>> +	if (!kvm->irqfds.init)
>> +		return;
>>    =20
>
> init is checked outside the lock here.
> Why?
>  =20

Guest is shutting down via vmfd->f_ops->release() and is already
guaranteed to be single-threaded, so proper locking is not really
important.  Probably should document that, though ;)
>  =20
>> +
>> +	mutex_lock(&irqfd_cleanup.lock);
>> +
>> +	if (!(--irqfd_cleanup.refs))
>> +		destroy_workqueue(irqfd_cleanup.wq);
>> +
>> +	mutex_unlock(&irqfd_cleanup.lock);
>> +
>> +	kvm->irqfds.init =3D false;
>>    =20
>
> ... and cleaned outside the lock as well.
>
>  =20
Ditto

>> +}
>> +
>>  static int
>>  kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>>  {
>> @@ -170,6 +235,10 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi=
)
>>  	int ret;
>>  	unsigned int events;
>> =20
>> +	ret =3D irqfd_cleanup_init(kvm);
>> +	if (ret < 0)
>> +		return ret;
>> +
>>  	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>  	if (!irqfd)
>>  		return -ENOMEM;
>> @@ -268,7 +337,7 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gs=
i)
>>  	 * so that we guarantee there will not be any more interrupts on thi=
s
>>  	 * gsi once this deassign function returns.
>>  	 */
>> -	flush_workqueue(irqfd_cleanup_wq);
>> +	flush_workqueue(irqfd_cleanup.wq);
>> =20
>>  	return 0;
>>  }
>> @@ -302,28 +371,7 @@ kvm_irqfd_release(struct kvm *kvm)
>>  	 * Block until we know all outstanding shutdown jobs have completed
>>  	 * since we do not take a kvm* reference.
>>  	 */
>> -	flush_workqueue(irqfd_cleanup_wq);
>> -
>> -}
>> -
>> -/*
>> - * create a host-wide workqueue for issuing deferred shutdown request=
s
>> - * aggregated from all vm* instances. We need our own isolated single=
-thread
>> - * queue to prevent deadlock against flushing the normal work-queue.
>> - */
>> -static int __init irqfd_module_init(void)
>> -{
>> -	irqfd_cleanup_wq =3D create_singlethread_workqueue("kvm-irqfd-cleanu=
p");
>> -	if (!irqfd_cleanup_wq)
>> -		return -ENOMEM;
>> -
>> -	return 0;
>> -}
>> +	flush_workqueue(irqfd_cleanup.wq);
>> +	irqfd_cleanup_release(kvm);
>> =20
>> -static void __exit irqfd_module_exit(void)
>> -{
>> -	destroy_workqueue(irqfd_cleanup_wq);
>>  }
>> -
>> -module_init(irqfd_module_init);
>> -module_exit(irqfd_module_exit);
>>    =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>  =20



--------------enig0085E8F29342442E554F080C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpSIFMACgkQlOSOBdgZUxnJZwCeKoqa2fZV6zynMXJCF/dz1gHW
8BoAn1zWYUdN04wS+TYTRVnq0C4qn12S
=J2yQ
-----END PGP SIGNATURE-----

--------------enig0085E8F29342442E554F080C--
