Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbZJMWbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbZJMWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZJMWbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:31:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50203 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZJMWbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:31:31 -0400
Subject: Re: [PATCH 5/5 v2] kernel handling of CPU DLPAR
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AD4C3A3.5050103@austin.ibm.com>
References: <4AB39FB3.1020608@austin.ibm.com>
	 <4AB3A172.4090601@austin.ibm.com>  <4AD4C3A3.5050103@austin.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KwxoQKOxJ3sgfKvpt4Qn"
Date: Wed, 14 Oct 2009 09:30:54 +1100
Message-Id: <1255473054.21871.39.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KwxoQKOxJ3sgfKvpt4Qn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 13:14 -0500, Nathan Fontenot wrote:
> This adds the capability to DLPAR add and remove CPUs from the kernel. Th=
e
> creates two new files /sys/devices/system/cpu/probe and
> /sys/devices/system/cpu/release to handle the DLPAR addition and removal =
of
> CPUs respectively.

How does this relate to the existing cpu hotplug mechanism? Or is this
making the cpu exist (possible), vs marking it as online?

Is some other platform going to want to do the same? ie. should the
probe/release part be in generic code?

> Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-13 13:08:=
22.000000000 -0500
> +++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-13 13:09:00.00=
0000000 -0500
> @@ -1,11 +1,11 @@
>  /*
> - * dlpar.c - support for dynamic reconfiguration (including PCI
> - * Hotplug and Dynamic Logical Partitioning on RPA platforms).
> + * dlpar.c - support for dynamic reconfiguration (including PCI,

We know it's dlpar.c :)

> + * Memory, and CPU Hotplug and Dynamic Logical Partitioning on
> + * PAPR platforms).
>   *
>   * Copyright (C) 2009 Nathan Fontenot
>   * Copyright (C) 2009 IBM Corporation
>   *
> - *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License version
>   * 2 as published by the Free Software Foundation.
> @@ -19,6 +19,7 @@
>  #include <linux/memory_hotplug.h>
>  #include <linux/sysdev.h>
>  #include <linux/sysfs.h>
> +#include <linux/cpu.h>
> =20
>=20
>  #include <asm/prom.h>
> @@ -408,6 +409,82 @@
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_HOTPLUG_CPU
> +static ssize_t cpu_probe_store(struct class *class, const char *buf,
> +			       size_t count)
> +{
> +	struct device_node *dn;
> +	unsigned long drc_index;
> +	char *cpu_name;
> +	int rc;
> +
> +	rc =3D strict_strtoul(buf, 0, &drc_index);
> +	if (rc)
> +		return -EINVAL;
> +
> +	rc =3D acquire_drc(drc_index);
> +	if (rc)
> +		return rc;
> +
> +	dn =3D configure_connector(drc_index);
> +	if (!dn) {
> +		release_drc(drc_index);
> +		return rc;
> +	}
> +
> +	/* fixup dn name */
> +	cpu_name =3D kzalloc(strlen(dn->full_name) + strlen("/cpus/") + 1,
> +			   GFP_KERNEL);
> +	if (!cpu_name) {
> +		free_cc_nodes(dn);
> +		release_drc(drc_index);
> +		return -ENOMEM;
> +	}
> +
> +	sprintf(cpu_name, "/cpus/%s", dn->full_name);
> +	kfree(dn->full_name);
> +	dn->full_name =3D cpu_name;

What was all that? Firmware gives us a bogus full name? But the parent
is right?

> +	rc =3D add_device_tree_nodes(dn);
> +	if (rc)
> +		release_drc(drc_index);
> +
> +	return rc ? rc : count;

You're sure rc is < 0.

> +}
> +
> +static ssize_t cpu_release_store(struct class *class, const char *buf,
> +				 size_t count)
> +{
> +	struct device_node *dn;
> +	u32 *drc_index;
> +	int rc;
> +
> +	dn =3D of_find_node_by_path(buf);
> +	if (!dn)
> +		return -EINVAL;
> +
> +	drc_index =3D (u32 *)of_get_property(dn, "ibm,my-drc-index", NULL);

No cast required.

> +	if (!drc_index) {
> +		of_node_put(dn);
> +		return -EINVAL;
> +	}
> +
> +	rc =3D release_drc(*drc_index);
> +	if (rc) {
> +		of_node_put(dn);
> +		return rc;
> +	}
> +
> +	rc =3D remove_device_tree_nodes(dn);
> +	if (rc)
> +		acquire_drc(*drc_index);
> +
> +	of_node_put(dn);
> +	return rc ? rc : count;
> +}


cheers

--=-KwxoQKOxJ3sgfKvpt4Qn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrU/54ACgkQdSjSd0sB4dIQpgCcDkcmQDcGTcP4xgQo5VwFcmmw
iU4AniUXtQwynuIUUyzCSGkuOgp/hnPp
=Sl/T
-----END PGP SIGNATURE-----

--=-KwxoQKOxJ3sgfKvpt4Qn--

