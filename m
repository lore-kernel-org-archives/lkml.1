Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbXELCbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbXELCbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762345AbXELCar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:30:47 -0400
Received: from ozlabs.org ([203.10.76.45]:42909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762249AbXELCaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:30:46 -0400
Subject: Re: [PATCH]: Fix assertion failure with MSI on sparc64
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20070511.132644.78708151.davem@davemloft.net>
References: <20070511.132644.78708151.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FlxgEMge/kAj62kUarq0"
Date: Sat, 12 May 2007 12:30:44 +1000
Message-Id: <1178937044.10759.20.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FlxgEMge/kAj62kUarq0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 at 13:26 -0700, David Miller wrote:
> Hi Michael, I'm still working through the various regressions on
> sparc64 added by your MSI changes :-)

Hi Dave,

Guilty as charged - I did CC you on the patches though ;)

> The one I fixed the other day was a missed switch over to
> alloc_pci_dev() in the sparc64 PCI probing code which caused an OOPS
> in pci_enable_msi() because the list head of the pci dev was not
> initialized.  PowerPC's OBP firmware tree based PCI probing code
> was updated, sparc64's wasnt.

Sorry - not sure how I missed that one, it even matches
"k.alloc(.*pci_dev" - thanks for fixing it :)

> Today's find is a triggered assertion in msi_free_irqs() when the
> system doesn't support MSI, in which case arch_setup_msi_irqs() always
> returns an error.

What do you need to determine that the system can't support MSI? Could
you do that logic in arch_msi_check_device()?

> The problem is that when this happens we branch into msi_free_irqs(),
> to which you added the following assertion loop:
>=20
> 	list_for_each_entry(entry, &dev->msi_list, list)
> 		BUG_ON(irq_has_action(entry->irq));
>=20
> Well, if arch_setup_msi_irqs() fails, entry->irq will be zero and
> although that's never assigned to any normal devices we use that IRQ
> number for the timer interrupt on sparc64 so this assertion triggers.
>=20
> Better to test for zero before doing the irq_has_action() assertion
> thing.

Yep, looks good - it matches the logic in arch_teardown_msi_irqs().

cheers


Acked-by: Michael Ellerman <michael@ellerman.id.au>

> Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index e6740d1..d9cbd58 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -549,8 +549,10 @@ static int msi_free_irqs(struct pci_dev* dev)
>  {
>  	struct msi_desc *entry, *tmp;
> =20
> -	list_for_each_entry(entry, &dev->msi_list, list)
> -		BUG_ON(irq_has_action(entry->irq));
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		if (entry->irq)
> +			BUG_ON(irq_has_action(entry->irq));
> +	}
> =20
>  	arch_teardown_msi_irqs(dev);
> =20
--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-FlxgEMge/kAj62kUarq0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRSbUdSjSd0sB4dIRAs6vAJ9cYwZnKHQ033IkXHKPL2ILMHdDJgCfcVm+
3slz03SzOBt0K1TQwmsAUUE=
=rIr6
-----END PGP SIGNATURE-----

--=-FlxgEMge/kAj62kUarq0--

