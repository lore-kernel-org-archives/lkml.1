Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXJ1Hhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXJ1Hhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 03:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXJ1Hhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 03:37:34 -0400
Received: from mx5.mail.ru ([194.67.23.25]:15285 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXJ1Hhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 03:37:32 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: cbou@mail.ru
Subject: [PATCH] [2.6.24-rc] ACPI: register power_supply subdevice only when battery is present
Date: Sun, 28 Oct 2007 11:37:26 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, Alexey Starikovskiy <aystarik@gmail.com>
References: <200710272054.31160.arvidjaar@mail.ru> <20071027184249.GA2982@zarina> <200710280950.46779.arvidjaar@mail.ru>
In-Reply-To: <200710280950.46779.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1445798.CSq8g8aEI9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710281037.28098.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1445798.CSq8g8aEI9
Content-Type: multipart/mixed;
  boundary="Boundary-01=_3wDJHD5VoNo3cgo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_3wDJHD5VoNo3cgo
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 28 October 2007, Andrey Borzenkov wrote:
> On Saturday 27 October 2007, Anton Vorontsov wrote:
> > On Sat, Oct 27, 2007 at 08:54:30PM +0400, Andrey Borzenkov wrote:
> > > I am not exactly sure about this one ... what other power_supply class
> > > drivers do? Should I fix HAL instead (but then, I do not know whether
> > > HAL is the only application that is using this interface).
> >
> > Well, PROP_PRESENT wasn't my idea, currently it's used by pmu and
> > olpc drivers becuase it's not trivial to register/unregister their
> > batteries on physical insertion/removal. I have some plans to teach
> > at least pmu batteries to not use PROP_PRESENT. I don't have any
> > OLPC, thus I can't convert it.
> >
> > To sum this: the good way to handle "missing" batteries is to
> > unregister them, so they'll not show up in the /sys/class/power_supply.
>
> Well, in this case HAL behaviour makes sense (default to present =3D=3D t=
rue
> if "present" attribute is missing)
>
> > Is that possible with the ACPI?
>
> At least looking in ACPI specs, this looks possible. What currently is
> presented as battery object is actually battery bay according to ACPI spe=
c:
>
> Unlike most other devices, when a battery is inserted or removed from the
> system, the device itself (the
> battery bay) is still considered to be present in the system.
>
> When battery is inserted/removed, ACPI notifies us and we can check wheth=
er
> battery is actually present and update registration accordingly. From the
> sysfs structure POV probably nothing has to be changed; just when and how
> power_supply is registered
> under /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:0n
>
> Alexey, does it make sense (or doable)?

or would you take attached patch as prototype? :) This works on my system a=
nd=20
does not crash it immediately. Here is event sequence I get:

UEVENT[1193556388.161539] add      /module/battery (module)
ACTION=3Dadd
DEVPATH=3D/module/battery
SUBSYSTEM=3Dmodule
SEQNUM=3D3243

UEVENT[1193556388.177069] add      /bus/acpi/drivers/battery (drivers)
ACTION=3Dadd
DEVPATH=3D/bus/acpi/drivers/battery
SUBSYSTEM=3Ddrivers
SEQNUM=3D3244

UEVENT[1193556388.212721]=20
add      /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dadd
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
SEQNUM=3D3245

UEVENT[1193556388.223113]=20
change   /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dchange
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
POWER_SUPPLY_NAME=3DBAT1
POWER_SUPPLY_TYPE=3DBattery
POWER_SUPPLY_STATUS=3DFull
POWER_SUPPLY_PRESENT=3D1
POWER_SUPPLY_TECHNOLOGY=3DUnknown
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D10800000
POWER_SUPPLY_VOLTAGE_NOW=3D0
POWER_SUPPLY_CURRENT_NOW=3D0
POWER_SUPPLY_ENERGY_FULL_DESIGN=3D38880000
POWER_SUPPLY_ENERGY_FULL=3D37530000
POWER_SUPPLY_ENERGY_NOW=3D0
POWER_SUPPLY_MODEL_NAME=3DXM2038P04
POWER_SUPPLY_MANUFACTURER=3D
SEQNUM=3D3246

physically remove battery

UEVENT[1193556483.326303]=20
remove   /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dremove
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
POWER_SUPPLY_NAME=3DBAT1
POWER_SUPPLY_TYPE=3DBattery
POWER_SUPPLY_PRESENT=3D0
SEQNUM=3D3252


battery back

UEVENT[1193556510.339045]=20
add      /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dadd
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
SEQNUM=3D3253

UEVENT[1193556510.339387]=20
change   /devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1=20
(power_supply)
ACTION=3Dchange
DEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1
SUBSYSTEM=3Dpower_supply
POWER_SUPPLY_NAME=3DBAT1
POWER_SUPPLY_TYPE=3DBattery
POWER_SUPPLY_STATUS=3DCharging
POWER_SUPPLY_PRESENT=3D1
POWER_SUPPLY_TECHNOLOGY=3DUnknown
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D10800000
POWER_SUPPLY_VOLTAGE_NOW=3D11340000
POWER_SUPPLY_CURRENT_NOW=3D13197000
POWER_SUPPLY_ENERGY_FULL_DESIGN=3D38880000
POWER_SUPPLY_ENERGY_FULL=3D37530000
POWER_SUPPLY_ENERGY_NOW=3D37519000
POWER_SUPPLY_MODEL_NAME=3DXM2038P04
POWER_SUPPLY_MANUFACTURER=3D
SEQNUM=3D3254

We'll probably need to teach user space to distinguish between battery and=
=20
battery bay (and not to crash when battery is removed :) ) but that is all=
=20
doable once we settle on kernel implementation.

--Boundary-01=_3wDJHD5VoNo3cgo
Content-Type: text/x-diff;
  charset="utf-8";
  name="fix_ACPI_battery_registration"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="fix_ACPI_battery_registration"

Subject: [PATCH] [2.6.24-rc] ACPI: register power_supply subdevice only whe=
n battery is present
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Make sure no power_supply object is present unless we actualy detect
presence of battery. This fixes ghost batteries detected by HAL

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/battery.c |   98 ++++++++++++++++++++++++++++++--------------=
=2D---
 1 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index d33cb49..f37e509 100644
=2D-- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -390,14 +390,64 @@ static int acpi_battery_init_alarm(struct acpi_batter=
y *battery)
 	return acpi_battery_set_alarm(battery);
 }
=20
+static ssize_t acpi_battery_alarm_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct acpi_battery *battery =3D to_acpi_battery(dev_get_drvdata(dev));
+	return sprintf(buf, "%d\n", battery->alarm * 1000);
+}
+
+static ssize_t acpi_battery_alarm_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	unsigned long x;
+	struct acpi_battery *battery =3D to_acpi_battery(dev_get_drvdata(dev));
+	if (sscanf(buf, "%ld\n", &x) =3D=3D 1)
+		battery->alarm =3D x/1000;
+	if (acpi_battery_present(battery))
+		acpi_battery_set_alarm(battery);
+	return count;
+}
+
+static struct device_attribute alarm_attr =3D {
+	.attr =3D {.name =3D "alarm", .mode =3D 0644, .owner =3D THIS_MODULE},
+	.show =3D acpi_battery_alarm_show,
+	.store =3D acpi_battery_alarm_store,
+};
+
+static int sysfs_add_battery(struct acpi_battery *battery)
+{
+	int result =3D 0;
+
+	result =3D power_supply_register(&battery->device->dev, &battery->bat);
+	result =3D device_create_file(battery->bat.dev, &alarm_attr);
+
+	return result;
+}
+
+static int sysfs_remove_battery(struct acpi_battery *battery)
+{
+	if (battery->bat.dev) {
+		device_remove_file(battery->bat.dev, &alarm_attr);
+		power_supply_unregister(&battery->bat);
+		battery->bat.dev =3D NULL;
+	}
+
+	return 0;
+}
+
 static int acpi_battery_update(struct acpi_battery *battery)
 {
=2D	int saved_present =3D acpi_battery_present(battery);
 	int result =3D acpi_battery_get_status(battery);
=2D	if (result || !acpi_battery_present(battery))
+	if (result)
 		return result;
=2D	if (saved_present !=3D acpi_battery_present(battery) ||
=2D	    !battery->update_time) {
+	if (!acpi_battery_present(battery)) {
+		sysfs_remove_battery(battery);
+		return 0;
+	}
+	if (!battery->bat.dev) {
 		battery->update_time =3D 0;
 		result =3D acpi_battery_get_info(battery);
 		if (result)
@@ -411,6 +461,7 @@ static int acpi_battery_update(struct acpi_battery *bat=
tery)
 			battery->bat.num_properties =3D
 				ARRAY_SIZE(energy_battery_props);
 		}
+		sysfs_add_battery(battery);
 		acpi_battery_init_alarm(battery);
 	}
 	return acpi_battery_get_state(battery);
@@ -693,33 +744,6 @@ static void acpi_battery_remove_fs(struct acpi_device =
*device)
=20
 #endif
=20
=2Dstatic ssize_t acpi_battery_alarm_show(struct device *dev,
=2D					struct device_attribute *attr,
=2D					char *buf)
=2D{
=2D	struct acpi_battery *battery =3D to_acpi_battery(dev_get_drvdata(dev));
=2D	return sprintf(buf, "%d\n", battery->alarm * 1000);
=2D}
=2D
=2Dstatic ssize_t acpi_battery_alarm_store(struct device *dev,
=2D					struct device_attribute *attr,
=2D					const char *buf, size_t count)
=2D{
=2D	unsigned long x;
=2D	struct acpi_battery *battery =3D to_acpi_battery(dev_get_drvdata(dev));
=2D	if (sscanf(buf, "%ld\n", &x) =3D=3D 1)
=2D		battery->alarm =3D x/1000;
=2D	if (acpi_battery_present(battery))
=2D		acpi_battery_set_alarm(battery);
=2D	return count;
=2D}
=2D
=2Dstatic struct device_attribute alarm_attr =3D {
=2D	.attr =3D {.name =3D "alarm", .mode =3D 0644, .owner =3D THIS_MODULE},
=2D	.show =3D acpi_battery_alarm_show,
=2D	.store =3D acpi_battery_alarm_store,
=2D};
=2D
 /* -----------------------------------------------------------------------=
=2D--
                                  Driver Interface
    -----------------------------------------------------------------------=
=2D-- */
@@ -737,7 +761,9 @@ static void acpi_battery_notify(acpi_handle handle, u32=
 event, void *data)
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
 					device->dev.bus_id, event,
 					acpi_battery_present(battery));
=2D	kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
+	/* acpi_batter_update could remove power_supply object */
+	if (battery->bat.dev)
+		kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
 }
=20
 static int acpi_battery_add(struct acpi_device *device)
@@ -755,17 +781,15 @@ static int acpi_battery_add(struct acpi_device *devic=
e)
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	acpi_driver_data(device) =3D battery;
 	mutex_init(&battery->lock);
+	battery->bat.name =3D acpi_device_bid(device);
+	battery->bat.type =3D POWER_SUPPLY_TYPE_BATTERY;
+	battery->bat.get_property =3D acpi_battery_get_property;
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS
 	result =3D acpi_battery_add_fs(device);
 	if (result)
 		goto end;
 #endif
=2D	battery->bat.name =3D acpi_device_bid(device);
=2D	battery->bat.type =3D POWER_SUPPLY_TYPE_BATTERY;
=2D	battery->bat.get_property =3D acpi_battery_get_property;
=2D	result =3D power_supply_register(&battery->device->dev, &battery->bat);
=2D	result =3D device_create_file(battery->bat.dev, &alarm_attr);
 	status =3D acpi_install_notify_handler(device->handle,
 					     ACPI_ALL_NOTIFY,
 					     acpi_battery_notify, battery);

--Boundary-01=_3wDJHD5VoNo3cgo--

--nextPart1445798.CSq8g8aEI9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJDw4R6LMutpd94wRAiMAAJ9+FZ2A3/BJr2ivK2knL7wnbBXItQCgpN5L
1V91XdFG+rIUWeo0T/OGkNU=
=irw6
-----END PGP SIGNATURE-----

--nextPart1445798.CSq8g8aEI9--
