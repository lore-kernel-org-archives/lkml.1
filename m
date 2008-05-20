Return-Path: <linux-kernel-owner+w=401wt.eu-S935373AbYETWjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373AbYETWjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934957AbYETWgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:39873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935046AbYETWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:36:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [PATCH 08/13] UIO: fix race in device_create
Date: Tue, 20 May 2008 15:34:55 -0700
Message-Id: <1211322900-12705-8-git-send-email-gregkh@suse.de>
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
Cc: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 55cc7b8..0a12e90 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -649,15 +649,14 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_get_minor;
 
-	idev->dev = device_create(uio_class->class, parent,
-				  MKDEV(uio_major, idev->minor),
-				  "uio%d", idev->minor);
+	idev->dev = device_create_drvdata(uio_class->class, parent,
+					  MKDEV(uio_major, idev->minor), idev,
+					  "uio%d", idev->minor);
 	if (IS_ERR(idev->dev)) {
 		printk(KERN_ERR "UIO: device register failed\n");
 		ret = PTR_ERR(idev->dev);
 		goto err_device_create;
 	}
-	dev_set_drvdata(idev->dev, idev);
 
 	ret = uio_dev_add_attributes(idev);
 	if (ret)
-- 
1.5.5.1

