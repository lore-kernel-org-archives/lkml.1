Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZFVHXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZFVHXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFVHXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:23:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:36738 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZFVHXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:23:41 -0400
Subject: Re: Badness at drivers/char/tty_ldisc.c:210 during shutdown
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <4A3F281F.9000408@in.ibm.com>
References: <4A3A2D2B.7070704@in.ibm.com>  <4A3F281F.9000408@in.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9kXdcRJptvCDm95r27vH"
Date: Mon, 22 Jun 2009 17:23:41 +1000
Message-Id: <1245655421.4400.78.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9kXdcRJptvCDm95r27vH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-22 at 12:13 +0530, Sachin Sant wrote:
> Sachin Sant wrote:
> > I came across the following badness message during shutdown on a=20
> > Power6 box.
> > This was with 2.6.30-git12(3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8)
> >
> > ------------[ cut here ]------------
> > Badness at drivers/char/tty_ldisc.c:210
> The badness message is still present with git18.
>=20
> ------------[ cut here ]------------
> Badness at drivers/char/tty_ldisc.c:210
> NIP: c00000000040a3e8 LR: c00000000040a3d0 CTR: 0000000000000000
> REGS: c00000003cf6b7f0 TRAP: 0700   Not tainted  (2.6.30-git18)
> MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000424  XER: 00000001
> TASK =3D c00000003e308660[3846] 'vhangup' THREAD: c00000003cf68000 CPU: 1
> <6>GPR00: 0000000000000001 c00000003cf6ba70 c000000000ef48c0 000000000000=
0001=20
> <6>GPR04: 0000000000000001 c00000003819f000 c000000000407b60 000000000000=
0000=20
> <6>GPR08: 0000000000000000 0000000000000000 0000000000000001 c000000000e1=
bce8=20
> <6>GPR12: 0000000044000428 c000000001002600 00000000ffffffff ffffffffffff=
ffff=20
> <6>GPR16: 0000000021fd8a50 0000000000000002 0000000000000000 0000000021fc=
03b0=20
> <6>GPR20: 0000000000000000 0000000000000000 c00000003d04c700 000000000000=
0001=20
> <6>GPR24: 0000000000000000 0000000000000000 0000000000000001 c00000004000=
7e20=20
> <6>GPR28: 0000000000000000 c0000000013ffd38 c000000000e7e860 c00000003cf6=
ba70=20
> NIP [c00000000040a3e8] .tty_ldisc_put+0xbc/0xf4
> LR [c00000000040a3d0] .tty_ldisc_put+0xa4/0xf4
> Call Trace:
> [c00000003cf6ba70] [c00000000040a3d0] .tty_ldisc_put+0xa4/0xf4 (unreliabl=
e)
> [c00000003cf6bb10] [c00000000040a7c8] .tty_ldisc_reinit+0x38/0x80
> [c00000003cf6bba0] [c00000000040b1d8] .tty_ldisc_hangup+0x190/0x260
> [c00000003cf6bc40] [c000000000401090] .do_tty_hangup+0x188/0x4c0
> [c00000003cf6bd20] [c000000000401440] .tty_vhangup_self+0x34/0x54
> [c00000003cf6bdb0] [c00000000019236c] .sys_vhangup+0x38/0x58
> [c00000003cf6be30] [c000000000008534] syscall_exit+0x0/0x40
> Instruction dump:
> 912b0088 4bcd17bd 60000000 e87e8008 7f44d378 481c04fd 60000000 801b0008=20
> 7c09fe70 7d200278 7c004850 54000ffe <0b000000> 7f63db78 4bd7c98d 60000000=
=20

Ah right, so this has check has just gone in, and the code in question
has been rewritten somewhat just recently.

commit 677ca3060c474d7d89941948e32493d9c18c52d2
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Jun 16 17:00:53 2009 +0100

    ldisc: debug aids
   =20
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 874c248..a19e935 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -207,6 +207,7 @@ static void tty_ldisc_put(struct tty_ldisc *ld)
        ldo->refcount--;
        module_put(ldo->owner);
        spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+       WARN_ON(ld->refcount);
        kfree(ld);
 }
=20

I don't grok this code much, but is the WARN racing with something else
doing a get? ie. what is the value of ld->refcount before we drop the
lock?

> Let me know if i can provide any other information.

Try enabling TTY_DEBUG_HANGUP in drivers/char/tty_io.c ?

cheers

--=-9kXdcRJptvCDm95r27vH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko/MX0ACgkQdSjSd0sB4dKC8ACgjMxHRQZsr6q/4c0QXxF3yZ92
HN4AnjOoD5FOnqnznaM823LupRbMFt7N
=tPqC
-----END PGP SIGNATURE-----

--=-9kXdcRJptvCDm95r27vH--

