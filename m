Return-Path: <linux-kernel-owner+w=401wt.eu-S1765773AbYETOEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765773AbYETOEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYETOEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:04:42 -0400
Received: from ozlabs.org ([203.10.76.45]:33770 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYETOEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:04:41 -0400
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, proski@gnu.org, a.p.zijlstra@chello.nl,
       pq@iki.fi, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       sandmann@redhat.com, paulus@samba.org
In-Reply-To: <20080515035918.896765954@goodmis.org>
References: <20080515034942.109223655@goodmis.org>
	 <20080515035918.896765954@goodmis.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zLwuQxwLOJpLHQ/LT9Hc"
Date: Wed, 21 May 2008 00:04:37 +1000
Message-Id: <1211292277.7960.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zLwuQxwLOJpLHQ/LT9Hc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 23:49 -0400, Steven Rostedt wrote:
> plain text document attachment (ftrace-powerpc-port.patch)
> This patch adds full support for ftrace for PowerPC (both 64 and 32 bit).
> This includes dynamic tracing and function filtering.

Hi Steven,

Just a few comments inline ..

> Index: linux-sched-devel.git/arch/powerpc/kernel/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-sched-devel.git.orig/arch/powerpc/kernel/Makefile	2008-05-14 19=
:30:53.000000000 -0700
> +++ linux-sched-devel.git/arch/powerpc/kernel/Makefile	2008-05-14 19:31:5=
6.000000000 -0700
> @@ -12,6 +12,18 @@ CFLAGS_prom_init.o      +=3D -fPIC
>  CFLAGS_btext.o		+=3D -fPIC
>  endif
> =20
> +ifdef CONFIG_FTRACE
> +# Do not trace early boot code
> +CFLAGS_REMOVE_cputable.o =3D -pg
> +CFLAGS_REMOVE_prom_init.o =3D -pg

Why do we not want to trace early boot? Just because it's not useful?=20

> Index: linux-sched-devel.git/arch/powerpc/kernel/entry_32.S
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-sched-devel.git.orig/arch/powerpc/kernel/entry_32.S	2008-05-14 =
19:30:50.000000000 -0700
> +++ linux-sched-devel.git/arch/powerpc/kernel/entry_32.S	2008-05-14 19:31=
:56.000000000 -0700
> @@ -1035,3 +1035,133 @@ machine_check_in_rtas:
>  	/* XXX load up BATs and panic */
> =20
.. snip

> +_GLOBAL(mcount)
> +_GLOBAL(_mcount)
> +	stwu	r1,-48(r1)
> +	stw	r3, 12(r1)
> +	stw	r4, 16(r1)
> +	stw	r5, 20(r1)
> +	stw	r6, 24(r1)
> +	mflr	r3
> +	lwz	r4, 52(r1)
> +	mfcr	r5
> +	stw	r7, 28(r1)
> +	stw	r8, 32(r1)
> +	stw	r9, 36(r1)
> +	stw	r10,40(r1)
> +	stw	r3, 44(r1)
> +	stw	r5, 8(r1)
> +
> +	LOAD_REG_ADDR(r5, ftrace_trace_function)
> +#if 0
> +	mtctr	r3
> +	mr	r1, r5
> +	bctrl
> +#endif
> +	lwz	r5,0(r5)
> +#if 1
> +	mtctr	r5
> +	bctrl
> +#else
> +	bl	ftrace_stub
> +#endif

#if 0, #if 1 ?

> Index: linux-sched-devel.git/arch/powerpc/kernel/ftrace.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-sched-devel.git/arch/powerpc/kernel/ftrace.c	2008-05-14 19:31:5=
6.000000000 -0700
> @@ -0,0 +1,165 @@
> +/*
> + * Code for replacing ftrace calls with jumps.
> + *
> + * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
> + *
> + * Thanks goes out to P.A. Semi, Inc for supplying me with a PPC64 box.
> + *
> + */
> +
> +#include <linux/spinlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/ftrace.h>
> +#include <linux/percpu.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +
> +#include <asm/cacheflush.h>
> +
> +#define CALL_BACK		4

I don't grok what you're doing with CALL_BACK, you add it in places and
subtract in others - and it looks like you could do neither, but I haven't
gone over it in detail.

> +static unsigned int ftrace_nop =3D 0x60000000;

I should really add a #define for that.

> +#ifdef CONFIG_PPC32
> +# define GET_ADDR(addr) addr
> +#else
> +/* PowerPC64's functions are data that points to the functions */
> +# define GET_ADDR(addr) *(unsigned long *)addr
> +#endif

And that.

.. snip

> +notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned lo=
ng addr)
> +{
> +	static unsigned int op;
> +
> +	addr =3D GET_ADDR(addr);
> +
> +	/* Set to "bl addr" */
> +	op =3D 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffe);

0x03fffffe should be 0x03fffffc, if you set bit 1 you'll end with a "bla" i=
nstruction,
ie. branch absolute and link. That shouldn't happen as long as ip and addr =
are
properly aligned, but still.

In fact I think you should just use create_function_call() or create_branch=
() from
include/asm-powerpc/system.h

> +#ifdef CONFIG_PPC64
> +# define _ASM_ALIGN	" .align 3 "
> +# define _ASM_PTR	" .llong "
> +#else
> +# define _ASM_ALIGN	" .align 2 "
> +# define _ASM_PTR	" .long "
> +#endif

We already have a #define for .long, it's called PPC_LONG (asm/asm-compat.h=
)

Perhaps we should add one for .align, PPC_LONG_ALIGN or something?

> +notrace int
> +ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> +		   unsigned char *new_code)
> +{
> +	unsigned replaced;
> +	unsigned old =3D *(unsigned *)old_code;
> +	unsigned new =3D *(unsigned *)new_code;
> +	int faulted =3D 0;
> +
> +	/* move the IP back to the start of the call */
> +	ip -=3D CALL_BACK;
> +
> +	/*
> +	 * Note: Due to modules and __init, code can
> +	 *  disappear and change, we need to protect against faulting
> +	 *  as well as code changing.
> +	 *
> +	 * No real locking needed, this code is run through
> +	 * kstop_machine.
> +	 */
> +	asm volatile (
> +		"1: lwz		%1, 0(%2)\n"
> +		"   cmpw	%1, %5\n"
> +		"   bne		2f\n"
> +		"   stwu	%3, 0(%2)\n"
> +		"2:\n"
> +		".section .fixup, \"ax\"\n"
> +		"3:	li %0, 1\n"
> +		"	b 2b\n"
> +		".previous\n"
> +		".section __ex_table,\"a\"\n"
> +		_ASM_ALIGN "\n"
> +		_ASM_PTR "1b, 3b\n"
> +		".previous"

Or perhaps we just need a macro for adding exception table entries.

> +		: "=3Dr"(faulted), "=3Dr"(replaced)
> +		: "r"(ip), "r"(new),
> +		  "0"(faulted), "r"(old)
> +		: "memory");
> +
> +	if (replaced !=3D old && replaced !=3D new)
> +		faulted =3D 2;
> +
> +	if (!faulted)
> +		flush_icache_range(ip, ip + 8);
> +
> +	return faulted;
> +}

> Index: linux-sched-devel.git/arch/powerpc/kernel/setup_32.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_32.c	2008-05-14 =
19:30:50.000000000 -0700
> +++ linux-sched-devel.git/arch/powerpc/kernel/setup_32.c	2008-05-14 19:31=
:56.000000000 -0700
> @@ -47,6 +47,11 @@
>  #include <asm/kgdb.h>
>  #endif
> =20
> +#ifdef CONFIG_FTRACE
> +extern void _mcount(void);
> +EXPORT_SYMBOL(_mcount);
> +#endif

Can you please put the extern in a header, and the EXPORT_SYMBOL in arch/po=
werpc/kernel/ftrace.c?

> Index: linux-sched-devel.git/arch/powerpc/kernel/setup_64.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-sched-devel.git.orig/arch/powerpc/kernel/setup_64.c	2008-05-14 =
19:30:50.000000000 -0700
> +++ linux-sched-devel.git/arch/powerpc/kernel/setup_64.c	2008-05-14 19:31=
:56.000000000 -0700
> @@ -85,6 +85,11 @@ struct ppc64_caches ppc64_caches =3D {
>  };
>  EXPORT_SYMBOL_GPL(ppc64_caches);
> =20
> +#ifdef CONFIG_FTRACE
> +extern void _mcount(void);
> +EXPORT_SYMBOL(_mcount);
> +#endif

Ditto.


cheers


--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-zLwuQxwLOJpLHQ/LT9Hc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIMtp1dSjSd0sB4dIRAhTBAJ9WanU9pIvM+/H4wK1oXYhtX1Q5QACbBzdx
YheCJGXO6nivZfjr7tuJ1Tc=
=U3h5
-----END PGP SIGNATURE-----

--=-zLwuQxwLOJpLHQ/LT9Hc--

