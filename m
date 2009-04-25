Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZDYDHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZDYDHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZDYDHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:07:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33198 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZDYDHZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:07:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
In-Reply-To: Your message of "Fri, 24 Apr 2009 18:14:22 PDT."
             <200904250133.n3P1XBJn006790@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240628800_5038P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Apr 2009 23:06:40 -0400
Message-ID: <5622.1240628800@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240628800_5038P
Content-Type: text/plain; charset="UTF-8"
Content-Id: <5606.1240628786.1@turing-police.cc.vt.edu>
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2009 18:14:22 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-04-24-18-14 has been uploaded to
> =

>    http://userweb.kernel.org/~akpm/mmotm/

This jumped out and asked if I wanted SLQB as the default allocator (even
though I've had SLAB defined for ages).  I said to myself "what the heck"
and accepted the change...

Tried to build the NVidia binary, and it choked during config on something
that will likely give a *lot* of programs indigestion.

The test program:

#include <linux/autoconf.h>
    #if defined(CONFIG_XEN) &&         defined(CONFIG_XEN_INTERFACE_VERSIO=
N) &&  !defined(__XEN_INTERFACE_VERSION__)
    #define __XEN_INTERFACE_VERSION__ CONFIG_XEN_INTERFACE_VERSION
    #endif
            #include <linux/version.h>
            #include <linux/utsname.h>
            int main() {
              if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)) {
                return 0;
              } else {
                return 1;
              }
            }

The command line:

cc -D__KERNEL__ -DKBUILD_BASENAME=3D"#conftest23112" -DKBUILD_MODNAME=3D"#=
conftest23112" -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.4.0/i=
nclude -I/lib/modules/2.6.30-rc3-mmotm0424/source/include/asm-x86_64/mach-=
default -I/lib/modules/2.6.30-rc3-mmotm0424/source/include/asm-x86/mach-de=
fault -I/lib/modules/2.6.30-rc3-mmotm0424/source/arch/x86/include/asm/mach=
-default -I/lib/modules/2.6.30-rc3-mmotm0424/build/include2 -I/lib/modules=
/2.6.30-rc3-mmotm0424/build/include -I/lib/modules/2.6.30-rc3-mmotm0424/so=
urce/include -I/lib/modules/2.6.30-rc3-mmotm0424/source/arch/x86/include -=
o conftest23112 conftest23112.c

and the joy it got me:

In file included from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linu=
x/slab.h:161,
                 from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linu=
x/percpu.h:5,
                 from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linu=
x/sched.h:76,
                 from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linu=
x/utsname.h:35,
                 from conftest2465.c:6:
/lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/slqb_def.h: In funct=
ion =E2=80=98kmalloc_slab=E2=80=99:
/lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/slqb_def.h:240: erro=
r: size of array =E2=80=98type name=E2=80=99 is negative

Why does utsname.h care about SLAB versus SLUB?  (Looks to me like somebod=
y
forgot to add a #include to slqb_def.h for all the headers it needed, and
it choked.  Interestingly enough, line 240 reads:

        BUILD_BUG_ON(!__builtin_constant_p(size));

but I didn't think this was the way BUILD_BUG_ON worked?

Changed back to SLAB, and things built just fine after that...

--==_Exmh_1240628800_5038P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ8n5AcC3lWbTT17ARAj5wAKCUlfkX0MMFXKDMBlE5BJVHn3rWpgCg4ZMQ
4bD5MmWKWvH/rSOpz7UqsYA=
=gwoA
-----END PGP SIGNATURE-----

--==_Exmh_1240628800_5038P--
