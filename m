Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXGTWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXGTWlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933399AbXGTWlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:41:13 -0400
Received: from chert.donpac.ru ([80.254.111.36]:47099 "EHLO chert.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765528AbXGTWlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:41:10 -0400
X-Greylist: delayed 42473 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 18:41:10 EDT
Date: Fri, 20 Jul 2007 14:53:08 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
       christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH 4/7] I/OAT: Split PCI startup from DMA handling code
Message-ID: <20070720105307.GB10631@pazke.donpac.ru>
Mail-Followup-To: Shannon Nelson <shannon.nelson@intel.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
	christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
References: <20070720004403.13564.14294.stgit@localhost.localdomain> <20070720004507.13564.77169.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20070720004507.13564.77169.stgit@localhost.localdomain>
X-Uname: Linux 2.6.21-2-amd64 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 200, 07 19, 2007 at 05:45:07PM -0700, Shannon Nelson wrote:
> Split the general PCI startup from the DMA handling code in order to
> prepare for adding support for DCA services and future versions of the
> ioatdma device.
>=20
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> ---
>=20
>  drivers/dma/Makefile     |    2=20
>  drivers/dma/ioat.c       |  186 ++++++++++++++++++++++++++++++++++++++++=
++++
>  drivers/dma/ioat_dma.c   |  196 +++++++++++-----------------------------=
------
>  drivers/dma/ioatdma.h    |   16 +++-
>  drivers/dma/ioatdma_hw.h |    2=20
>  5 files changed, 245 insertions(+), 157 deletions(-)
>=20
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 77bee99..cec0c9c 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -1,5 +1,5 @@
>  obj-$(CONFIG_DMA_ENGINE) +=3D dmaengine.o
>  obj-$(CONFIG_NET_DMA) +=3D iovlock.o
>  obj-$(CONFIG_INTEL_IOATDMA) +=3D ioatdma.o
> -ioatdma-objs :=3D ioat_dma.o
> +ioatdma-objs :=3D ioat.o ioat_dma.o
>  obj-$(CONFIG_INTEL_IOP_ADMA) +=3D iop-adma.o
> diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
> new file mode 100644
> index 0000000..9d9f672
> --- /dev/null
> +++ b/drivers/dma/ioat.c
> @@ -0,0 +1,186 @@
> +/*
> + * Intel I/OAT DMA Linux driver
> + * Copyright(c) 2004 - 2007 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * The full GNU General Public License is included in this distribution =
in
> + * the file called "COPYING".
> + *
> + */
> +
> +/*
> + * This driver supports an Intel I/OAT DMA engine, which does asynchrono=
us
> + * copy operations.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include "ioatdma.h"
> +#include "ioatdma_registers.h"
> +#include "ioatdma_hw.h"
> +
> +MODULE_VERSION("1.24");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation");
> +
> +static struct pci_device_id ioat_pci_tbl[] =3D {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
> +	{ 0, }
> +};

Why this driver lacks MODULE_DEVICE_TABLE() ? Is it intentionaly omitted ?


--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoJQTIWZCBzwS8mkRAtgYAKDLLXTRvdm7oifKUgEPshfEYNUH8wCeMi0H
Anz1SbKaZOAxqDnIraNob5o=
=u1NI
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
