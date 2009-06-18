Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbZFRODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbZFRODx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZFRODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:03:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47345 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbZFRODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:03:39 -0400
Message-ID: <4A3A4938.60604@novell.com>
Date: Thu, 18 Jun 2009 10:03:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com> <200906181446.31373.rusty@rustcorp.com.au> <20090618064908.GB11155@redhat.com> <4A3A2C67.4030406@novell.com> <20090618122219.GE16838@redhat.com>
In-Reply-To: <20090618122219.GE16838@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB112B91066500838AFD16119"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB112B91066500838AFD16119
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 18, 2009 at 08:00:39AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>
>>> BTW, Gregory, this can be used to fix the race in the design: create =
a
>>> thread and let it drop the module reference with module_put_and_exit.=

>>>  =20
>>>      =20
>> I had thought of doing something like this initially too, but I think
>> its racy as well.  Ultimately, you need to make sure the eventfd
>> callback is completely out before its safe to run, and deferring to a
>> thread would not change this race.  The only sane way I can see to do
>> that is to have the caller infrastructure annotate the event somehow
>> (either directly with a module_put(), or indirectly with some kind of
>> state transition that can be tracked with something like
>> synchronize_sched().
>>    =20
>
> Here's what one could do: create a thread for each irqfd, and increment=

> module ref count, put that thread to sleep.  When done with
> irqfd, don't delete it and don't decrement module refcount, wake thread=

> instead.  thread kills irqfd and calls module_put_and_exit.
>
> I don't think it's racy


I believe it is. How would you prevent the thread from doing the
module_put_and_exit() before the eventfd callback thread is known to
have exited the relevant .text section?

All this talk does give me an idea, tho.  Ill make a patch.

=20

>  =20
>>> Which will work, but I guess at this point we should ask ourselves
>>> whether all the hearburn with srcu, threads and module references is
>>> better than just asking the user to call and ioctl.
>>>  =20
>>>      =20
>> I am starting to agree with you, here. :)
>>
>> Note one thing: the SRCU stuff is mostly orthogonal from the rest of t=
he
>> conversation re: the module_put() races.  I only tied it into the
>> current thread because the eventfd_notifier_register() thread gave me =
a
>> convenient way to hook some other context to do the module_put().  In
>> the long term, the srcu changes are for the can_sleep() stuff.  So on
>> that note, lets see if I can convince Davide that the srcu stuff is no=
t
>> so evil before we revert the POLLHUP patches, since the module_put() f=
ix
>> is trivial once that is in place.
>>    =20
>
> Can this help with DEASSIGN as well? We need it for migration.
>  =20

No, but afaict you do not need this for migration anyway.  Migrate the
GSI and re-call kvm_irqfd() on the other side.  Would the fd even be
relevant across a migration anyway?  I would think not, but admittedly I
know little about how qemu/kvm migration actually works.

Regards,
-Greg



--------------enigB112B91066500838AFD16119
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6STgACgkQlOSOBdgZUxn5SQCeM7JWNUqbtnzGmLWPGJnNpXgw
xUwAn0LQofoohxbo0xmVq2qwe4Ikvaj3
=DPPX
-----END PGP SIGNATURE-----

--------------enigB112B91066500838AFD16119--
