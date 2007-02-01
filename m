Return-Path: <linux-kernel-owner+w=401wt.eu-S1161292AbXBADDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292AbXBADDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 22:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbXBADDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 22:03:11 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:53711 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933383AbXBADDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 22:03:10 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.20-rc7
Date: Thu, 1 Feb 2007 05:01:16 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1195401.b4VfoaX97T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702010501.20994.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1195401.b4VfoaX97T
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

01 =C5=9Eub 2007 Per tarihinde, Linus Torvalds =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> That _usually_ just means that /sbin/modprobe is corrupt, or compiled with
> a binfmt that itself needs a module to load.
>
> Are you 100% certain that you didn't just happen to put an /sbin/modprobe
> into your initramfs that happens to be a.out, with a.out being modular? Or
> something similarly silly?

Yep, i'm sure config and binary is OK.

zangetsu ~ # readelf -h /sbin/busybox
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x8048130
  Start of program headers:          52 (bytes into file)
  Start of section headers:          1010608 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         5
  Size of section headers:           40 (bytes)
  Number of section headers:         25
  Section header string table index: 24

zangetsu ~ #  zcat /proc/config.gz | grep BINFMT
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_AOUT=3Dy
CONFIG_BINFMT_MISC=3Dy

And as i said before same binaries works within initrd image with same kern=
el

> Actually, with that "binfmt-0000", I guess the most likely thing is a
> corrupt /sbin/modprobe that isn't a valid binfmt format at all (but the
> kernel won't know the difference between a missing binfmt thing and an
> invalid one). It has bytes 2/3 being zero, which is neither ELF nor
> a.out, methinks.
>
> BUT! If that's not it, doing a "git bisect" to figure out exactly what
> triggered it would be a wonderful idea..

I think i found the cause of the problem, initramfs can't handle hardlinks=
=20
anymore (which works with 2.6.18), copying same /sbin/busybox binary with=20
different names into initramfs (which ends ups with 50 MB image) or using=20
symbolic ones instead of hards seems works.

=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1195401.b4VfoaX97T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFwVgAy7E6i0LKo6YRAuLoAKCO/+e2+WtJGuE5sw3kSB0KWxgDbACg15E/
NBWFO4+kaVKCr/Niu029yFg=
=j0aA
-----END PGP SIGNATURE-----

--nextPart1195401.b4VfoaX97T--
