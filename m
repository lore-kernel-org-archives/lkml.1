Return-Path: <linux-kernel-owner+w=401wt.eu-S936116AbZFPFxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936116AbZFPFxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbZFPFu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:57 -0400
Received: from kroah.org ([198.145.64.141]:48307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870AbZFPFu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/64] debugfs: dont stop on first failed recursive delete
Date: Mon, 15 Jun 2009 22:45:57 -0700
Message-Id: <1245131213-24168-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

debugfs: dont stop on first failed recursive delete

While running a while loop of removing a module that removes a debugfs
directory with debugfs_remove_recursive, and at the same time doing a
while loop of cat of a file in that directory, I would hit a point where
somehow the cat of the file caused the remove to fail.

The result is that other files did not get removed when the module
was removed. I simple read of one of those file can oops the kernel
because the operations to the file no longer exist (removed by module).

The funny thing is that the file being cat'ed was removed. It was
the siblings that were not. I see in the code to debugfs_remove_recursive
there's a test that checks if the child fails to bail out of the loop
to prevent an infinite loop.

What this patch does is to still try any siblings in that directory.
If all the siblings fail, or there are no more siblings, then we exit
the loop.

This fixes the above symptom, but...

This is no full proof. It makes the debugfs_remove_recursive a bit more
robust, but it does not explain why the one file failed. There may
be some kind of delay deletion that makes the debugfs think it did
not succeed. So this patch is more of a fix for the symptom but not
the disease.

This patch still makes the debugfs_remove_recursive more robust and
until I can find out why the bug exists, this patch will keep
the kernel from oopsing in most cases.  Even after the cause is found
I think this change can stand on its own and should be kept.

[ Impact: prevent kernel oops on module unload and reading debugfs files ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 0662ba6..d22438e 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -403,6 +403,7 @@ void debugfs_remove_recursive(struct dentry *dentry)
 		}
 		child = list_entry(parent->d_subdirs.next, struct dentry,
 				d_u.d_child);
+ next_sibling:
 
 		/*
 		 * If "child" isn't empty, walk down the tree and
@@ -417,6 +418,16 @@ void debugfs_remove_recursive(struct dentry *dentry)
 		__debugfs_remove(child, parent);
 		if (parent->d_subdirs.next == &child->d_u.d_child) {
 			/*
+			 * Try the next sibling.
+			 */
+			if (child->d_u.d_child.next != &parent->d_subdirs) {
+				child = list_entry(child->d_u.d_child.next,
+						   struct dentry,
+						   d_u.d_child);
+				goto next_sibling;
+			}
+
+			/*
 			 * Avoid infinite loop if we fail to remove
 			 * one dentry.
 			 */
-- 
1.6.3.2

