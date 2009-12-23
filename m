Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZLWT4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZLWT4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbZLWT4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:56:31 -0500
Received: from kroah.org ([198.145.64.141]:52959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZLWTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/10] driver core: Prevent reference to freed memory on error path
Date: Wed, 23 Dec 2009 11:52:41 -0800
Message-Id: <1261597963-18323-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

priv is drv->p. So only free drv->p after we've finished using priv.

Found using a static code analysis tool

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.7

