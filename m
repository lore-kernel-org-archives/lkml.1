Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYIDJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYIDJMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYIDJMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:12:33 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:35212 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYIDJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:12:32 -0400
Date: Thu, 4 Sep 2008 11:12:30 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v3][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20080904091230.GW14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040402170.5982@takamine.ncl.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6060-1220519417-0001-2"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809040402170.5982@takamine.ncl.cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6060-1220519417-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2008 at 04:02:38AM -0400, Oren Laadan wrote:
>
> Add those interfaces, as well as helpers needed to easily manage the
> file format. The code is roughly broken out as follows:
>
> checkpoint/sys.c - user/kernel data transfer, as well as setup of the
> checkpoint/restart context (a per-checkpoint data structure for
> housekeeping)
>
> checkpoint/checkpoint.c - output wrappers and basic checkpoint handling
>
> checkpoint/restart.c - input wrappers and basic restart handling
>
> Patches to add the per-architecture support as well as the actual
> work to do the memory checkpoint follow in subsequent patches.
>

[...]

> diff --git a/include/linux/ckpt_hdr.h b/include/linux/ckpt_hdr.h
> new file mode 100644
> index 0000000..629ad5a
> --- /dev/null
> +++ b/include/linux/ckpt_hdr.h
> @@ -0,0 +1,82 @@
> +#ifndef _CHECKPOINT_CKPT_HDR_H_
> +#define _CHECKPOINT_CKPT_HDR_H_
> +/*
> + *  Generic container checkpoint-restart
> + *
> + *  Copyright (C) 2008 Oren Laadan
> + *
> + *  This file is subject to the terms and conditions of the GNU General =
Public
> + *  License.  See the file COPYING in the main directory of the Linux
> + *  distribution for more details.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/utsname.h>
> +
> +/*
> + * To maintain compatibility between 32-bit and 64-bit architecture flav=
ors,
> + * keep data 64-bit aligned: use padding for structure members, and use
> + * __attribute__ ((aligned (8))) for the entire structure.
> + */
> +
> +/* records: generic header */
> +
> +struct cr_hdr {
> +	__s16 type;
> +	__s16 len;
> +	__u32 parent;
> +};
> +
> +/* header types */
> +enum {
> +	CR_HDR_HEAD =3D 1,
> +	CR_HDR_STRING,
> +
> +	CR_HDR_TASK =3D 101,
> +	CR_HDR_THREAD,
> +	CR_HDR_CPU,
> +
> +	CR_HDR_MM =3D 201,
> +	CR_HDR_VMA,
> +	CR_HDR_MM_CONTEXT,
> +
> +	CR_HDR_TAIL =3D 5001
> +};
> +
> +struct cr_hdr_head {
> +	__u64 magic;
> +
> +	__u16 major;
> +	__u16 minor;
> +	__u16 patch;
> +	__u16 rev;
> +
> +	__u64 time;	/* when checkpoint taken */
> +	__u64 flags;	/* checkpoint options */
> +
> +	char release[__NEW_UTS_LEN];
> +	char version[__NEW_UTS_LEN];
> +	char machine[__NEW_UTS_LEN];
> +} __attribute__((aligned(8)));
> +
> +struct cr_hdr_tail {
> +	__u64 magic;
> +} __attribute__((aligned(8)));
> +
> +struct cr_hdr_task {
> +	__u64 state;
> +	__u32 exit_state;
> +	__u32 exit_code, exit_signal;

64bits alignment issue?
I probably missed it in previous versions...

Louis

> +
> +	__u64 utime, stime, utimescaled, stimescaled;
> +	__u64 gtime;
> +	__u64 prev_utime, prev_stime;
> +	__u64 nvcsw, nivcsw;
> +	__u64 start_time_sec, start_time_nsec;
> +	__u64 real_start_time_sec, real_start_time_nsec;
> +	__u64 min_flt, maj_flt;
> +
> +	__s32 task_comm_len;
> +} __attribute__((aligned(8)));
> +
> +#endif /* _CHECKPOINT_CKPT_HDR_H_ */

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6060-1220519417-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIv6Z+VKcRuvQ9Q1QRAhVkAJ9nIWbXFmGlEyDnI2IQGu87lv746gCeIfTw
/5vn592JmSqbB4bIkeVUkuA=
=EgkY
-----END PGP SIGNATURE-----

--=_bohort-6060-1220519417-0001-2--
