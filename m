Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXLCPeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXLCPeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXLCPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:33:56 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36537 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbXLCPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:33:56 -0500
To: jmoyer@redhat.com, zach.brown@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6.24 BUG] 100% iowait on host while UML is running
Message-Id: <E1IzDHv-0003xj-Af@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 03 Dec 2007 16:32:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.24, top started showing 100% iowait on one CPU when a UML
instance was running (but completely idle).  I've traced it to this
commit.  Reverting it cures the problem.

Miklos



commit 41d10da3717409de33d5441f2f6d8f072ab3fbb6
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Tue Oct 16 23:27:20 2007 -0700

    aio: account I/O wait time properly
    
    Some months back I proposed changing the schedule() call in
    read_events to an io_schedule():
    	http://osdir.com/ml/linux.kernel.aio.general/2006-10/msg00024.html
    This was rejected as there are AIO operations that do not initiate
    disk I/O.  I've had another look at the problem, and the only AIO
    operation that will not initiate disk I/O is IOCB_CMD_NOOP.  However,
    this command isn't even wired up!
    
    Given that it doesn't work, and hasn't for *years*, I'm going to
    suggest again that we do proper I/O accounting when using AIO.
    
    Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
    Acked-by: Zach Brown <zach.brown@oracle.com>
    Cc: Benjamin LaHaise <bcrl@kvack.org>
    Cc: Suparna Bhattacharya <suparna@in.ibm.com>
    Cc: Badari Pulavarty <pbadari@us.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/aio.c b/fs/aio.c
index ea2e198..d02f43b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -303,7 +303,7 @@ static void wait_for_all_aios(struct kioctx *ctx)
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (ctx->reqs_active) {
 		spin_unlock_irq(&ctx->ctx_lock);
-		schedule();
+		io_schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		spin_lock_irq(&ctx->ctx_lock);
 	}
@@ -323,7 +323,7 @@ ssize_t fastcall wait_on_sync_kiocb(struct kiocb *iocb)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!iocb->ki_users)
 			break;
-		schedule();
+		io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 	return iocb->ki_user_data;
@@ -1170,7 +1170,7 @@ retry:
 			ret = 0;
 			if (to.timed_out)	/* Only check after read evt */
 				break;
-			schedule();
+			io_schedule();
 			if (signal_pending(tsk)) {
 				ret = -EINTR;
 				break;
