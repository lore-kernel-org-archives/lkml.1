Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZEESVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZEESVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZEESVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:21:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZEESVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=dKP6xWD4N2yYZnjf3qSPHIDqjN3kTmCxoq1Gfiu8os+ugLQcaE+HrhoXLdxIQz9o/6
         X5S7P4eyHx6t4Xryy6JuozKzvKdP56psa/N7NoPZDNKAdgCHhkjjnTZsvDBKASue0vND
         qHmsiAC/Cx3b+8KKApO+uGUhsKv9OjukRbZ1o=
Message-ID: <4A0083A9.8020900@gmail.com>
Date: Tue, 05 May 2009 14:21:29 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A005F05.30409@redhat.com> <4A007DDA.5000302@novell.com> <4A008127.7060406@redhat.com>
In-Reply-To: <4A008127.7060406@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC0E17A9DE20751204F0D8DB5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC0E17A9DE20751204F0D8DB5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Avi Kivity wrote:
>> =20
>>> Gregory Haskins wrote:
>>>
>>>   =20
>>>> +int
>>>> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
>>>> +{
>>>> +    struct _irqfd *irqfd;
>>>> +    struct file *file =3D NULL;
>>>> +    int fd =3D -1;
>>>> +    int ret;
>>>> +
>>>> +    irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>>> +    if (!irqfd)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    irqfd->kvm =3D kvm;
>>>>        =20
>>> You need to increase the refcount on struct kvm here.  Otherwise evil=

>>> userspace will create an irqfd, close the vm and vcpu fds, and inject=

>>> an interrupt.
>>>    =20
>>
>> I just reviewed the code in prep for v5, and now I remember why I didn=
t
>> take a reference:  I designed it the opposite direction:  the vm-fd ow=
ns
>> a reference to the irqfd, and will decouple the kvm context from the
>> eventfd on shutdown  (see kvm_irqfd_release()).   I still need to spin=
 a
>> v5 regardless in order to add the padding as previously discussed.  Bu=
t
>> let me know if you still see any holes in light of this alternate obje=
ct
>> lifetime approach I am using.
>>  =20
>
> Right, irqfd_release works.  But I think refcounting is simpler, since
> we already kvm_get_kvm() and kvm_put_kvm(), and you wouldn't need the
> irqfd list.  On the other hand, I'm not sure you get a callback from
> eventfd on close(), so refcounting may not be implementable.

;)

>
> Drat, irqfd_release doesn't work.  You reference kvm->lock in
> irqfd_inject without taking any locks.

I *think* this is ok, tho.  I remove myself from the waitq, and then
flush any potentially scheduled deferred work before returning.  This
all happens synchronously to the vm_release() code when the vm-fd is
bring dropped, but before we actually release the struct kvm*.=20
Therefore, I think kvm->lock is guaranteed to remain valid for the
duration of the irqfd_release(), and we guarantee it wont be accessed
after the irqfd_release() completes.  Or do you have a different concern?=


On this topic of proper ref counts, though....

I wonder if I need an extra fget() in there.  I presume that the
evenfd_file_create() returns with only a single reference, which
presumably I am handing one to userspace, and one to the irqfd.... which
is broken.  Or does fd_install() bump that for me (doesnt look like
it)?  Al, Davide, any comments?

>
> btw, there's still your original idea of creating the eventfd in
> userspace and passing it down.  That would be workable if we can see a
> way to both signal the eventfd and get called back in irq context.=20
> Maybe that's preferable to what we're doing here, but we need to see
> how it would work.

We can do that, but I don't see it as changing the general problem
here.  However, I think if you find that the above comments about the
kvm->lock w.r.t. irqfd_release() are ok, we don't need to worry about
it.  If you prefer the userspace allocation of eventfd() for other
reasons, we can easily go back to that model as well...but its not
strictly necessary for this particular issue iiuc.

-Greg


--------------enigC0E17A9DE20751204F0D8DB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoAg6kACgkQP5K2CMvXmqEZiQCeOCfZ6sRGe9vcAJGFCZyAIFCG
rtUAn30atdHcydwc1BfIa5QFjFcp4QVQ
=w+pM
-----END PGP SIGNATURE-----

--------------enigC0E17A9DE20751204F0D8DB5--
