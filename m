Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbXL1Nyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbXL1Nyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXL1Nvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:45 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44489 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752990AbXL1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:29 -0500
Message-ID: <398849894.11859@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135121.907366463@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:21 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] writeback: requeue_io_wait() on blocked kupdate
Content-Disposition: inline; filename=writeback-more_io_wait-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	kupdate cannot write all pages because of uncontrollable bad conditions.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -292,11 +292,16 @@ __sync_single_inode(struct inode *inode,
 				 * For the kupdate function we move the inode
 				 * to s_more_io so it will get more writeout as
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				requeue_io(inode);
+				if (wbc->nr_to_write > 0)
+					/* somehow blocked: wait and retry */
+					requeue_io_wait(inode);
+				else
+					/* slice used up: queue for next turn */
+					requeue_io(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
 				 * other inodes on this superblock will get some
 				 * writeout.  Otherwise heavy writing to one

-- 
