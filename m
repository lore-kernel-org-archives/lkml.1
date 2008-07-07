Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYGGCFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYGGCFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYGGCFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:05:30 -0400
Received: from ozlabs.org ([203.10.76.45]:50828 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYGGCF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:05:28 -0400
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1215264855-4372-2-git-send-email-matthew@wil.cx>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-2-git-send-email-matthew@wil.cx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w0NXJ7uTTNa1rbj1EeLM"
Date: Mon, 07 Jul 2008 12:05:25 +1000
Message-Id: <1215396326.19157.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w0NXJ7uTTNa1rbj1EeLM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> Add the new API pci_enable_msi_block() to allow drivers to
> request multiple MSIs.  Reimplement pci_enable_msi in terms
> of pci_enable_msi_block.  Add a default implementation of
> arch_setup_msi_block() that only allows one MSI to be requested.

I don't think you need arch_setup_msi_block() at all.

We already have an arch hook that takes a number of irqs, it's
arch_setup_msi_irqs(), plural. It also has the type passed to it (MSI or
MSI-X), so it can decide if it needs to allocate the irq numbers
contiguously.

Or am I missing something?

cheers

> diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
> index c62d101..317c7c8 100644
> --- a/arch/powerpc/kernel/msi.c
> +++ b/arch/powerpc/kernel/msi.c
> @@ -32,7 +32,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, =
int type)
>  	return ppc_md.setup_msi_irqs(dev, nvec, type);
>  }
> =20
> -void arch_teardown_msi_irqs(struct pci_dev *dev)
> +void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
>  {
>  	return ppc_md.teardown_msi_irqs(dev);
>  }
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 92992a8..6cbdf11 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -40,18 +40,31 @@ arch_setup_msi_irq(struct pci_dev *dev, struct msi_de=
sc *entry)
>  }
> =20
>  int __attribute__ ((weak))
> +arch_setup_msi_block(struct pci_dev *pdev, struct msi_desc *desc, int nv=
ec)
> +{
> +	if (nvec > 1)
> +		return 1;
> +	return arch_setup_msi_irq(pdev, desc);
> +}
> +
> +int __attribute__ ((weak))
>  arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  {
> -	struct msi_desc *entry;
> +	struct msi_desc *desc;
>  	int ret;
> =20
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> -		ret =3D arch_setup_msi_irq(dev, entry);
> -		if (ret)
> -			return ret;
> +	if (type =3D=3D PCI_CAP_ID_MSI) {
> +		desc =3D list_first_entry(&dev->msi_list, struct msi_desc, list);
> +		ret =3D arch_setup_msi_block(dev, desc, nvec);
> +	} else {
> +		list_for_each_entry(desc, &dev->msi_list, list) {
> +			ret =3D arch_setup_msi_irq(dev, desc);
> +			if (ret)
> +				break;
> +		}
>  	}
> =20
> -	return 0;
> +	return ret;
>  }
> =20
>  void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
> @@ -60,13 +73,16 @@ void __attribute__ ((weak)) arch_teardown_msi_irq(uns=
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
>  	}
>  }
> =20
> @@ -350,7 +366,7 @@ EXPORT_SYMBOL_GPL(pci_restore_msi_state);
>   * multiple messages. A return of zero indicates the successful setup
>   * of an entry zero with the new MSI irq or non-zero for otherwise.
>   **/
> -static int msi_capability_init(struct pci_dev *dev)
> +static int msi_capability_init(struct pci_dev *dev, int nr_irqs)
>  {
>  	struct msi_desc *entry;
>  	int pos, ret;
> @@ -394,7 +410,7 @@ static int msi_capability_init(struct pci_dev *dev)
>  	list_add_tail(&entry->list, &dev->msi_list);
> =20
>  	/* Configure MSI capability structure */
> -	ret =3D arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
> +	ret =3D arch_setup_msi_irqs(dev, nr_irqs, PCI_CAP_ID_MSI);
>  	if (ret) {
>  		msi_free_irqs(dev);
>  		return ret;
> @@ -546,36 +562,47 @@ static int pci_msi_check_device(struct pci_dev* dev=
, int nvec, int type)
>  }
> =20
>  /**
> - * pci_enable_msi - configure device's MSI capability structure
> - * @dev: pointer to the pci_dev data structure of MSI device function
> + * pci_enable_msi_block - configure device's MSI capability structure
> + * @pdev: Device to configure
> + * @nr_irqs: Number of IRQs requested
> + *
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
>   *
> - * Setup the MSI capability structure of device function with
> - * a single MSI irq upon its software driver call to request for
> - * MSI mode enabled on its hardware device function. A return of zero
> - * indicates the successful setup of an entry zero with the new MSI
> - * irq or non-zero for otherwise.
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
> +
> +	status =3D pci_msi_check_device(pdev, nr_irqs, PCI_CAP_ID_MSI);
>  	if (status)
>  		return status;
> =20
> -	WARN_ON(!!dev->msi_enabled);
> +	WARN_ON(!!pdev->msi_enabled);
> =20
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
> @@ -621,26 +648,30 @@ EXPORT_SYMBOL(pci_disable_msi);
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
>  	}
> =20
> -	arch_teardown_msi_irqs(dev);
> +	arch_teardown_msi_irqs(dev, nvec);
> =20
> -	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
> -		if (entry->msi_attrib._type =3D=3D MSIX_ATTRIB) {
> -			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
> +	list_for_each_entry_safe(desc, tmp, &dev->msi_list, list) {
> +		if (desc->msi_attrib._type =3D=3D MSIX_ATTRIB) {
> +			writel(1, desc->mask_base + desc->msi_attrib.entry_nr
>  				  * PCI_MSIX_ENTRY_SIZE
>  				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> =20
> -			if (list_is_last(&entry->list, &dev->msi_list))
> -				iounmap(entry->mask_base);
> +			if (list_is_last(&desc->list, &dev->msi_list))
> +				iounmap(desc->mask_base);
>  		}
> -		list_del(&entry->list);
> -		kfree(entry);
> +		list_del(&desc->list);
> +		kfree(desc);
>  	}
> =20
>  	return 0;
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index d322148..4731fe7 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -45,9 +45,10 @@ struct msi_desc {
>   * The arch hook for setup up msi irqs
>   */
>  int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
> +int arch_setup_msi_block(struct pci_dev *dev, struct msi_desc *desc, int=
 nvec);
>  void arch_teardown_msi_irq(unsigned int irq);
>  extern int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> -extern void arch_teardown_msi_irqs(struct pci_dev *dev);
> +extern void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec);
>  extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int type=
);
> =20
>=20
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
>  extern void pci_msi_shutdown(struct pci_dev *dev);
>  extern void pci_disable_msi(struct pci_dev *dev);
>  extern int pci_enable_msix(struct pci_dev *dev,
> @@ -737,6 +737,8 @@ extern void msi_remove_pci_irq_vectors(struct pci_dev=
 *dev);
>  extern void pci_restore_msi_state(struct pci_dev *dev);
>  #endif
> =20
> +#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
> +
>  #ifdef CONFIG_HT_IRQ
>  /* The functions a driver should call */
>  int  ht_create_irq(struct pci_dev *dev, int idx);
--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-w0NXJ7uTTNa1rbj1EeLM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIcXnldSjSd0sB4dIRAiMTAJ4n2/mV5QT8YGP9w+O/dlJB4mZ8jACdHcti
Fmax54R8ZgyuiKK799cEJPM=
=klGO
-----END PGP SIGNATURE-----

--=-w0NXJ7uTTNa1rbj1EeLM--

