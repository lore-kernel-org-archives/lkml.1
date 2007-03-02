Return-Path: <linux-kernel-owner+w=401wt.eu-S2992505AbXCBPRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992505AbXCBPRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992506AbXCBPRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:17:42 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:34117 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992505AbXCBPRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:17:42 -0500
To: linux-kernel@vger.kernel.org
CC: spyro@f2s.com
Subject: [PATCH] floppy: handle device_create_file() failure while init
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Fri, 02 Mar 2007 18:16:38 +0300
Message-ID: <87r6s73cbt.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the "ignoring return value of 'device_create_file'" 
warning message.
Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/block/floppy.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 567c630..dfdabc3 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4333,7 +4333,10 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		if (err)
+			goto out_unreg_platform_dev;
+
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->queue = floppy_queue;
@@ -4344,6 +4347,8 @@ static int __init floppy_init(void)
 
 	return 0;
 
+out_unreg_platform_dev:
+	platform_device_unregister(&floppy_device[drive]);
 out_flush_work:
 	flush_scheduled_work();
 	if (usage_count)
-- 
1.4.4.2

