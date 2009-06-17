Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZFQR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZFQR3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZFQR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:28:44 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52663 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbZFQR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:42 -0400
Message-ID: <4A3927C0.5060607@novell.com>
Date: Wed, 17 Jun 2009 13:28:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F967F568B12D2BDFB7889C2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F967F568B12D2BDFB7889C2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Davide,

Davide Libenzi wrote:
> On Tue, 16 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Tue, 16 Jun 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> Does this all make sense?
>>>>    =20
>>>>        =20
>>> This conversation has been *really* long, and I haven't had time to l=
ook=20
>>> at the patch yet. But looking at the amount of changes, and the amoun=
t of=20
>>> even more changes talked in this thread, there's a very slim chance t=
hat=20
>>> I'll ACK the eventfd code.
>>> You may want to consider a solution that does not litter eventfd code=
 that=20
>>> much.
>>>
>>>
>>> - Davide
>>>
>>>
>>>  =20
>>>      =20
>> Hi Davide,
>>
>> I understand your position and value your time/insight into looking at=

>> this things.
>>
>> Despite the current ongoing discussion, I still stand that the current=

>> patch is my proposed solution (though I have yet to convince Michael).=
=20
>> But in any case,  if you have the time, please look it over because I
>> still think its the right direction to head in.
>>    =20
>
> I don't think so. You basically upload a bunch of stuff it could have b=
een=20
> inside your irqfd into eventfd.

Can you elaborate?  I currently do not see how I could do the proposed
concept inside of irqfd while still using eventfd.  Of course, that
would be possible if we fork irqfd from eventfd,  and perhaps this is
what you are proposing.  As previously stated I don't want to give up on
the prospect of re-using it quite yet, so bear with me. :)

The issue with eventfd, as I see it, is that eventfd uses a
spin_lock_irqsave (by virtue of the wait-queue stuff) across the
"signal" callback (which today is implemented as a wake-up).  This
spin_lock implicitly creates a non-preemptible critical section that
occurs independently of whether eventfd_signal() itself is invoked from
a sleepable context or not.

What I strive to achieve is to remove the creation of this internal
critical section.  If eventfd_signal() is called from atomic context, so
be it.  We will detect this in the callback and be forced to take the
slow-path, and I am ok with that.  *But*, if eventfd_signal() (or
f_ops->write(), for that matter) are called from a sleepable context
*and* eventfd doesn't introduce its own critical section (such as with
my srcu patch), we can potentially optimize within the callback by
executing serially instead of deferring (e.g. via a workqueue).

(Note: The issue of changing eventfd_signal interface is a separate
tangent that Michael proposed, and is not something I am advocating.  In
the current proposal, eventfd_signal() retains its exact semantics as it
has in mainline).

>  Now the eventfd_signal() can magically=20
> sleep, or not, depending on what the signal functions do. This makes up=
 a=20
> pretty aweful interface if you ask me.
> A lot simpler and cleaner if eventfd_signal(), like all the wake up=20
> functions inside the kernel, can be called from atomic context. Always,=
=20
> not sometimes.
>  =20

It can!  :) This is not changing from whats in mainline today (covered
above).

Thanks Davide,
-Greg



--------------enig2F967F568B12D2BDFB7889C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko5J8AACgkQlOSOBdgZUxlTSwCeOFwltP9oOCS+HwnN+AlYU+Ec
mMEAn3JrPJaz99oufqdNwEnEqO6NqFgr
=DsP0
-----END PGP SIGNATURE-----

--------------enig2F967F568B12D2BDFB7889C2--
