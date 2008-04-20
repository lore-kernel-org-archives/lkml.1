Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbYDTKpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbYDTKpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYDTKkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56302 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDTKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben@fluff.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/36] sysdev: detect multiple driver registrations
Date: Sun, 20 Apr 2008 03:45:47 -0700
Message-Id: <1208688366-9252-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben@fluff.org>

I've just found how easy it is to accidentally register a sysdev_driver for
two different classes.  When this happens, bad things happen as the
sysdev_driver structure keeps has the list entry for the driver
registration.

The following patch makes a WARN_ON() if this happens, although I think
BUG_ON or returning -EAGAIN could also be valid responses to this.

Signed-off-by: Ben Dooks <ben@fluff.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 8e13fd9..1a06c23 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -167,6 +167,22 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 {
 	int err = 0;
 
+	if (!cls) {
+		printk(KERN_WARNING "sysdev: invalid class passed to "
+			"sysdev_driver_register!\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	/* Check whether this driver has already been added to a class. */
+	if ((drv->entry.next != drv->entry.prev) ||
+	    (drv->entry.next != NULL)) {
+		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
+			" been registered to a class, something is wrong, but "
+			"will forge on!\n", cls->name, drv);
+		WARN_ON(1);
+	}
+
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
-- 
1.5.4.5

