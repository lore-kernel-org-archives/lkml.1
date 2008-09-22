Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbYIVGQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYIVGQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYIVGQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:16:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:32863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYIVGQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,444,1217833200"; 
   d="asc'?scan'208";a="618896433"
Subject: Re: [PATCH] x86: efi vendor_reserved memory type
From: Huang Ying <ying.huang@intel.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <E1KgfWE-0006lU-7s@eag09.americas.sgi.com>
References: <E1KgfWE-0006lU-7s@eag09.americas.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yPzuOb2wjlVTtq7SHTAS"
Date: Mon, 22 Sep 2008 14:16:00 +0800
Message-Id: <1222064160.23099.4.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yPzuOb2wjlVTtq7SHTAS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Cliff,

Why do you need this? Why not just set the memory area as ordinary
RESERVED? And use other method for these special devices to find out
these memory area (such as struct setup_data)?

Best Regards,
Huang Ying
On Fri, 2008-09-19 at 20:55 +0800, Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
>=20
> Add an EFI_VENDOR_RESERVED memory type.
> This supports memory available only to special devices. Such memory
> will
> not be used as general RAM by the OS.
>=20
> And add a method for a device driver to locate that memory. The walk()
> function scans the EFI memory map and does a callback to a specified
> function for each memory area of a specified type.
> efi_memmap_walk_vr() is made available for a module to scan for
> type EFI_VENDOR_RESERVED.
>=20
> A UV driver will be posted later that will use these routines.
>=20
> Diffed against 2.6.27-rc1-mm1-dirty
>=20
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/kernel/efi.c |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h   |    3 ++-
>  2 files changed, 38 insertions(+), 1 deletion(-)
>=20
> Index: linux/arch/x86/kernel/efi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/x86/kernel/efi.c
> +++ linux/arch/x86/kernel/efi.c
> @@ -568,3 +568,39 @@ u64 efi_mem_attributes(unsigned long phy
>         }
>         return 0;
>  }
> +
> +static void
> +walk(efi_freemem_callback_t callback, void *arg, int type)
> +{
> +       efi_memory_desc_t *md;
> +       void *p;
> +       int size;
> +
> +       /*
> +        * memmap.map is zeroed in efi_enter_virtual_mode()
> +        * but we can use the physical address (phys_map)
> +        */
> +       size =3D memmap.nr_map*memmap.desc_size;
> +       for (p =3D memmap.phys_map; p < memmap.phys_map+size;
> +                                               p +=3D memmap.desc_size)
> {
> +               md =3D (efi_memory_desc_t *)__va(p);
> +               if (md->type !=3D type)
> +                       continue;
> +               if ((*callback)(md->phys_addr,
> +                    md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT)
> - 1,
> +                    arg) < 0)
> +                       return;
> +       }
> +}
> +
> +/*
> + * Walk the EFI memory map and call "callback" once for each EFI
> memory
> + * descriptor of type VENDOR_RESERVED.
> + */
> +void
> +efi_memmap_walk_vr(efi_freemem_callback_t callback, void *arg)
> +{
> +       walk(callback, arg, EFI_VENDOR_RESERVED);
> +}
> +
> +EXPORT_SYMBOL_GPL(efi_memmap_walk_vr);
> Index: linux/include/linux/efi.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/linux/efi.h
> +++ linux/include/linux/efi.h
> @@ -77,7 +77,8 @@ typedef       struct {
>  #define EFI_MEMORY_MAPPED_IO           11
>  #define EFI_MEMORY_MAPPED_IO_PORT_SPACE        12
>  #define EFI_PAL_CODE                   13
> -#define EFI_MAX_MEMORY_TYPE            14
> +#define EFI_VENDOR_RESERVED            14
> +#define EFI_MAX_MEMORY_TYPE            15
>=20
>  /* Attribute values: */
>  #define EFI_MEMORY_UC          ((u64)0x0000000000000001ULL)    /*
> uncached */
>=20
>=20

--=-yPzuOb2wjlVTtq7SHTAS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjXOBgACgkQKhFGF+eHlpj33gCfUPm2rcvIMhG/uyhl3kMf+aBr
uL0AmgP7/1SHgx9z7EjD9YrkWn+ur8+U
=HVbW
-----END PGP SIGNATURE-----

--=-yPzuOb2wjlVTtq7SHTAS--

