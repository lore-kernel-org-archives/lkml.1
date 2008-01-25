Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbYAYIIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbYAYIIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbYAYH76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:58 -0500
Received: from ns.suse.de ([195.135.220.2]:59391 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763943AbYAYH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 190/196] rtc: use class iteration api
Date: Thu, 24 Jan 2008 23:33:39 -0800
Message-Id: <1201246425-5058-111-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/rtc/interface.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index f1e00ff..7e3ad4f 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -251,20 +251,23 @@ void rtc_update_irq(struct rtc_device *rtc,
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq);
 
+static int __rtc_match(struct device *dev, void *data)
+{
+	char *name = (char *)data;
+
+	if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0)
+		return 1;
+	return 0;
+}
+
 struct rtc_device *rtc_class_open(char *name)
 {
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	down(&rtc_class->sem);
-	list_for_each_entry(dev, &rtc_class->devices, node) {
-		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
-			dev = get_device(dev);
-			if (dev)
-				rtc = to_rtc_device(dev);
-			break;
-		}
-	}
+	dev = class_find_device(rtc_class, name, __rtc_match);
+	if (dev)
+		rtc = to_rtc_device(dev);
 
 	if (rtc) {
 		if (!try_module_get(rtc->owner)) {
@@ -272,7 +275,6 @@ struct rtc_device *rtc_class_open(char *name)
 			rtc = NULL;
 		}
 	}
-	up(&rtc_class->sem);
 
 	return rtc;
 }
-- 
1.5.3.8

