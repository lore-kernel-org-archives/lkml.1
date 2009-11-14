Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbZKNMvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbZKNMvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 07:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZKNMvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 07:51:52 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:53688 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZKNMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 07:51:51 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: Three buttons reported on two-button touchpad
Date: Sat, 14 Nov 2009 15:51:10 +0300
User-Agent: KMail/1.12.90 (Linux/2.6.31.6-desktop-0.rc1.1mnb; KDE/4.3.73; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1855912.F8eKTYv1IE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911141551.14263.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1855912.F8eKTYv1IE
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Kernel 2.6.31.x

dmesg:
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps: 0xa04751/0x0

but /proc/bus/input/devices:

I: Bus=3D0011 Vendor=3D0002 Product=3D0007 Version=3D01b1
N: Name=3D"SynPS/2 Synaptics TouchPad"
P: Phys=3Disa0060/serio1/input0
S: Sysfs=3D/devices/platform/i8042/serio1/input/input15
U: Uniq=3D
H: Handlers=3Dmouse1 event2
B: EV=3Db
B: KEY=3D420 70000 0 0 0 0
B: ABS=3D11000003

So even when capabilities clear say only 2 buttons, driver claims there=20
are 3 of them.

The reason most likely is initialization sequence.=20
psmouse_switch_protocol() unconditionally sets supported buttons:

        input_dev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
        input_dev->keybit[BIT_WORD(BTN_MOUSE)] =3D BIT_MASK(BTN_LEFT) |
                BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
        input_dev->relbit[0] =3D BIT_MASK(REL_X) | BIT_MASK(REL_Y);

before even starting hardware detection and knowing real capabilities.=20
Detection for specific hardware won't change it (possibly only extend).

Is it OK to move button bits setting into ps2bare_detect()? This seems=20
to agree with comments in psmouse_extensions() as well:

/*
 * Okay, all failed, we have a standard mouse here. The number of the=20
buttons
 * is still a question, though. We assume 3.
 */

All other detection routines seem to be setting those bits already.

--nextPart1855912.F8eKTYv1IE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEABECAAYFAkr+p74ACgkQR6LMutpd94w3twCYjjvW30+2AlKT5ULtivr+Vowl
4gCfUT6vyIpnWmdOSLhVrd/LzVcVIg4=
=PzVJ
-----END PGP SIGNATURE-----

--nextPart1855912.F8eKTYv1IE--
