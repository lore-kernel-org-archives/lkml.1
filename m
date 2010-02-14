Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0BNSO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:14:57 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63452 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0BNSO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SanZARuxVuuCM4futVmTkCwHmiA9lDuVJi09DOFDexuGKGJhJWe3ZD1K7t9NykhFdW
         cYXVTh5lx1bfLaU63a0YG29Ib4sJcF8GFBl1kKo4UohWOAzWGBqi+CMnFcGWlsxdyqRp
         SbzHqUPpXTbkQmtflaApe5n3hDduzjRvn/+OE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] reiserfs fixes
Date: Sun, 14 Feb 2010 19:14:50 +0100
Message-Id: <1266171290-5960-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the reiserfs/kill-bkl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      reiserfs: Fix softlockup while waiting on an inode


 fs/reiserfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

---
commit 175359f89df39f4faed663c8cfd6ee0222d2fa1e
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Feb 11 13:13:10 2010 +0100

    reiserfs: Fix softlockup while waiting on an inode
    
    When we wait for an inode through reiserfs_iget(), we hold
    the reiserfs lock. And waiting for an inode may imply waiting
    for its writeback. But the inode writeback path may also require
    the reiserfs lock, which leads to a deadlock.
    
    We just need to release the reiserfs lock from reiserfs_iget()
    to fix this.
    
    Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Tested-by: Christian Kujau <lists@nerdbynature.de>
    Cc: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9087b10..2df0f5c 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1497,9 +1497,11 @@ struct inode *reiserfs_iget(struct super_block *s, const struct cpu_key *key)
 
 	args.objectid = key->on_disk_key.k_objectid;
 	args.dirid = key->on_disk_key.k_dir_id;
+	reiserfs_write_unlock(s);
 	inode = iget5_locked(s, key->on_disk_key.k_objectid,
 			     reiserfs_find_actor, reiserfs_init_locked_inode,
 			     (void *)(&args));
+	reiserfs_write_lock(s);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
