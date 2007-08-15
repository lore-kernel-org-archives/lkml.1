Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXHOJLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXHOJLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbXHOJLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:11:38 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47615 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758874AbXHOJLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:11:37 -0400
Date: Wed, 15 Aug 2007 13:11:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
Subject: [1/1] w1: fix w1_remove_master_device() searching.
Message-ID: <20070815091112.GB28320@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case bus master driver provided bogus value as its private data,
search can be incorrect. Problem found by Adrian Bunk.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 2fbd8dd..6840dfe 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -170,22 +170,24 @@ void __w1_remove_master_device(struct w1_master *dev)
 
 void w1_remove_master_device(struct w1_bus_master *bm)
 {
-	struct w1_master *dev = NULL;
+	struct w1_master *dev, *found = NULL;
 
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
 		if (!dev->initialized)
 			continue;
 
-		if (dev->bus_master->data == bm->data)
+		if (dev->bus_master->data == bm->data) {
+			found = dev;
 			break;
+		}
 	}
 
-	if (!dev) {
+	if (!found) {
 		printk(KERN_ERR "Device doesn't exist.\n");
 		return;
 	}
 
-	__w1_remove_master_device(dev);
+	__w1_remove_master_device(found);
 }
 
 EXPORT_SYMBOL(w1_add_master_device);

-- 
	Evgeniy Polyakov
