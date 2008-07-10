Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYGJBdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYGJBdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYGJBcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:32:53 -0400
Received: from ozlabs.org ([203.10.76.45]:38260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbYGJBcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:32:51 -0400
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20080707113105.GY14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-2-git-send-email-matthew@wil.cx>
	 <1215396326.19157.15.camel@localhost>
	 <20080707024525.GV14894@parisc-linux.org>
	 <1215403012.9862.25.camel@localhost>
	 <20080707113105.GY14894@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6dAaAgCCKsRLZkOQxx1K"
Date: Thu, 10 Jul 2008 11:32:44 +1000
Message-Id: <1215653564.13950.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6dAaAgCCKsRLZkOQxx1K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-07 at 05:31 -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 01:56:52PM +1000, Michael Ellerman wrote:
> > So I think you want to make the default arch_msi_check_device() return
> > an error if you ask for MSI & nvec > 1. Then on powerpc we'll probably
> > add the same check to our version (at least until we can test it), but
> > on x86 you can let MSI & nvec > 1 pass.
>=20
> That was my intent ... something like this:

Sorry for the slow response, comments inline ...

> diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
> index c62d101..79ff21f 100644
> --- a/arch/powerpc/kernel/msi.c
> +++ b/arch/powerpc/kernel/msi.c
> @@ -29,10 +29,12 @@ int arch_msi_check_device(struct pci_dev* dev, int nv=
ec, int type)
> =20
>  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  {
> +	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
> +		return 1;

This should go in arch_msi_check_device(). We might move it into a
ppc_md routine eventually.

>  	return ppc_md.setup_msi_irqs(dev, nvec, type);
>  }
> =20
> -void arch_teardown_msi_irqs(struct pci_dev *dev)
> +void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
>  {
>  	return ppc_md.teardown_msi_irqs(dev);
>  }
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 92992a8..4f7b31f 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -42,11 +42,14 @@ arch_setup_msi_irq(struct pci_dev *dev, struct msi_de=
sc *entry)
>  int __attribute__ ((weak))
>  arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  {
> -	struct msi_desc *entry;
> +	struct msi_desc *desc;
>  	int ret;
> =20
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> -		ret =3D arch_setup_msi_irq(dev, entry);
> +	if ((type =3D=3D PCI_CAP_ID_MSI) && (nvec > 1))
> +		return 1;

I think the check should be in the generic arch_msi_check_device(), so
archs can override just the check.

> +
> +	list_for_each_entry(desc, &dev->msi_list, list) {
> +		ret =3D arch_setup_msi_irq(dev, desc);
>  		if (ret)
>  			return ret;
>  	}
> @@ -60,13 +63,16 @@ void __attribute__ ((weak)) arch_teardown_msi_irq(uns=
igned int irq)
>  }
> =20
>  void __attribute__ ((weak))
> -arch_teardown_msi_irqs(struct pci_dev *dev)
> +arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
>  {
>  	struct msi_desc *entry;
> =20
>  	list_for_each_entry(entry, &dev->msi_list, list) {
> -		if (entry->irq !=3D 0)
> -			arch_teardown_msi_irq(entry->irq);
> +		int i;
> +		if (entry->irq =3D=3D 0)
> +			continue;
> +		for (i =3D 0; i < nvec; i++)
> +			arch_teardown_msi_irq(entry->irq + i);

This looks wrong. You're looping through all MSIs for the device, and
then for each one you're looping through all MSIs for the device. And
you're assuming they're contiguous, which they won't be for MSI-X.

AFAICS this code should work for you as it was.

> @@ -546,36 +552,47 @@ static int pci_msi_check_device(struct pci_dev* dev=
, int nvec, int type)
>  }
> =20
>  /**
> - * pci_enable_msi - configure device's MSI capability structure
> - * @dev: pointer to the pci_dev data structure of MSI device function
> + * pci_enable_msi_block - configure device's MSI capability structure
> + * @pdev: Device to configure
> + * @nr_irqs: Number of IRQs requested
>   *
> - * Setup the MSI capability structure of device function with
> - * a single MSI irq upon its software driver call to request for
> - * MSI mode enabled on its hardware device function. A return of zero
> - * indicates the successful setup of an entry zero with the new MSI
> - * irq or non-zero for otherwise.
> + * Allocate IRQs for a device with the MSI capability.
> + * This function returns a negative errno if an error occurs.  On succes=
s,
> + * this function returns the number of IRQs actually allocated.  Since
> + * MSIs are required to be a power of two, the number of IRQs allocated
> + * may be rounded up to the next power of two (if the number requested i=
s
> + * not a power of two).  Fewer IRQs than requested may be allocated if t=
he
> + * system does not have the resources for the full number.
> + *
> + * If successful, the @pdev's irq member will be updated to the lowest n=
ew
> + * IRQ allocated; the other IRQs allocated to this device will be consec=
utive.
>   **/
> -int pci_enable_msi(struct pci_dev* dev)
> +int pci_enable_msi_block(struct pci_dev *pdev, unsigned int nr_irqs)
>  {
>  	int status;
> =20
> -	status =3D pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
> +	/* MSI only supports up to 32 interrupts */
> +	if (nr_irqs > 32)
> +		return 32;

You don't describe this behaviour in the doco. I'm a bit lukewarm on it,
ie. returning the number that /could/ be allocated and having drivers
use that, I think it's likely drivers will be poorly tested in the case
where they get fewer irqs than they ask for. But I suppose that's a
separate problem.

> +
> +	status =3D pci_msi_check_device(pdev, nr_irqs, PCI_CAP_ID_MSI);
>  	if (status)
>  		return status;
> =20
> -	WARN_ON(!!dev->msi_enabled);
> +	WARN_ON(!!pdev->msi_enabled);

Your patches would be easier to read if you didn't keep renaming to
entry to desc and dev to pdev :)

> -	/* Check whether driver already requested for MSI-X irqs */
> -	if (dev->msix_enabled) {
> +	/* Check whether driver already requested MSI-X irqs */
> +	if (pdev->msix_enabled) {
>  		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
>  			"Device already has MSI-X enabled\n",
> -			pci_name(dev));
> +			pci_name(pdev));
>  		return -EINVAL;
>  	}
> -	status =3D msi_capability_init(dev);
> +
> +	status =3D msi_capability_init(pdev, nr_irqs);
>  	return status;
>  }
> -EXPORT_SYMBOL(pci_enable_msi);
> +EXPORT_SYMBOL(pci_enable_msi_block);
> =20
>  void pci_msi_shutdown(struct pci_dev* dev)
>  {
> @@ -621,26 +638,30 @@ EXPORT_SYMBOL(pci_disable_msi);
> =20
>  static int msi_free_irqs(struct pci_dev* dev)
>  {
> -	struct msi_desc *entry, *tmp;
> +	int i, nvec =3D 1;
> +	struct msi_desc *desc, *tmp;
> =20
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> -		if (entry->irq)
> -			BUG_ON(irq_has_action(entry->irq));
> +	list_for_each_entry(desc, &dev->msi_list, list) {
> +		nvec =3D 1 << desc->msi_attrib.multiple;
> +		if (!desc->irq)
> +			continue;
> +		for (i =3D 0; i < nvec; i++)
> +			BUG_ON(irq_has_action(desc->irq + i));

This looks wrong in the same way arch_teardown_msi_irqs() does.

>  	}
> =20
> -	arch_teardown_msi_irqs(dev);
> +	arch_teardown_msi_irqs(dev, nvec);
> =20


> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d18b1dd..f7ca7f8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -699,7 +699,7 @@ struct msix_entry {
> =20
>=20
>  #ifndef CONFIG_PCI_MSI
> -static inline int pci_enable_msi(struct pci_dev *dev)
> +static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int=
 count)
>  {
>  	return -1;
>  }
> @@ -726,7 +726,7 @@ static inline void msi_remove_pci_irq_vectors(struct =
pci_dev *dev)
>  static inline void pci_restore_msi_state(struct pci_dev *dev)
>  { }
>  #else
> -extern int pci_enable_msi(struct pci_dev *dev);
> +extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int count)=
;

Here you have "count", the implementation uses "nr_irqs", and the rest
of the code uses "nvec".

>  extern void pci_msi_shutdown(struct pci_dev *dev);
>  extern void pci_disable_msi(struct pci_dev *dev);
>  extern int pci_enable_msix(struct pci_dev *dev,
> @@ -737,6 +737,8 @@ extern void msi_remove_pci_irq_vectors(struct pci_dev=
 *dev);
>  extern void pci_restore_msi_state(struct pci_dev *dev);
>  #endif
> =20
> +#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)

Someone will probably say this should be a static inline.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-6dAaAgCCKsRLZkOQxx1K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIdWa8dSjSd0sB4dIRAqWHAKCAnBUOyHuDOlBBF5fDD1CCHo4KCgCfc0yG
H1EZXWxYsV4IZ6df6vypaEA=
=k58/
-----END PGP SIGNATURE-----

--=-6dAaAgCCKsRLZkOQxx1K--

