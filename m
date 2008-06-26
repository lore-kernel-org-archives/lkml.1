Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYFZLG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYFZLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYFZLGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:06:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:59274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbYFZLGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:06:47 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-aio@kvack.org
Subject: [PATCH] aio: avoid using queue_delayed_work in aio_kick_handler to schedule itself
Date: Thu, 26 Jun 2008 09:27:27 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260927.27995.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoid using queue_delayed_work in aio_kick_handler() to run itself 
immediately. Instead use aio_run_all_iocbs()

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/aio.c b/fs/aio.c
index e27f611..7817e8f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -823,21 +823,13 @@ static void aio_kick_handler(struct work_struct *work)
 	struct kioctx *ctx = container_of(work, struct kioctx, wq.work);
 	mm_segment_t oldfs = get_fs();
 	struct mm_struct *mm;
-	int requeue;
 
 	set_fs(USER_DS);
-	use_mm(ctx->mm);
-	spin_lock_irq(&ctx->ctx_lock);
-	requeue =__aio_run_iocbs(ctx);
 	mm = ctx->mm;
-	spin_unlock_irq(&ctx->ctx_lock);
+	use_mm(mm);
+	aio_run_all_iocbs(ctx);
  	unuse_mm(mm);
 	set_fs(oldfs);
-	/*
-	 * we're in a worker thread already, don't use queue_delayed_work,
-	 */
-	if (requeue)
-		queue_delayed_work(aio_wq, &ctx->wq, 0);
 }
 
 
