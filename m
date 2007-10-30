Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbXJ3UVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbXJ3UVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbXJ3UV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:21:27 -0400
Received: from mx33.mail.ru ([194.67.23.194]:29550 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536AbXJ3UVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:21:25 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: [PATCH] 2.6.24: make /proc/acpi/ac_adapter dependent on ACPI_PROCFS
Date: Tue, 30 Oct 2007 23:21:18 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6710902.Byjeafhgg4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710302321.19497.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6710902.Byjeafhgg4
Content-Type: multipart/mixed;
  boundary="Boundary-01=_/I5JHY9F5ppequm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_/I5JHY9F5ppequm
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Let's make it consistent with battery code; also it fixes HAL case of=20
duplicated adapters. Somebody will have to sort out HAL with ACPI_PROCFS=20
case ...

=2Dandrey

--Boundary-01=_/I5JHY9F5ppequm
Content-Type: text/x-diff;
  charset="us-ascii";
  name="ac_adapter-without-procfs"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="ac_adapter-without-procfs"

Subject: [PATCH] 2.6.24: make /proc/acpi/ac_adapter dependent on ACPI_PROCFS
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Do not provide /proc/acpi/ac_adapter if ACPI_PROCFS is not defined.
This eliminates duplicated power adapters in HAL and makes it consistent
with battery module

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/ac.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index e03de37..1461dc9 100644
=2D-- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -27,8 +27,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#ifdef CONFIG_ACPI_PROCFS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#endif
 #include <linux/power_supply.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -49,12 +51,14 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
=20
+#ifdef CONFIG_ACPI_PROCFS
 extern struct proc_dir_entry *acpi_lock_ac_dir(void);
 extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
+static int acpi_ac_open_fs(struct inode *inode, struct file *file);
+#endif
=20
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device, int type);
=2Dstatic int acpi_ac_open_fs(struct inode *inode, struct file *file);
=20
 const static struct acpi_device_id ac_device_ids[] =3D {
 	{"ACPI0003", 0},
@@ -80,12 +84,15 @@ struct acpi_ac {
=20
 #define to_acpi_ac(x) container_of(x, struct acpi_ac, charger);
=20
+#ifdef CONFIG_ACPI_PROCFS
 static const struct file_operations acpi_ac_fops =3D {
 	.open =3D acpi_ac_open_fs,
 	.read =3D seq_read,
 	.llseek =3D seq_lseek,
 	.release =3D single_release,
 };
+#endif
+
 static int get_ac_property(struct power_supply *psy,
 			   enum power_supply_property psp,
 			   union power_supply_propval *val)
@@ -127,6 +134,7 @@ static int acpi_ac_get_state(struct acpi_ac *ac)
 	return 0;
 }
=20
+#ifdef CONFIG_ACPI_PROCFS
 /* -----------------------------------------------------------------------=
=2D--
                               FS Interface (/proc)
    -----------------------------------------------------------------------=
=2D-- */
@@ -206,6 +214,7 @@ static int acpi_ac_remove_fs(struct acpi_device *device)
=20
 	return 0;
 }
+#endif
=20
 /* -----------------------------------------------------------------------=
=2D--
                                    Driver Model
@@ -264,7 +273,9 @@ static int acpi_ac_add(struct acpi_device *device)
 	if (result)
 		goto end;
=20
+#ifdef CONFIG_ACPI_PROCFS
 	result =3D acpi_ac_add_fs(device);
+#endif
 	if (result)
 		goto end;
 	ac->charger.name =3D acpi_device_bid(device);
@@ -287,7 +298,9 @@ static int acpi_ac_add(struct acpi_device *device)
=20
       end:
 	if (result) {
+#ifdef CONFIG_ACPI_PROCFS
 		acpi_ac_remove_fs(device);
+#endif
 		kfree(ac);
 	}
=20
@@ -309,7 +322,9 @@ static int acpi_ac_remove(struct acpi_device *device, i=
nt type)
 					    ACPI_ALL_NOTIFY, acpi_ac_notify);
 	if (ac->charger.dev)
 		power_supply_unregister(&ac->charger);
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_ac_remove_fs(device);
+#endif
=20
 	kfree(ac);
=20
@@ -323,13 +338,17 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
=20
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_ac_dir =3D acpi_lock_ac_dir();
 	if (!acpi_ac_dir)
 		return -ENODEV;
+#endif
=20
 	result =3D acpi_bus_register_driver(&acpi_ac_driver);
 	if (result < 0) {
+#ifdef CONFIG_ACPI_PROCFS
 		acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
 		return -ENODEV;
 	}
=20
@@ -341,7 +360,9 @@ static void __exit acpi_ac_exit(void)
=20
 	acpi_bus_unregister_driver(&acpi_ac_driver);
=20
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
=20
 	return;
 }

--Boundary-01=_/I5JHY9F5ppequm--

--nextPart6710902.Byjeafhgg4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ5I/R6LMutpd94wRAjC5AJ0RdGsb1Roz+zGXvW0kwRV0KWxhkQCdFxOk
4iqK8ity1gbCC5NQrx9/szc=
=3quH
-----END PGP SIGNATURE-----

--nextPart6710902.Byjeafhgg4--
