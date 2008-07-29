Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYG2COz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYG2COz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYG2COr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:14:47 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:33310 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYG2COr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:14:47 -0400
Date: Mon, 28 Jul 2008 21:13:58 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 3/30] W1: don't delay search start
Message-ID: <20080729021358.GC24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:13:59 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Move the creation of the w1_process thread to after the device has
been initialized.  This way w1_process doesn't have to check to see if
it has been initialized and the bus search can proceed without
sleeping.  That also eliminates two checks in the w1_process loop.
The sleep now happens at the end of the loop not the beginning.

Also added a comment for why the atomic_set was 2.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c     |   19 ++++++-------------
 drivers/w1/w1_int.c |   26 +++++++++++++++++---------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index aac03f1..730faa4 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -813,21 +813,14 @@ int w1_process(void *data)
 	struct w1_master *dev =3D (struct w1_master *) data;
=20
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->fla=
gs)) {
+		if (dev->search_count) {
+			mutex_lock(&dev->mutex);
+			w1_search_process(dev, W1_SEARCH);
+			mutex_unlock(&dev->mutex);
+		}
+
 		try_to_freeze();
 		msleep_interruptible(w1_timeout * 1000);
-
-		if (kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags))
-			break;
-
-		if (!dev->initialized)
-			continue;
-
-		if (dev->search_count =3D=3D 0)
-			continue;
-
-		mutex_lock(&dev->mutex);
-		w1_search_process(dev, W1_SEARCH);
-		mutex_unlock(&dev->mutex);
 	}
=20
 	atomic_dec(&dev->refcnt);
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index ed32280..36ff402 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -61,6 +61,9 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_=
count, int slave_ttl,
 	dev->slave_ttl		=3D slave_ttl;
         dev->search_count	=3D -1; /* continual scan */
=20
+	/* 1 for w1_process to decrement
+	 * 1 for __w1_remove_master_device to decrement
+	 */
 	atomic_set(&dev->refcnt, 2);
=20
 	INIT_LIST_HEAD(&dev->slist);
@@ -109,23 +112,23 @@ int w1_add_master_device(struct w1_bus_master *master)
 	if (!dev)
 		return -ENOMEM;
=20
+	retval =3D  w1_create_master_attributes(dev);
+	if (retval)
+		goto err_out_free_dev;
+
+	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
+
+	dev->initialized =3D 1;
+
 	dev->thread =3D kthread_run(&w1_process, dev, "%s", dev->name);
 	if (IS_ERR(dev->thread)) {
 		retval =3D PTR_ERR(dev->thread);
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=3D%d\n",
 			 retval);
-		goto err_out_free_dev;
+		goto err_out_rm_attr;
 	}
=20
-	retval =3D  w1_create_master_attributes(dev);
-	if (retval)
-		goto err_out_kill_thread;
-
-	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
-
-	dev->initialized =3D 1;
-
 	mutex_lock(&w1_mlock);
 	list_add(&dev->w1_master_entry, &w1_masters);
 	mutex_unlock(&w1_mlock);
@@ -137,8 +140,13 @@ int w1_add_master_device(struct w1_bus_master *master)
=20
 	return 0;
=20
+#if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
+	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
+#endif
+err_out_rm_attr:
+	w1_destroy_master_attributes(dev);
 err_out_free_dev:
 	w1_free_dev(dev);
=20
--=20
1.4.4.4

--bAmEntskrkuBymla
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjnzmAI852cse6PARAhM5AKDJxAiHuEZ8wuymKrw6wbjloe6eywCgkqoy
9sXMuKirNqu/QQnSCfaLw/M=
=e+n1
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
