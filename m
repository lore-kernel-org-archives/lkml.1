Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXL1NxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXL1NxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXL1Nve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:34 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44553 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752969AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849894.48319@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.639594456@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:26 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] writeback: requeue_io() on redirtied inode
Content-Disposition: inline; filename=writeback-remove-redirty-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redirtied inodes could be seen in really fast writes.
They should really be synced as soon as possible.

redirty_tail() could delay the inode for up to 30s.
Kill the delay by using requeue_io() instead.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -287,11 +287,11 @@ __sync_single_inode(struct inode *inode,
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */
-			redirty_tail(inode);
+			requeue_io(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
 			 */
 			list_move(&inode->i_list, &inode_in_use);

-- 
