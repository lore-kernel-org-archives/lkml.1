Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZLJTct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZLJTct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZLJTcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:32:48 -0500
Received: from www.tglx.de ([62.245.132.106]:40057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbZLJTcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:32:47 -0500
Message-Id: <20091210193057.799393067@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 19:32:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch] drivers: Fix bogus 0 error return in device_add()
Content-Disposition: inline; filename=drivers-base-fix-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_add() is called with a device which does not have dev->p set
up, then device_private_init() is called. If that succeeds, then the
error variable is set to 0. Now if the dev_name(dev) check further
down fails, then device_add() correctly terminates, but returns 0.
That of course lets the driver progress. If later another driver uses
this half set up device as parent then device_add() of the child
device explodes and renders sysfs completely unusable.

Set the error to -EINVAL if dev_name() check fails.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/base/core.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/core.c
+++ linux-2.6-tip/drivers/base/core.c
@@ -898,8 +898,10 @@ int device_add(struct device *dev)
 		dev->init_name = NULL;
 	}
 
-	if (!dev_name(dev))
+	if (!dev_name(dev)) {
+		error = -EINVAL;
 		goto name_error;
+	}
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 


