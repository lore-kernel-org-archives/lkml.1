Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYC1Mzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYC1Mzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYC1MxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:53:18 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56336 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYC1MxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:53:17 -0400
Date: Fri, 28 Mar 2008 07:24:10 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 3/35] W1: don't delay search start
Message-ID: <20080328122410.GD3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:24:10 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.6
w1_int.c 1.4
Move the creation of the w1_process thread to after the device has
been initialized.  This way w1_process doesn't have to check to see if
it has been initialized and the bus search can proceed without
sleeping.  That also eliminates two checks in the w1_process loop.
The sleep now happens at the end of the loop not the beginning.

Also added a comment for why the atomic_set was 2.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c     |   19 ++++++-------------
 drivers/w1/w1_int.c |   26 +++++++++++++++++---------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 6fb4110..9a09f3a 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -812,21 +812,14 @@ int w1_process(void *data)
 	struct w1_master *dev =3D (struct w1_master *) data;
=20
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->fla=
gs)) {
+		if(dev->search_count) {
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
index 15a798f..bb6cbbe 100644
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

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ONqAI852cse6PARAsijAJ4y3KHDRvzniVB2wEo9B6r0Wh3ayQCgwA0q
jeh1BGY+qPgzOLRaG57X0NI=
=WvqV
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
