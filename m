Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZFXLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZFXLLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZFXLLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:11:15 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:35932 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbZFXLLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:11:13 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.42,282,1243807200";
 d="asc'?scan'208";a="16606027"
Message-id: <4A4209D2.4060209@archlinux.org>
Date: Wed, 24 Jun 2009 13:11:14 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: linux-kernel@vger.kernel.org
Subject: Bluetooth HID devices not getting properly removed
X-Enigmail-Version: 0.95.6
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig87E85570AB57974B5EBC8B42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig87E85570AB57974B5EBC8B42
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

I am unsure where to put this bug, because it actually manifests inside=20
HAL. I think the bluetooth hid driver is at fault, because there is an=20
inconsistency in uevents between USB and bluetooth mice.

So this is what happens: When I add a bluetooth mouse, udev receives=20
certain uevents, this is an excerpt from udevadm monitor:

KERNEL[1245834026.993304] add=20
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11 =

(bluetooth)
KERNEL[1245834027.252241] add=20
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11/=
0005:046D:B002.0005=20
(hid)
KERNEL[1245834027.252301] add=20
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11/=
input12=20
(input)

Pay attention to the input device, it is added with a full device path.=20
When removing the mouse, this happens:

KERNEL[1245834012.631443] remove=20
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11 =

(bluetooth)
KERNEL[1245834012.632668] remove   /hci0:11/input12/mouse2 (input)
KERNEL[1245834012.641797] remove   /hci0:11/input12/event8 (input)
KERNEL[1245834012.655447] remove   /hci0:11/input12 (input)
KERNEL[1245834012.655502] remove   /hci0:11/0005:046D:B002.0004 (hid)

See how the device path of the removed input devices is truncated? When=20
I do the same with a USB mouse, a full device path is returned each time.=


All of this results in hal not removing its logical input device, which=20
means the number of (non-existent) mice in the hal device tree increases =

whenever I disable and re-enable my mouse.

So where do I put this bug? Linux? Bluez? Udev? Hal? My guess is Linux,=20
as these device paths come from Linux originally and are in fact=20
inconsistent. This is all tested on 2.6.30, I have no idea if it was the =

case on older kernels.

Please CC me on replies.


--------------enig87E85570AB57974B5EBC8B42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkpCCdIACgkQEda5KzHP/VDSkQCfXJXu3Ask0tbI62MVzVs8y/y/
o2QAoNHDbjsy726VQrrfaoFzTbTMem9T
=LFEa
-----END PGP SIGNATURE-----

--------------enig87E85570AB57974B5EBC8B42--
