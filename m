Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbXCNC1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbXCNC1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbXCNC1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:27:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:48919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807AbXCNC1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:27:23 -0400
Date: Tue, 13 Mar 2007 19:27:13 -0700
From: Seth Arnold <seth.arnold@suse.de>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-ID: <20070314022713.GI27643@suse.de>
Mail-Followup-To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-security-module@vger.kernel.org, safford@watson.ibm.com,
	serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com,
	zohar@us.ibm.com, linux-kernel@vger.kernel.org
References: <1173394696.5981.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zkC76Fx3DIm/XDBj"
Content-Disposition: inline
In-Reply-To: <1173394696.5981.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--zkC76Fx3DIm/XDBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 08, 2007 at 05:58:16PM -0500, Mimi Zohar wrote:
> This is a request for comments for a new Integrity Based Access
> Control(IBAC) LSM module which bases access control decisions
> on the new integrity framework services.=20

Thanks Mimi, nice to see an example of how the integrity framework ought
to be used.

> (Hopefully this will help clarify the interaction between an LSM=20
> module and LIM module.)

Is this module intended to clarify an interface, or be useful in and of
itself?

> Index: linux-2.6.21-rc3-mm2/security/ibac/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.21-rc3-mm2/security/ibac/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for building IBAC
> +#
> +
> +obj-$(CONFIG_SECURITY_IBAC) +=3D ibac.o
> +ibac-y 	:=3D ibac_main.o
> Index: linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> @@ -0,0 +1,126 @@
> +/*
> + * Integrity Based Access Control (IBAC)
> + *
> + * Copyright (C) 2007 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + *      This program is free software; you can redistribute it and/or mo=
dify
> + *      it under the terms of the GNU General Public License as publishe=
d by
> + *      the Free Software Foundation, version 2 of the License.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/kernel.h>
> +#include <linux/security.h>
> +#include <linux/integrity.h>
> +
> +#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
> +int ibac_enabled =3D CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;
> +
> +static int __init ibac_enabled_setup(char *str)
> +{
> +	ibac_enabled =3D simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +
> +__setup("ibac=3D", ibac_enabled_setup);
> +#else
> +int ibac_enabled =3D 0;
> +#endif

If the command line option isn't enabled, how will ibac_enabled ever be
set to '1'? Have I overlooked or forgotten some helper routine elsewhere?

> +static unsigned int integrity_enforce =3D 0;
> +static int __init integrity_enforce_setup(char *str)
> +{
> +	integrity_enforce =3D simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +
> +__setup("ibac_enforce=3D", integrity_enforce_setup);
> +
> +#define XATTR_NAME "security.evm.hash"

Is this name unique to this IBAC module? Or should it be kept in sync
with the integrity framework?

> +static inline int is_kernel_thread(struct task_struct *tsk)
> +{
> +	return (!tsk->mm) ? 1 : 0;
> +}
> +
> +static int ibac_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	struct dentry *dentry =3D bprm->file->f_dentry;
> +	int xattr_len;
> +	char *xattr_value =3D NULL;
> +	int rc, status;
> +
> +	rc =3D integrity_verify_metadata(dentry, XATTR_NAME,
> +				       &xattr_value, &xattr_len, &status);
> +	if (rc < 0 && rc =3D=3D -EOPNOTSUPP) {
> +		kfree(xattr_value);
> +		return 0;
> +	}
> +
> +	if (rc < 0) {
> +		printk(KERN_INFO "verify_metadata %s failed "
> +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
> +		if (!integrity_enforce)
> +			rc =3D 0;
> +		goto out;
> +	}
> +	if (status !=3D INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
> +		if (!is_kernel_thread(current)) {

Please remind me why kernel threads are exempt?

> +			printk(KERN_INFO "verify_metadata %s "
> +			       "(Integrity status: FAIL)\n", bprm->filename);

Integrity status may be FAIL or NO_LABEL at this point -- would it be
more useful to report the whole truth?

> +			if (integrity_enforce) {
> +				rc =3D -EACCES;
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	rc =3D integrity_verify_data(dentry, &status);
> +	if (rc < 0) {
> +		printk(KERN_INFO "%s verify_data failed "
> +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
> +		if (!integrity_enforce)
> +			rc =3D 0;
> +		goto out;
> +	}
> +	if (status !=3D INTEGRITY_PASS) {
> +		if (!is_kernel_thread(current)) {

Please remind me why kernel threads are exempt?

> +			printk(KERN_INFO "verify_data %s "
> +			       "(Integrity status: FAIL)\n", bprm->filename);

Same question about FAIL vs NO_LABEL.. (Would NO_LABEL be caught by a
failing verify_metadata above?)

> +			if (integrity_enforce) {
> +				rc =3D -EACCES;
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	kfree(xattr_value);
> +
> +	/* measure all integrity level executables */
> +	integrity_measure(dentry, bprm->filename, MAY_EXEC);
> +	return 0;

If integrity_measure() fails (can it fail?) is allowing the exec still the
right approach? (I seem to recall that "measuring integrity" is actually
something more like "go off an compute the integrity, but don't compare
it against anything" -- but even if it fails, is continuing correct?)

Rest elided :) Thanks Mimi

--zkC76Fx3DIm/XDBj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF912B+9nuM9mwoJkRAknsAJ43mq1hQ80S0Pkxfot14prYHp7VkwCcD+zG
JP/25P+t9ETvtWmx09Slbc8=
=SJ+A
-----END PGP SIGNATURE-----

--zkC76Fx3DIm/XDBj--
