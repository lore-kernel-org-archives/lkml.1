Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZJ0Sym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZJ0Sym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZJ0Syl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:54:41 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62240 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbZJ0Syk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=KdMXcX4FGiyuDMiFImZ7CfhqnS87AnCDxMVCQwrEef/nk+akKkVmHIu7PyBOnOwl9M
         mZo1UlhIKolZ6JWPb2so129UzVMyhohUIYtRDsrCdXoVed/LkakPB6ua2cnFHmafyzJP
         dH6XHApFDY2Rrz7GE/iA0zh0SY0mHKZTFcSxI=
Message-ID: <4AE741F0.1030509@gmail.com>
Date: Tue, 27 Oct 2009 14:54:40 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 3/3] KVM: Directly inject interrupts if they support
 lockless operation
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162208.23704.19953.stgit@dev.haskins.net> <20091027174515.GA14421@redhat.com>
In-Reply-To: <20091027174515.GA14421@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA3F56A2AB4B53DF50822CAC7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA3F56A2AB4B53DF50822CAC7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Oct 26, 2009 at 12:22:08PM -0400, Gregory Haskins wrote:
>> IRQFD currently uses a deferred workqueue item to execute the injectio=
n
>> operation.  It was originally designed this way because kvm_set_irq()
>> required the caller to hold the irq_lock mutex, and the eventfd callba=
ck
>> is invoked from within a non-preemptible critical section.
>>
>> With the advent of lockless injection support for certain GSIs, the
>> deferment mechanism is no longer technically needed in all cases.
>> Since context switching to the workqueue is a source of interrupt
>> latency, lets switch to a direct method whenever possible.  Fortunatel=
y
>> for us, the most common use of irqfd (MSI-based GSIs) readily support
>> lockless injection.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>=20
> This is a useful optimization I think.
> Some comments below.
>=20
>> ---
>>
>>  virt/kvm/eventfd.c |   31 +++++++++++++++++++++++++++----
>>  1 files changed, 27 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 30f70fd..e6cc958 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -51,20 +51,34 @@ struct _irqfd {
>>  	wait_queue_t              wait;
>>  	struct work_struct        inject;
>>  	struct work_struct        shutdown;
>> +	void (*execute)(struct _irqfd *);
>>  };
>> =20
>>  static struct workqueue_struct *irqfd_cleanup_wq;
>> =20
>>  static void
>> -irqfd_inject(struct work_struct *work)
>> +irqfd_inject(struct _irqfd *irqfd)
>>  {
>> -	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject);
>>  	struct kvm *kvm =3D irqfd->kvm;
>> =20
>>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>  }
>> =20
>> +static void
>> +irqfd_deferred_inject(struct work_struct *work)
>> +{
>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject);
>> +
>> +	irqfd_inject(irqfd);
>> +}
>> +
>> +static void
>> +irqfd_schedule(struct _irqfd *irqfd)
>> +{
>> +	schedule_work(&irqfd->inject);
>> +}
>> +
>>  /*
>>   * Race-free decouple logic (ordering is critical)
>>   */
>> @@ -126,7 +140,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, in=
t sync, void *key)
>> =20
>>  	if (flags & POLLIN)
>>  		/* An event has been signaled, inject an interrupt */
>> -		schedule_work(&irqfd->inject);
>> +		irqfd->execute(irqfd);
>> =20
>>  	if (flags & POLLHUP) {
>>  		/* The eventfd is closing, detach from KVM */
>> @@ -179,7 +193,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)=

>>  	irqfd->kvm =3D kvm;
>>  	irqfd->gsi =3D gsi;
>>  	INIT_LIST_HEAD(&irqfd->list);
>> -	INIT_WORK(&irqfd->inject, irqfd_inject);
>> +	INIT_WORK(&irqfd->inject, irqfd_deferred_inject);
>>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>> =20
>>  	file =3D eventfd_fget(fd);
>> @@ -209,6 +223,15 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi=
)
>>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
>>  	spin_unlock_irq(&kvm->irqfds.lock);
>> =20
>> +	ret =3D kvm_irq_check_lockless(kvm, gsi);
>> +	if (ret < 0)
>> +		goto fail;
>> +
>> +	if (ret)
>> +		irqfd->execute =3D &irqfd_inject;
>> +	else
>> +		irqfd->execute =3D &irqfd_schedule;
>> +
>=20
> Can't gsi get converted from lockless to non-lockless
> after it's checked (by the routing ioctl)?

I think I protect against this in patch 2/3 by ensuring that any vectors
that are added have to conform to the same locking rules.  The code
doesn't support deleting routes, so we really only need to make sure
that new routes do not change.

> Kernel will crash then.
>=20
> How about, each time we get event from eventfd, we implement
> kvm_irqfd_toggle_lockless, which does a single scan, and returns
> true/false status (and I really mean toggle, let's not do set 1 / set 0=

> as well) telling us whether interrupts could be delivered in a lockless=

> manner?

I am not sure I like this idea in general given that I believe I already
handle the error case you are concerned with.

However, the concept of providing a "toggle" option so we can avoid
scanning the list twice is a good one.  That can be done as a new patch
series, but it would be a nice addition.

Thanks Michael,
-Greg


--------------enigA3F56A2AB4B53DF50822CAC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnQfAACgkQP5K2CMvXmqFCoQCeNBtPkv5cOuj5aFy4Q2c8iccW
jEgAoIlSsgJyLKQBtPTXmVl96eigeo8+
=vhUE
-----END PGP SIGNATURE-----

--------------enigA3F56A2AB4B53DF50822CAC7--
