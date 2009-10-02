Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbZJBB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbZJBB7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZJBBck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:40 -0400
Received: from kroah.org ([198.145.64.141]:32934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbZJBBci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:08 2009
Message-Id: <20091002012408.452341191@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Subject: [018/136] fs: make sure data stored into inode is properly seen before unlocking new inode
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Kara <jack@suse.cz>

commit 580be0837a7a59b207c3d5c661d044d8dd0a6a30 upstream.

In theory it could happen that on one CPU we initialize a new inode but
clearing of I_NEW | I_LOCK gets reordered before some of the
initialization.  Thus on another CPU we return not fully uptodate inode
from iget_locked().

This seems to fix a corruption issue on ext3 mounted over NFS.

[akpm@linux-foundation.org: add some commentary]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -695,13 +695,15 @@ void unlock_new_inode(struct inode *inode)
 	}
 #endif
 	/*
-	 * This is special!  We do not need the spinlock
-	 * when clearing I_LOCK, because we're guaranteed
-	 * that nobody else tries to do anything about the
-	 * state of the inode when it is locked, as we
-	 * just created it (so there can be no old holders
-	 * that haven't tested I_LOCK).
+	 * This is special!  We do not need the spinlock when clearing I_LOCK,
+	 * because we're guaranteed that nobody else tries to do anything about
+	 * the state of the inode when it is locked, as we just created it (so
+	 * there can be no old holders that haven't tested I_LOCK).
+	 * However we must emit the memory barrier so that other CPUs reliably
+	 * see the clearing of I_LOCK after the other inode initialisation has
+	 * completed.
 	 */
+	smp_mb();
 	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
 	inode->i_state &= ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);


