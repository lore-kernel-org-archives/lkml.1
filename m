Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZFVRnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZFVRnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZFVRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:43:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54695 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZFVRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:43:46 -0400
Message-ID: <4A3FC2B1.4050107@novell.com>
Date: Mon, 22 Jun 2009 13:43:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13D2C9EAE96AB08EF7FBCBEA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13D2C9EAE96AB08EF7FBCBEA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Sun, 21 Jun 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> This looks great, Davide.  I am fairly certain I can now solve the r=
aces
>>>> and even implement Michael's DEASSIGN feature with this patch in pla=
ce.=20
>>>> I will actually fire it up tomorrow when I am back in the office and=

>>>> give it a spin, but I do not spy any more races via visual inspectio=
n.
>>>>
>>>> Kind Regards,
>>>> -Greg
>>>>
>>>> PS: I was wrong with my previous statement about requiring an embedd=
able
>>>> object (eventfd_notifier for me, eventfd_pollcb for you).  I think y=
ou
>>>> can technically solve this issue minimally by merely locking the POL=
LHUP
>>>> and exposing the kref.  However, I think that leads to an more awkwa=
rd
>>>> interface (e.g. we already have eventfd_fget() plus we add a new one=

>>>> like eventfd_refget(), which might confuse users), so I prefer what =
you
>>>> did here.  Just thought I would throw that out there in case you wou=
ld
>>>> prefer to change even fewer lines.
>>>>    =20
>>>>        =20
>>> I actually ended up exposing the eventfd context anyway, since IMO is=
 a=20
>>> better option instead of holding references to the eventfd file (that=
=20
>>> makes VFS people uneasy).
>>>  =20
>>>      =20
>> I liked "version - 1"  better ;)
>>
>> I think ultimately we still want to hold the fget() for
>> eventfd_signal(), as it is the producer side.  Without it, we have no
>> way of knowing when the last producer goes away if they happen to be a=
n
>> in-kernel user.
>>    =20
>
> No you don't. Holding a file* reference does not give you any assurance=
=20
> whatsoever that the last consumer did not go away. The f_count value wi=
ll=20
> simply be 1 (just you).
>  =20

I am probably confused or perhaps have the wrong terminology, but isnt
that "ok".  I am concerned about the consumer (the guy getting the
POLLINs) to be able to detect POLLHUP when the last producer
(f_ops->write() from userspace, eventfd_signal() from kernel) goes away.

Consider the following sequence:

-------------------

userspace calls "fd =3D eventfd()", and gives one to KVM as an irqfd, and=

the other to some PCI-passthrough device.

The kvm/irqfd side acquires a kref, the pci side acquires a file.  At
this moment, userspace has the fd, and the pci device has the file (for
eventfd_signal()).  The fget() count is 2.  Userspace closes the fd
because its done with it, and the count drops to 1.

Some time later, pci does an fput(), and KVM sees the POLLHUP and cleans =
up.

-------------------

In this new model, the POLLHUP would have gone out as soon as userspace
closed the fd, even though the intended producer (the PCI device) and
the consumer (the KVM guest) are still up and running.  This doesnt seem
right to me.  Or am I missing something?

Thanks Davide,
-Greg


--------------enig13D2C9EAE96AB08EF7FBCBEA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/wrEACgkQlOSOBdgZUxm7PgCfcIAZjgX7ozp9fl2VrTrIEUg8
CH8AnR+EO72hctlJj22dV6KcRKZzVN2M
=unaA
-----END PGP SIGNATURE-----

--------------enig13D2C9EAE96AB08EF7FBCBEA--
