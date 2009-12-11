Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbZLKEvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbZLKEvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbZLKEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:51:13 -0500
Received: from kroah.org ([198.145.64.141]:36922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980AbZLKEgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:14 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:59 2009
Message-Id: <20091211042758.666491884@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [47/90] ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0047-ext4-Make-sure-ext4_dirty_inode-updates-the-inode-in.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit f3dc272fd5e2ae08244796bb39e7e1ce4b25d3b3)

This patch a problem that ext4_dirty_inode() was not calling
ext4_mark_inode_dirty() if the current_handle is not valid, which it
is the case in no journal mode.

It also removes a test for non-matching transaction which can never
happen.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5605,24 +5605,13 @@ void ext4_dirty_inode(struct inode *inod
 	handle_t *current_handle = ext4_journal_current_handle();
 	handle_t *handle;
 
-	if (!ext4_handle_valid(current_handle)) {
-		ext4_mark_inode_dirty(current_handle, inode);
-		return;
-	}
-
 	handle = ext4_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
-	if (current_handle &&
-		current_handle->h_transaction != handle->h_transaction) {
-		/* This task has a transaction open against a different fs */
-		printk(KERN_EMERG "%s: transactions do not match!\n",
-		       __func__);
-	} else {
-		jbd_debug(5, "marking dirty.  outer handle=%p\n",
-				current_handle);
-		ext4_mark_inode_dirty(handle, inode);
-	}
+
+	jbd_debug(5, "marking dirty.  outer handle=%p\n", current_handle);
+	ext4_mark_inode_dirty(handle, inode);
+
 	ext4_journal_stop(handle);
 out:
 	return;


