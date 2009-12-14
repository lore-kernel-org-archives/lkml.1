Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbZLNSYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbZLNSYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362AbZLNSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:24:12 -0500
Received: from smtp.nokia.com ([192.100.105.134]:35828 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbZLNSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:24:11 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de, kay.sievers@vrfy.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] driver core: Prevent reference to freed memory on error path
Date: Mon, 14 Dec 2009 20:28:12 +0200
Message-Id: <1260815292-18538-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 14 Dec 2009 18:24:00.0892 (UTC) FILETIME=[9BA47BC0:01CA7CEA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

priv is drv->p. So only free drv->p after we've finished using priv.

Found using a static code analysis tool

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 63c143e..c0c5a43 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -703,9 +703,9 @@ int bus_add_driver(struct device_driver *drv)
 	return 0;
 
 out_unregister:
+	kobject_put(&priv->kobj);
 	kfree(drv->p);
 	drv->p = NULL;
-	kobject_put(&priv->kobj);
 out_put_bus:
 	bus_put(bus);
 	return error;
-- 
1.6.0.4

