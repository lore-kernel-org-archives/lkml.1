Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbZGAArj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbZGAArj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbZGAAeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:08 -0400
Received: from kroah.org ([198.145.64.141]:60020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761336AbZGAAeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:12 2009
Message-Id: <20090701002411.695417787@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 002/108] fs: remove incorrect I_NEW warnings
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=fs-remove-incorrect-i_new-warnings.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 545b9fd3d737afc0bb5203b1e79194a471605acd upstream.

Some filesystems can call in to sync an inode that is still in the
I_NEW state (eg. ext family, when mounted with -osync). This is OK
because the filesystem has sole access to the new inode, so it can
modify i_state without races (because no other thread should be
modifying it, by definition of I_NEW). Ie. a false positive, so
remove the warnings.

The races are described here 7ef0d7377cb287e08f3ae94cebc919448e1f5dff,
which is also where the warnings were introduced.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -289,7 +289,6 @@ __sync_single_inode(struct inode *inode,
 	int ret;
 
 	BUG_ON(inode->i_state & I_SYNC);
-	WARN_ON(inode->i_state & I_NEW);
 
 	/* Set I_SYNC, reset I_DIRTY */
 	dirty = inode->i_state & I_DIRTY;
@@ -314,7 +313,6 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
-	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&


