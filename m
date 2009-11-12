Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZKLLwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZKLLwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZKLLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:52:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZKLLww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:52:52 -0500
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before
 invoking kthread_stop on them
From: Romit Dasgupta <romit@ti.com>
Reply-To: romit@ti.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
In-Reply-To: <200911112141.12437.rjw@sisk.pl>
References: <1257928216.15415.57.camel@boson>
	 <200911111230.58479.rjw@sisk.pl> <20091111193719.GR8742@kernel.dk>
	 <200911112141.12437.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Thu, 12 Nov 2009 17:22:06 +0530
Message-ID: <1258026726.2341.1.camel@boson>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting after incorporationg the suggestions:
> 
> Romit, please rework as suggested by Jens and resubmit.

Unfreezes the bdi flusher task when the said task needs to exit.

Steps to reproduce this.
1) Mount a file system from MMC/SD card.
2) Unmount the file system. This creates a flusher task.
3) Attempt suspend to RAM. System is unresponsive.

This is because the bdi flusher thread is already in the refrigerator and will
remain so until it is thawed. The MMC driver suspend routine call stack will
ultimately issue a 'kthread_stop' on the bdi flusher thread and will block
until the flusher thread is exited. Since the bdi flusher thread is in the
refrigerator it never cleans up until thawed.

Signed-off-by: Romit Dasgupta <romit@ti.com>
---
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5a37e20..5a9ab6f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -603,11 +603,15 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	bdi_remove_from_list(bdi);
 
 	/*
+	 * Force unfreeze of bdi threads before stopping it, otherwise
+	 * it would never exit if it is stuck in the refrigerator.
 	 * Finally, kill the kernel threads. We don't need to be RCU
 	 * safe anymore, since the bdi is gone from visibility.
 	 */
-	list_for_each_entry(wb, &bdi->wb_list, list)
+	list_for_each_entry(wb, &bdi->wb_list, list) {
+		wb->task->flags &= ~PF_FROZEN;
 		kthread_stop(wb->task);
+	}
 }
 
 void bdi_unregister(struct backing_dev_info *bdi)


