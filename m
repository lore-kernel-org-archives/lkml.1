Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZDYEjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZDYEjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZDYEjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:39:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZDYEjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:39:43 -0400
Date: Sat, 25 Apr 2009 00:39:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@kroah.com
Subject: [PATCH][RFC] debugfs: dont stop on first failed recursive delete
Message-ID: <alpine.DEB.2.00.0904250037570.24293@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/debugfs


Steven Rostedt (1):
      debugfs: dont stop on first failed recursive delete

----
 fs/debugfs/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
---------------------------
commit 2f1680c7a8a9e974ad22b4b145ef7724a76d0e1f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Apr 25 00:26:51 2009 -0400

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
    
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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

