Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbZFQXmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbZFQXmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFQXlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:41:53 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:41881 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZFQXlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:41:52 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 19:41:52 EDT
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Wed, 17 Jun 2009 19:35:13 -0400
User-Agent: KMail/1.9.9
Cc: Ian Abbott <abbotti@mev.co.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
References: <200906161701.45234.herton@mandriva.com.br> <4A39343C.7030908@mev.co.uk> <200906172009.50798.herton@mandriva.com.br>
In-Reply-To: <200906172009.50798.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15379278.AcGlsTzjNB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906171935.14341.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15379278.AcGlsTzjNB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 17 June 2009, Herton Ronaldo Krzesinski wrote:
> Also s626_attach is modified to use now pci_get_subsys instead of
> pci_get_device as reported by Ian Abbott, additionaly ensuring that
> subvendor or subdevice id is set in pci id table entries.
>
> Reference: http://lkml.org/lkml/2009/6/16/552
> ---
>  drivers/staging/comedi/drivers/s626.c |   35
> ++++++++++++++++++++------------ 1 files changed, 22 insertions(+), 13
> deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c
> b/drivers/staging/comedi/drivers/s626.c index 30dec9d..3ec4407 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -110,9 +110,9 @@ static const struct s626_board s626_boards[] =3D {
>  #define PCI_VENDOR_ID_S626 0x1131
>  #define PCI_DEVICE_ID_S626 0x7146
>
> +/* sub pci id must be specified, see s626_attach for more details */
>  static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) =3D {
> -	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> -		0},
> +	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
>  	{0}
>  };
>
> @@ -498,24 +498,33 @@ static int s626_attach(struct comedi_device *dev,
> struct comedi_devconfig *it) resource_size_t resourceStart;
>  	dma_addr_t appdma;
>  	struct comedi_subdevice *s;
> -	struct pci_dev *pdev;
> +	const struct pci_device_id *ids;
> +	struct pci_dev *pdev =3D NULL;
>
>  	if (alloc_private(dev, sizeof(struct s626_private)) < 0)
>  		return -ENOMEM;
>
> -	for (pdev =3D pci_get_device(PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626,
> -			NULL); pdev !=3D NULL;
> -		pdev =3D pci_get_device(PCI_VENDOR_ID_S626,
> -			PCI_DEVICE_ID_S626, pdev)) {
> +	/*
> +	 * Require also one of sub pci ids to be defined (see check below),
> +	 * otherwise there will be a clash with Philips SAA7146 media/dvb
> +	 * based cards (they have same vendor:device =3D=3D 0x1131:0x7146 pair
> +	 * as main S626 cards)
> +	 */
> +	for (ids =3D s626_pci_table;
> +	     (ids->vendor && (ids->subvendor || ids->subdevice)) && !pdev;
> +	     ids++) {
> +		pdev =3D pci_get_subsys(ids->vendor, ids->device, ids->subvendor,
> +				      ids->subdevice, NULL);
> +		if (!pdev)
> +			continue;
> +
>  		if (it->options[0] || it->options[1]) {
> +			/* matches requested bus/slot */
>  			if (pdev->bus->number =3D=3D it->options[0] &&
> -				PCI_SLOT(pdev->devfn) =3D=3D it->options[1]) {
> -				/* matches requested bus/slot */
> +			    PCI_SLOT(pdev->devfn) =3D=3D it->options[1])
>  				break;
> -			}
> -		} else {
> -			/* no bus/slot specified */
> -			break;
> +			pci_dev_put(pdev);
> +			pdev =3D NULL;
>  		}
>  	}
>  	devpriv->pdev =3D pdev;


This patch looks buggy.  It's changing the logic beyond just checking for=20
subvendor/subdevice ids.


--nextPart15379278.AcGlsTzjNB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKOX2y5vihyNWuA4URAsF5AKCMud13BW4meTpBvT1D6IYaWxpWRwCgwr2r
OMZrJGP5jo48qmYyw37ONnw=
=mOH/
-----END PGP SIGNATURE-----

--nextPart15379278.AcGlsTzjNB--
