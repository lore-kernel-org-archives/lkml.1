Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZFQTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZFQTSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbZFQTRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:17:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38296 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZFQTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:17:51 -0400
Message-ID: <4A39415C.9060803@novell.com>
Date: Wed, 17 Jun 2009 15:17:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB1300CB52CB03DD4ABCA8981"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB1300CB52CB03DD4ABCA8981
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 17 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Can you elaborate?  I currently do not see how I could do the proposed=

>> concept inside of irqfd while still using eventfd.  Of course, that
>> would be possible if we fork irqfd from eventfd,  and perhaps this is
>> what you are proposing.  As previously stated I don't want to give up =
on
>> the prospect of re-using it quite yet, so bear with me. :)
>>
>> The issue with eventfd, as I see it, is that eventfd uses a
>> spin_lock_irqsave (by virtue of the wait-queue stuff) across the
>> "signal" callback (which today is implemented as a wake-up).  This
>> spin_lock implicitly creates a non-preemptible critical section that
>> occurs independently of whether eventfd_signal() itself is invoked fro=
m
>> a sleepable context or not.
>>
>> What I strive to achieve is to remove the creation of this internal
>> critical section.  If eventfd_signal() is called from atomic context, =
so
>> be it.  We will detect this in the callback and be forced to take the
>> slow-path, and I am ok with that.  *But*, if eventfd_signal() (or
>> f_ops->write(), for that matter) are called from a sleepable context
>> *and* eventfd doesn't introduce its own critical section (such as with=

>> my srcu patch), we can potentially optimize within the callback by
>> executing serially instead of deferring (e.g. via a workqueue).
>>    =20
>
> Since when the scheduling (assuming it's not permanently running on=20
> another core due to high frequency work post) of a kernel thread is suc=
h=20
> a big impact that interfaces need to be redesigned for that?
>  =20

Low-latency applications, for instance, care about this.  Even one
context switch can add a substantial overhead.

> How much the (possible, but not certain) kernel thread context switch t=
ime=20
> weighs in the overall KVM IRQ service time?
>  =20

Generally each one is costing me about 7us on average.  For something
like high-speed networking, we have a path that has about 30us of
base-line overhead.  So one additional ctx-switch puts me at base+7 ( =3D=

~37us), two puts me in base+2*7 (=3D ~44us).  So in that context (no pun
intended ;), it hurts quite a bit.  I'll be the first to admit that not
everyone (most?) will care about latency, though.  But FWIW, I do.

>
>
>  =20
>> It can!  :) This is not changing from whats in mainline today (covered=

>> above).
>>    =20
>
> It can/could, if the signal() function takes very accurate care of doin=
g=20
> the magic atomic check.
>  =20

True, but thats the notifiee's burden, not eventfd's.  And its always
going to be opt-in.  Even today, someone is free to either try to sleep
(which will oops on the might_sleep()), or try to check if they can
sleep (it will always say they can't due to the eventfd wqh spinlock).=20
The only thing that changes with my patch is that someone that opts in
to check if they can sleep may find that they sometimes (mostly?) can.

In any case, I suspect that there are no other clients of eventfd other
than standard wait-queue sleepers, and irqfd.  The wake_up() code is
never going to care anyway, so this really comes down to future users of
the notification interfaces (irqfd today, iosignalfd in the near-term).=20
Therefore, there really aren't any legacy issues to deal with that I am
aware of, even if they mattered.

Thanks Davide,
-Greg


--------------enigB1300CB52CB03DD4ABCA8981
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko5QVwACgkQlOSOBdgZUxnVKQCfWwDNbwsBSIMdW3tpWc4z4NjL
rEoAnRjmoIsADmqgQD/l0RE8yZ0zPqL5
=aMm2
-----END PGP SIGNATURE-----

--------------enigB1300CB52CB03DD4ABCA8981--
