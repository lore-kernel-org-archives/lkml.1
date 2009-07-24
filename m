Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZGXHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZGXHSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZGXHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:18:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZGXHSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:18:45 -0400
Date: Fri, 24 Jul 2009 17:18:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: boot panic in serial init
Message-Id: <20090724171841.b128f8be.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jul_2009_17_18_41_+1000_olGmIiZ7e3MchuU0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jul_2009_17_18_41_+1000_olGmIiZ7e3MchuU0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next on a pSeries PowerPC machine panics during boot like
this:

calling  .serial8250_init+0x0/0x230 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
------------[ cut here ]------------
kernel BUG at arch/powerpc/lib/locks.c:36!
cpu 0x0: Vector: 700 (Program Check) at [c0000000be683740]
    pc: c000000000039460: .__spin_yield+0x40/0x90
    lr: c000000000570284: ._spin_lock+0x84/0x90
    sp: c0000000be6839c0
   msr: 8000000000029032
  current =3D 0xc0000000be67e000
  paca    =3D 0xc000000000947200
    pid   =3D 1, comm =3D swapper
kernel BUG at arch/powerpc/lib/locks.c:36!
enter ? for help
[c0000000be683a30] c000000000570284 ._spin_lock+0x84/0x90
[c0000000be683ab0] c00000000056e75c .__mutex_lock_slowpath+0xec/0x2d0
[c0000000be683b90] c00000000056e274 .mutex_lock+0x54/0x60
[c0000000be683c10] c00000000032f6f8 .uart_add_one_port+0xd8/0x3f0
[c0000000be683d30] c0000000007a48c4 .serial8250_init+0x1a4/0x230
[c0000000be683de0] c00000000000947c .do_one_initcall+0x6c/0x1e0
[c0000000be683ee0] c000000000779d6c .kernel_init+0x23c/0x2c0
[c0000000be683f90] c00000000002a8e4 .kernel_thread+0x54/0x70

arch/powerpc/lib/locks.c line 36 is:

        lock_value =3D lock->slock;
        if (lock_value =3D=3D 0)
                return;
        holder_cpu =3D lock_value & 0xffff;
        BUG_ON(holder_cpu >=3D NR_CPUS);

this last line.  Which would imply that the lock has probably not been
initialised.  Indeed, uart_add_one_port does:

	struct tty_port *port;

	mutex_lock(&port->mutex);

without assigning to port.  See "serial-move-mutex" from the ttydev tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jul_2009_17_18_41_+1000_olGmIiZ7e3MchuU0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkppYFEACgkQjjKRsyhoI8zFAgCggYX9ZSlUhQwwRhu5egWUcrpk
gfMAnjtKLiVIfs52W7iPTDKRxLMkDmHq
=jdui
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jul_2009_17_18_41_+1000_olGmIiZ7e3MchuU0--
