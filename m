Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYIDJrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYIDJrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYIDJrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:47:43 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:42894 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYIDJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:47:42 -0400
Date: Thu, 4 Sep 2008 11:47:40 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
Message-ID: <20080904094740.GY14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6599-1220521527-0001-2"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6599-1220521527-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2008 at 04:05:50AM -0400, Oren Laadan wrote:
>
> Dump the files_struct of a task with 'struct cr_hdr_files', followed by
> all open file descriptors. Since FDs can be shared, they are assigned a
> tag and registered in the object hash.
>
> For each open FD there is a 'struct cr_hdr_fd_ent' with the FD, its tag
> and its close-on-exec property. If the FD is to be saved (first time)
> then this is followed by a 'struct cr_hdr_fd_data' with the FD state.
> Then will come the next FD and so on.
>
> This patch only handles basic FDs - regular files, directories and also
> symbolic links.
>

[...]

> diff --git a/checkpoint/ckpt_file.c b/checkpoint/ckpt_file.c
> new file mode 100644
> index 0000000..34df371
> --- /dev/null
> +++ b/checkpoint/ckpt_file.c
> @@ -0,0 +1,224 @@
> +/*
> + *  Checkpoint file descriptors
> + *
> + *  Copyright (C) 2008 Oren Laadan
> + *
> + *  This file is subject to the terms and conditions of the GNU General =
Public
> + *  License.  See the file COPYING in the main directory of the Linux
> + *  distribution for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/file.h>
> +#include <linux/fdtable.h>
> +#include <linux/ckpt.h>
> +#include <linux/ckpt_hdr.h>
> +
> +#include "ckpt_file.h"
> +
> +#define CR_DEFAULT_FDTABLE  256
> +
> +/**
> + * cr_scan_fds - scan file table and construct array of open fds
> + * @files: files_struct pointer
> + * @fdtable: (output) array of open fds
> + * @return: the number of open fds found
> + *
> + * Allocates the file descriptors array (*fdtable), caller should free
> + */
> +int cr_scan_fds(struct files_struct *files, int **fdtable)
> +{
> +	struct fdtable *fdt;
> +	int *fdlist;
> +	int i, n, max;
> +
> +	max =3D CR_DEFAULT_FDTABLE;
> +
> + repeat:
> +	n =3D 0;
> +	fdlist =3D kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
> +	if (!fdlist)
> +		return -ENOMEM;
> +
> +	spin_lock(&files->file_lock);
> +	fdt =3D files_fdtable(files);
> +	for (i =3D 0; i < fdt->max_fds; i++) {
> +		if (fcheck_files(files, i)) {
> +			if (n =3D=3D max) {
> +				spin_unlock(&files->file_lock);
> +				kfree(fdlist);
> +				max *=3D 2;
> +				if (max < 0) {	/* overflow ? */
> +					n =3D -EMFILE;
> +					break;
> +				}
> +				goto repeat;

				fdlist =3D krealloc(fdlist, max, GFP_KERNEL)?

Sorry, I should have suggested this in my first review.

Louis

> +			}
> +			fdlist[n++] =3D i;
> +		}
> +	}
> +	spin_unlock(&files->file_lock);
> +
> +	*fdtable =3D fdlist;
> +	return n;
> +}
> +

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6599-1220521527-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIv668VKcRuvQ9Q1QRAvWuAKC1ojg6iOa8U2sfcc5YvR4IkuGXrACfamin
bbx1ZDq35Tirzo0R+1UTfTc=
=mt7i
-----END PGP SIGNATURE-----

--=_bohort-6599-1220521527-0001-2--
