Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXKJSlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXKJSlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXKJSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:40:54 -0500
Received: from mx6.mail.ru ([194.67.23.26]:18127 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbXKJSkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:40:53 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.24-rc2: fix oops in ACPI battery removal
Date: Sat, 10 Nov 2007 21:40:48 +0300
User-Agent: KMail/1.9.7
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1836497.F0uKbJhieq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711102140.49304.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1836497.F0uKbJhieq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alexey, this fixes my patch that went into -rc2. Sorry for Oops.

Subject: [PATCH] 2.6.24-rc2: do not unregister power_supply in sysfs ->show=
 method
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Currently unplugging battery oopses with call stack:

[ 2245.375393]  [<c010488a>] show_trace_log_lvl+0x1a/0x30
[ 2245.375570]  [<c0104949>] show_stack_log_lvl+0xa9/0xd0
[ 2245.375732]  [<c0104a36>] show_registers+0xc6/0x1c0
[ 2245.375884]  [<c0104c21>] die+0xf1/0x200
[ 2245.376014]  [<c02d2a58>] do_page_fault+0x198/0x690
[ 2245.376207]  [<c02d1522>] error_code+0x6a/0x70
[ 2245.376366]  [<c0243c20>] device_del+0x20/0x280
[ 2245.376530]  [<c0243e8b>] device_unregister+0xb/0x20
[ 2245.376686]  [<dfd7401a>] power_supply_unregister+0x1a/0x20 [power_suppl=
y]
[ 2245.376911]  [<dfd5f035>] sysfs_remove_battery+0x1f/0x22 [battery]
[ 2245.382969]  [<dfd5f1e6>] acpi_battery_update+0x42/0x293 [battery]
[ 2245.388862]  [<dfd5f5f5>] acpi_battery_get_property+0x34/0x16e [battery]
[ 2245.394770]  [<dfd74368>] power_supply_show_property+0x38/0x130 [power_s=
upply]
[ 2245.400733]  [<dfd746f1>] power_supply_uevent+0x111/0x1c0 [power_supply]
[ 2245.406745]  [<c0244559>] dev_uevent+0x99/0x100
[ 2245.412744]  [<c01d37ff>] kobject_uevent_env+0x17f/0x3c0
[ 2245.418768]  [<c01d3a4a>] kobject_uevent+0xa/0x10
[ 2245.424732]  [<c0243da3>] device_del+0x1a3/0x280
[ 2245.430683]  [<c0243e8b>] device_unregister+0xb/0x20
[ 2245.436632]  [<dfd7401a>] power_supply_unregister+0x1a/0x20 [power_suppl=
y]
[ 2245.442670]  [<dfd5f035>] sysfs_remove_battery+0x1f/0x22 [battery]
[ 2245.448790]  [<dfd5f1e6>] acpi_battery_update+0x42/0x293 [battery]
[ 2245.454874]  [<dfd5f7ad>] acpi_battery_notify+0x1e/0x69 [battery]
[ 2245.460957]  [<c02086cd>] acpi_ev_notify_dispatch+0x4c/0x57
[ 2245.467077]  [<c0200d54>] acpi_os_execute_notify+0x24/0x2f
[ 2245.473167]  [<c012a431>] run_workqueue+0x161/0x1e0
[ 2245.479289]  [<c012ae5b>] worker_thread+0x8b/0xf0
[ 2245.485279]  [<c012e0b2>] kthread+0x42/0x70
[ 2245.491068]  [<c01044e3>] kernel_thread_helper+0x7/0x14

Do not try to (un-)register sysfs in acpi_battery_update - instead, do
it only on battery add or in notification handler.

On the way fix battery removal (reset device to NULL) and use proper
interface for sending change event (power_supply_changed) instead of
doing it directly.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/battery.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 1905b88..2810a9b 100644
=2D-- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -457,6 +457,7 @@ static void sysfs_remove_battery(struct acpi_battery *b=
attery)
 		return;
 	device_remove_file(battery->bat.dev, &alarm_attr);
 	power_supply_unregister(&battery->bat);
+	battery->bat.dev =3D NULL;
 }
=20
 static int acpi_battery_update(struct acpi_battery *battery)
@@ -464,12 +465,6 @@ static int acpi_battery_update(struct acpi_battery *ba=
ttery)
 	int result =3D acpi_battery_get_status(battery);
 	if (result)
 		return result;
=2D	if (!acpi_battery_present(battery)) {
=2D		sysfs_remove_battery(battery);
=2D		return 0;
=2D	}
=2D	if (!battery->bat.dev)
=2D		sysfs_add_battery(battery);
 	return acpi_battery_get_state(battery);
 }
=20
@@ -758,14 +753,17 @@ static void acpi_battery_notify(acpi_handle handle, u=
32 event, void *data)
 		return;
 	device =3D battery->device;
 	acpi_battery_update(battery);
+	if (!acpi_battery_present(battery))
+		sysfs_remove_battery(battery);
+	else if (!battery->bat.dev)
+		sysfs_add_battery(battery);
+	else
+		power_supply_changed(&battery->bat);
 	acpi_bus_generate_proc_event(device, event,
 				     acpi_battery_present(battery));
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
 					device->dev.bus_id, event,
 					acpi_battery_present(battery));
=2D	/* acpi_batter_update could remove power_supply object */
=2D	if (battery->bat.dev)
=2D		kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
 }
=20
 static int acpi_battery_add(struct acpi_device *device)
@@ -784,6 +782,8 @@ static int acpi_battery_add(struct acpi_device *device)
 	acpi_driver_data(device) =3D battery;
 	mutex_init(&battery->lock);
 	acpi_battery_update(battery);
+	if (acpi_battery_present(battery))
+		sysfs_add_battery(battery);
 #ifdef CONFIG_ACPI_PROCFS
 	result =3D acpi_battery_add_fs(device);
 	if (result)

--nextPart1836497.F0uKbJhieq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHNfsxR6LMutpd94wRAkbCAJ4r6VjT3fU98xJIAupxnBjCxIuEgQCgrwKv
9JIsUxWhDLhWvkxbeJXuw5U=
=zYze
-----END PGP SIGNATURE-----

--nextPart1836497.F0uKbJhieq--
