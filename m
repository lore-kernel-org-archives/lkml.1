Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbZKKIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbZKKIax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZKKIaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:30:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58426 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbZKKIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:30:51 -0500
Subject: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before
 invoking kthread_stop on them
From: Romit Dasgupta <romit@ti.com>
Reply-To: romit@ti.com
To: jens.axboe@oracle.com, rjw@sisk.pl, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Wed, 11 Nov 2009 14:00:16 +0530
Message-ID: <1257928216.15415.57.camel@boson>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kicks out frozen bdi flusher task out of the refrigerator when the flusher task
needs to exit.
Signed-off-by: Romit Dasgupta <romit@ti.com>
---
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5a37e20..c757b05 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -606,8 +606,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * Finally, kill the kernel threads. We don't need to be RCU
 	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	list_for_each_entry(wb, &bdi->wb_list, list)
+	list_for_each_entry(wb, &bdi->wb_list, list) {
+		if (unlikely(frozen(wb->task)))
+			wb->task->flags &= ~PF_FROZEN;
 		kthread_stop(wb->task);
+	}
 }
 
 void bdi_unregister(struct backing_dev_info *bdi)


