Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab0BLAKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:10:48 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39924 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab0BLAKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:10:46 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: parsic/sh/sparc tracehook breakage when tracing signals
Date: Thu, 11 Feb 2010 19:10:47 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32.6; KDE/4.3.4; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1627566.h4GJO6812R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201002111910.50596.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1627566.h4GJO6812R
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

when i ported the Blackfin code to the tracehook framework, i copied a late=
nt=20
bug from the sparc port.  trying to trace another process while handling=20
signals no longer worked (and subsequently broke some of the gdb tests).

this was due to calling tracehook_signal_handler() with the last argument=20
(stepping) always as 0.  if we look at the definition of this function in=20
linux/tracehook.h, we see that calling the function stepping=3D0 is pointle=
ss:
	if (stepping)
		ptrace_notify(SIGTRAP);

after Roland pointed out some more stuff, i went back and looked at all the=
=20
tracehook arches in the tree.  it seems like these arches are all broken in=
=20
the same way:
	parisc (arch/parisc/kernel/signal.c)
	SuperH (64bit only) (arch/sh/kernel/signal_64.c)
	Sparc (all bits) (arch/sparc/kernel/signal{_32,32,_64}.c)

seems like you guys should just change the last argument to:
	test_thread_flag(TIF_SINGLESTEP)
=2Dmike

--nextPart1627566.h4GJO6812R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLdJyKAAoJEEFjO5/oN/WBnGMP/0iAgP5/xROM5pverI8/N88r
r2KRre8KNyYGnVVEO47O23JVfjGjk7xjb8rwVcfs4ewK8BWu/HKvYGDJZKnvs5wj
Tq64gUX5eAnquWgj85Gx2fGcRGth9q7GtpuYrd1OMkyHHXf0n2D6eG4ujLevr4Y5
KkAF1P1Y7UicUrjfXe1i5Gx38d/4TDf/Zif2LmBca0BKlTMa8VZj3aJ3WsBTy0Qz
xrMemWdCQHdRhNHv6CiDgajlJANFxCNXS1aSI+ZADyTGkZ0uZj8TUCRFlhDKp8Vc
HBcuLnXGKwhcUcgIucWghE/R0jS/1+HPKQdvrbQOV0NP068ZB2O9Xsl62B6N8Kd2
siXukIHdgDCUf3ZsfOllxhAib4vAGEU8E/E8UK+8GC0JH7aia3i6HpOLXfTBic2P
/l/9NCGX6AblvqyeUaTVEpNQpKM2NZX97CGlBsU0JBrme3pcE3Tpm5OorkHrKXJr
dDGtAMkLr9IgABuVFP+Kpz2R0hWu6f8m+tiK2hQ23pF4yyfANTZd7d6QDMXmEXvT
KqjpwNAGYRTT2frBEBgeEv71D+YuXjA+bJEgE7yEd+FUPOSF+3Klmp4eistvNLX+
k2ODRdV35hAjaYvlhdb0Z5arO4wBaSnnar/lPFP5+swk1JyvZdIUKZvXgVcmhpr9
qR7V2m/oTHaaPHbdoMcB
=zWWT
-----END PGP SIGNATURE-----

--nextPart1627566.h4GJO6812R--
