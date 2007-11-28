Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXK1S13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXK1S13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXK1S1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:27:21 -0500
Received: from mail.anarazel.de ([217.115.131.40]:54079 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXK1S1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:27:20 -0500
From: Andres Freund <andres@anarazel.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: "hwcap 0 nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9
Date: Wed, 28 Nov 2007 19:27:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
References: <200711281829.25532.andres@anarazel.de> <474DAF78.8040300@goop.org>
In-Reply-To: <474DAF78.8040300@goop.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2536639.hFE4diLM1p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711281927.07597.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2536639.hFE4diLM1p
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Jeremy,

On Wednesday 28 November 2007, Jeremy Fitzhardinge wrote in "Re: "hwcap 0=20
nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9":
> Andres Freund wrote:
> > after converting a host from using a ubuntu patched 2.6.22 domU to using
> > 2.6.23 xen via paravirt_ops (no configuration change except devicename
> > change in fstab, and another getty running) ldconfig no longer picks up
> > the nosegneg libc leading to segfaults for some programs.
> It shouldn't ever lead to segfaults.  At worst, you should get poor
> performance because the hypervisor emulates the -ve segment offset.
strace -ff=20
perl /usr/bin/debsums --generate=3Dnocheck -sp /var/cache/apt/archives
=2E..
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 4
fstat64(4, {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =3D 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         =3D 0
getdents64(4, /* 3 entries */, 4096)    =3D 72
getdents64(4, /* 0 entries */, 4096)    =3D 0
=2D-- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++
Process 3238 detached

root@test:~# gdb perl5.8.8                =20
GNU gdb 6.6-debian
=2E..
Starting=20
program: /usr/bin/perl5.8.8 /usr/bin/debsums --generate=3Dnocheck -sp /var/=
cache/apt/archives
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
[Thread debugging using libthread_db enabled]
[New Thread -1209940304 (LWP 3356)]
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread -1209940304 (LWP 3356)]
0xb7eda3d7 in readdir64_r () from /lib/tls/i686/cmov/libc.so.6
(gdb) bt
#0  0xb7eda3d7 in readdir64_r () from /lib/tls/i686/cmov/libc.so.6
#1  0x080fdca5 in Perl_pp_readdir ()
#2  0x080c0d29 in Perl_runops_standard ()
#3  0x0806727a in perl_run ()
#4  0x08063732 in main ()

This was before running an ldconfig. After running, it still selects the wr=
ong=20
libraries, but doesnt crash anymore (hm?).


> > /etc/ld.so.conf.d/xen.conf:
> > hwcap 0 nosegneg
> This looks OK.  If this doesn't work, then it suggests there's something
> wrong with the kernel vdso which is not exporting the nonegseg
> (pseudo-)hardware capability.  But we've gone over this several times
> now, and I was fairly sure we'd finally got it right - works for me, at
> least.

> The alternative is that there's some bug on the userspace side in your
> version of Ubuntu...
The thing is, that the same image, aside from the neccessary config changes=
=20
(sda1->xvda1, xvc0->hvc0), recognizes the right libraries. So I dont see an=
=20
obvious problem there.

> > I now discover, that after some playing around (during discovering what
> > the problem is) i must have changed something, because ldd still shows
> > the use of the i686/cmov libraries, but applications reliably causing
> > crashes earlier, dont do so anymore.
> As I said, you shouldn't be seeing crashes either way.  If you are, it
> suggests a hypervisor bug.  Does "xm dmesg" show anything?
(XEN) traps.c:1698:d16 Domain attempted WRMSR 0000008b from 00000056:000000=
00=20
to 00000000:00000000.
(XEN) traps.c:1698:d17 Domain attempted WRMSR 00000404 from 00000000:000000=
01=20
to ffffffff:ffffffff.
And some more of it. But why does a ldconfig, which doesnt change the=20
libraries loaded, change that?

=46or all debug data of the crashes see above.

> > PS: I did this conversion mainly, because I was getting quite random
> > crashes inside the domU. I guess, as this was a vendor kernel + xensour=
ce
> > xen kernel, this isnt appropriate for lkml? As well as the crashes of t=
he
> > Dom0 (ubuntu again)?
> Yeah, anything which isn't 2.6.18-xen isn't officially "Xen project",
> but its worth reporting the bugs to xen-devel (and Ubuntu, of course).
> And to me, for that matter.  I won't be able to help directly, but the
> crashes may highlight things we need to be careful about in the pvops
> Xen support.
Ok, will do so in the next days and will CC you at that.

Btw, is there a roadmap how in-kernel Xen is planned to develop?

Greetings,=20

Andres

--nextPart2536639.hFE4diLM1p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHTbL7porPraT14igRAvD8AJ98z1wNla4Du7NR+9FEJSKaCGTmGgCfVjic
e9SPs+qYXnvptzNfMrVDv+E=
=fMfm
-----END PGP SIGNATURE-----

--nextPart2536639.hFE4diLM1p--
