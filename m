Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXFOXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXFOXe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXFOXew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:34:52 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52260 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754983AbXFOXew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:34:52 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [BUG] Interesting race between cpufreq_ondemand and snd_atiixp
Date: Sat, 16 Jun 2007 02:33:41 +0300
User-Agent: KMail/1.9.7
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk, tiwai@suse.de
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24628092.ZCpxYv0aH2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706160233.47659.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24628092.ZCpxYv0aH2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

One of our colleagues found following problem with his old laptop while=20
testing Linus's latest git with external alsa-driver (v1.0.14). And we can=
=20
also reproduce same problem with 2.6.18.8 so it seems not a new regression=
=20
(if it is a regression).

As a summary "sound stops to work if cpufreq_ondemand governor is used" on=
=20
that laptop. Problem occurs only if cpufreq_* modules are loaded and %100=20
reproducable if system configured for ondemand governor.=20

Here are the steps to reproduce the problem on that laptop;

1. Boot system with cpufreq_* modules blacklisted
   strace -o log -f -tttTTT mpg123 some.mp3

works without a problem [full log @ 1]

2. modprobe cpufreq_ondemand
   echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   strace -o log -f -tttTTT mpg123 some.mp3

hangs and no sound at all [full log @ 2]

3. echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   strace -o log -f -tttTTT mpg123 some.mp3

works without a problem [full log @ 3]
=09
And with both 2.6.18.8 and 2.6.22-rc4 KDE (artsd) starts to gave "Operation=
=20
not denied" errors on login, and after that error occured stracing mpg123=20
from console gaves following output (the very same check of semctl fails wi=
th=20
EINTR with second) [full log @ 4];
=20
=2E..
4004  1181948891.899907 semget(5678293, 1, IPC_CREAT|0660) =3D 1081344=20
<0.000010>
4004  1181948891.899945 semctl(1081344, 0, IPC_64|IPC_STAT, 0xbfd1b498) =3D=
 0=20
<0.000009>
4004  1181948891.899981 semctl(1081344, 0, IPC_64|IPC_SET, 0xbfd1b498) =3D =
=2D1=20
EPERM (Operation not permitted) <0.000009>
4004  1181948891.900026 semop(1081344, 0xbfd1b6a0, 2) =3D -1 EINTR (Interru=
pted=20
system call) <15.979441>
4004  1181948907.879574 --- SIGTERM (Terminated) @ 0 (0) ---
4004  1181948907.879782 +++ killed by SIGTERM +++

You can also find dmesg [5], lspci -vv [6], lsmod [7], /proc/cpuinfo=20
[8], /proc/interrupts [9] and used .config [10] from there.

I have also a physical access to that laptop so please just ask if you want=
=20
anything else.

[1] http://cekirdek.pardus.org.tr/~caglar/kernel/working
[2] http://cekirdek.pardus.org.tr/~caglar/kernel/notworking
[3] http://cekirdek.pardus.org.tr/~caglar/kernel/againworking
[4] http://cekirdek.pardus.org.tr/~caglar/kernel/perm
[5] http://cekirdek.pardus.org.tr/~caglar/kernel/dmesg_2.6.22
[6] http://cekirdek.pardus.org.tr/~caglar/kernel/lspci
[7] http://cekirdek.pardus.org.tr/~caglar/kernel/lsmod_2.6.22
[8] http://cekirdek.pardus.org.tr/~caglar/kernel/cpuinfo
[9] http://cekirdek.pardus.org.tr/~caglar/kernel/interrupts
[10] http://cekirdek.pardus.org.tr/~caglar/kernel/config

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart24628092.ZCpxYv0aH2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGcyHby7E6i0LKo6YRAkvYAKDIhgcMCWGbOXwP8TXehrzFHflBPQCfZ45p
7OlhZWulC0uJmGcSvR+j5KQ=
=lxt9
-----END PGP SIGNATURE-----

--nextPart24628092.ZCpxYv0aH2--
