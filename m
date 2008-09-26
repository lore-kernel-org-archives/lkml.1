Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYIZGl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYIZGl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYIZGls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:41:48 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53767 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYIZGlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:41:47 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Jing Huang <huangj@brocade.com>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Date: Fri, 26 Sep 2008 08:41:31 +0200
User-Agent: KMail/1.9.10
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com,
       vravindr@brocade.com
References: <200809260054.m8Q0slEL027478@swe37.brocade.com>
In-Reply-To: <200809260054.m8Q0slEL027478@swe37.brocade.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7597654.u251fTYhS1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809260841.39433.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7597654.u251fTYhS1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
>
> This patch contains code that interfaces to upper layer linux kernel,
> such as PCI, SCSI mid-layer and sysfs etc. It is created using 2.6.27-rc7
> kernel.
>
> Signed-off-by: Jing Huang <huangj@brocade.com>

> +int
> +bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
> +{
> +	unsigned long   bar0_len;
> +	int             rc =3D -ENODEV;
> +
> +	if (pci_enable_device(pdev)) {
> +		BFA_PRINTF(BFA_ERR, "pci_enable_device fail %p\n", pdev);
> +		goto out;
> +	}

You should use pcim_enable_device(). This would help you by simplifying you=
r=20
error and release code as it keeps track of freeing a bunch of resources. S=
ee=20
Documentation/driver-model/devres.txt.

> +
> +	if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
> +		goto out_disable_device;
> +
> +	pci_set_master(pdev);
> +
> +
> +	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) !=3D 0)
> +		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) !=3D 0) {
> +			BFA_PRINTF(BFA_ERR, "pci_set_dma_mask fail %p\n", pdev);
> +			goto out_release_region;
> +		}
> +#ifdef SUPPORT_PCI_AER
> +	/*
> +	 * Enable PCIE Advanced Error Recovery (AER) if the kernel version
> +	 * supports.
> +	 */
> +	BFAD_ENABLE_PCIE_AER(pdev);
> +#endif
> +
> +	bfad->pci_bar0_map =3D pci_resource_start(pdev, 0);
> +	bar0_len =3D pci_resource_len(pdev, 0);
> +	bfad->pci_bar0_kva =3D ioremap(bfad->pci_bar0_map, bar0_len);

bfad->pci_bar0_kva =3D pcim_iomap(pdev, 0, 0);

> +
> +	if (bfad->pci_bar0_kva =3D=3D NULL) {
> +		BFA_DEV_PRINTF(bfad, BFA_ERR, "Fail to map bar0\n");
> +		goto out_release_region;
> +	}
> +
> +	bfad->hal_pcidev.pci_slot =3D PCI_SLOT(pdev->devfn);
> +	bfad->hal_pcidev.pci_func =3D PCI_FUNC(pdev->devfn);
> +	bfad->hal_pcidev.pci_bar_kva =3D bfad->pci_bar0_kva;
> +	bfad->hal_pcidev.device_id =3D pdev->device;
> +	bfad->pci_name =3D pci_name(pdev);
> +
> +	bfad->pci_attr.vendor_id =3D pdev->vendor;
> +	bfad->pci_attr.device_id =3D pdev->device;
> +	bfad->pci_attr.ssid =3D pdev->subsystem_device;
> +	bfad->pci_attr.ssvid =3D pdev->subsystem_vendor;
> +	bfad->pci_attr.pcifn =3D PCI_FUNC(pdev->devfn);

Why duplicate all this information?

Greetings,

Eike

--nextPart7597654.u251fTYhS1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjchCMACgkQXKSJPmm5/E46QwCfY1VV+yPJjmL5p/15IxcyN5tH
PfMAnRocaSPFgBp4tVd1NX3BcYUlMA8Q
=SusH
-----END PGP SIGNATURE-----

--nextPart7597654.u251fTYhS1--
