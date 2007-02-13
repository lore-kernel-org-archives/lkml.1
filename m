Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXBMLaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXBMLaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXBMLaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:30:39 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:35611 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXBMLah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:30:37 -0500
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 06:30:37 EST
From: Marcel Siegert <mws@linuxtv.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: dvb shared datastructure bug?
Date: Tue, 13 Feb 2007 12:04:38 +0100
User-Agent: KMail/1.9.6
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, "Manu Abraham" <abraham.manu@gmail.com>
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
In-Reply-To: <1171352878.12771.30.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1702596.CEflUvLCKE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702131204.47314.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1702596.CEflUvLCKE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_HtZ0FpF3P50Qhuu"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_HtZ0FpF3P50Qhuu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 13 February 2007, Arjan van de Ven wrote:
> Hi,
>=20
> while working on the last pieces of the file_ops constantification, DVB
> is the small village in France that is holding the Romans at bay... but
> I think I found the final flaw in it now:=20
>=20
>        *pdvbdev =3D dvbdev =3D kmalloc(sizeof(struct dvb_device), GFP_KER=
NEL);
>=20
>         if (!dvbdev) {
>                 mutex_unlock(&dvbdev_register_lock);
>                 return -ENOMEM;
>         }
>=20
>         memcpy(dvbdev, template, sizeof(struct dvb_device));
>         dvbdev->type =3D type;
>         dvbdev->id =3D id;
>         dvbdev->adapter =3D adap;
>         dvbdev->priv =3D priv;
>=20
>         dvbdev->fops->owner =3D adap->module;
>=20
>=20
> this is the place in DVB that is writing to a struct file_operations.
> But as with almost all such cases in the kernel, this one is buggy:
> While the code nicely copies a template dvbdev, that template only has a
> pointer to a *shared* fops struct, the copy doesn't help that. So this
> code is overwriting the fops owner field for ALL active devices, not
> just the ones the copy of the template is for....
>=20
> I'm lost in the maze of this part of DVB (it seems to have some magic
> potion to resist me) but I was hoping some of the local citizens could
> take a look at this buglet...
>=20
> Greetings,
>     Arjan van de Ven

hi arjan,
thanks for pointing out this issue.

attached find a patch that fixes the problem.

@mauro - please pull changeset a7ac92d208fe
   dvbdev: fix illegal re-usage of fileoperations struct

from  http://www.linuxtv.org/hg/~mws/v4l-dvb-fixtree

for upstream to kernel. thanks.

best regards=20
marcel

--Boundary-01=_HtZ0FpF3P50Qhuu
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="dvbdevfix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvbdevfix.patch"

diff -r 667e84e2e762 linux/drivers/media/dvb/dvb-core/dvbdev.c
=2D-- a/linux/drivers/media/dvb/dvb-core/dvbdev.c	Tue Feb 13 07:00:55 2007 =
=2D0200
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c	Tue Feb 13 12:00:13 2007 +0=
100
@@ -211,12 +211,14 @@ int dvb_register_device(struct dvb_adapt
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	struct file_operations *dvbdevfops;
+
 	int id;
=20
 	if (mutex_lock_interruptible(&dvbdev_register_lock))
 		return -ERESTARTSYS;
=20
=2D	if ((id =3D dvbdev_get_free_id (adap, type)) < 0) {
+	if ((id =3D dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
 		*pdvbdev =3D NULL;
 		printk ("%s: could get find free device id...\n", __FUNCTION__);
@@ -225,7 +227,15 @@ int dvb_register_device(struct dvb_adapt
=20
 	*pdvbdev =3D dvbdev =3D kmalloc(sizeof(struct dvb_device), GFP_KERNEL);
=20
=2D	if (!dvbdev) {
+	if (!dvbdev){
+		mutex_unlock(&dvbdev_register_lock);
+		return -ENOMEM;
+	}
+
+	dvbdevfops =3D kzalloc(sizeof(struct file_operations), GFP_KERNEL);
+
+	if (!dvbdevfops){
+		kfree (dvbdev);
 		mutex_unlock(&dvbdev_register_lock);
 		return -ENOMEM;
 	}
@@ -235,7 +245,7 @@ int dvb_register_device(struct dvb_adapt
 	dvbdev->id =3D id;
 	dvbdev->adapter =3D adap;
 	dvbdev->priv =3D priv;
=2D
+	dvbdev->fops =3D dvbdevfops;
 	dvbdev->fops->owner =3D adap->module;
=20
 	list_add_tail (&dvbdev->list_head, &adap->device_list);
@@ -263,6 +273,7 @@ void dvb_unregister_device(struct dvb_de
 					dvbdev->type, dvbdev->id)));
=20
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);

--Boundary-01=_HtZ0FpF3P50Qhuu--

--nextPart1702596.CEflUvLCKE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iD8DBQBF0ZtP7ZVdekXr02IRAiiHAKCT/z0eLrlOs42UYdrAmFlriaFu2QCgmEEO
22uhZvzy2/DHMaAhjVBMGzY=
=Mez7
-----END PGP SIGNATURE-----

--nextPart1702596.CEflUvLCKE--
