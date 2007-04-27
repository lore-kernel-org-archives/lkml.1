Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbXD0S5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbXD0S5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbXD0S5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:18 -0400
Received: from mail.suse.de ([195.135.220.2]:50480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbXD0S4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/46] dev_printk and new-style class devices
Date: Fri, 27 Apr 2007 11:53:17 -0700
Message-Id: <11777000471977-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000433552-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

As the new-style class devices (as opposed to old-style struct
class_device) are becoming more widely used, I noticed that the
dev_printk-based functions are not working properly with these.
New-style class devices have no driver nor bus, almost by definition,
and as a result dev_driver_string(), which is used as the first
parameter of dev_printk, resolves to an empty string. This causes
entries like the following to show in my logs:

 i2c-2: adapter [SMBus stub driver] registered

Notice the unaesthetical leading whitespace. In order to fix this
problem, I suggest that we extend dev_driver_string to deal with
new-style class devices:

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 658eae5..9ea12d9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -43,7 +43,8 @@ int (*platform_notify_remove)(struct device * dev) = NULL;
 const char *dev_driver_string(struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
-			(dev->bus ? dev->bus->name : "");
+			(dev->bus ? dev->bus->name :
+			(dev->class ? dev->class->name : ""));
 }
 EXPORT_SYMBOL(dev_driver_string);
 
-- 
1.5.1.2

