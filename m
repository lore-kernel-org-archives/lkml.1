Return-Path: <linux-kernel-owner+w=401wt.eu-S1761211AbZEFPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211AbZEFPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbZEFPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:16:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45369 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbZEFPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:16:40 -0400
Message-ID: <4A01A9C5.5010601@novell.com>
Date: Wed, 06 May 2009 11:16:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [RFC PATCH 1/3] add generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <20090505132437.19891.42922.stgit@dev.haskins.net> <4A019614.9080702@codemonkey.ws>
In-Reply-To: <4A019614.9080702@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9BE912F6407EB8013141D825"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9BE912F6407EB8013141D825
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> We add a generic hypercall() mechanism for use by IO code which is
>> compatible with a variety of hypervisors, but which prefers to use
>> hypercalls over other types of hypervisor traps for performance and/or=

>> feature reasons.
>>
>> For instance, consider an emulated PCI device in KVM.  Today we can
>> chose
>> to do IO over MMIO or PIO infrastructure, but they each have their own=

>> distinct disadvantages:
>>
>> *) MMIO causes a page-fault, which must be decoded by the hypervisor
>> and is
>>    therefore fairly expensive.
>>
>> *) PIO is more direct than MMIO, but it poses other problems such as:
>>       a) can have a small limited address space (x86 is 2^16)
>>       b) is a narrow-band interface (one 8, 16, 32, 64 bit word at a
>> time)
>>       c) not available on all archs (PCI mentions ppc as problematic)
>> and
>>          is therefore recommended to avoid.
>>
>> Hypercalls, on the other hand, offer a direct access path like PIOs, y=
et
>> do not suffer the same drawbacks such as a limited address space or a
>> narrow-band interface.  Hypercalls are much more friendly to software
>> to software interaction since we can pack multiple registers in a way
>> that is natural and simple for software to utilize.
>>  =20
>
> No way.  Hypercalls are just about awful because they cannot be
> implemented sanely with VT/SVM as Intel/AMD couldn't agree on a common
> instruction for it.  This means you either need a hypercall page,
> which I'm pretty sure makes transparent migration impossible, or you
> need to do hypercall patching which is going to throw off attestation.

This is irrelevant since KVM already does this patching today and we
therefore have to deal with this fact.  This new work is riding on the
existing infrastructure so it of negligible cost to add new vectors at
least w.r.t. your concerns above.

>
> If anything, I'd argue that we shouldn't use hypercalls for anything
> in KVM because it will break run-time attestation.

The cats already out of the bag on that one.  Besides, even if the
hypercall infrastructure does break attestation (which I don't think is
proven as fact) not everyone cares about migration.  At some point,
someone may want to make a decision to trade performance for the ability
to migrate (or vice versa).  I am ok with that.

>
>
> Hypercalls cannot pass any data either.  We pass data with hypercalls
> by relying on external state (like register state). =20

This is a silly argument.  The CALL or SYSENTER instructions do not pass
data either.  Rather, they branch the IP and/or execution context,
predicated on the notion that the new IP/context can still access the
relevant machine state prior to the call.  VMCALL type instructions are
just one more logical extension of that same construct.

PIO on the other hand is different.  The architectural assumption is
that the target endpoint does not have access to the machine state.=20
Sure, we can "cheat" in virtualization by knowing that it really will
have access, but then we are still constrained by all the things I have
already mentioned that are disadvantageous to PIOs, plus....

> It's just as easy to do this with PIO.

=2E.you are glossing over the fact that we already have the infrastructur=
e
to do proper register setup in kvm_hypercallX().  We would need to come
up with an similar (arch specific) "pio_callX()" as well.  Oh wait, no
we wouldn't, since PIOs apparently only work on x86. ;)  Ok, so we would
need to come up with these pio_calls for x86, and no other arch can use
the infrastructure (but wait, PPC can use PCI too, so how does that
work? It must be either MMIO emulation or its not supported?  That puts
us back to square one).

In addition, we can have at most 8k unique vectors on x86_64 (2^16/8
bytes per port).    Even this is a gross overestimation because it
assumes the entire address space is available for pio_call, which it
isn't, and it assumes all allocations are in the precise width of the
address space (8-bytes), which they wont be.  It doesn't exactly sound
like a winner to me.

> VMware does this with vmport, for instance.  However, in general, you
> do not want to pass that much data with a notification.  It's better
> to rely on some external state (like a ring queue) and have the
> "hypercall" act simply as a notification mechanism.

Disagree completely.  Things like shared-memory rings provide a really
nice asynchronous mechanism, and for the majority of your IO and for
fast-path thats probably exactly what we should do.  However, there are
plenty of patterns that fit better with a synchronous model.  Case in
point: see VIRTIO_VBUS_FUNC_GET_FEATURES, SET_STATUS, and RESET
functions in the virtio-vbus driver I posted.  And as an aside, the ring
notification rides on the same fundamental synchronous transport.

So sure, you could argue that you could also make an extra "call" ring,
place your request in the ring, and use a flush/block primitive to wait
for that item to execute.  But that sounds a bit complicated when all I
want is the ability to invoke simple synchronous calls.  Therefore, lets
just get this "right" and build the primitives to express both patterns
easily.

In the end, I don't specifically care if the "call()" vehicle is a PIO
or a hypercall per se, as long as we can meet the following:
   a) is feasible at least anywhere PCI works
   b) provides a robust and uniform interface so drivers do not need to
care about the implementation.
   b) has equivalent performance (e.g. if PPC maps PIO as MMIO, that is
no-good).

Regards,
-Greg



--------------enig9BE912F6407EB8013141D825
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoBqcUACgkQlOSOBdgZUxnIRACeLpZ1A67CAjIQ9lQnblcegR4R
yFAAmQH5jYRYJxR9Wr1BGo4BTQPOEiWw
=paCf
-----END PGP SIGNATURE-----

--------------enig9BE912F6407EB8013141D825--
