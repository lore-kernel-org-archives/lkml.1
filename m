Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbXJGQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbXJGQxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXJGQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:53:07 -0400
Received: from mx34.mail.ru ([194.67.23.200]:15106 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXJGQxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:53:06 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: toshiba_acpi@memebeam.org
Subject: [PATCH] Fix Oops in toshiba_acpi error return path
Date: Sun, 7 Oct 2007 20:52:57 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1829313.ShhmVIek1p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710072053.02865.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1829313.ShhmVIek1p
Content-Type: multipart/mixed;
  boundary="Boundary-01=_q7QCH7Yru47PWvM"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_q7QCH7Yru47PWvM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This fixes oops when registering backlight device fails. Attached as I stil=
l=20
cannot convince kmail to not mangle long lines ...

=2Dandrey

--Boundary-01=_q7QCH7Yru47PWvM
Content-Type: text/x-diff;
  charset="us-ascii";
  name="toshiba_acpi-oops"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="toshiba_acpi-oops"

Subject: [PATCH] Fix Oops in toshiba_acpi error return path
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

When backlight_device_register() fails, return after undo initialization,
do not try to use pointer that just was reset to NULL

This fixes this oops:

[ 1595.177672]  [<c010480a>] show_trace_log_lvl+0x1a/0x30
[ 1595.177706]  [<c01052a2>] show_trace+0x12/0x20
[ 1595.177718]  [<c0105305>] dump_stack+0x15/0x20
[ 1595.177728]  [<c01c9375>] kobject_shadow_add+0x125/0x1c0
[ 1595.177754]  [<c01c941a>] kobject_add+0xa/0x10
[ 1595.177764]  [<c0239a37>] device_add+0x97/0x5d0
[ 1595.177776]  [<c0239f82>] device_register+0x12/0x20
[ 1595.177786]  [<dfd912df>] backlight_device_register+0x9f/0x110 [backligh=
t]
[ 1595.177814]  [<df861117>] toshiba_acpi_init+0x117/0x15e [toshiba_acpi]
[ 1595.177834]  [<c013e28d>] sys_init_module+0xfd/0x14e0
[ 1595.177871]  [<c0104112>] sysenter_past_esp+0x5f/0x99
[ 1595.177883]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1595.177890] Could not register toshiba backlight device
[ 1595.177985] BUG: unable to handle kernel NULL pointer dereference at vir=
tual address 00000004
=2E..
[ 1595.394097] EIP:    0060:[<df861143>]    Not tainted VLI
[ 1595.394101] EFLAGS: 00010282   (2.6.23-rc9-1avb #24)
[ 1595.480081] EIP is at toshiba_acpi_init+0x143/0x15e [toshiba_acpi]

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/toshiba_acpi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 13369b4..18660cc 100644
=2D-- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -591,9 +591,12 @@ static int __init toshiba_acpi_init(void)
 						NULL,
 						&toshiba_backlight_data);
         if (IS_ERR(toshiba_backlight_device)) {
+		int ret =3D PTR_ERR(toshiba_backlight_device);
+
 		printk(KERN_ERR "Could not register toshiba backlight device\n");
 		toshiba_backlight_device =3D NULL;
 		toshiba_acpi_exit();
+		return ret;
 	}
         toshiba_backlight_device->props.max_brightness =3D HCI_LCD_BRIGHTN=
ESS_LEVELS - 1;
=20

--Boundary-01=_q7QCH7Yru47PWvM--

--nextPart1829313.ShhmVIek1p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHCQ7qR6LMutpd94wRAg3xAKDPdQtXpMGbBHIIaT8Ev3lqM48OZACgpzvs
cT+P51Pcf3Oo2Jt93hljHzM=
=daLG
-----END PGP SIGNATURE-----

--nextPart1829313.ShhmVIek1p--
