Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYBOT5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYBOT5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbYBOT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:56:49 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54876 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761386AbYBOT4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:56:47 -0500
Date: Fri, 15 Feb 2008 20:56:59 +0100
From: matthias@kaehlcke.net
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 2/3] Convert stats_sem in a mutex
Message-ID: <20080215195659.GC22741@traven>
Mail-Followup-To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080215195329.912560854@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-wireless-prism54-stats_sem-to-mutex.diff"
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore stats_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:43:05.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:44:03.000000000 +0100
@@ -165,7 +165,7 @@
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
-	down(&priv->stats_sem);
+	mutex_lock(&priv->stats_lock);
 
 /* Noise floor.
  * I'm not sure if the unit is dBm.
@@ -207,7 +207,7 @@
 	mgt_get_request(priv, DOT11_OID_MPDUTXFAILED, 0, NULL, &r);
 	priv->local_iwstatistics.discard.retries = r.u;
 
-	up(&priv->stats_sem);
+	mutex_unlock(&priv->stats_lock);
 
 	return;
 }
@@ -218,12 +218,12 @@
 	islpci_private *priv = netdev_priv(ndev);
 
 	/* If the stats are being updated return old data */
-	if (down_trylock(&priv->stats_sem) == 0) {
+	if (mutex_trylock(&priv->stats_lock) == 0) {
 		memcpy(&priv->iwstatistics, &priv->local_iwstatistics,
 		       sizeof (struct iw_statistics));
 		/* They won't be marked updated for the next time */
 		priv->local_iwstatistics.qual.updated = 0;
-		up(&priv->stats_sem);
+		mutex_unlock(&priv->stats_lock);
 	} else
 		priv->iwstatistics.qual.updated = 0;
 
Index: linux-2.6/drivers/net/wireless/prism54/islpci_dev.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/islpci_dev.c	2008-02-15 20:42:15.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/islpci_dev.c	2008-02-15 20:44:03.000000000 +0100
@@ -864,7 +864,7 @@
 	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
-	sema_init(&priv->stats_sem, 1);
+	mutex_init(&priv->stats_lock);
 	spin_lock_init(&priv->slock);
 
 	/* init state machine with off#1 state */
Index: linux-2.6/drivers/net/wireless/prism54/islpci_dev.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:43:49.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:44:03.000000000 +0100
@@ -88,7 +88,7 @@
 
 	/* Take care of the wireless stats */
 	struct work_struct stats_work;
-	struct semaphore stats_sem;
+	struct mutex stats_lock;
 	/* remember when we last updated the stats */
 	unsigned long stats_timestamp;
 	/* The first is accessed under semaphore locking.

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
