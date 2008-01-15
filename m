Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYAOMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYAOMwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYAOMsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:38 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47964 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751412AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401293.20627@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124800.602843975@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] writeback: defer writeback on locked inode
Content-Disposition: inline; filename=writeback-more_io_wait-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	inode is locked.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -329,12 +329,9 @@ __writeback_single_inode(struct inode *i
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
 

-- 
