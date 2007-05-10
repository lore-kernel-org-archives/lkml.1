Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXEJKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXEJKfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXEJKfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:35:48 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:50074 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754287AbXEJKfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:35:47 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Date: Thu, 10 May 2007 12:35:37 +0200
Message-Id: <117879333788-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point before 2.6.20, the mmc subsystem moved the card
detection code to its own workqueue. One consequence of this change
is that when using an mmc card as a root device, the card may get
detected after the init task attempts to mount the root filesystem,
causing a kernel panic because the root device could not be opened.

This patch adds a call to mmc_flush_scheduled_work() late in the boot
sequence so that we can be sure the mmc card detection scans are
complete before attempting to use an mmc device as a root device.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/mmc/core/sysfs.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sysfs.c b/drivers/mmc/core/sysfs.c
index 843b1fb..168b20f 100644
--- a/drivers/mmc/core/sysfs.c
+++ b/drivers/mmc/core/sysfs.c
@@ -358,3 +358,16 @@ static void __exit mmc_exit(void)
 
 module_init(mmc_init);
 module_exit(mmc_exit);
+
+#ifndef MODULE
+/*
+ * Make sure scanning for new cards has completed before attempting
+ * to mount the root filesystem.
+ */
+static int __init mmc_finish_detect(void)
+{
+	mmc_flush_scheduled_work();
+	return 0;
+}
+late_initcall(mmc_finish_detect);
+#endif
-- 
1.4.4.4

