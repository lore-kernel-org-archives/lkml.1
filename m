Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbZE0UHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbZE0UHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZE0UHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:07:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58750 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZE0UHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:07:32 -0400
Message-ID: <4A1D9D7B.9080507@novell.com>
Date: Wed, 27 May 2009 16:07:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com> <20090527184106.GA18463@redhat.com>
In-Reply-To: <20090527184106.GA18463@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAD9230FFEC2448A30BD4813D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAD9230FFEC2448A30BD4813D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, May 27, 2009 at 10:06:50AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> +static int
>>>> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>>>> +{
>>>> +	struct _irqfd *irqfd;
>>>> +	struct file *file =3D NULL;
>>>> +	int ret;
>>>> +
>>>> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>>> +	if (!irqfd)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	irqfd->kvm =3D kvm;
>>>> +	irqfd->gsi =3D gsi;
>>>> +	INIT_LIST_HEAD(&irqfd->list);
>>>> +	INIT_WORK(&irqfd->work, irqfd_inject);
>>>> +
>>>> +	/*
>>>> +	 * Embed the file* lifetime in the irqfd.
>>>> +	 */
>>>> +	file =3D fget(fd);
>>>> +	if (IS_ERR(file)) {
>>>> +		ret =3D PTR_ERR(file);
>>>> +		goto fail;
>>>> +	}
>>>>    =20
>>>>        =20
>>> So we get a reference to a file, and unless the user is nice to us, i=
t
>>> will only be dropped when kvm char device file is closed?
>>> I think this will deadlock if the fd in question is the open kvm char=
 device.
>>>
>>>
>>>  =20
>>>      =20
>> Hmm...I hadn't considered this possibility, though I am not sure if it=

>> would cause a deadlock in the pattern you suggest.  It seems more like=

>> it would result in, at worst, an extra reference to itself (and thus a=

>> leak) rather than a deadlock...
>>
>> I digress.  In either case, perhaps I should s/fget/eventfd_fget to at=

>> least limit the type of fd to eventfd.  I was trying to be "slick" by
>> not needing the eventfd_fget() exported, but I am going to need to
>> export it later anyway for iosignalfd, so its probably a moot point.
>>
>> Thanks Michael,
>> -Greg
>>
>>    =20
>
> This only works as long as eventfd does not do fget on some fd as well.=

> Which it does not do now, and may never do - but we create a fragile
> system this way.
>
> I think it's really wrong, fundamentally, to keep a reference to a
> file until another file is closed, unless you are code under fs/.
> We will get nasty circular references sooner or later.
>  =20

Hmm.. I understand your concern, but I respectfully disagree.

One object referencing another is a natural expression, regardless of
what type they may be.  The fact is that introducing the concept of
irqfd creates a relationship between an eventfd instance and a kvm
instance whether we like it or not, and this relationship needs to be
managed.  It is therefore IMO perfectly natural to express that
relationship with a reference count, and I do not currently see anything
wrong or even particularly fragile about how I've currently done this.=20
I'm sure there are other ways, however.  Do you have a particular
suggestion in mind?

> Isn't the real reason we use fd to be able to support the same interfac=
e
> on top of both kvm and lguest?
>  =20

Actually, the reason why we use an fd is to decouple the
interrupt-producing end-point from the KVM core.  Ignoring eventfd in
specific for a moment, one convenient way to do that is with an fd
because it provides a nice, already written/tested handle-to-pointer
translation, and a polymorphic interface (e.g. f_ops).  Choosing to use
eventfd flavored fd's buys us additional advantages in terms of
leveraging already tested f_ops code, and compatibility with an
interface that is designed-for/used-by other established subsystems for
signaling.
> And if so, wouldn't some kind of bus be a better solution?
>  =20

Ultimately I aim to implement a bus (vbus, specifically) in terms of
irqfd (and iosignalfd, for that matter).  However, the eventfd
interfaces are general purpose and can be used in other areas as well
(for instance, virtio-pci, or the shared-mem driver recently
discussed).  I realize this is probably not the point you were making
here, but fyi.

Regards,
-Greg



--------------enigAD9230FFEC2448A30BD4813D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodnX4ACgkQlOSOBdgZUxkA2wCfe2mAJKS2NPptmZ/bZHRhjBWA
fIQAn3BLt3tmnEUaLYnijCdo3VhURUGj
=q4UO
-----END PGP SIGNATURE-----

--------------enigAD9230FFEC2448A30BD4813D--
