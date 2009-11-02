Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZKBLEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZKBLEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZKBLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:04:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZKBLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:04:07 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "rjw@sisk.pl" <rjw@sisk.pl>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 2 Nov 2009 16:33:42 +0530
Subject: [PATCH 1/1] PM: Making bdi threads non-freezable
Thread-Topic: [PATCH 1/1] PM: Making bdi threads non-freezable
Thread-Index: AcpbrCOsHp5kpaNZSRe8xI+8AVsI3Q==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC66@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the case when bdi threads are in the refrigerator but file system sync
can happen after this. This is possible in MMC when CONFIG_MMC_UNSAFE_RESUME is
not set.

Signed-off-by: Romit Dasgupta <romit@ti.com>
---
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..661229d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -956,7 +956,6 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 		schedule_timeout_interruptible(wait_jiffies);
-		try_to_freeze();
 	}
 
 	return 0;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5a37e20..9383271 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -273,7 +273,6 @@ static void bdi_task_init(struct backing_dev_info *bdi,
 	spin_unlock(&bdi->wb_lock);
 
 	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
 
 	/*
 	 * Our parent may run at a different priority, just set us to normal
@@ -419,7 +418,6 @@ static int bdi_forker_task(void *ptr)
 			spin_unlock_bh(&bdi_lock);
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
 			schedule_timeout(wait);
-			try_to_freeze();
 			continue;
 		}

