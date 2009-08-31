Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZHaLwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZHaLwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZHaLwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:52:47 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:48969 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZHaLwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:52:46 -0400
Date: Mon, 31 Aug 2009 13:52:45 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: linux-kernel@vger.kernel.org
Subject: Regression: device-mapper cannot open devices with identical uuids
 anymore
Message-ID: <20090831115245.GA23044@darkside.12.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

somewhere between 2.6.26 and 2.6.30 device-mapper stopped being able to
open multiple devices with the same UUID:

# uname -a
Linux darkside 2.6.30-1-686 #1 SMP Sat Aug 15 19:11:58 UTC 2009 i686 GNU/Li=
nux
# cp -ia /tmp/foo0 /tmp/foo1
# losetup /dev/loop0 /tmp/foo0
# losetup /dev/loop1 /tmp/foo1
# cryptsetup luksOpen /dev/loop0 foo0
Enter LUKS passphrase for /dev/loop0:
key slot 0 unlocked.
Command successful.
# cryptsetup luksOpen /dev/loop1 foo1
Enter LUKS passphrase for /dev/loop1:
key slot 0 unlocked.
[234800.953458] device-mapper: ioctl: device doesn't appear to be in the de=
v hash table.
Command failed: device-mapper: create ioctl failed: Device or resource busy

This did work in 2.6.26:

# uname -a
Linux abaris 2.6.26-2-686 #1 SMP Fri Aug 14 01:27:18 UTC 2009 i686 GNU/Linux
# cp -ia /tmp/foo0 /tmp/foo1
# losetup /dev/loop0 /tmp/foo0
# losetup /dev/loop1 /tmp/foo1
# cryptsetup luksOpen /dev/loop0 foo0
Enter LUKS passphrase:=20
key slot 0 unlocked.
Command successful.
# cryptsetup luksOpen /dev/loop1 foo1
Enter LUKS passphrase:=20
key slot 0 unlocked.
Command successful.

Equal preparation-sequence for both tests is:

# dd if=3D/dev/zero of=3D/tmp/foo0 bs=3D1M count=3D100
# losetup /dev/loop0 /tmp/foo0
# cryptsetup luksFormat /dev/loop0
# losetup -d /dev/loop0

Changing the UUID in the LUKS header of the foo1 image helps to
successfully open the second device, so the issue seems to be closely
related to the identical UUID.

I've stumbled across this issue because I backup crypted devices and
sometimes (not very often :)) I have to have a peek into one of the
backups...


PS: I'm mailing here because my mail doesn't seem to get delivered to
dm-devel@redhat.com.


Thanks for your work & regards
   Mario
--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSpu5jBS+e2HeSPbpAQJO2Qf+OyXlPAID7hwNWYMqRe5Z1muqFPiP7ZYJ
vE0N7UjGR1RKfwXYliDcz5jAT2m5+A6jOkC8KWI27ZOeiKxVy4BAGe0ArrKWwbHJ
7MNFh/t7AEmqUfu3aDPtowvpFruwwRfFl+UpdIj8j1cMkgkbXFRpDPVMBYEpN1VD
ugPziT+oMoFIzUGIEbM95HyYtK5oRbvK1mNNAbJW42vpQAinrRrp46ChaYaLt0OU
GSdklrsP6aIPfuuyUWVg3LvzHVHfYaN0PldFXv6i7wRe4VZTbhBHge3VxwsLBmdr
A/v937iHZPnzl1NwB1gswbvDtV5KwO7kW1LQQY/q8rQdq9WQy57FlA==
=9t5T
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
