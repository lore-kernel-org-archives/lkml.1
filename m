Return-Path: <linux-kernel-owner+w=401wt.eu-S935854AbYBCCGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854AbYBCCGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 21:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbYBCCGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 21:06:07 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41173 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1763096AbYBCCGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 21:06:06 -0500
Message-ID: <402004370.28303@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 3 Feb 2008 10:05:59 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: __sync_single_inode() trivial cleanup
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JLUF5-0001rN-JM@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the if-else straight in __sync_single_inode().
No behavior change.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -261,8 +261,13 @@ __sync_single_inode(struct inode *inode,
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
-		if (!(inode->i_state & I_DIRTY) &&
-		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (inode->i_state & I_DIRTY) {
+			/*
+			 * Someone redirtied the inode while were writing back
+			 * the pages.
+			 */
+			redirty_tail(inode);
+		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
@@ -306,12 +311,6 @@ __sync_single_inode(struct inode *inode,
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
-			 */
-			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse

