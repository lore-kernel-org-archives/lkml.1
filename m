Return-Path: <linux-kernel-owner+w=401wt.eu-S934782AbYETWl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782AbYETWl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934991AbYETWgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:40022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934AbYETWgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:36:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 10/13] s390: fix race in device_create
Date: Tue, 20 May 2008 15:34:57 -0700
Message-Id: <1211322900-12705-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/char/vmlogrdr.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index e848734..2c2428c 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -762,10 +762,10 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 		device_unregister(dev);
 		return ret;
 	}
-	priv->class_device = device_create(vmlogrdr_class, dev,
-					   MKDEV(vmlogrdr_major,
-						 priv->minor_num),
-					   "%s", dev->bus_id);
+	priv->class_device = device_create_drvdata(vmlogrdr_class, dev,
+						   MKDEV(vmlogrdr_major,
+							 priv->minor_num),
+						   priv, "%s", dev->bus_id);
 	if (IS_ERR(priv->class_device)) {
 		ret = PTR_ERR(priv->class_device);
 		priv->class_device=NULL;
@@ -773,7 +773,6 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 		device_unregister(dev);
 		return ret;
 	}
-	dev->driver_data = priv;
 	priv->device = dev;
 	return 0;
 }
-- 
1.5.5.1

