Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZFVQHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZFVQHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZFVQGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:06:02 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50404 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZFVQF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:05:56 -0400
Message-ID: <4A3FABD9.7080108@novell.com>
Date: Mon, 22 Jun 2009 12:05:45 -0400
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
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com> <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE006001E27278A36189AAC3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE006001E27278A36189AAC3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Sun, 21 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> This looks great, Davide.  I am fairly certain I can now solve the rac=
es
>> and even implement Michael's DEASSIGN feature with this patch in place=
=2E=20
>> I will actually fire it up tomorrow when I am back in the office and
>> give it a spin, but I do not spy any more races via visual inspection.=

>>
>> Kind Regards,
>> -Greg
>>
>> PS: I was wrong with my previous statement about requiring an embeddab=
le
>> object (eventfd_notifier for me, eventfd_pollcb for you).  I think you=

>> can technically solve this issue minimally by merely locking the POLLH=
UP
>> and exposing the kref.  However, I think that leads to an more awkward=

>> interface (e.g. we already have eventfd_fget() plus we add a new one
>> like eventfd_refget(), which might confuse users), so I prefer what yo=
u
>> did here.  Just thought I would throw that out there in case you would=

>> prefer to change even fewer lines.
>>    =20
>
> I actually ended up exposing the eventfd context anyway, since IMO is a=
=20
> better option instead of holding references to the eventfd file (that=20
> makes VFS people uneasy).
>  =20

I liked "version - 1"  better ;)

I think ultimately we still want to hold the fget() for
eventfd_signal(), as it is the producer side.  Without it, we have no
way of knowing when the last producer goes away if they happen to be an
in-kernel user.

Also, thinking about it some more, I think I like the non-wrapped pollcb
variant better now.  This is because I can uhook the wqh in the POLLHUP
and defer the kref_put() until later.  I think this combination gives me
the most ideal environment (even though technically I should not expect
more activity on the wait-queue after the POLLHUP).

In either case, I whipped up a super-lite patch with just the bare
minimum and then developed the KVM solution on top.  Things look really
good, now, and I am happy with the result.  As an aside, it only has the
following impact on the eventfd core:

 fs/eventfd.c            |   43 ++++++++++++++++++++++++++++++++++++-----=
--
 include/linux/eventfd.h |    7 +++++++
 2 files changed, 43 insertions(+), 7 deletions(-)

Ill post the series, including the KVM portions, for review.

Thanks Davide,
-Greg




--------------enigCE006001E27278A36189AAC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/q9oACgkQlOSOBdgZUxnHfgCeMu/sjifsAbsK2K6pa7MOPL6O
oQwAnjDW/YwtUkvRUvpP8run3493zvuX
=6x7h
-----END PGP SIGNATURE-----

--------------enigCE006001E27278A36189AAC3--
