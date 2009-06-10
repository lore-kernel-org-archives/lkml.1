Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZFJACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZFJACo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZFJACg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:02:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48477 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZFJACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:02:35 -0400
Subject: Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory operations and
 huge pages
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Cc: rdreier@cisco.com, alexs@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ewg@lists.openfabrics.org, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com
In-Reply-To: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S9Rw98E4WhQMC5FbJiRl"
Date: Wed, 10 Jun 2009 10:02:36 +1000
Message-Id: <1244592156.4680.5.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S9Rw98E4WhQMC5FbJiRl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 15:59 +0200, Hannes Hering wrote:
> This patch implements toleration of dynamic memory operations and 16 GB
> gigantic pages. On module load the driver walks through available system
> memory, checks for available memory ranges and then registers the kernel
> internal memory region accordingly. The translation of address ranges is
> implemented via a 3-level busmap.

Hi Hannes,

For those of us who haven't read the HEA spec lately, can you give us
some more detail on that? :)

How does it interact with kexec/kdump?

> +static int ehca_update_busmap(unsigned long pfn, unsigned long nr_pages)
> +{
> +	unsigned long i, start_section, end_section;
> +	int top, dir, idx;
> +
> +	if (!nr_pages)
> +		return 0;
> +
> +	if (!ehca_bmap) {
> +		ehca_bmap =3D kmalloc(sizeof(struct ehca_bmap), GFP_KERNEL);
> +		if (!ehca_bmap)
> +			return -ENOMEM;
> +		/* Set map block to 0xFF according to EHCA_INVAL_ADDR */
> +		memset(ehca_bmap, 0xFF, EHCA_TOP_MAP_SIZE);
> +	}
> +
> +	start_section =3D phys_to_abs(pfn * PAGE_SIZE) / EHCA_SECTSIZE;
> +	end_section =3D phys_to_abs((pfn + nr_pages) * PAGE_SIZE) / EHCA_SECTSI=
ZE;


phys_to_abs() ? As below, or does it come from somewhere else?

 arch/powerpc/include/asm/abs_addr.h:
 47 static inline unsigned long phys_to_abs(unsigned long pa)              =
    =20
 48 {
 49         unsigned long chunk;
 50=20
 51         /* This is a no-op on non-iSeries */
 52         if (!firmware_has_feature(FW_FEATURE_ISERIES))
 53                 return pa;
 54=20
 55         chunk =3D addr_to_chunk(pa);
 56=20
 57         if (chunk < mschunks_map.num_chunks)
 58                 chunk =3D mschunks_map.mapping[chunk];
 59=20
 60         return chunk_to_addr(chunk) + (pa & MSCHUNKS_OFFSET_MASK);
 61 }


cheers

--=-S9Rw98E4WhQMC5FbJiRl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkou+A0ACgkQdSjSd0sB4dLuewCfSpTFRmT6ie66HWeYI0citu+h
DRkAniClvuCqubfuz2smbsIRsx0ee0FU
=S1Hv
-----END PGP SIGNATURE-----

--=-S9Rw98E4WhQMC5FbJiRl--

