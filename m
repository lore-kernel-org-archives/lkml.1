Return-Path: <linux-kernel-owner+w=401wt.eu-S966151AbXFGAfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151AbXFGAfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965240AbXFGAfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:35:05 -0400
Received: from ozlabs.org ([203.10.76.45]:35821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXFGAfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:35:03 -0400
Subject: Re: [PATCH 2.6.22-rc4] ehea: Fixed possible kernel panic on VLAN
	packet recv
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Thomas Klein <osstklei@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>
In-Reply-To: <200706062053.16986.osstklei@de.ibm.com>
References: <200706062053.16986.osstklei@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mcXb+V+eRMmRMoHPYMoC"
Date: Thu, 07 Jun 2007 10:35:00 +1000
Message-Id: <1181176500.4166.1.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mcXb+V+eRMmRMoHPYMoC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-06 at 20:53 +0200, Thomas Klein wrote:
> This patch fixes a possible kernel panic due to not checking the vlan gro=
up
> when processing received VLAN packets and a malfunction in VLAN/hyperviso=
r
> registration.
>=20
>=20
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> ---
>=20
>=20
> diff -Nurp -X dontdiff linux-2.6.22-rc4/drivers/net/ehea/ehea.h patched_k=
ernel/drivers/net/ehea/ehea.h
> --- linux-2.6.22-rc4/drivers/net/ehea/ehea.h	2007-06-05 02:57:25.00000000=
0 +0200
> +++ patched_kernel/drivers/net/ehea/ehea.h	2007-06-06 12:53:58.000000000 =
+0200
> @@ -39,7 +39,7 @@
>  #include <asm/io.h>
> =20
>  #define DRV_NAME	"ehea"
> -#define DRV_VERSION	"EHEA_0061"
> +#define DRV_VERSION	"EHEA_0064"
> =20
>  #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
>  	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
> diff -Nurp -X dontdiff linux-2.6.22-rc4/drivers/net/ehea/ehea_main.c patc=
hed_kernel/drivers/net/ehea/ehea_main.c
> --- linux-2.6.22-rc4/drivers/net/ehea/ehea_main.c	2007-06-05 02:57:25.000=
000000 +0200
> +++ patched_kernel/drivers/net/ehea/ehea_main.c	2007-06-06 12:53:58.00000=
0000 +0200
> @@ -1947,7 +1945,7 @@ static void ehea_vlan_rx_add_vid(struct=20
>  	}
> =20
>  	index =3D (vid / 64);
> -	cb1->vlan_filter[index] |=3D ((u64)(1 << (vid & 0x3F)));
> +	cb1->vlan_filter[index] |=3D ((u64)(0x8000000000000000 >> (vid & 0x3F))=
);
> =20
>  	hret =3D ehea_h_modify_ehea_port(adapter->handle, port->logical_port_id=
,
>  				       H_PORT_CB1, H_PORT_CB1_ALL, cb1);
> @@ -1982,7 +1980,7 @@ static void ehea_vlan_rx_kill_vid(struct
>  	}
> =20
>  	index =3D (vid / 64);
> -	cb1->vlan_filter[index] &=3D ~((u64)(1 << (vid & 0x3F)));
> +	cb1->vlan_filter[index] &=3D ~((u64)(0x8000000000000000 >> (vid & 0x3F)=
));

These two seem ripe for splitting into some sort of helper routine.
Which would leave only one place to get it right.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-mcXb+V+eRMmRMoHPYMoC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGZ1K0dSjSd0sB4dIRAgCPAKC0cdqLYHAJcGSH7K3tj8soQgn0VwCgsqcG
Mpkt/9j8eZqK2t8M2IARs+g=
=BG5i
-----END PGP SIGNATURE-----

--=-mcXb+V+eRMmRMoHPYMoC--

