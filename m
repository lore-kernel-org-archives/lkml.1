Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYABJty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYABJty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYABJto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:49:44 -0500
Received: from mx28.mail.ru ([194.67.23.67]:10664 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYABJtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:49:43 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: hal@lists.freedesktop.org
Subject: kpowersave stuck at battery charging
Date: Wed, 2 Jan 2008 12:48:49 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1573125.q275fWChfk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801021248.55844.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1573125.q275fWChfk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This is did not happen before; I am not sure right now what caused this (i.=
e.=20
battery aging or some software change) nor whether this is kernel/HAL/kpowe=
rsave=20
issue.

kpowersave is stuck at assuming battery is loading and at 94%. Sysfs displa=
ys=20
battery state as Full:

UEVENT[1199264702.345795]=20
change   /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dchange
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
POWER_SUPPLY_NAME=3DBAT1
POWER_SUPPLY_TYPE=3DBattery
POWER_SUPPLY_STATUS=3DFull
POWER_SUPPLY_PRESENT=3D1
POWER_SUPPLY_TECHNOLOGY=3DLi-ion
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D10800000
POWER_SUPPLY_VOLTAGE_NOW=3D11340000
POWER_SUPPLY_CURRENT_NOW=3D0
POWER_SUPPLY_ENERGY_FULL_DESIGN=3D38880000
POWER_SUPPLY_ENERGY_FULL=3D37530000
POWER_SUPPLY_ENERGY_NOW=3D35640000
POWER_SUPPLY_MODEL_NAME=3DXM2038P04
POWER_SUPPLY_MANUFACTURER=3D
SEQNUM=3D6472

HAL did not set (dis-)charging either:

{pts/0}% lshal -l -u /org/freedesktop/Hal/devices/computer_power_supply_0
udi =3D '/org/freedesktop/Hal/devices/computer_power_supply_0'
  battery.charge_level.current =3D 35640  (0x8b38)  (int)
  battery.charge_level.last_full =3D 37530  (0x929a)  (int)
  battery.charge_level.percentage =3D 94  (0x5e)  (int)
  battery.charge_level.rate =3D 0  (0x0)  (int)
  battery.current =3D 0  (0x0)  (int)
  battery.present =3D true  (bool)
  battery.rechargeable.is_charging =3D false  (bool)
  battery.rechargeable.is_discharging =3D false  (bool)
  battery.reporting.current =3D 35640  (0x8b38)  (int)
  battery.reporting.design =3D 38880  (0x97e0)  (int)
  battery.reporting.last_full =3D 37530  (0x929a)  (int)
  battery.reporting.technology =3D 'Li-ion'  (string)
  battery.reporting.unit =3D 'mWh'  (string)
  battery.technology =3D 'lithium-ion'  (string)
  battery.type =3D 'primary'  (string)
  battery.vendor =3D ''  (string)
  battery.voltage.current =3D 11340  (0x2c4c)  (int)
  info.capabilities =3D {'battery'} (string list)
  info.category =3D 'battery'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Li-ion'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_power_supply_0'  (str=
ing)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'power_supply'  (string)
  linux.sysfs_path=20
=3D '/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1'  (str=
ing)

Kernel 2.6.24-rc6, HAL 0.5.10, kpowersave 0.7.3.

I suspect this is kpowersave which ignores is_(dis)charging attribute and j=
ust=20
compares energy_full with energy_now. According to ACPI spec, energy_full=20
gives "predicted full charge capacity" - actually it is called Last Full Ch=
arge=20
Capacity. At least this is what ACPI battery code implements. As such this =
is=20
purely informational and cannot be relied upon for deciding when charging i=
s=20
complete. Actually HAL /proc/acpi/battery code did not even use this proper=
ty.

So

=2D does ACPI battery code misuse POWER_SUPPLY_PROP_ENERGY_FULL?
=2D does HAL misuse .../energy_full?
=2D does kpowersave misuse battery.charge_level.last_full?

--nextPart1573125.q275fWChfk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHe14DR6LMutpd94wRApFfAJ9M+mD1BrJ2DgMifbObMrNaP6sWggCfUxNm
QgE8pUfLFfb5n7f29vT6oYI=
=LV8P
-----END PGP SIGNATURE-----

--nextPart1573125.q275fWChfk--
