Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXCZC5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXCZC5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 22:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXCZC5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 22:57:20 -0400
Received: from ozlabs.org ([203.10.76.45]:50849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXCZC5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 22:57:19 -0400
Subject: Re: [PATCH 17/21] MSI: Clear the irq_desc's msi pointer on free
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1y7lo64v4.fsf@ebiederm.dsl.xmission.com>
References: <20070322105344.A34C6DDF74@ozlabs.org>
	 <m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
	 <1174604508.5401.7.camel@concordia.ozlabs.ibm.com>
	 <m1y7lo64v4.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HRsyqrBNuYLKopUsf4ra"
Date: Mon, 26 Mar 2007 12:57:16 +1000
Message-Id: <1174877836.4782.6.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HRsyqrBNuYLKopUsf4ra
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-22 at 21:00 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > On Thu, 2007-03-22 at 08:23 -0600, Eric W. Biederman wrote:
> >> Michael Ellerman <michael@ellerman.id.au> writes:
> >>=20
> >> > Currently we never clear the msi_desc pointer in the irq_desc. This
> >> > leaves us with a pointer to free'ed memory hanging around. No one se=
ems
> >> > to have hit this, so presumably other parts of the code are protecti=
ng
> >> > us from ever using the stale pointer .. or we're just lucky, we shou=
ld
> >> > still clear it.
> >>=20
> >> Hmm.  Maybe.  Currently this is done in dynamic_irq_cleanup,
> >> at least for everything except sparc64.
> >
> > OK, I missed that. I still think we should do it here, otherwise there'=
s
> > a window, however small, where the msi_desc pointer is pointing at free=
d
> > memory.
>=20
> After following the code through the current cleanup happens before you a=
re
> proposing, and in fact the irq is return to the set of irq's that can
> be allocated before you are calling set_irq_msi(irq, NULL).

We don't call dynamic_irq_cleanup(), so it never gets done. Perhaps we
should be using your dynamic_irq_init/cleanup.

> Therefore you are doing this too late and we need to ensure the
> architecture code does this in arch_teardown_msi_irq.

As long as the arch teardown routine somehow calls dynamic_irq_cleanup()
it should be fine. But I guess it's probably safer to just have all
archs do set_msi_irq(irq, NULL) in the teardown.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-HRsyqrBNuYLKopUsf4ra
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGBzaLdSjSd0sB4dIRAl9cAKCq/pHNG5dCV18MoLKweH2+MhNXRwCgjXgM
n8fZeKvCLjUEttF9NXfRv/U=
=u3M6
-----END PGP SIGNATURE-----

--=-HRsyqrBNuYLKopUsf4ra--

