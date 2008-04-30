Return-Path: <linux-kernel-owner+w=401wt.eu-S1764404AbYEAAAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764404AbYEAAAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbYD3X6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765147AbYD3X6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stas Sergeev <stsp@aknet.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/11] driver core: warn about duplicate driver names on the same bus
Date: Wed, 30 Apr 2008 16:57:43 -0700
Message-Id: <1209599870-22919-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stas Sergeev <stsp@aknet.ru>

Currently an attempt to register multiple
drivers with the same name causes the
stack trace with some cryptic error message.
The attached patch adds the necessary check
and the clear error message.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9a6537f..2ef5acf 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -217,12 +217,22 @@ static void driver_remove_groups(struct device_driver *drv,
 int driver_register(struct device_driver *drv)
 {
 	int ret;
+	struct device_driver *other;
 
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
 		printk(KERN_WARNING "Driver '%s' needs updating - please use "
 			"bus_type methods\n", drv->name);
+
+	other = driver_find(drv->name, drv->bus);
+	if (other) {
+		put_driver(other);
+		printk(KERN_ERR "Error: Driver '%s' is already registered, "
+			"aborting...\n", drv->name);
+		return -EEXIST;
+	}
+
 	ret = bus_add_driver(drv);
 	if (ret)
 		return ret;
-- 
1.5.5.1

