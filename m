Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbZFDQ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbZFDQ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbZFDQUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:20:03 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:48904 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZFDQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:46 -0400
Message-Id: <20090604161903.765486755@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:19:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Frank Blaschka <frank.blaschka@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 18/38] pm: ctcm driver power management callbacks
Content-Disposition: inline; filename=pm_ctcm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Blaschka <frank.blaschka@de.ibm.com>

Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/net/ctcm_main.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/s390/net/ctcm_main.c
===================================================================
--- linux-2.6.orig/drivers/s390/net/ctcm_main.c
+++ linux-2.6/drivers/s390/net/ctcm_main.c
@@ -1,7 +1,7 @@
 /*
  * drivers/s390/net/ctcm_main.c
  *
- * Copyright IBM Corp. 2001, 2007
+ * Copyright IBM Corp. 2001, 2009
  * Author(s):
  *	Original CTC driver(s):
  *		Fritz Elfert (felfert@millenux.com)
@@ -1690,6 +1690,38 @@ static void ctcm_remove_device(struct cc
 	put_device(&cgdev->dev);
 }
 
+static int ctcm_pm_suspend(struct ccwgroup_device *gdev)
+{
+	struct ctcm_priv *priv = dev_get_drvdata(&gdev->dev);
+
+	if (gdev->state == CCWGROUP_OFFLINE)
+		return 0;
+	netif_device_detach(priv->channel[READ]->netdev);
+	ctcm_close(priv->channel[READ]->netdev);
+	ccw_device_set_offline(gdev->cdev[1]);
+	ccw_device_set_offline(gdev->cdev[0]);
+	return 0;
+}
+
+static int ctcm_pm_resume(struct ccwgroup_device *gdev)
+{
+	struct ctcm_priv *priv = dev_get_drvdata(&gdev->dev);
+	int rc;
+
+	if (gdev->state == CCWGROUP_OFFLINE)
+		return 0;
+	rc = ccw_device_set_online(gdev->cdev[1]);
+	if (rc)
+		goto err_out;
+	rc = ccw_device_set_online(gdev->cdev[0]);
+	if (rc)
+		goto err_out;
+	ctcm_open(priv->channel[READ]->netdev);
+err_out:
+	netif_device_attach(priv->channel[READ]->netdev);
+	return rc;
+}
+
 static struct ccwgroup_driver ctcm_group_driver = {
 	.owner       = THIS_MODULE,
 	.name        = CTC_DRIVER_NAME,
@@ -1699,6 +1731,9 @@ static struct ccwgroup_driver ctcm_group
 	.remove      = ctcm_remove_device,
 	.set_online  = ctcm_new_device,
 	.set_offline = ctcm_shutdown_device,
+	.freeze	     = ctcm_pm_suspend,
+	.thaw	     = ctcm_pm_resume,
+	.restore     = ctcm_pm_resume,
 };
 
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

