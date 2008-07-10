Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYGJEBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYGJEBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYGJEAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:00:53 -0400
Received: from ozlabs.org ([203.10.76.45]:36115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYGJEAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:00:52 -0400
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080710014339.GN14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-2-git-send-email-matthew@wil.cx>
	 <1215396326.19157.15.camel@localhost>
	 <20080707024525.GV14894@parisc-linux.org>
	 <1215403012.9862.25.camel@localhost>
	 <20080707113105.GY14894@parisc-linux.org>
	 <1215653564.13950.40.camel@localhost>
	 <20080710014339.GN14894@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lwANZx887VUUUOmvWyFW"
Date: Thu, 10 Jul 2008 14:00:32 +1000
Message-Id: <1215662432.13950.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lwANZx887VUUUOmvWyFW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 19:43 -0600, Matthew Wilcox wrote:
> On Thu, Jul 10, 2008 at 11:32:44AM +1000, Michael Ellerman wrote:
> > >  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> > >  {
> > > +	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
> > > +		return 1;
> >=20
> > This should go in arch_msi_check_device(). We might move it into a
> > ppc_md routine eventually.
>=20
> I'm OK with that, but ...
>=20
> > >  int __attribute__ ((weak))
> > >  arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> > >  {
> > > -	struct msi_desc *entry;
> > > +	struct msi_desc *desc;
> > >  	int ret;
> > > =20
> > > -	list_for_each_entry(entry, &dev->msi_list, list) {
> > > -		ret =3D arch_setup_msi_irq(dev, entry);
> > > +	if ((type =3D=3D PCI_CAP_ID_MSI) && (nvec > 1))
> > > +		return 1;
> >=20
> > I think the check should be in the generic arch_msi_check_device(), so
> > archs can override just the check.
>=20
> ... then x86 has to implement arch_msi_check_device in order to _not_
> perform the check, which feels a bit bass-ackwards to me.

Agreed, but I think that's still better. You might have alignment
constraints or whatever you need to check as well.=20

> > > =20
> > >  void __attribute__ ((weak))
> > > -arch_teardown_msi_irqs(struct pci_dev *dev)
> > > +arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
> > >  {
> > >  	struct msi_desc *entry;
> > > =20
> > >  	list_for_each_entry(entry, &dev->msi_list, list) {
> > > -		if (entry->irq !=3D 0)
> > > -			arch_teardown_msi_irq(entry->irq);
> > > +		int i;
> > > +		if (entry->irq =3D=3D 0)
> > > +			continue;
> > > +		for (i =3D 0; i < nvec; i++)
> > > +			arch_teardown_msi_irq(entry->irq + i);
> >=20
> > This looks wrong. You're looping through all MSIs for the device, and
> > then for each one you're looping through all MSIs for the device. And
> > you're assuming they're contiguous, which they won't be for MSI-X.
> >=20
> > AFAICS this code should work for you as it was.
>=20
> For MSI-X, nvec will be =3D 1.  Maybe I should call it something else to
> avoid confusion.  The code won't work for me as-was because it won't
> call arch_teardown_msi_irq() for all entries.

It will call arch_teardown_msi_irq() for all entries, unless they were
never allocated (entry->irq =3D=3D 0). Or are we talking about different
things?

If you mean that you're allocating more irqs than there are entries then
you need to deal with that in arch_teardown_msi_irqs().=20

> > > @@ -737,6 +737,8 @@ extern void msi_remove_pci_irq_vectors(struct pci=
_dev *dev);
> > >  extern void pci_restore_msi_state(struct pci_dev *dev);
> > >  #endif
> > > =20
> > > +#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
> >=20
> > Someone will probably say this should be a static inline.
>=20
> Not quite sure why.  You don't get any better typechecking by making it
> a static inline.

Yeah I agree, just pointing it out.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-lwANZx887VUUUOmvWyFW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIdYlgdSjSd0sB4dIRAqWnAJ0Wuyow52juFR6l0it+H3W3lUNjiACffFhF
tfjxEC0LuJR4JOVgZhef5Bk=
=pLdB
-----END PGP SIGNATURE-----

--=-lwANZx887VUUUOmvWyFW--

