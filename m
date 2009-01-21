Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZAUFVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZAUFVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZAUFVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:21:09 -0500
Received: from kroah.org ([198.145.64.141]:53313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbZAUFVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:21:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <rdreier@cisco.com>, Roland Dreier <rolandd@cisco.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] driver core: Convert '/' to '!' in dev_set_name()
Date: Tue, 20 Jan 2009 21:19:53 -0800
Message-Id: <1232515197-3974-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090121051855.GA3665@kroah.com>
References: <20090121051855.GA3665@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>

Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
dev_set_name()") deleted the code in register_disk() that changed a '/'
to a '!' in the device name when registering a disk, but dev_set_name()
does not perform this conversion.

This leads to amusing problems with disks that have '/' in their names:
for example a failure to boot with the root partition on a cciss device,
even though the kernel says it knows about the root device:

    VFS: Cannot open root device "cciss/c0d0p6" or unknown-block(0,0)
    Please append a correct "root=" boot option; here are the available partitions:
    6800        71652960 cciss/c0d0 driver: cciss
      6802               1 cciss/c0d0p2
      6805         2931831 cciss/c0d0p5
      6806        34354908 cciss/c0d0p6
    6810        71652960 cciss/c0d1 driver: cciss

Fix this by adding code to change '/' to '!' in dev_set_name() to handle
this until dev_set_name() is converted to use kobject_set_name().

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8079afc..55e5309 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -777,10 +777,16 @@ static void device_remove_class_symlinks(struct device *dev)
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
 	va_list vargs;
+	char *s;
 
 	va_start(vargs, fmt);
 	vsnprintf(dev->bus_id, sizeof(dev->bus_id), fmt, vargs);
 	va_end(vargs);
+
+	/* ewww... some of these buggers have / in the name... */
+	while ((s = strchr(dev->bus_id, '/')))
+		*s = '!';
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
-- 
1.6.0.4

