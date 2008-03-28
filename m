Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYC1MwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYC1MwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYC1MvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:16 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56318 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbYC1MvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:15 -0400
Date: Fri, 28 Mar 2008 07:24:56 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 6/35] W1: w1_process, block when there's nothing to do
Message-ID: <20080328122456.GG3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:24:56 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.10
Instead of sleeping with a timeout, it will now sleep with a timeout
only when there is an active bus search.  When the search is not
active it will block until something wakes it up.  kthread_stop and
changing the search_count will wake up the thread.  Now if the search
value is changed (to request a new search) it will wake up and do the
search immediately, rather than waiting for the end of the current
timeout.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 7dd34f2..5d8c2c7 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -251,6 +251,7 @@ static ssize_t w1_master_attribute_store_search(struct =
device * dev,
 	mutex_lock(&md->mutex);
 	md->search_count =3D simple_strtol(buf, NULL, 0);
 	mutex_unlock(&md->mutex);
+	wake_up_process(md->thread);
=20
 	return count;
 }
@@ -828,7 +829,11 @@ int w1_process(void *data)
 		if(kthread_should_stop())
 			break;
=20
-		schedule_timeout(jtime);
+		/* Only sleep when the search is active. */
+		if(dev->search_count)
+			schedule_timeout(jtime);
+		else
+			schedule();
 	}
=20
 	atomic_dec(&dev->refcnt);
--=20
1.4.4.4

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OOYAI852cse6PARAi6OAJ4+m8+QXoFa3T9Eo80OQb/a3Dg2KACeM/jl
g5txtRss5Dwe+IIjE4kZTTo=
=SLp5
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
