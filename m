Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXC2FDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXC2FDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965951AbXC2FDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:03:32 -0400
Received: from ozlabs.org ([203.10.76.45]:54843 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbXC2FDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:03:31 -0400
Subject: Re: [PATCH 14/21] MSI: Use a list instead of the custom link
	structure
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m13b3pswx2.fsf@ebiederm.dsl.xmission.com>
References: <20070322105343.3B358DDF6D@ozlabs.org>
	 <m13b3pswx2.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YUAR3J540GEZy43s4XX7"
Date: Thu, 29 Mar 2007 15:03:29 +1000
Message-Id: <1175144609.16660.33.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YUAR3J540GEZy43s4XX7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 00:29 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > The msi descriptors are linked together with what looks a lot like
> > a linked list, but isn't a struct list_head list. Make it one.
> >
> > The only complication is that previously we walked a list of irqs, and
> > got the descriptor for each with get_irq_msi(). Now we have a list of
> > descriptors and need to get the irq out of it, so it needs to be in the
> > actual struct msi_desc. We use 0 to indicate no irq is setup.
> >
> > At some point after a pci_dev is created we need to initialise its
> > msi_list. pci_device_add() looks like the right place to do that, altho=
ugh
> > I'm not convinced it's 100% safe. In drivers/char/agp/alpha-agp.c we cr=
eate
> > a pci_dev and I don't see that it ever gets passed to pci_device_add(),=
 but
> > we probably don't care.
>=20
> Well that one appears to be a dummy place holder and probably should at
> least have a kzalloc to initialize all of the fields to know values.
>=20
> Regardless the normal pci device allocation does use kzalloc so we will
> have well defined if not beautiful behavior if we try and use it.
>=20
> Until we have a case where we need to use the msi_list outside of=20
> where we enable and disable msi we should be perfectly fine initializing
> the list somewhere inside of pci_enable_msi, and pci_enable_msix.
> With dev->msi_enabled and dev->msix_enabled serving as flags to the
> rest of the world that it is safe to look at the list.
>=20
> It certainly sounds safer to me then becoming to closely coupled with
> code that doesn't really care about how msi works.  Heck even though
> we repeat the call twice I bet it will even be less code.

I thought about doing it in the MSI enable methods, but I think it
really belongs in the (nonexistant) routine that allocs and sets up a
pci_dev.

I think it's pretty dicy to be passing around a pci_dev with an
uninitialised msi_list. Even if currently no code outside the MSI enable
methods looks at it, I think we're asking for bugs in the future.

So I'll do a patch which adds alloc_pci_dev(), update the callers, and
then put the msi_list initialisation in there.

> > --- msi-new.orig/include/linux/msi.h
> > +++ msi-new/include/linux/msi.h
> > @@ -1,6 +1,8 @@
> >  #ifndef LINUX_MSI_H
> >  #define LINUX_MSI_H
> > =20
> > +#include <linux/list.h>
> > +
> >  struct msi_msg {
> >  	u32	address_lo;	/* low 32 bits of msi message address */
> >  	u32	address_hi;	/* high 32 bits of msi message address */
> > @@ -24,10 +26,8 @@ struct msi_desc {
> >  		unsigned default_irq;	/* default pre-assigned irq	  */
> >  	}msi_attrib;
> > =20
> > -	struct {
> > -		__u16	head;
> > -		__u16	tail;
> > -	}link;
> > +	int irq;
> This should be "unsigned int irq"

Oops, I'll fix that.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-YUAR3J540GEZy43s4XX7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGC0ihdSjSd0sB4dIRAkkCAJ41/b8NnckoqwWF6Zhj1LkVA1OREwCfVNp3
zwLFAwP+npb6hg735Yr3qZM=
=eEDC
-----END PGP SIGNATURE-----

--=-YUAR3J540GEZy43s4XX7--

