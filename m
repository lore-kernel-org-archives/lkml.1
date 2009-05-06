Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbZEFPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbZEFPh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbZEFPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:37:47 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43158 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbZEFPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:37:46 -0400
Message-ID: <4A01AEC1.8020201@novell.com>
Date: Wed, 06 May 2009 11:37:37 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: viro@ZenIV.linux.org.uk, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC36982FA43A9EFF207183E8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC36982FA43A9EFF207183E8F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 6 May 2009, Gregory Haskins wrote:
>
>  =20
>> Al, Davide,
>>
>> Gregory Haskins wrote:
>>    =20
>>> +
>>> +int
>>> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
>>> +{
>>> +	struct _irqfd *irqfd;
>>> +	struct file *file =3D NULL;
>>> +	int fd =3D -1;
>>> +	int ret;
>>> +
>>> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>> +	if (!irqfd)
>>> +		return -ENOMEM;
>>> +
>>> +	irqfd->kvm =3D kvm;
>>> +	irqfd->gsi =3D gsi;
>>> +	INIT_LIST_HEAD(&irqfd->list);
>>> +	INIT_WORK(&irqfd->work, irqfd_inject);
>>> +
>>> +	/*
>>> +	 * We re-use eventfd for irqfd, and therefore will embed the eventf=
d
>>> +	 * lifetime in the irqfd.
>>> +	 */
>>> +	file =3D eventfd_file_create(0, 0);
>>> +	if (IS_ERR(file)) {
>>> +		ret =3D PTR_ERR(file);
>>> +		goto fail;
>>> +	}
>>> +
>>> +	irqfd->file =3D file;
>>> +
>>> +	/*
>>> +	 * Install our own custom wake-up handling so we are notified via
>>> +	 * a callback whenever someone signals the underlying eventfd
>>> +	 */
>>> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
>>> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
>>> +
>>> +	ret =3D file->f_op->poll(file, &irqfd->pt);
>>> +	if (ret < 0)
>>> +		goto fail;
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +	list_add_tail(&irqfd->list, &kvm->irqfds);
>>> +	mutex_unlock(&kvm->lock);
>>> +
>>> +	ret =3D get_unused_fd();
>>> +	if (ret < 0)
>>> +		goto fail;
>>> +
>>> +	fd =3D ret;
>>> +
>>> +	fd_install(fd, file);
>>>  =20
>>>      =20
>> Can you comment on whether this function needs to take an additional
>> reference on file here?  (one for the one held by userspace/fd, and th=
e
>> other for irqfd->file)  My instinct is telling me this may be currentl=
y
>> broken, but I am not sure.
>>    =20
>
> I don't know exactly how it is used, but looks broken.
Yeah, I think it is.  I addressed this in v5 so please review that
version if you have a moment.

>  If the fd is=20
> returned to userspace, and userspace closes the fd, you will leak the=20
> irqfd*. If you do an extra fget(), you will never know if the userspace=
=20
> closed the last-1 instance of the eventfd file*.
> What is likely needed, is add a callback to eventfd_file_create(), so t=
hat=20
> the eventfd can call your callback on ->release, and give you a chance =
to=20
> perform proper cleanup of the irqfd*.
>  =20

I think we are ok in this regard (at least in v5) without the callback.=20
kvm holds irqfd, which holds eventfd.  In a normal situation, we will
have eventfd with 2 references.  If userspace closes the eventfd, it
will drop 1 of the 2 eventfd file references, but the object should
remain intact as long as kvm still holds it as well.  When the kvm-fd is
released, we will then decouple from the eventfd->wqh and drop the last
fput(), officially freeing it.

Likewise, if kvm is closed before the eventfd, we will simply decouple
from the wqh and fput(eventfd), leaving the last reference held by
userspace until it closes as well.

Let me know if you see any holes in that.

Thanks Davide,
-Greg



--------------enigC36982FA43A9EFF207183E8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoBrsEACgkQlOSOBdgZUxm+/ACfbKIYwM0avkxnUSny/qbnjbUS
ud4AoIKteeUGrsGbNFXmRT6WnuJrOhtT
=ekNx
-----END PGP SIGNATURE-----

--------------enigC36982FA43A9EFF207183E8F--
