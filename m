Return-Path: <linux-kernel-owner+w=401wt.eu-S1750724AbXBMNF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750724AbXBMNF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXBMNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:05:57 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:53132 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXBMNF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:05:56 -0500
From: Marcel Siegert <mws@linuxtv.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: dvb shared datastructure bug?
Date: Tue, 13 Feb 2007 14:05:44 +0100
User-Agent: KMail/1.9.6
References: <1171352878.12771.30.camel@laptopd505.fenrus.org> <200702131204.47314.mws@linuxtv.org> <1171366526.12771.99.camel@laptopd505.fenrus.org>
In-Reply-To: <1171366526.12771.99.camel@laptopd505.fenrus.org>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_peb0FMKItTPOQY5"
Message-Id: <200702131405.45940.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_peb0FMKItTPOQY5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 13 February 2007, you wrote:
>=20
> > attached find a patch that fixes the problem.
>=20
>=20
> Hi,
>=20
> Thank you for the quick response.
> I think there is a small bug in this; at least I don't see where you
> copy over the content of the fops template to the newly allocated piece
> of memory...
>=20
> Greetings,
>    Arjan van de Ven

hi arjan,

also fixed that issue. my fault, sorry.

i updated my repository @ linutv.org accordingly.

i will ask mauro to pull changeset   b265e2484422
=A0 =A0dvbdev: fix illegal re-usage of fileoperations struct
from =A0http://www.linuxtv.org/hg/~mws/v4l-dvb-fixtree

for upstream to kernel., if no more issues appear today.

thanks again.

marcel



--Boundary-00=_peb0FMKItTPOQY5
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="dvbdevfix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvbdevfix.patch"

diff -r 667e84e2e762 linux/drivers/media/dvb/dvb-core/dvbdev.c
=2D-- a/linux/drivers/media/dvb/dvb-core/dvbdev.c	Tue Feb 13 07:00:55 2007 =
=2D0200
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c	Tue Feb 13 13:44:47 2007 +0=
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
@@ -235,7 +245,9 @@ int dvb_register_device(struct dvb_adapt
 	dvbdev->id =3D id;
 	dvbdev->adapter =3D adap;
 	dvbdev->priv =3D priv;
=2D
+	dvbdev->fops =3D dvbdevfops;
+
+	memcpy(dvbdev->fops, template->fops, sizeof(struct file_operations));
 	dvbdev->fops->owner =3D adap->module;
=20
 	list_add_tail (&dvbdev->list_head, &adap->device_list);
@@ -263,6 +275,7 @@ void dvb_unregister_device(struct dvb_de
 					dvbdev->type, dvbdev->id)));
=20
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);

--Boundary-00=_peb0FMKItTPOQY5--
