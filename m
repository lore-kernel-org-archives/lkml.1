Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXGDAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXGDAem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbXGDAdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:33:54 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49243 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXGDAdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:33:49 -0400
Date: Tue, 03 Jul 2007 17:31:02 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/4] try parent numa_node at first before using default
In-reply-to: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       rientjes@google.com, Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707031731.02456.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] try parent numa_node at first before using default

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index dd40d78..c344d82 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
 
 void device_initialize(struct device *dev)
 {
+	int node;
+
 	kobj_set_kset_s(dev, devices_subsys);
 	kobject_init(&dev->kobj);
 	klist_init(&dev->klist_children, klist_children_get,
@@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
-	set_dev_node(dev, -1);
+
+	node = dev->parent ? dev_to_node(dev->parent) : -1;
+	set_dev_node(dev, node);
 }
 
 #ifdef CONFIG_SYSFS_DEPRECATED
