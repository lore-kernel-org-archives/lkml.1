Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbZFRMA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbZFRMA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbZFRMAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:00:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39250 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZFRMAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:00:47 -0400
Message-ID: <4A3A2C67.4030406@novell.com>
Date: Thu, 18 Jun 2009 08:00:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com> <200906181446.31373.rusty@rustcorp.com.au> <20090618064908.GB11155@redhat.com>
In-Reply-To: <20090618064908.GB11155@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig057C0D5E316F47ACB5A952BF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig057C0D5E316F47ACB5A952BF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 18, 2009 at 02:46:30PM +0930, Rusty Russell wrote:
>  =20
>> On Mon, 15 Jun 2009 10:24:39 pm Michael S. Tsirkin wrote:
>>    =20
>>> On Mon, Jun 15, 2009 at 08:08:18AM -0400, Gregory Haskins wrote:
>>>      =20
>>>> Hmm.  I understand what you are saying conceptually (i.e. the .text
>>>> could get yanked before we hit the next line of code, in this case t=
he
>>>> "return 0").  However, holding a reference when you _know_ someone e=
lse
>>>> holds a reference to me says that one of the references is redundant=
=2E
>>>> In addition, there is certainly plenty of precedence for
>>>> module_put(THIS_MODULE) all throughout the kernel (including
>>>> module_put_and_exit()).  Are those broken as well?
>>>>        =20
>>> Maybe not, but I don't know why. It works fine as long as you don't
>>> unload any modules though :) Rusty, could you enlighten us please?
>>>      =20
>> Yep, they're almost all broken.  A few have comments indicating that s=
omeone=20
>> else is holding a reference (eg. loopback).
>>
>> But at some point you give up playing whack-a-mole for random drivers.=

>>
>> module_put_and_exit() does *not* have this problem, BTW.
>>
>> Rusty.
>>    =20
>
> I see that, the .text for module_put_and_exit is never modular itself.
> Thanks, Rusty!
>  =20

Ah!  That is the trick I wasn't understanding.
> BTW, Gregory, this can be used to fix the race in the design: create a
> thread and let it drop the module reference with module_put_and_exit.
>  =20

I had thought of doing something like this initially too, but I think
its racy as well.  Ultimately, you need to make sure the eventfd
callback is completely out before its safe to run, and deferring to a
thread would not change this race.  The only sane way I can see to do
that is to have the caller infrastructure annotate the event somehow
(either directly with a module_put(), or indirectly with some kind of
state transition that can be tracked with something like
synchronize_sched().
> Which will work, but I guess at this point we should ask ourselves
> whether all the hearburn with srcu, threads and module references is
> better than just asking the user to call and ioctl.
>  =20

I am starting to agree with you, here. :)

Note one thing: the SRCU stuff is mostly orthogonal from the rest of the
conversation re: the module_put() races.  I only tied it into the
current thread because the eventfd_notifier_register() thread gave me a
convenient way to hook some other context to do the module_put().  In
the long term, the srcu changes are for the can_sleep() stuff.  So on
that note, lets see if I can convince Davide that the srcu stuff is not
so evil before we revert the POLLHUP patches, since the module_put() fix
is trivial once that is in place.

Thanks Michael (and Rusty),
-Greg



--------------enig057C0D5E316F47ACB5A952BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6LGcACgkQlOSOBdgZUxlvRACdGhh5sTcfTm3duMxImepOSUGH
HkQAnjo2CCxMdnxqwqvVh0GD80Dn2Jdq
=R71s
-----END PGP SIGNATURE-----

--------------enig057C0D5E316F47ACB5A952BF--
