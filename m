Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbZLKW0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbZLKW0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762805AbZLKWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:44 -0500
Received: from kroah.org ([198.145.64.141]:32840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762766AbZLKWZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, stable <stable@kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/27] Driver core: fix race in dev_driver_string
Date: Fri, 11 Dec 2009 14:24:49 -0800
Message-Id: <1260570289-6997-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1310) works around a race in dev_driver_string().  If
the device is unbound while the function is running, dev->driver might
become NULL after we test it and before we dereference it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 353b137..f1290cb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -56,7 +56,14 @@ static inline int device_is_not_partition(struct device *dev)
  */
 const char *dev_driver_string(const struct device *dev)
 {
-	return dev->driver ? dev->driver->name :
+	struct device_driver *drv;
+
+	/* dev->driver can change to NULL underneath us because of unbinding,
+	 * so be careful about accessing it.  dev->bus and dev->class should
+	 * never change once they are set, so they don't need special care.
+	 */
+	drv = ACCESS_ONCE(dev->driver);
+	return drv ? drv->name :
 			(dev->bus ? dev->bus->name :
 			(dev->class ? dev->class->name : ""));
 }
-- 
1.6.5.5

