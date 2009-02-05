Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZBEC6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZBEC6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZBEC6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:58:15 -0500
Received: from ozlabs.org ([203.10.76.45]:34510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZBEC6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:58:13 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1233797363.4612.49.camel@pasglop>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
	 <1233783502.4612.7.camel@pasglop>
	 <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
	 <1233794410.4612.34.camel@pasglop>  <1233795431.15714.13.camel@localhost>
	 <1233797363.4612.49.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DX5Sep2HMHMOI7EFtnpy"
Date: Thu, 05 Feb 2009 13:58:10 +1100
Message-Id: <1233802690.15714.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DX5Sep2HMHMOI7EFtnpy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 12:29 +1100, Benjamin Herrenschmidt wrote:
> > > Yup, missed that change in the patch. In fact, I even missed the
> > > existence of a WARN_ONCE that takes those text arguments... baaaah. I
> > > suppose I should try to read more of lkml :-)
> >=20
> > But don't expect to see them on powerpc, they never make it to the
> > console.
>=20
> Allright, that's the problem with our implementation of WARN using a
> conditional trap, we don't carry all the variable arguments for the
> printf over.
>=20
> I'm tempted to turn our implementation back to normal C code with an if
> and a branch out of line, but Michael seems to say that even with
> appropriate use of unlikely() etc... gcc decides to generate the worst
> possible code every single time ...
>=20
> <rant>
> such as always inlining the whole printf mumbo jumbo and having the
> not-warning case branch over it, not -all- CPUs have good branch
> prediction dude, so the icache is going to scream but gcc folks know
> better of course....
> </rant>
>=20
> Anyway, I'll see Michael what exactly the situation is here and if we
> can fix it a way or another.

Well I'm glad you listened to me when I told you not to fire off a rant
email before I had another look at it ;)

Because Arjan has patched the generic bug.h so that we at least get the
printk on powerpc, and then use our version of __WARN().

So you should see the message at least.


As far as the code gen, with gcc 4.3.1 (debian).

WARN looks like:

#define WARN(condition, format...) ({                                      =
     \
        int __ret_warn_on =3D !!(condition);                              \
        if (unlikely(__ret_warn_on))                                    \
                __WARN_printf(format);                                  \
        unlikely(__ret_warn_on);                                        \
})


Called from:

int smp_request_message_ipi(int virq, int msg)
{
        int err;
...
        err =3D request_irq(virq, smp_ipi_action[msg], IRQF_DISABLED|IRQF_P=
ERCPU,
                          smp_ipi_name[msg], 0);
        WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
                virq, smp_ipi_name[msg], err);

        return err;
}


Comes out as:

c00000000002c9e8:       48 0a 88 c9     bl      c0000000000d52b0 <.request_=
irq>
c00000000002c9ec:       60 00 00 00     nop
c00000000002c9f0:       2f 83 00 00     cmpwi   cr7,r3,0
c00000000002c9f4:       7c 7f 1b 78     mr      r31,r3
c00000000002c9f8:       40 bc 00 20     bge+    cr7,c00000000002ca18 <.smp_=
request_message_ipi+0x84>
c00000000002c9fc:       7c bc e8 2a     ldx     r5,r28,r29
c00000000002ca00:       e8 7e 80 d0     ld      r3,-32560(r30)
c00000000002ca04:       7f 64 db 78     mr      r4,r27
c00000000002ca08:       7f e6 fb 78     mr      r6,r31
c00000000002ca0c:       48 5f 53 7d     bl      c000000000621d88 <.printk>
c00000000002ca10:       60 00 00 00     nop    =20
c00000000002ca14:       0f e0 00 00     twi     31,r0,0
c00000000002ca18:       38 21 00 a0     addi    r1,r1,160
c00000000002ca1c:       7f e3 fb 78     mr      r3,r31
c00000000002ca20:       e8 01 00 10     ld      r0,16(r1)
c00000000002ca24:       eb 61 ff d8     ld      r27,-40(r1)
c00000000002ca28:       eb 81 ff e0     ld      r28,-32(r1)
c00000000002ca2c:       eb a1 ff e8     ld      r29,-24(r1)
c00000000002ca30:       eb c1 ff f0     ld      r30,-16(r1)
c00000000002ca34:       eb e1 ff f8     ld      r31,-8(r1)
c00000000002ca38:       7c 08 03 a6     mtlr    r0
c00000000002ca3c:       4e 80 00 20     blr   =20


So it's jumping over the if body, rather than moving it out of the
straight line. It is hinting it right, so we should check if that helps
us at all.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-DX5Sep2HMHMOI7EFtnpy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmKVcEACgkQdSjSd0sB4dJxyACfZkk1TXi512vBlt7tVfbn6AO/
JdsAn1f/1JDg5Re3cBTJrHU+yRv5e1A+
=vNwJ
-----END PGP SIGNATURE-----

--=-DX5Sep2HMHMOI7EFtnpy--

