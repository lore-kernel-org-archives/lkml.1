Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYAOMsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYAOMsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYAOMsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:13 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47950 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754977AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401291.20012@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124758.972567524@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:40 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] writeback: introduce writeback_control.more_io
Content-Disposition: inline; filename=writeback-more_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce writeback_control.more_io to indicate that more I/O is
scheduled for this wakeup of pdflush.

Note that more_io is only updated on the _visited_ superblocks,
which prevents pdflush deamons from interfering with one another.

Cc: Michael Rubin <mrubin@google.com>                                                                                   
Cc: Peter Zijlstra <peterz@infradead.org>                                                                               
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |    6 +++++-
 include/linux/writeback.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -472,8 +472,12 @@ int generic_sync_sb_inodes(struct super_
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0)
+		if (wbc->nr_to_write <= 0) {
+			wbc->more_io = 1;
 			break;
+		}
+		if (!list_empty(&sb->s_more_io))
+			wbc->more_io = 1;
 	}
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
--- linux-mm.orig/include/linux/writeback.h
+++ linux-mm/include/linux/writeback.h
@@ -62,6 +62,7 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*

-- 
