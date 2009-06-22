Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZFVUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZFVUGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZFVUGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:06:32 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:45887 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZFVUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=bCC7/0NwuEHfkxkknBKKnzu3QJOXSs9IVjR1eH4JpGdhMKr50H6yuUwD9tZnlED9cp
         3o8qpIo5zMZgNP6d3C5bBDsR9xk7pIhaQ+fcKJzcCt+To+EOFAhwYYLtCSIP3GSSnRyK
         RLUAVBfM9p8oAEPV/MmuI+PN6EuoDvPvYhw6M=
Message-ID: <4A3FE445.4090204@gmail.com>
Date: Mon, 22 Jun 2009 16:06:29 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7A9C102F221D93C36D3E8E02"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7A9C102F221D93C36D3E8E02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Mon, Jun 22, 2009 at 11:51:42AM -0700, Davide Libenzi wrote:
>>>  =20
>>>      =20
>>>> A file* based kernel-to-kernel interface is rather wrong IMO.
>>>>    =20
>>>>        =20
>>> But eventfd_ctx should work fine.
>>>  =20
>>>      =20
>> Yeah, and I guess we can always just say that qemu can't close the fd =
or
>> something.  Seems hacky, but it might work if Davide insists we need h=
is
>> change.
>>    =20
>
> Continuing here, since there's no reason of having many subthreads talk=
ing=20
> about the same thing.
> Can you make a detailed example of what you're trying to achieve (no Hi=
nt=20
> Mode, please)?
> As it sounds to me, that you need a consumer/producer reference countin=
g,=20
> to cover your scenario correctly.
>  =20

Well, one of them was already briefly mentioned (the PCI-passthrough
thing).  I am not personally working on this part (yet, anyway).

Another example of something I am actually working on as we speak would
be for this thing we are building called "virtual-bus".  It is a way to
build/deploy device models directly in the kernel.

In either of these cases, we have this concept of allowing the guest to
notify the host, or vice versa, that something happened.  Typically this
would be in reference to some chunk of shared memory, and the signaling
is telling the other side "I changed something, go look".

Without going into a ton of detail (unless, of course, you want it) is
that we are generalizing the signaling infrastructure (irqfd and
iosignalfd) so that something like PCI-passthrough or vbus are not
directly coupled to KVM.  They communicate to KVM purely in terms of
(among other things) these irqfd/iosignalfd interfaces.

Using vbus as an example (though others are similar):  vbus would
primarily exists as a kernel-model.  However, there would be a small
device model in qemu-kem userspace to publish something like a PCI
device that declares its resource requirements to the guest.   Some of
those requirements would be things like how many interrupts it needs,
and what IO ranges it supports, etc.  When the guest programs the PCI
space, it maps the resources from its own world into the virtual PCI
resources emulated in qemu.

So up in userspace, the vbus pci-device would have an open reference to
the kvm guest (derived from /dev/kvm) and an open reference to a vbus
(derived from /dev/vbus).  Lets call these kvmfd, and vbusfd,
respectively.  For something like an interrupt, we would hook the point
where the PCI-MSI interrupt is assigned, and would do the following:

gsi =3D kvm_irq_route_gsi();
fd =3D eventfd(0, 0);
ioctl(kvmfd, KVM_IRQFD_ASSIGN, {fd, gsi});
ioctl(vbusfd, VBUS_SHMSIGNAL_ASSIGN, {sigid, fd});

So userspace orchestrated the assignment of this one eventfd to a KVM
consumer, and a VBUS producer.  The two subsystems do not care about the
details of the other side of the link, per se.  VBUS just knows that it
can eventfd_signal() its memory region to tell whomever is listening
that it changed.  Likewise, KVM just knows to inject "gsi" when it gets
signalled.  You could equally have given "fd" to a userspace thread for
either producer or consumer roles, or any other combination.

If we were doing PCI-passthough, substitute the last SHMSIGNAL_ASSIGN
ioctl call with some PCI_PASSTHROUGH_ASSIGN verb and you get the idea.

The important thing is that once this is established, userspace doesn't
necessarily care about the fd anymore.  So now the question is: do we
keep it around for other things?  Do we keep it around because we don't
want KVM to see the POLLHUP, or do we address the "release" code so that
it works even if userspace issued close(fd) at this point.  I am not
sure what the answer is, but this is the scenario we are concerned with
in this thread.  In the example above, vbus is free to produce events on
its eventfd until it gets a SHMSIGNAL_DEASSIGN request.

-Greg

>
>
> - Davide
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig7A9C102F221D93C36D3E8E02
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/5EUACgkQP5K2CMvXmqFfjQCdHFB5mgPM4aoznJsHgPNshsC+
i+gAnRhFIfMGc/SVDJj5uu3X0E+Qn8g8
=xayJ
-----END PGP SIGNATURE-----

--------------enig7A9C102F221D93C36D3E8E02--
