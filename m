Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXD0TOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXD0TOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXD0TMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:12:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043AbXD0S5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/46] Driver core: switch firmware_class to uevent_suppress.
Date: Fri, 27 Apr 2007 11:53:29 -0700
Message-Id: <11777000923797-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000881307-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Use uevent_suppress instead of returning an error code in
firmware_uevent(). Get rid of the now unneeded FW_STATUS_READY
and FW_STATUS_READY_NOHOTPLUG.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c0a979a..97ab5bd 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -31,8 +31,6 @@ enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
 	FW_STATUS_ABORT,
-	FW_STATUS_READY,
-	FW_STATUS_READY_NOHOTPLUG,
 };
 
 static int loading_timeout = 60;	/* In seconds */
@@ -96,9 +94,6 @@ static int firmware_uevent(struct device *dev, char **envp, int num_envp,
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int i = 0, len = 0;
 
-	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
-		return -ENODEV;
-
 	if (add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			   "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
@@ -333,6 +328,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -382,9 +378,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	}
 
 	if (uevent)
-                set_bit(FW_STATUS_READY, &fw_priv->status);
-        else
-                set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+		f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 
-- 
1.5.1.2

