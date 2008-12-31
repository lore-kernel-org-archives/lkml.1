Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYLaEkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYLaEkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYLaEkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:40:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36645 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYLaEkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:40:37 -0500
Date: Wed, 31 Dec 2008 15:40:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org
Subject: Re: [patch] powerpc: change u64/s64 to a long long integer type
Message-Id: <20081231154027.457d9197.sfr@canb.auug.org.au>
In-Reply-To: <20081222080341.GA18897@elte.hu>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au>
	<b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com>
	<20081222070426.GD29160@elte.hu>
	<20081222181932.5dd9514e.sfr@canb.auug.org.au>
	<20081222080341.GA18897@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Dec_2008_15_40_27_+1100_lxmpQ31sob3ZmrIW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Dec_2008_15_40_27_+1100_lxmpQ31sob3ZmrIW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 22 Dec 2008 09:03:41 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> Subject: powerpc: change u64/s64 to a long long integer type
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Dec 22 08:32:41 CET 2008
>=20
> Convert arch/powerpc/ over to long long based u64:
>=20
>  -#ifdef __powerpc64__
>  -# include <asm-generic/int-l64.h>
>  -#else
>  -# include <asm-generic/int-ll64.h>
>  -#endif
>  +#include <asm-generic/int-ll64.h>
>=20
> This will avoid reoccuring spurious warnings in core kernel code that=20
> comes when people test on their own hardware. (i.e. x86 in ~98% of the=20
> cases) This is what x86 uses and it generally helps keep 64-bit code=20
> 32-bit clean too.

Thanks for this great start.  Just a few comments ...

Firstly, it would be nice if we could split this into things we can do
now (e.g. logical bug fixes) and things that must be done at the time of
the u64 type change (e.g. the printk's etc).  That will make the second
patch hopefully somewhat smaller.

> Index: linux/arch/powerpc/kernel/prom.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/powerpc/kernel/prom.c
> +++ linux/arch/powerpc/kernel/prom.c
> @@ -824,11 +824,11 @@ static int __init early_init_dt_scan_cho
>  #endif
> =20
>  #ifdef CONFIG_KEXEC
> -	lprop =3D (u64*)of_get_flat_dt_prop(node, "linux,crashkernel-base", NUL=
L);
> +	lprop =3D (unsigned long *)of_get_flat_dt_prop(node, "linux,crashkernel=
-base", NULL);
>  	if (lprop)
>  		crashk_res.start =3D *lprop;
> =20
> -	lprop =3D (u64*)of_get_flat_dt_prop(node, "linux,crashkernel-size", NUL=
L);
> +	lprop =3D (unsigned long *)of_get_flat_dt_prop(node, "linux,crashkernel=
-size", NULL);

These casts are actually not needed at all as of_get_flat_dt_prop()
returns "void *".

> Index: linux/arch/powerpc/oprofile/cell/vma_map.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/powerpc/oprofile/cell/vma_map.c
> +++ linux/arch/powerpc/oprofile/cell/vma_map.c
> @@ -92,7 +92,7 @@ vma_map_add(struct vma_to_fileoffset_map
>   * A pointer to the first vma_map in the generated list
>   * of vma_maps is returned.  */
>  struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
> -					     unsigned long __spu_elf_start)
> +					     u64 __spu_elf_start)

Wouldn't it make more sense to change the prototype to match the
implementation and the only caller (which passes an "unsigned long")?

> Index: linux/arch/powerpc/platforms/cell/interrupt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/powerpc/platforms/cell/interrupt.c
> +++ linux/arch/powerpc/platforms/cell/interrupt.c
> @@ -148,7 +148,7 @@ static unsigned int iic_get_irq(void)
> =20
>  	iic =3D &__get_cpu_var(iic);
>  	*(unsigned long *) &pending =3D
> -		in_be64((unsigned long __iomem *) &iic->regs->pending_destr);
> +		in_be64((unsigned long long __iomem *) &iic->regs->pending_destr);

in_be64()'s argument is "const volatile u64 __iomem *" so the
original "unsigned long" should have been "u64".

> Index: linux/arch/powerpc/platforms/cell/spu_base.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/arch/powerpc/platforms/cell/spu_base.c
> +++ linux/arch/powerpc/platforms/cell/spu_base.c
> @@ -139,10 +139,10 @@ static void spu_restart_dma(struct spu *
>  {
>  	struct spu_priv2 __iomem *priv2 =3D spu->priv2;
> =20
> -	if (!test_bit(SPU_CONTEXT_SWITCH_PENDING, &spu->flags))
> +	if (!test_bit(SPU_CONTEXT_SWITCH_PENDING, (unsigned long *)&spu->flags))
>  		out_be64(&priv2->mfc_control_RW, MFC_CNTL_RESTART_DMA_COMMAND);
>  	else {
> -		set_bit(SPU_CONTEXT_FAULT_PENDING, &spu->flags);
> +		set_bit(SPU_CONTEXT_FAULT_PENDING, (unsigned long *)&spu->flags);

I have submitted a different patch for this.  The bitops work on unsigned
longs, so I changed the "flags" to be unsigned long.

So, would you like me to push this along - including splitting it up a
bit (keeping your Signed-off-by, of course)?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Dec_2008_15_40_27_+1100_lxmpQ31sob3ZmrIW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkla97sACgkQjjKRsyhoI8xctgCgqNgbRUgxUA8aWzvYgKnM4jme
tCMAoJj8OIJR3iikTE1SuIOqB4rUZW2U
=MlgA
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Dec_2008_15_40_27_+1100_lxmpQ31sob3ZmrIW--
