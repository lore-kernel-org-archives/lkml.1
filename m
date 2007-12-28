Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXL1NwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXL1NwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXL1Nvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:31 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44515 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752888AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849894.98675@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.207057056@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:23 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] writeback: requeue_io_wait() on locked inode
Content-Disposition: inline; filename=writeback-more_io_wait-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	inode is locked

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -322,16 +322,13 @@ __writeback_single_inode(struct inode *i
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
 	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to s_more_io so
-		 * that writeback can proceed with the other inodes on s_io.
-		 * We'll have another go at writing back this inode when we
-		 * completed a full scan of s_io.
+		 * doing writeback-for-data-integrity. Recheck it after a while.
 		 */
-		requeue_io(inode);
+		requeue_io_wait(inode);
 		return 0;
 	}
 
 	/*
 	 * It's a data-integrity sync.  We must wait.

-- 
