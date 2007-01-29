Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXA2KLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXA2KLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXA2KLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:11:31 -0500
Received: from ozlabs.org ([203.10.76.45]:43481 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbXA2KLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:11:30 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	 <20070128.153707.30184351.davem@davemloft.net>
	 <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	 <20070128.212554.23015561.davem@davemloft.net>
	 <1170050737.26655.233.camel@localhost.localdomain>
	 <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rR6ZmTxUxIaoiYSFGFD2"
Date: Mon, 29 Jan 2007 21:11:27 +1100
Message-Id: <1170065487.19887.91.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rR6ZmTxUxIaoiYSFGFD2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-01-29 at 02:03 -0700, Eric W. Biederman wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>=20
> > On Sun, 2007-01-28 at 21:25 -0800, David Miller wrote:
> >> From: ebiederm@xmission.com (Eric W. Biederman)
> >> Date: Sun, 28 Jan 2007 22:18:59 -0700
> >>=20
> >> > Regardless of my opinion on the sanity of the hypervisor architects.
> >> > I have not seen anything that indicates it will be hard to support
> >> > the hypervisor doing everything or most of everything for us, so
> >> > I see no valid technical objection to it.  Nor have I ever.
> >> >=20
> >> > So I have no problem with additional patches in that direction.
> >>=20
> >> Ok, that's great to hear.
> >>=20
> >> I know your bi-directional approach isn't exactly what Ben
> >> wants but he can support his machines with it.  Maybe after
> >> some time we can agree to move from that more towards the
> >> totally abstracted scheme.
> >
> > It can support my machines without HV with trivial changes I reckon: I
> > need an ops struct to indirect eric's 2 remaining arch hooks
> > (setup/teardown) but that can be done inline within asm-powerpc. I need
> > to double check of course and probably actually port the MPIC backend
> > and possibly go write the Cell Axon one while at it to verify everythin=
g
> > is allright, but the base design seems sound enough.
> >
> > For the ones with HV (RTAS stuff), we still need to agree on how to
> > approach it. We can either:
> >
> > Option 1
> > --------
> >
> > Do a hook -above- Eric stuff, by having the toplevel APIs themselves be
> > arch hooks that can either go toward the RTAS implementation or toward
> > Eric's code. That is, eric code would define those (pick better names i=
f
> > you are good at it):
> >
> > 	pci_generic_enable_msi
> > 	pci_generic_disable_msi
> > 	pci_generic_enable_msix
> > 	pci_generic_disable_msix
> > 	pci_generic_save_msi_state
> > 	pci_generic_restore_msi_state
> >
> > Then we can have asm-i386/msi.h & friends do something like
> >
> > #define pci_enable_msi	pci_generic_enable_msi
> > #define pci_disable_msi	pci_generic_disable_msi
> >    etc...
> >
> > And we can have asm-powerpc/msi.h hook then via ppc_md:
> >
> > static inline int pci_enable_msi(xxx...)
> > {
> > 	return ppc_md.pci_enable_msi(xxx...);
> > }
> > etc...
> >
> > (ppc_md is our per-platform global hook structure filled at boot when w=
e
> > discover on what machine type we are running on) so that pSeries can us=
e
> > it's own RTAS callbacks, and others can just re-hook those to Eric's
> > code.
>=20
> This is the most straight forward and handles machines with really
> weird msi setups, so I lean in this direction.
>=20
> The question is there anything at all we can do generically?
>=20
> I can't see a case where ppc_md would not wind up with the hooks
> that decide if it is a hypervisor or not.  Even if we came up
> with a better set of functions you need to hook.
>=20
> > Option 2
> > --------
> >
> > That is to make Eric's code itself cope with the HV case. I'm a bit at
> > loss right now as how precisely to do it. I need to spend more time
> > staring at the code after Eric latest patches rather than the patches
> > themselves I suppose :-) (Eric, they don't apply out of the box on
> > current git, they are against -mm ?).
> >
> > Some of the main issues here, more/less following the order in which
> > Eric code calls things:
> >
> >  - The number of vectors for MSI-X is obtained from config space (at
> > least for sanity checking the requested argument). On RTAS, it should
> > come from an OF property (we are really not supposed to go read the
> > config space even if we can). I -suppose- we can survive for now with
> > just reading it, but we might well run into trouble with some "special"
> > devices shared accross partitions or if the IBM magic bridges themselve=
s
> > ever start sending MSI-X on their own (unlikely but who knows...).
> > Michael's code handled that by having a callback ->check() do the sanit=
y
> > checking of the nvec, and then just use the nvec passed in as an
> > argument once it's sane.
>=20
> Ok. I think I get the point of check.  I believe I need to look at your
> code a little more and see what you are doing to see if there is anything
> generic worth doing, that we can always do outside of architecture code
> no matter how much of the job the Hypervisor wants to do for us.
>=20
> I'd hate to hit a different Hypervisor that did something close but
> not quite the same and have the code fail then.  So definitely
> avoiding touching pci config space at all in the calls seems to make a
> lot of sense.  This includes avoiding pci_find_capability right?

You can read config space, but it's not clear to me if the HV is allowed
to filter it and hide things. It's also possible that the device
supports MSI, but for some reason the HV doesn't allow it on that device
etc. so you really have to ask the HV if it's enabled. So pci_find_cap()
shouldn't crash or anything, but it may lie to you.

> Off the top of my head the only things we can do generically are
> some data structure things and flags like dev->msi_enabled or
> dev->msix_enabled.

It would be good to have a common data structure if possible. My
thinking was that most of the information is per pci_dev, so that's
where I put it. I realise the Intel code stores some info that's
per-irq, but most of it is per-device. I hadn't got anywhere near coding
it, but my vague idea was to add a arch_data (or whatever) pointer to my
msi_info struct, which would allow backends to stash stuff.

I think the pci_intx() calls can be in the core.

Munging dev->irq could be in the core, assuming it's left in some known
location by the code. On the other hand we might want to decide it's a
bad idea altogether.

One thing I did like about my code, is that pci_enable_msi() and
pci_enable_msix() are just small wrappers around generic_enable_msi() -
which does all the work, and is the same regardless of whether it's an
MSI or MSI-X. Although that's facilitated by the type arg which you
don't like.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-rR6ZmTxUxIaoiYSFGFD2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFvchPdSjSd0sB4dIRAmccAJ9V/nA7YELwpq0TNmSaUtOvHYulRwCgpiIe
NWnL5z2VgVkk6buuGVtRIWs=
=jiUZ
-----END PGP SIGNATURE-----

--=-rR6ZmTxUxIaoiYSFGFD2--

