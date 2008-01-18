Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbYARFzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbYARFzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYARFzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:55:10 -0500
Received: from ozlabs.org ([203.10.76.45]:53817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYARFzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:55:09 -0500
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bH556Zmx0ERcWECw1xBp"
Date: Fri, 18 Jan 2008 16:55:03 +1100
Message-Id: <1200635703.18783.5.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bH556Zmx0ERcWECw1xBp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-12-08 at 04:07 +0530, Balbir Singh wrote:
> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
> NUMA nodes can be specified using the following command line option
>=20

>=20
> Comments are as always welcome!

Here's some :)

> diff -puN arch/powerpc/mm/numa.c~ppc-fake-numa-easy arch/powerpc/mm/numa.=
c
> --- linux-2.6.24-rc4-mm1/arch/powerpc/mm/numa.c~ppc-fake-numa-easy	2007-1=
2-07 21:25:55.000000000 +0530
> +++ linux-2.6.24-rc4-mm1-balbir/arch/powerpc/mm/numa.c	2007-12-08 03:19:4=
6.000000000 +0530
> @@ -24,6 +24,8 @@
> =20
>  static int numa_enabled =3D 1;
> =20
> +static char *cmdline __initdata;

Can you call this fake_numa_args or something, cmdline is a bit generic.


> @@ -39,6 +41,43 @@ static bootmem_data_t __initdata plat_no
>  static int min_common_depth;
>  static int n_mem_addr_cells, n_mem_size_cells;
> =20
> +static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
> +						unsigned int *nid)
> +{
> +	unsigned long long mem;
> +	char *p =3D cmdline;
> +	static unsigned int fake_nid =3D 0;
> +	static unsigned long long curr_boundary =3D 0;
> +
> +	*nid =3D fake_nid;

As I mentioned in my other email I think this is broken, you
unconditionally overwrite *nid, even if no fake numa was specified?

> +	if (!p)
> +		return 0;
> +
> +	mem =3D memparse(p, &p);
> +	if (!mem)
> +		return 0;
> +
> +	if (mem < curr_boundary)
> +		return 0;
> +
> +	curr_boundary =3D mem;
> +
> +	if ((end_pfn << PAGE_SHIFT) > mem) {
> +		/*
> +		 * Skip commas and spaces
> +		 */
> +		while (*p =3D=3D ',' || *p =3D=3D ' ' || *p =3D=3D '\t')
> +			p++;
> +
> +		cmdline =3D p;
> +		fake_nid++;
> +		*nid =3D fake_nid;
> +		dbg("created new fake_node with id %d\n", fake_nid);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static void __cpuinit map_cpu_to_node(int cpu, int node)
>  {
>  	numa_cpu_lookup_table[cpu] =3D node;
> @@ -344,12 +383,14 @@ static void __init parse_drconf_memory(s
>  			if (nid =3D=3D 0xffff || nid >=3D MAX_NUMNODES)
>  				nid =3D default_nid;
>  		}
> -		node_set_online(nid);
> =20
>  		size =3D numa_enforce_memory_limit(start, lmb_size);
>  		if (!size)
>  			continue;
> =20
> +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> +		node_set_online(nid);

I can't convince myself that this is 100% ok, the moving of
node_set_online(). At the very least it's a change in behaviour,
previously we would online the node regardless of the memory limit.

>  		add_active_range(nid, start >> PAGE_SHIFT,
>  				 (start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
>  	}
> @@ -429,7 +470,6 @@ new_range:
>  		nid =3D of_node_to_nid_single(memory);
>  		if (nid < 0)
>  			nid =3D default_nid;
> -		node_set_online(nid);
> =20
>  		if (!(size =3D numa_enforce_memory_limit(start, size))) {
>  			if (--ranges)
> @@ -438,6 +478,9 @@ new_range:
>  				continue;
>  		}
> =20
> +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> +		node_set_online(nid);

Ditto previous comment.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-bH556Zmx0ERcWECw1xBp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHkD83dSjSd0sB4dIRAiaLAJ9QQPF4rINKjN8EOa5eIEJveSMX0gCdHyea
8tl5958vOiocLRygft7mvnA=
=3sfP
-----END PGP SIGNATURE-----

--=-bH556Zmx0ERcWECw1xBp--

