Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbZJMWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbZJMWbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbZJMWbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:31:52 -0400
Received: from ozlabs.org ([203.10.76.45]:50674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbZJMWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:31:50 -0400
Subject: Re: [PATCH 4/5 v3] kernel handling of memory DLPAR
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AD4C346.20801@austin.ibm.com>
References: <4AB39FB3.1020608@austin.ibm.com>
	 <4AB3A13D.1060405@austin.ibm.com>  <4AD4C346.20801@austin.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iX7iz0wiQNauT/dkLkVI"
Date: Wed, 14 Oct 2009 09:31:01 +1100
Message-Id: <1255473061.21871.40.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iX7iz0wiQNauT/dkLkVI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 13:13 -0500, Nathan Fontenot wrote:
> This adds the capability to DLPAR add and remove memory from the kernel. =
 The

Hi Nathan,

Sorry to only get around to reviewing version 3, time is a commodity in
short supply :)

> Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-08 11:08:=
42.000000000 -0500
> +++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-13 13:08:22.00=
0000000 -0500
> @@ -16,6 +16,10 @@
>  #include <linux/notifier.h>
>  #include <linux/proc_fs.h>
>  #include <linux/spinlock.h>
> +#include <linux/memory_hotplug.h>
> +#include <linux/sysdev.h>
> +#include <linux/sysfs.h>
> +
> =20
>  #include <asm/prom.h>
>  #include <asm/machdep.h>
> @@ -404,11 +408,165 @@
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +
> +static struct property *clone_property(struct property *old_prop)
> +{
> +	struct property *new_prop;
> +
> +	new_prop =3D kzalloc((sizeof *new_prop), GFP_KERNEL);
> +	if (!new_prop)
> +		return NULL;
> +
> +	new_prop->name =3D kzalloc(strlen(old_prop->name) + 1, GFP_KERNEL);

kstrdup()?

> +	new_prop->value =3D kzalloc(old_prop->length + 1, GFP_KERNEL);
> +	if (!new_prop->name || !new_prop->value) {
> +		free_property(new_prop);
> +		return NULL;
> +	}
> +
> +	strcpy(new_prop->name, old_prop->name);
> +	memcpy(new_prop->value, old_prop->value, old_prop->length);
> +	new_prop->length =3D old_prop->length;
> +
> +	return new_prop;
> +}
> +
> +int platform_probe_memory(u64 phys_addr)
> +{
> +	struct device_node *dn;
> +	struct property *new_prop, *old_prop;
> +	struct property *lmb_sz_prop;
> +	struct of_drconf_cell *drmem;
> +	u64 lmb_size;
> +	int num_entries, i, rc;
> +
> +	if (!phys_addr)
> +		return -EINVAL;
> +
> +	dn =3D of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
> +	if (!dn)
> +		return -EINVAL;
> +
> +	lmb_sz_prop =3D of_find_property(dn, "ibm,lmb-size", NULL);
> +	lmb_size =3D *(u64 *)lmb_sz_prop->value;

of_get_property() ?
> +
> +	old_prop =3D of_find_property(dn, "ibm,dynamic-memory", NULL);

I know we should never fail to find these properties, but it would be
nice to check just in case.

> +
> +	num_entries =3D *(u32 *)old_prop->value;
> +	drmem =3D (struct of_drconf_cell *)
> +				((char *)old_prop->value + sizeof(u32));

You do this dance twice (see below), a struct might make it cleaner.

> +	for (i =3D 0; i < num_entries; i++) {
> +		u64 lmb_end_addr =3D drmem[i].base_addr + lmb_size;
> +		if (phys_addr >=3D drmem[i].base_addr
> +		    && phys_addr < lmb_end_addr)
> +			break;
> +	}
> +
> +	if (i >=3D num_entries) {
> +		of_node_put(dn);
> +		return -EINVAL;
> +	}
> +
> +	if (drmem[i].flags & DRCONF_MEM_ASSIGNED) {
> +		of_node_put(dn);
> +		return 0;

This is the already added case?

> +	}
> +
> +	rc =3D acquire_drc(drmem[i].drc_index);
> +	if (rc) {
> +		of_node_put(dn);
> +		return -1;

-1 ?

> +	}
> +
> +	new_prop =3D clone_property(old_prop);
> +	drmem =3D (struct of_drconf_cell *)
> +				((char *)new_prop->value + sizeof(u32));
> +
> +	drmem[i].flags |=3D DRCONF_MEM_ASSIGNED;
> +	prom_update_property(dn, new_prop, old_prop);
> +
> +	rc =3D blocking_notifier_call_chain(&pSeries_reconfig_chain,
> +					  PSERIES_DRCONF_MEM_ADD,
> +					  &drmem[i].base_addr);
> +	if (rc =3D=3D NOTIFY_BAD) {
> +		prom_update_property(dn, old_prop, new_prop);
> +		release_drc(drmem[i].drc_index);
> +	}
> +
> +	of_node_put(dn);
> +	return rc =3D=3D NOTIFY_BAD ? -1 : 0;

-1 ?

> +}
> +
> +static ssize_t memory_release_store(struct class *class, const char *buf=
,
> +				    size_t count)
> +{
> +	unsigned long drc_index;
> +	struct device_node *dn;
> +	struct property *new_prop, *old_prop;
> +	struct of_drconf_cell *drmem;
> +	int num_entries;
> +	int i, rc;
> +
> +	rc =3D strict_strtoul(buf, 0, &drc_index);
> +	if (rc)
> +		return -EINVAL;
> +
> +	dn =3D of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
> +	if (!dn)
> +		return 0;

0 really?

> +
> +	old_prop =3D of_find_property(dn, "ibm,dynamic-memory", NULL);
> +	new_prop =3D clone_property(old_prop);
> +
> +	num_entries =3D *(u32 *)new_prop->value;
> +	drmem =3D (struct of_drconf_cell *)
> +				((char *)new_prop->value + sizeof(u32));
> +
> +	for (i =3D 0; i < num_entries; i++) {
> +		if (drmem[i].drc_index =3D=3D drc_index)
> +			break;
> +	}
> +
> +	if (i >=3D num_entries) {
> +		free_property(new_prop);
> +		of_node_put(dn);
> +		return -EINVAL;
> +	}

Couldn't use old_prop up until here? They're identical aren't they, so
you can do the clone here and you can avoid the free in the above error
case.

> +	drmem[i].flags &=3D ~DRCONF_MEM_ASSIGNED;
> +	prom_update_property(dn, new_prop, old_prop);
> +
> +	rc =3D blocking_notifier_call_chain(&pSeries_reconfig_chain,
> +					  PSERIES_DRCONF_MEM_REMOVE,
> +					  &drmem[i].base_addr);
> +	if (rc !=3D NOTIFY_BAD)
> +		rc =3D release_drc(drc_index);
> +
> +	if (rc)
> +		prom_update_property(dn, old_prop, new_prop);
> +
> +	of_node_put(dn);
> +	return rc ? -1 : count;

-1, EPERM?

> +}
> +
> +static struct class_attribute class_attr_mem_release =3D
> +			__ATTR(release, S_IWUSR, NULL, memory_release_store);
> +#endif
> +
>  static int pseries_dlpar_init(void)
>  {
>  	if (!machine_is(pseries))
>  		return 0;
> =20
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +	if (sysfs_create_file(&memory_sysdev_class.kset.kobj,
> +			      &class_attr_mem_release.attr))
> +		printk(KERN_INFO "DLPAR: Could not create sysfs memory "
> +		       "release file\n");
> +#endif
> +
>  	return 0;
>  }
>  device_initcall(pseries_dlpar_init);
> Index: powerpc/arch/powerpc/mm/mem.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- powerpc.orig/arch/powerpc/mm/mem.c	2009-10-08 11:07:45.000000000 -050=
0
> +++ powerpc/arch/powerpc/mm/mem.c	2009-10-08 11:08:54.000000000 -0500
> @@ -111,8 +111,19 @@
>  #ifdef CONFIG_MEMORY_HOTPLUG
> =20
>  #ifdef CONFIG_NUMA
> +int __attribute ((weak)) platform_probe_memory(u64 start)

__weak

Though be careful, I think this is vulnerable to a bug in some
toolchains where the compiler will inline this version. See the comment
around early_irq_init() in kernel/softirq.c for example.

This will need to be a ppc_md hook as soon as another platform supports
memory hotplug, though that may be never :)

> +{
> +	return 0;
> +}
> +
>  int memory_add_physaddr_to_nid(u64 start)
>  {
> +	int rc;
> +
> +	rc =3D platform_probe_memory(start);
> +	if (rc)
> +		return rc;
> +
>  	return hot_add_scn_to_nid(start);
>  }
>  #endif

cheers


--=-iX7iz0wiQNauT/dkLkVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrU/6UACgkQdSjSd0sB4dISgQCgzOl735XOF8THI8v1DStwNjQp
gw0An1NwKbbGU4hpn2KIqtLHQEEISvxm
=CAzw
-----END PGP SIGNATURE-----

--=-iX7iz0wiQNauT/dkLkVI--

