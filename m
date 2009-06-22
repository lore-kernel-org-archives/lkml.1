Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZFVScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZFVScS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFVScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:32:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36474 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZFVScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:32:02 -0400
Message-ID: <4A3FCDF2.3010903@novell.com>
Date: Mon, 22 Jun 2009 14:31:14 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC3C1F306BB9A3595AE5E2FA1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC3C1F306BB9A3595AE5E2FA1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> I am probably confused or perhaps have the wrong terminology, but isnt=

>> that "ok".  I am concerned about the consumer (the guy getting the
>> POLLINs) to be able to detect POLLHUP when the last producer
>> (f_ops->write() from userspace, eventfd_signal() from kernel) goes awa=
y.
>>
>> Consider the following sequence:
>>
>> -------------------
>>
>> userspace calls "fd =3D eventfd()", and gives one to KVM as an irqfd, =
and
>> the other to some PCI-passthrough device.
>>
>> The kvm/irqfd side acquires a kref, the pci side acquires a file.  At
>> this moment, userspace has the fd, and the pci device has the file (fo=
r
>> eventfd_signal()).  The fget() count is 2.  Userspace closes the fd
>> because its done with it, and the count drops to 1.
>>
>> Some time later, pci does an fput(), and KVM sees the POLLHUP and clea=
ns up.
>>
>> -------------------
>>
>> In this new model, the POLLHUP would have gone out as soon as userspac=
e
>> closed the fd, even though the intended producer (the PCI device) and
>> the consumer (the KVM guest) are still up and running.  This doesnt se=
em
>> right to me.  Or am I missing something?
>>    =20
>
> What you're doing there, is setting up a kernel-to-kernel (since=20
> userspace only role is to create the eventfd) communication, using a fi=
le*=20
> as accessory. That IMO is plain wrong.
> If userspace is either the producer, or the consumer, and you need to=20
> handle userspace leaving the building, you need to:
>
> 	file =3D eventfd_fget(fd);
> 	ctx =3D eventfd_ctx_get(file); /* Eventually, if producer */
> 	eventfd_pollcb_register(file, ...);
> 	fput(file);
>
> In your case of kernel-to-kernel scenario, why would you need eventfd a=
t=20
> all, if userspace role in that model is simply to create it?
>  =20

The general thesis is for decoupling of the two subsystems.  In order to
do this, you need some form of polymorphism and an intermediate "handle"
mechanism which is userspace friendly.  File-descriptors already fit
this role neatly, with the "int fd" being the handle, and the f_ops
being the polymorphic interface.  Eventfd is of course, a subclass of
this concept in that it has these same general properties but with
signaling semantics (non-blocking collapsible events, etc).

Say, for example, you wanted disk IO completion events to generate an
interrupt into a guest.  One way to do this would, of course, modify all
the disk-io code so it knows how to directly inject a KVM guest
interrupt.   While this would work, someone would undoubtedly get flamed
for such a suggestion ;)

Another way to do it is to treat the AIO eventfd as the hook point.=20
IIUC AIO already knows how to be an eventfd producer.  KVM, by virtue of
irqfd, already knows how to be an eventfd consumer.  So now kvm can
consume AIO, or it can consume userspace events equally well, and
without modification.  Neither side needs to know about the other per
se, other than the details on how to use the eventfd interface.

Don't get me wrong:  We expect userspace to use all this stuff too.  I
just expect that we will see all permutations of producer/consumer +
userspace/kernel combinations, so I want to retain that "all producers
have left" notification feature set.  Today eventfd supports producers
or consumers in userspace, and producers in the kernel.  This new work
we are doing adds consumer support in the kernel.  Kernel to kernel is
just a natural extension of that.

-Greg

> There are more effective ways to have in kernel communication channels,=
=20
> than resorting to userspace link facilities like eventfd.
>
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



--------------enigC3C1F306BB9A3595AE5E2FA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/zfIACgkQlOSOBdgZUxnd/QCgg8Wd5kWSXk413J/NY9H5CNZe
/GIAnRAOgJdI9ZUxXV7Ns7QREb3qE0kr
=Dc/Q
-----END PGP SIGNATURE-----

--------------enigC3C1F306BB9A3595AE5E2FA1--
