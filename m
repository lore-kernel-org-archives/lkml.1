Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYC1Mxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYC1Mxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbYC1Mvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:46 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56324 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbYC1Mvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:45 -0400
Date: Fri, 28 Mar 2008 07:24:41 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 4/35] W1: w1_process, allow wakeup in sleep
Message-ID: <20080328122440.GE3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IU5/I01NYhRvwH70"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:24:41 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IU5/I01NYhRvwH70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.7 1.8
msleep_interruptible only wakes for signals, but we don't use them.
We want kthread_stop to wake it up, so call schedule_timeout
ourselves.  This is prep-work for blocking when there isn't anything       =
     to do, instead of sleeping in a loop, as something has to be able to
wake it up.
Added a check for termination after the bus search, otherwise it would
sleep for the full time value if kthread_stop was called while
w1_process was in the bus search.  This would cause a deadlock when it
is blocking instead of sleeping with a timeout.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9a09f3a..ad89d85 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -810,6 +810,10 @@ void w1_search_process(struct w1_master *dev, u8 searc=
h_type)
 int w1_process(void *data)
 {
 	struct w1_master *dev =3D (struct w1_master *) data;
+	/* As long as w1_timeout is only set by a module parameter the sleep
+	 * time can be calculated in jiffies once.
+	 */
+	const unsigned long jtime=3Dmsecs_to_jiffies(w1_timeout * 1000);
=20
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->fla=
gs)) {
 		if(dev->search_count) {
@@ -819,7 +823,12 @@ int w1_process(void *data)
 		}
=20
 		try_to_freeze();
-		msleep_interruptible(w1_timeout * 1000);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		if(kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags))
+			break;
+
+		schedule_timeout(jtime);
 	}
=20
 	atomic_dec(&dev->refcnt);
--=20
1.4.4.4

--IU5/I01NYhRvwH70
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OOIAI852cse6PARAsi6AJsGstFjI/siHnY7Lj069kv9zCS5TwCeK8Oe
6m8q8dTP9K5UI/VWzTIL2Qk=
=HBig
-----END PGP SIGNATURE-----

--IU5/I01NYhRvwH70--
