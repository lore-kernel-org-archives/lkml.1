Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXJ0Qyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXJ0Qyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXJ0Qyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:54:37 -0400
Received: from mx39.mail.ru ([194.67.23.35]:62534 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbXJ0Qyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:54:36 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if battery is absent
Date: Sat, 27 Oct 2007 20:54:30 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7908304.Z9he3TsPEE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710272054.31160.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7908304.Z9he3TsPEE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_H12IHT5Jl25MIH1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_H12IHT5Jl25MIH1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I am not exactly sure about this one ... what other power_supply class driv=
ers=20
do? Should I fix HAL instead (but then, I do not know whether HAL is the on=
ly=20
application that is using this interface).


--Boundary-01=_H12IHT5Jl25MIH1
Content-Type: text/x-diff;
  charset="us-ascii";
  name="2.6.24-rc1_battery_present_property"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="2.6.24-rc1_battery_present_property"

Subject: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if batte=
ry is absent
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Ensure that we always have "present" attribute in sysfs. This is compatible
with procfs case where we had "present: no" if battery was not available.

This fixes HAL battery detection where it does pretend battery is present
but canot provide any value for it.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/battery.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 681e26b..6e67fcd 100644
=2D-- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -187,6 +187,10 @@ static int acpi_battery_get_property(struct power_supp=
ly *psy,
 	return 0;
 }
=20
+static enum power_supply_property missing_battery_props[] =3D {
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
 static enum power_supply_property charge_battery_props[] =3D {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -389,8 +393,13 @@ static int acpi_battery_update(struct acpi_battery *ba=
ttery)
 {
 	int saved_present =3D acpi_battery_present(battery);
 	int result =3D acpi_battery_get_status(battery);
=2D	if (result || !acpi_battery_present(battery))
+	if (result)
 		return result;
+	if (!acpi_battery_present(battery)) {
+		battery->bat.properties =3D missing_battery_props;
+		battery->bat.num_properties =3D ARRAY_SIZE(missing_battery_props);
+		return result;
+	}
 	if (saved_present !=3D acpi_battery_present(battery) ||
 	    !battery->update_time) {
 		battery->update_time =3D 0;

--Boundary-01=_H12IHT5Jl25MIH1--

--nextPart7908304.Z9he3TsPEE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI21HR6LMutpd94wRAgY6AKDA6PkJCBmJgwq3EYAk6owB43+LvwCgwvdX
UhQT7Utx8QZ5IIp9cB7Q1L8=
=crwy
-----END PGP SIGNATURE-----

--nextPart7908304.Z9he3TsPEE--
