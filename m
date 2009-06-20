Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZFTCJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZFTCJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 22:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZFTCJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 22:09:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50252 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZFTCJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 22:09:38 -0400
Message-ID: <4A3C44DA.7000503@novell.com>
Date: Fri, 19 Jun 2009 22:09:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFBE4C346CCD9103FA9E324F9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFBE4C346CCD9103FA9E324F9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Fri, 19 Jun 2009, Davide Libenzi wrote:
>
>  =20
>> On Fri, 19 Jun 2009, Gregory Haskins wrote:
>>
>>    =20
>>> I am fairly confident it is not that simple after having thought abou=
t
>>> this issue over the last few days.  But I've been wrong in the past. =

>>> Propose a patch and I will review it for races/correctness, if you
>>> like.  Perhaps a combination of that plus your asymmetrical locking
>>> scheme would work.  One of the challenges you will hit is avoiding AB=
BA
>>> between your "get" lock and the wqh, but good luck!
>>>      =20
>> A patch for what? The eventfd patch is a one-liner.
>>    =20

Yes, understood.  What I was trying to gently say is that the one-liner
proposal alone is still broken afaict.  However, if there is another
solution that works that you like better than 133-liner I posted, I am
more than willing to help analyze it.  In the end, I only care that this
is fixed.

>> It seems hard to believe that the thing cannot be handled on your side=
=2E=20
>> Once the wake_up_locked() is turned into a wake_up(), what other races=
 are=20
>> there?
>>    =20
>
> AFAICS, the IRQfd code simply registers the callback to ->poll() and wa=
its=20
> for two events.
> In the POLLIN event, you schedule_work(&irqfd->inject) and there are no=
=20
> races there AFAICS (you basically do not care of anything eventfd memor=
y=20
> related at all).
> For POLLHUP, you do:
>
> 	spin_lock(irqfd->slock);
> 	if (irqfd->wqh)
> 		schedule_work(&irqfd->inject);
> 	irqfd->wqh =3D NULL;
> 	spin_unlock(irqfd->slock);
>
> In your work function you notice the POLLHUP condition and take proper =

> action (dunno what it is in your case).
> In your kvm_irqfd_release() function:
>
> 	spin_lock(irqfd->slock);
> 	if (irqfd->wqh)
> 		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> 	irqfd->wqh =3D NULL;
> 	spin_unlock(irqfd->slock);
>
> Any races in there?
>  =20

Yes, for one you have an ABBA deadlock on the irqfd->slock and wqh->lock
(recall wqh has to be locked to fix that other race I mentioned).

(As a hint, I think I fixed 4-5 races with these patches, so there are a
few others still lurking as well)

-Greg



--------------enigFBE4C346CCD9103FA9E324F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko8RNoACgkQlOSOBdgZUxltdgCeM5z0qnEl7bU1mnkPXDaJiJGC
dlAAoIDHZ7R9N+IuEMgsviKo4P5K2FXg
=JFqY
-----END PGP SIGNATURE-----

--------------enigFBE4C346CCD9103FA9E324F9--
