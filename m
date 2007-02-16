Return-Path: <linux-kernel-owner+w=401wt.eu-S1946309AbXBPXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946309AbXBPXk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946300AbXBPXjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:39564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946309AbXBPXjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/10] Driver core: device_add_attrs() cleanup
Date: Fri, 16 Feb 2007 15:37:34 -0800
Message-Id: <11716690802025-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <1171669076436-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de> <11716690692008-git-send-email-gregkh@suse.de> <1171669073246-git-send-email-gregkh@suse.de> <1171669076436-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Clean up the coding in device_add_attrs() a bit.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 472810f..253868e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -324,27 +324,25 @@ int bus_for_each_drv(struct bus_type * bus, struct device_driver * start,
 	return error;
 }
 
-static int device_add_attrs(struct bus_type * bus, struct device * dev)
+static int device_add_attrs(struct bus_type *bus, struct device *dev)
 {
 	int error = 0;
 	int i;
 
-	if (bus->dev_attrs) {
-		for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
-			error = device_create_file(dev,&bus->dev_attrs[i]);
-			if (error)
-				goto Err;
+	if (!bus->dev_attrs)
+		return 0;
+
+	for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
+		error = device_create_file(dev,&bus->dev_attrs[i]);
+		if (error) {
+			while (--i >= 0)
+				device_remove_file(dev, &bus->dev_attrs[i]);
+			break;
 		}
 	}
- Done:
 	return error;
- Err:
-	while (--i >= 0)
-		device_remove_file(dev,&bus->dev_attrs[i]);
-	goto Done;
 }
 
-
 static void device_remove_attrs(struct bus_type * bus, struct device * dev)
 {
 	int i;
-- 
1.5.0

