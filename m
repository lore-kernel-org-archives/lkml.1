Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbYC1Mze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbYC1Mze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYC1MxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:53:06 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56334 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbYC1MxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:53:04 -0400
Date: Fri, 28 Mar 2008 07:24:49 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 5/35] W1: w1_process, remove W1_MASTER_NEED_EXIT, it is redundant
Message-ID: <20080328122449.GF3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:24:49 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.9
w1.h 1.7
w1_int.c 1.5
Removed W1_MASTER_NEED_EXIT along with the flags variable it used as
they were redundant.  The kthread_stop() and kthread_should_stop() do
the same thing and were already being used and checked.  I also think
there was a race condition in the current implemention.  If
W1_MASTER_NEED_EXIT was set, the w1_process woke up, then exited
because that flag was set before the remove master thread called
kthread_stop, kthread_stop would never return.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c     |    6 +++---
 drivers/w1/w1.h     |    4 ----
 drivers/w1/w1_int.c |    2 --
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index ad89d85..7dd34f2 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -772,7 +772,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w=
1_slave_found_callback cb
 			tmp64 =3D (triplet_ret >> 2);
 			rn |=3D (tmp64 << i);
=20
-			if(test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+			if(kthread_should_stop()) {
 				printk(KERN_INFO "Abort w1_search (exiting)\n");
 				return;
 			}
@@ -815,7 +815,7 @@ int w1_process(void *data)
 	 */
 	const unsigned long jtime=3Dmsecs_to_jiffies(w1_timeout * 1000);
=20
-	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->fla=
gs)) {
+	while (!kthread_should_stop()) {
 		if(dev->search_count) {
 			mutex_lock(&dev->mutex);
 			w1_search_process(dev, W1_SEARCH);
@@ -825,7 +825,7 @@ int w1_process(void *data)
 		try_to_freeze();
 		__set_current_state(TASK_INTERRUPTIBLE);
=20
-		if(kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags))
+		if(kthread_should_stop())
 			break;
=20
 		schedule_timeout(jtime);
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 1533cb3..c47ca1e 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -149,8 +149,6 @@ struct w1_bus_master
 		u8, w1_slave_found_callback);
 };
=20
-#define W1_MASTER_NEED_EXIT		0
-
 struct w1_master
 {
 	struct list_head	w1_master_entry;
@@ -169,8 +167,6 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
=20
-	long			flags;
-
 	struct task_struct	*thread;
 	struct mutex		mutex;
=20
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index bb6cbbe..3388d8f 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -142,7 +142,6 @@ int w1_add_master_device(struct w1_bus_master *master)
=20
 #if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 #endif
 err_out_rm_attr:
@@ -158,7 +157,6 @@ void __w1_remove_master_device(struct w1_master *dev)
 	struct w1_netlink_msg msg;
 	struct w1_slave *sl, *sln;
=20
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
=20
 	mutex_lock(&w1_mlock);
--=20
1.4.4.4

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OORAI852cse6PARAr+5AJ9K+KGS3YsA6jEa3DAWxpFGLDkZ+ACfftgv
uR2qlNPhpd+AWsGFISIr/xQ=
=+HO3
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--
