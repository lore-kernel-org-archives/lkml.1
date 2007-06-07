Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbXFGLdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbXFGLdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXFGLdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:33:17 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52171 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXFGLdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:33:16 -0400
Date: Thu, 7 Jun 2007 13:33:02 +0200 (CEST)
From: Eberhard Moenkeberg <emoenke@gwdg.de>
To: Surya <surya.prabhakar@wipro.com>
cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       kernel-janitors <kernel-janitors@lists.osdl.org>,
       trivial <trivial@kernel.org>, hannu@opensound.com
Subject: Re: [PATCH]: complete cleanup of check_region
In-Reply-To: <1181209169.2422.12.camel@bluegenie>
Message-ID: <Pine.LNX.4.64.0706071330500.17273@gwdu05.gwdg.de>
References: <1181209169.2422.12.camel@bluegenie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1283851528-1623116437-1181215963=:17273"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1283851528-1623116437-1181215963=:17273
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Thu, 7 Jun 2007, Surya wrote:

>=20
> Hi all,
> =09This patch cleans up all the instances of check_region and
> __check_region and replaces them with request_region and
> __request_region. Applies and compiles clean on latest Linus tree.
>=20
> Files affected:
> =09drivers/cdrom/sbpcd.c
> =09drivers/pnp/resource.c
> =09include/linux/ioport.h
> =09kernel/resource.c
> =09sound/oss/pss.c
>=20
>=20
> thanks.
>=20
>=20
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>


in drivers/cdrom/sbpcd.c the message string should be changed too.

Acked-by: Eberhard Moenkeberg <emoenke@gwdg.de>

> ---=20
>=20
> diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
> index a1283b1..2c1355e 100644
> --- a/drivers/cdrom/sbpcd.c
> +++ b/drivers/cdrom/sbpcd.c
> @@ -358,6 +358,11 @@
>   * Add bio/kdev_t changes for 2.5.x required to make it work again.=20
>   * Still room for improvement in the request handling here if anyone
>   * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
> + *
> + *
> + * Cleaned up the reference for deprecated check_region to=20
> + * request_region.
> + * Thu Jun  7 12:14:00 IST 2007 Surya <surya.prabhakar@wipro.com>
>   */
> =20
> =20
> @@ -5670,7 +5675,7 @@ int __init sbpcd_init(void)
>  =09{
>  =09=09addr[1]=3Dsbpcd[port_index];
>  =09=09if (addr[1]=3D=3D0) break;
> -=09=09if (check_region(addr[1],4))
> +=09=09if (request_region(addr[1],4, "sbpcd driver"))
>  =09=09{
>  =09=09=09msg(DBG_INF,"check_region: %03X is not free.\n",addr[1]);
>  =09=09=09continue;
> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> index a685fbe..2be8001 100644
> --- a/drivers/pnp/resource.c
> +++ b/drivers/pnp/resource.c
> @@ -251,7 +251,7 @@ int pnp_check_port(struct pnp_dev * dev, int idx)
>  =09/* check if the resource is already in use, skip if the
>  =09 * device is active because it itself may be in use */
>  =09if(!dev->active) {
> -=09=09if (__check_region(&ioport_resource, *port, length(port,end)))
> +=09=09if (__request_region(&ioport_resource, *port, length(port,end), "i=
sapnp request-region"))
>  =09=09=09return 0;
>  =09}
> =20
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 71ea923..ebe6c22 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -124,19 +124,12 @@ extern struct resource * __request_region(struct re=
source *,
> =20
>  /* Compatibility cruft */
>  #define release_region(start,n)=09__release_region(&ioport_resource, (st=
art), (n))
> -#define check_mem_region(start,n)=09__check_region(&iomem_resource, (sta=
rt), (n))
> +#define check_mem_region(start,n)=09__request_region(&iomem_resource, (s=
tart), (n), "request-region")
>  #define release_mem_region(start,n)=09__release_region(&iomem_resource, =
(start), (n))
> =20
> -extern int __check_region(struct resource *, resource_size_t, resource_s=
ize_t);
>  extern void __release_region(struct resource *, resource_size_t,
>  =09=09=09=09resource_size_t);
> =20
> -static inline int __deprecated check_region(resource_size_t s,
> -=09=09=09=09=09=09resource_size_t n)
> -{
> -=09return __check_region(&ioport_resource, s, n);
> -}
> -
>  /* Wrappers for managed devices */
>  struct device;
>  #define devm_request_region(dev,start,n,name) \
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 9bd14fd..99a97ca 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -520,36 +520,6 @@ struct resource * __request_region(struct resource *=
parent,
>  EXPORT_SYMBOL(__request_region);
> =20
>  /**
> - * __check_region - check if a resource region is busy or free
> - * @parent: parent resource descriptor
> - * @start: resource start address
> - * @n: resource region size
> - *
> - * Returns 0 if the region is free at the moment it is checked,
> - * returns %-EBUSY if the region is busy.
> - *
> - * NOTE:
> - * This function is deprecated because its use is racy.
> - * Even if it returns 0, a subsequent call to request_region()
> - * may fail because another driver etc. just allocated the region.
> - * Do NOT use it.  It will be removed from the kernel.
> - */
> -int __check_region(struct resource *parent, resource_size_t start,
> -=09=09=09resource_size_t n)
> -{
> -=09struct resource * res;
> -
> -=09res =3D __request_region(parent, start, n, "check-region");
> -=09if (!res)
> -=09=09return -EBUSY;
> -
> -=09release_resource(res);
> -=09kfree(res);
> -=09return 0;
> -}
> -EXPORT_SYMBOL(__check_region);
> -
> -/**
>   * __release_region - release a previously reserved resource region
>   * @parent: parent resource descriptor
>   * @start: resource start address
> diff --git a/sound/oss/pss.c b/sound/oss/pss.c
> index ece428b..c61a1a3 100644
> --- a/sound/oss/pss.c
> +++ b/sound/oss/pss.c
> @@ -54,6 +54,9 @@
>   *=09    Added __init to probe_pss(), attach_pss() and probe_pss_mpu()
>   * 02-Jan-2001: Chris Rankin
>   *          Specify that this module owns the coprocessor
> + * 07-Jun-2007: Surya Prabhakar <surya.prabhakar@wipro.com>
> + *=09    Cleaned up the reference for deprecated check_region to=20
> + * =09    request_region.
>   */
> =20
> =20
> @@ -677,7 +680,7 @@ static void configure_nonsound_components(void)
>  =09{
>  =09=09printk(KERN_INFO "PSS: CDROM port not enabled.\n");
>  =09}
> -=09else if(check_region(pss_cdrom_port, 2))
> +=09else if(request_region(pss_cdrom_port, 2, "CDROM config"))
>  =09{
>  =09=09printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
>  =09}
>=20
>=20
> --=20
> surya .
> 07/06/2007


Viele Gr=FC=DFe
Eberhard M=F6nkeberg (emoenke@gwdg.de, em@kki.org)
--1283851528-1623116437-1181215963=:17273--
