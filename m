Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZD0N2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZD0N2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZD0N2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:28:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52302 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZD0N2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:28:04 -0400
Message-ID: <49F5B2DA.5060207@novell.com>
Date: Mon, 27 Apr 2009 09:27:54 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com>
In-Reply-To: <49F58D75.7040304@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F746A918E0026913F3D452D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F746A918E0026913F3D452D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>>> This allows an eventfd to be registered as an irq source with a
>>>> guest.  Any
>>>> signaling operation on the eventfd (via userspace or kernel) will
>>>> inject
>>>> the registered GSI at the next available window.
>>>>
>>>> =20
>>>> +struct kvm_irqfd {
>>>> +    __u32 fd;
>>>> +    __u32 gsi;
>>>> +};
>>>> +
>>>>        =20
>>> I think it's better to have ioctl create and return the fd.  This way=

>>> we aren't tied to eventfd (though it makes a lot of sense to use it).=

>>>    =20
>>
>> I dont mind either way, but I am not sure it buys us much as the one
>> driving the fd would need to understand if the interface is
>> eventfd-esque or something else anyway.  Let me know if you still want=

>> to see this changed.
>>  =20
>
> Sure, the interface remains the same (write 8 bytes), but the
> implementation can change.  For example, we can implement it to work
> from interrupt context, once we hack the locking appropriately.

I was thinking more along the lines of eventfd_signal().  AIO and vbus
currently use this interface, as opposed to the more polymorhpic
f_ops->write().

>
>
>>>> +static void
>>>> +irqfd_inject(struct work_struct *work)
>>>> +{
>>>> +    struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work=
);
>>>> +    struct kvm *kvm =3D irqfd->kvm;
>>>> +
>>>> +    mutex_lock(&kvm->lock);
>>>> +    kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
>>>>        =20
>>> Need to lower the irq too (though irqfd only supports edge triggered
>>> interrupts).
>>>
>>>    =20
>> Should I just do back-to-back 1+0 inside the same lock?
>>
>>  =20
>
> Yes.  Might be nice to add a kvm_toggle_irq(), but let's leave that
> until later.

Ok.

>
>
> =20
>
>>> One day we'll have lockless injection and we'll want to drop this.  I=

>>> guess if we create the fd ourselves we can make it work, but I don't
>>> see how we can do this with eventfd.
>>>
>>>    =20
>>
>> Hmm...this is a good point.  There probably is no way to use eventfd
>> "off the shelf" in a way that doesn't cause this callback to be in a
>> critical section.  Should we just worry about switching away from
>> eventfd when this occurs, or should I implement a custom anon-fd now?
>>  =20
>
> I'd just go with eventfd, and switch when it becomes relevant.  As
> long as the kernel allocates the fd, we're free to do as we like.

Sounds good.

-Greg



--------------enig8F746A918E0026913F3D452D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn1stoACgkQlOSOBdgZUxmJzQCfbMEuNabXS39nXojFMZuLsVRI
wRoAnRcViorj78pqpub5FD7awV+usnrL
=oXlY
-----END PGP SIGNATURE-----

--------------enig8F746A918E0026913F3D452D--
