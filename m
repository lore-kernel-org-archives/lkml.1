Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYGJBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYGJBc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYGJBcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:32:47 -0400
Received: from ozlabs.org ([203.10.76.45]:38239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYGJBcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:32:46 -0400
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the
	msi_desc
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080707120418.GZ14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-1-git-send-email-matthew@wil.cx>
	 <1215396324.19157.14.camel@localhost>
	 <20080707024125.GU14894@parisc-linux.org>
	 <1215402512.9862.16.camel@localhost>
	 <20080707120418.GZ14894@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-El28Ae/5X6ZBuZ7gG1+Y"
Date: Thu, 10 Jul 2008 11:32:43 +1000
Message-Id: <1215653563.13950.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-El28Ae/5X6ZBuZ7gG1+Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-07 at 06:04 -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 01:48:32PM +1000, Michael Ellerman wrote:
> > Yeah seriously :)  The _ is part of it, but MSI_ATTRIB is uglier than
> > PCI_CAP_ID_MSI exactly because it's not PCI_CAP_ID_MSI, which exists an=
d
> > is well defined and is used in the rest of the code.
>=20
> Here's an improvement over both the status quo and my patch -- simply
> use a single bit called is_msix.

That is cleaner, you get to fix it when they create MSIXX though ;)

> > I didn't say it was a queue, but a Q ;)  But I agree it's not a good
> > name, the spec calls it "multiple message enable", nvec would match the
> > existing code best, or log_nvec.
>=20
> I don't see what's wrong with 'multiple'.  log_nvec is clunky, and
> 'multiple' works well as a boolean (since 0 means 1 interrupt).

For me 'multiple' only makes sense as a boolean, but whatever.

> > > > If you're worried about bloating msi_desc, there's several fields i=
n
> > > > there that are per-device not per-desc, so we could do another patc=
h to
> > > > move them into pci_dev or something hanging off it, eg.
> > > > pci_dev->msi_info rather than storing them in every desc.
>=20
> Ouch.  I just used pahole and discovered we were using 72 bytes on
> 64-bit.  A swift rearrangement of a u16 gets us back down to 64.

pahole is awesome, nice find.

> Here's the replacement patch:

Perhaps I'm pedantic, but I'd rather it was two patches, one to change
type to is_msix and one to add the multiple flag.

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 8c61304..8f7e483 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c

> @@ -180,32 +167,31 @@ void read_msi_msg(unsigned int irq, struct msi_msg =
*msg)
...
>  		struct pci_dev *dev =3D entry->dev;
>  		int pos =3D entry->msi_attrib.pos;
> +		u16 msgctl;
> +
> +		pci_read_config_word(dev, msi_control_reg(pos), &msgctl);
> +		msgctl &=3D ~PCI_MSI_FLAGS_QSIZE;
> +		msgctl |=3D entry->msi_attrib.multiple << 4;
> +		pci_write_config_word(dev, msi_control_reg(pos), msgctl);

A #define for "<< 4" would be nice. And should we be paranoid about
potentially writing 0b110 or 0b111 which are reserved?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-El28Ae/5X6ZBuZ7gG1+Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIdWa7dSjSd0sB4dIRAv2nAJ42ez06LDu8ubACZUBZpFKxw0HQuACgnz3y
HLr7juIWycWxEg945+aklLs=
=+/Ye
-----END PGP SIGNATURE-----

--=-El28Ae/5X6ZBuZ7gG1+Y--

