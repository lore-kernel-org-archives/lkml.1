Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbXC2ENH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbXC2ENH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXC2ENH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:13:07 -0400
Received: from ozlabs.org ([203.10.76.45]:40576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXC2ENF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:13:05 -0400
Subject: Re: [PATCH 10/21] MSI: Add an arch_msi_supported()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1fy7psyjg.fsf@ebiederm.dsl.xmission.com>
References: <20070322105340.C6E43DDF66@ozlabs.org>
	 <m1fy7psyjg.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7dqF9HlhbMBKYYShSA3q"
Date: Thu, 29 Mar 2007 14:13:01 +1000
Message-Id: <1175141581.16660.24.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7dqF9HlhbMBKYYShSA3q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-27 at 23:54 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > Add an arch_msi_supported(), which gives archs a chance to check the in=
put
> > to pci_enable_msi/x. For MSI-X this routine might need the entry array,=
 so
> > pass it in. For plain MSI, NULL is passed, the arch routine needs to co=
pe
> > with that. Propagate the error value returned from the arch routine out=
 to
> > the caller.
>=20
> Ugh.  I'm not very comfortable with passing struct msix_entry into
> the architectures right now.
>=20
> There are a couple of reasons.
> - It's irq field is to small (so we need to change it at some point)
> - No a single driver that calls pci_enable_msix uses the scatter gather
>   feature (so the entry member is redundant).
>=20
> So this struct msix_entry needs to change and we need to change the drive=
rs
> along with it.  Having to change a couple of architectures as well sounds
> painful.  So we might as well fix that at the same time as we are
> adding the RTAS support so architectures don't have to deal with this
> nasty unused concept.
>=20
> I'm thinking the same thing to do is to completely remove struct msix_ent=
ry
> and just let drivers walk the linked list you introduce a few patches
> later down.  All they need is to get their irq numbers anyway.

I agree with most of that. I thought of doing that change, but didn't
want to have the powerpc code stuck behind a huge pile of driver
changes.

My only other worry is that at some point we'll get a driver that does
want to choose the entries it's allocated, and at that point we'll have
to put back the msix_entry code (or something similar). I don't have any
idea of when/if that sort of hardware/driver requirement is likely to
surface though, if it's "not for a while" it might be worth ripping out
the complexity until we really need it.

> I was tempted to drop nvec as well since our irq numbers are virtual,
> we could always delay the failure into request_irq.  But there are
> a few embedded architectures like the arm where the number irqs
> numbers may stay limited for a long time and if the driver will never
> use all of the irqs we get to save some resources and some work.  So
> that makes sense.

I think nvec should stay.

> So can we please at least move this patch down to the end with the
> rest of the RTAS arch support?
>=20
> Moving it towards the end will allow it to be reviewed in the context
> where it will be used and it will give us a chance to simplify
> pci_enable_msix before we get there.

I'm happy to move it to the end of the series. I'm also happy to stop
passing the msix_entry into the arch.

But I don't want to predicate the merge of our powerpc stuff on the
removal of msix_entry entirely, there's too much risk that we'll slip to
v23.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-7dqF9HlhbMBKYYShSA3q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGCzzNdSjSd0sB4dIRAo3UAKDMVopjpPO4r5EJCQPMG6yPyjhOagCfbJiy
H29i2I3aD0jQZNufLSPlLwc=
=GWSM
-----END PGP SIGNATURE-----

--=-7dqF9HlhbMBKYYShSA3q--

