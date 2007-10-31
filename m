Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbXJaFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbXJaFNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXJaFMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:12:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXJaFM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:12:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y
Date: Tue, 30 Oct 2007 22:11:43 -0700
Message-Id: <1193807505-3821-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193807505-3821-3-git-send-email-gregkh@suse.de>
References: <20071031050954.GA3791@kroah.com>
 <1193807505-3821-1-git-send-email-gregkh@suse.de>
 <1193807505-3821-2-git-send-email-gregkh@suse.de>
 <1193807505-3821-3-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This should fix the sysfs warnings that renaming network devices is
causing to show up with CONFIG_SYSFS_DEPRECATED=y

The code just shouldn't run if class devices are real directories, it's
an update for the symlink in the class directory. Nobody noticed that as
long as the creation of sysfs files silently failed, and we both missed
it before the merge, because we don't run SYSFS_DEPRECATED=y.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c134341..3f4d6aa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1228,18 +1228,18 @@ int device_rename(struct device *dev, char *new_name)
 			sysfs_remove_link(&dev->parent->kobj, old_class_name);
 		}
 	}
-#endif
-
+#else
 	if (dev->class) {
 		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
 		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
 					  dev->bus_id);
 		if (error) {
-			/* Uh... how to unravel this if restoring can fail? */
 			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
 				__FUNCTION__, error);
 		}
 	}
+#endif
+
 out:
 	put_device(dev);
 
-- 
1.5.3.4

