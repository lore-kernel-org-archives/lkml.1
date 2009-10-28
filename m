Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZJ1NUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZJ1NUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZJ1NUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:20:46 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:51016 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZJ1NUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Jl9AqBO4aFycouMBmovjMrKFN0vusr7UECVr3OtaioM9gxMew7PynqGAH5ztPXZ9ii
         k+FE2gH36bttsh23XPTJxYSpr/cL16KRHDP0jaMLJlfhjtAhKNBdjGztpIAntiRyAOwD
         sImHQBPON+daG+QnfreBqVIoFPoKGUQ9K3tM8=
Message-ID: <4AE8452A.4010203@gmail.com>
Date: Wed, 28 Oct 2009 09:20:42 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 3/3] KVM: Directly inject interrupts if they support
 lockless operation
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162208.23704.19953.stgit@dev.haskins.net> <20091027174515.GA14421@redhat.com> <4AE741F0.1030509@gmail.com> <20091028073550.GA22784@redhat.com>
In-Reply-To: <20091028073550.GA22784@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3DBA0FDB9A8EEF719B39FF05"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3DBA0FDB9A8EEF719B39FF05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2009 at 02:54:40PM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> On Mon, Oct 26, 2009 at 12:22:08PM -0400, Gregory Haskins wrote:
>>>> IRQFD currently uses a deferred workqueue item to execute the inject=
ion
>>>> operation.  It was originally designed this way because kvm_set_irq(=
)
>>>> required the caller to hold the irq_lock mutex, and the eventfd call=
back
>>>> is invoked from within a non-preemptible critical section.
>>>>
>>>> With the advent of lockless injection support for certain GSIs, the
>>>> deferment mechanism is no longer technically needed in all cases.
>>>> Since context switching to the workqueue is a source of interrupt
>>>> latency, lets switch to a direct method whenever possible.  Fortunat=
ely
>>>> for us, the most common use of irqfd (MSI-based GSIs) readily suppor=
t
>>>> lockless injection.
>>>>
>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>> This is a useful optimization I think.
>>> Some comments below.
>>>
>>>> ---
>>>>
>>>>  virt/kvm/eventfd.c |   31 +++++++++++++++++++++++++++----
>>>>  1 files changed, 27 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>>> index 30f70fd..e6cc958 100644
>>>> --- a/virt/kvm/eventfd.c
>>>> +++ b/virt/kvm/eventfd.c
>>>> @@ -51,20 +51,34 @@ struct _irqfd {
>>>>  	wait_queue_t              wait;
>>>>  	struct work_struct        inject;
>>>>  	struct work_struct        shutdown;
>>>> +	void (*execute)(struct _irqfd *);
>>>>  };
>>>> =20
>>>>  static struct workqueue_struct *irqfd_cleanup_wq;
>>>> =20
>>>>  static void
>>>> -irqfd_inject(struct work_struct *work)
>>>> +irqfd_inject(struct _irqfd *irqfd)
>>>>  {
>>>> -	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject)=
;
>>>>  	struct kvm *kvm =3D irqfd->kvm;
>>>> =20
>>>>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>>>  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>>>  }
>>>> =20
>>>> +static void
>>>> +irqfd_deferred_inject(struct work_struct *work)
>>>> +{
>>>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject)=
;
>>>> +
>>>> +	irqfd_inject(irqfd);
>>>> +}
>>>> +
>>>> +static void
>>>> +irqfd_schedule(struct _irqfd *irqfd)
>>>> +{
>>>> +	schedule_work(&irqfd->inject);
>>>> +}
>>>> +
>>>>  /*
>>>>   * Race-free decouple logic (ordering is critical)
>>>>   */
>>>> @@ -126,7 +140,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, =
int sync, void *key)
>>>> =20
>>>>  	if (flags & POLLIN)
>>>>  		/* An event has been signaled, inject an interrupt */
>>>> -		schedule_work(&irqfd->inject);
>>>> +		irqfd->execute(irqfd);
>>>> =20
>>>>  	if (flags & POLLHUP) {
>>>>  		/* The eventfd is closing, detach from KVM */
>>>> @@ -179,7 +193,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gs=
i)
>>>>  	irqfd->kvm =3D kvm;
>>>>  	irqfd->gsi =3D gsi;
>>>>  	INIT_LIST_HEAD(&irqfd->list);
>>>> -	INIT_WORK(&irqfd->inject, irqfd_inject);
>>>> +	INIT_WORK(&irqfd->inject, irqfd_deferred_inject);
>>>>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>>>> =20
>>>>  	file =3D eventfd_fget(fd);
>>>> @@ -209,6 +223,15 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int g=
si)
>>>>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
>>>>  	spin_unlock_irq(&kvm->irqfds.lock);
>>>> =20
>>>> +	ret =3D kvm_irq_check_lockless(kvm, gsi);
>>>> +	if (ret < 0)
>>>> +		goto fail;
>>>> +
>>>> +	if (ret)
>>>> +		irqfd->execute =3D &irqfd_inject;
>>>> +	else
>>>> +		irqfd->execute =3D &irqfd_schedule;
>>>> +
>>> Can't gsi get converted from lockless to non-lockless
>>> after it's checked (by the routing ioctl)?
>> I think I protect against this in patch 2/3 by ensuring that any vecto=
rs
>> that are added have to conform to the same locking rules.  The code
>> doesn't support deleting routes, so we really only need to make sure
>> that new routes do not change.
>=20
> What I refer to, is when userspace calls KVM_SET_GSI_ROUTING.
> I don't see how your patch helps here: can't a GSI formerly
> used for MSI become unused, and then reused for non-MSI?
> If not, it's a problem I think, because I think userspace currently doe=
s this
> sometimes.

I see your point.  I was thinking vectors could only be added, not
deleted, but I see upon further inspection that is not the case.

>=20
>>> Kernel will crash then.
>>>
>>> How about, each time we get event from eventfd, we implement
>>> kvm_irqfd_toggle_lockless, which does a single scan, and returns
>>> true/false status (and I really mean toggle, let's not do set 1 / set=
 0
>>> as well) telling us whether interrupts could be delivered in a lockle=
ss
>>> manner?
>> I am not sure I like this idea in general given that I believe I alrea=
dy
>> handle the error case you are concerned with.
>>
>> However, the concept of providing a "toggle" option so we can avoid
>> scanning the list twice is a good one.  That can be done as a new patc=
h
>> series, but it would be a nice addition.
>>
>> Thanks Michael,
>> -Greg
>>
>=20
>=20



--------------enig3DBA0FDB9A8EEF719B39FF05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkroRSoACgkQP5K2CMvXmqFZ4wCcCfxBRRux4NRT33WgHlo22twz
8KQAn0trxac2ZyBB203u2bfyFGLzi/r4
=Irp5
-----END PGP SIGNATURE-----

--------------enig3DBA0FDB9A8EEF719B39FF05--
