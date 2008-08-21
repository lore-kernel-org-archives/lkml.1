Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYHUSUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYHUSUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYHUSUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:20:45 -0400
Received: from ip4-83-240-21-68.cust.nbox.cz ([83.240.21.68]:55052 "EHLO
	scarab.smoula.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYHUSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:20:45 -0400
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 14:20:44 EDT
Subject: cpufreq regression, unable to set lower frequency
From: Martin Filip <bugtraq@smoula.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GqqAMJ9gvOI+PLk/cbxR"
Date: Thu, 21 Aug 2008 19:51:41 +0200
Message-Id: <1219341101.9264.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GqqAMJ9gvOI+PLk/cbxR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi LKML,

I've upgraded my kernel few days earlier and suddenly my cpufreqd
stopperd working. My configuration is this:
AC adapter connected:
  set scaling_max_freq and scaling_min_freq to maximal available
frequency
AC adapter disconnected:
  set scaling_max_freq to maximal available, scaling_min_freq to minimal
available.

When I connect AC adapter, everything works fine but when I disconnect
my adapter, everything remains on maximal frequency and in logs I can
see:

cpufreqd: cpufreqd_set_profile: Couldn't set profile "Powersave Low" set
for cpu0

After some tests I've traced problem to=20

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.25.y.git;a=3Dc=
ommitdiff;h=3D53391fa20cab6df6b476a5a0ad6be653c9de0c46

What do you think? Is this condition correct?

# cd /sys/devices/system/cpu/cpu0/cpufreq/

when AC adapter is connected, something like this should happen:
# cat scaling_available_frequencies=20
2167000 2000000 1833000 1667000 1500000 1333000 1000000=20
# echo 2167000 > scaling_max_freq=20
# echo 2167000 > scaling_min_freq=20

when disconnected, something like this should:
# echo 1000000 > scaling_max_freq=20
-su: echo: write error: Invalid argument
# echo 1000000 > scaling_min_freq

after min is set, max can be lowered to. Before this patch, lowering max
below min lead to lowering of min to the same value.

I think that this whole condition must not be here at all. After
removing this condition the kernel behaves like this:


# cat scaling_min_freq scaling_max_freq=20
2167000
2167000
# echo 1000000 > scaling_max_freq
# cat scaling_min_freq scaling_max_freq
1000000
1000000
# echo 2167000 > scaling_min_freq
# cat scaling_min_freq scaling_max_freq
1000000
1000000
# echo 2167000 > scaling_max_freq
# echo 2167000 > scaling_min_freq
# cat scaling_min_freq scaling_max_freq
2167000
2167000


Which I think is not perfect but is better then current behavior. What
do you think?

--=20
Martin Filip <bugtraq@smoula.net>
jabber: nexus@smoula.net

--=-GqqAMJ9gvOI+PLk/cbxR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Toto je =?UTF-8?Q?digit=C3=A1ln=C4=9B?=
	=?ISO-8859-1?Q?_podepsan=E1?= =?UTF-8?Q?_=C4=8D=C3=A1st?=
	=?ISO-8859-1?Q?_zpr=E1vy?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkitqy0ACgkQzvp9bBLJ9XO1EACfWQVBIVr1CUEZbZXAdWjWIzYo
+MYAnRxvF0Tnbteuy2r0B9R8gQ5tUNC3
=VAxv
-----END PGP SIGNATURE-----

--=-GqqAMJ9gvOI+PLk/cbxR--

