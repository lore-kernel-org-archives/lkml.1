Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYBXEbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYBXEbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYBXEa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:30:57 -0500
Received: from orchitis.omgwallhack.org ([66.179.21.205]:35151 "EHLO
	smtp.omgwallhack.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYBXEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:30:56 -0500
Subject: Re: Hang on suspend
From: Julian Blake Kongslie <jblake@omgwallhack.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200802232143.31903.rjw@sisk.pl>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
	 <200802232143.31903.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3fRoIofROKZApMWzVCAF"
Organization: Fists of Righteous Harmony
Date: Sat, 23 Feb 2008 20:30:44 -0800
Message-Id: <1203827444.4202.18.camel@dukephillips.omgwallhack.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3fRoIofROKZApMWzVCAF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-02-23 at 21:43 +0100, Rafael J. Wysocki wrote:
> Can you please apply the appened patch and retest?

Didn't apply cleanly to v2.6.25-rc2; I had to mangle one or two lines.
The patch I applied follows at the end of this message.

Unfortunately, it's about the same as before. I got:

Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
ACPI: Preparing to enter system sleep state S3
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
nsc-ircc 00:0b: disabled
parport_pc 00:0a: disabled
eth1: Going into suspend...
ACPI: PCI interrupt for device 0000:0b:02.0 disabled
ACPI: PCI interrupt for device 0000:00:1e.3 disabled
ACPI: PCI interrupt for device 0000:00:1e.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
BUG: unable to handle kernel NULL pointer dereference at 00000090

And the oops and stacktrace that follows appears essentially identical
to the one I already transcribed. If you need it copied, I've got
photographs, but I'd like to save myself the typing...

Those PCI devices, in case it matters, are:
	0b:02.0	Wireless card (Intel 2200BG)
	00:1e.3 Modem (ICH6 AC'97)
	00:1e.2 Audio (ICH6 AC'97)
	00:1e.0 82801 Mobile PCI Bridge
	00:1d.7 USB2 EHCI
	00:1d.3 USB UHCI
	00:1d.2 USB UHCI
	00:1d.1 USB UHCI
	00:1d.0 USB UHCI

The other devices not mentioned are:
	0b:00.0 CardBus Bridge: Ricoh Co Ltd RL5c476 II (rev 8d)
	02:00.0 Ethernet (Broadcom BCM5751M)
	01:00.0 ATI Mobility FireGL V3200
	00:1f.3 SMBus (ICH6)
	00:1f.2 ICH6M SATA
	00:1f.0 ICH6M LPC Interface Bridge
	00:1c.2 ICH6 PCI Express Port 3
	00:1c.0 ICH6 PCI Express Port 1
	00:01.0 915GM/PM PCI Express Root Port
	00:00.0 Processor to DRAM Controller

> Thanks,
> Rafael

Thanks for the help!

--=20
-Julian Blake Kongslie
<jblake@omgwallhack.org>

If this is a mailing list, please CC me on replies.
vim: set ft=3Dtext :

Here's the patch against v2.6.25-rc2 I used:

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bdc03f7..e3095c7 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -48,7 +48,6 @@
  */
=20
 LIST_HEAD(dpm_active);
-static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
 static LIST_HEAD(dpm_destroy);
@@ -81,28 +80,6 @@ void device_pm_add(struct device *dev)
  */
 void device_pm_remove(struct device *dev)
 {
-	/*
-	 * If this function is called during a suspend, it will be blocked,
-	 * because we're holding the device's semaphore at that time, which may
-	 * lead to a deadlock.  In that case we want to print a warning.
-	 * However, it may also be called by unregister_dropped_devices() with
-	 * the device's semaphore released, in which case the warning should
-	 * not be printed.
-	 */
-	if (down_trylock(&dev->sem)) {
-		if (down_read_trylock(&pm_sleep_rwsem)) {
-			/* No suspend in progress, wait on dev->sem */
-			down(&dev->sem);
-			up_read(&pm_sleep_rwsem);
-		} else {
-			/* Suspend in progress, we may deadlock */
-			dev_warn(dev, "Suspicious %s during suspend\n",
-				__FUNCTION__);
-			dump_stack();
-			/* The user has been warned ... */
-			down(&dev->sem);
-		}
-	}
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -110,7 +87,6 @@ void device_pm_remove(struct device *dev)
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	up(&dev->sem);
 }
=20
 /**
@@ -266,7 +242,7 @@ static void dpm_resume(void)
 		struct list_head *entry =3D dpm_off.next;
 		struct device *dev =3D to_device(entry);
=20
-		list_move_tail(entry, &dpm_locked);
+		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
@@ -275,25 +251,6 @@ static void dpm_resume(void)
 }
=20
 /**
- *	unlock_all_devices - Release each device's semaphore
- *
- *	Go through the dpm_off list.  Put each device on the dpm_active
- *	list and unlock it.
- */
-static void unlock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry =3D dpm_locked.prev;
-		struct device *dev =3D to_device(entry);
-
-		list_move(entry, &dpm_active);
-		up(&dev->sem);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	unregister_dropped_devices - Unregister devices scheduled for removal
  *
  *	Unregister all devices on the dpm_destroy list.
@@ -305,7 +262,6 @@ static void unregister_dropped_devices(void)
 		struct list_head *entry =3D dpm_destroy.next;
 		struct device *dev =3D to_device(entry);
=20
-		up(&dev->sem);
 		mutex_unlock(&dpm_list_mtx);
 		/* This also removes the device from the list */
 		device_unregister(dev);
@@ -324,7 +280,6 @@ void device_resume(void)
 {
 	might_sleep();
 	dpm_resume();
-	unlock_all_devices();
 	unregister_dropped_devices();
 	up_write(&pm_sleep_rwsem);
 }
@@ -461,8 +416,8 @@ static int dpm_suspend(pm_message_t state)
 	int error =3D 0;
=20
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry =3D dpm_locked.prev;
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry =3D dpm_active.prev;
 		struct device *dev =3D to_device(entry);
=20
 		list_del_init(&dev->power.entry);
@@ -478,7 +433,7 @@ static int dpm_suspend(pm_message_t state)
 					""));
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_locked);
+				list_add_tail(&dev->power.entry, &dpm_active);
 			mutex_unlock(&dpm_list_mtx);
 			break;
 		}
@@ -492,36 +447,6 @@ static int dpm_suspend(pm_message_t state)
 }
=20
 /**
- *	lock_all_devices - Acquire every device's semaphore
- *
- *	Go through the dpm_active list. Carefully lock each device's
- *	semaphore and put it in on the dpm_locked list.
- */
-static void lock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active)) {
-		struct list_head *entry =3D dpm_active.next;
-		struct device *dev =3D to_device(entry);
-
-		/* Required locking order is dev->sem first,
-		 * then dpm_list_mutex.  Hence this awkward code.
-		 */
-		get_device(dev);
-		mutex_unlock(&dpm_list_mtx);
-		down(&dev->sem);
-		mutex_lock(&dpm_list_mtx);
-
-		if (list_empty(entry))
-			up(&dev->sem);		/* Device was removed */
-		else
-			list_move_tail(entry, &dpm_locked);
-		put_device(dev);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	device_suspend - Save state and stop all devices in system.
  *
  *	Prevent new devices from being registered, then lock all devices
@@ -533,7 +458,6 @@ int device_suspend(pm_message_t state)
=20
 	might_sleep();
 	down_write(&pm_sleep_rwsem);
-	lock_all_devices();
 	error =3D dpm_suspend(state);
 	if (error)
 		device_resume();


--=-3fRoIofROKZApMWzVCAF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Don't have my public key? Email <jblake@omgwallhack.org> and I'll gladly mail it to you.

iD8DBQBHwPL0uU009xtCYDURArcTAJ0QNIdO3oqHG1A4+IOqbvDpqXwzRgCfeCZw
wcDrrudyJK20HCmQr16qaJU=
=xq7A
-----END PGP SIGNATURE-----

--=-3fRoIofROKZApMWzVCAF--

