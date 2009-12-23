Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZLWTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZLWTxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZLWTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:18 -0500
Received: from kroah.org ([198.145.64.141]:52954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbZLWTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Kay Sievers <kay.sievers@vrfy.org>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/10] Driver-core: Fix bogus 0 error return in device_add()
Date: Wed, 23 Dec 2009 11:52:40 -0800
Message-Id: <1261597963-18323-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If device_add() is called with a device which does not have dev->p set
up, then device_private_init() is called. If that succeeds, then the
error variable is set to 0. Now if the dev_name(dev) check further
down fails, then device_add() correctly terminates, but returns 0.
That of course lets the driver progress. If later another driver uses
this half set up device as parent then device_add() of the child
device explodes and renders sysfs completely unusable.

Set the error to -EINVAL if dev_name() check fails.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 83afc8b..2820257 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -909,8 +909,10 @@ int device_add(struct device *dev)
 		dev->init_name = NULL;
 	}
 
-	if (!dev_name(dev))
+	if (!dev_name(dev)) {
+		error = -EINVAL;
 		goto name_error;
+	}
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
-- 
1.6.5.7

