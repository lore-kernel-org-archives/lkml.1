Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXC2JKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXC2JKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXC2JKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:10:46 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56537 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXC2JKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:10:21 -0400
Date: Thu, 29 Mar 2007 11:12:14 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>,
       Manuel Estrada Sainz <ranty@debian.org>,
       Eric Rannaud <eric.rannaud@gmail.com>
Subject: [Patch -mm 2/3] Driver core: switch firmware_class to
 uevent_suppress.
Message-ID: <20070329111214.1c3aa250@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Use uevent_suppress instead of returning an error code in
firmware_uevent(). Get rid of the now unneeded FW_STATUS_READY
and FW_STATUS_READY_NOHOTPLUG.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/firmware_class.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

--- linux-2.6.21-rc5-mm1.orig/drivers/base/firmware_class.c
+++ linux-2.6.21-rc5-mm1/drivers/base/firmware_class.c
@@ -31,8 +31,6 @@ enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
 	FW_STATUS_ABORT,
-	FW_STATUS_READY,
-	FW_STATUS_READY_NOHOTPLUG,
 };
 
 static int loading_timeout = 60;	/* In seconds */
@@ -96,9 +94,6 @@ static int firmware_uevent(struct device
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int i = 0, len = 0;
 
-	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
-		return -ENODEV;
-
 	if (add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			   "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
@@ -333,6 +328,7 @@ static int fw_register_device(struct dev
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -382,9 +378,7 @@ static int fw_setup_device(struct firmwa
 	}
 
 	if (uevent)
-                set_bit(FW_STATUS_READY, &fw_priv->status);
-        else
-                set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+		f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 
