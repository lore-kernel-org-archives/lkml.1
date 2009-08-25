Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZHYCdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZHYCdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZHYCdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:33:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41395 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbZHYCc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I/qZ++IGh/UA5mcoIumRp1zLS501T8WcAjaDScOj51V5BcsFtrinICUPExBoUVT9cQ
         dZ1133+XPHVX1O+VC1d4iRPW5Dp2fTccchLqcK37F7TvbHvowwiRr4z9SRMgccSz4hCy
         ZwokmhOaDXhxj80NrlI42Dxy8PeevKei3fgAg=
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH 2/4] kill-the-bkl/reiserfs: fix recursive reiserfs lock in reiserfs_mkdir()
Date: Tue, 25 Aug 2009 04:32:48 +0200
Message-Id: <1251167570-5233-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_mkdir() acquires the reiserfs lock, assuming it has been called
from the dir inodes callbacks, without the lock held.

But it can also be called from other internal sites such as
reiserfs_xattr_init() which already holds the lock. This recursive
locking leads to further wrong assumptions. For example, later calls
to reiserfs_mutex_lock_safe() won't actually unlock the reiserfs lock
the time we acquire a given mutex, creating unexpected lock inversions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/namei.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b3973c9..e296ff7 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -732,6 +732,7 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct inode *inode;
 	struct reiserfs_transaction_handle th;
 	struct reiserfs_security_handle security;
+	int lock_depth;
 	/* We need blocks for transaction + (user+group)*(quotas for new inode + update of quota for directory owner) */
 	int jbegin_count =
 	    JOURNAL_PER_BALANCE_CNT * 3 +
@@ -755,7 +756,7 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return retval;
 	}
 	jbegin_count += retval;
-	reiserfs_write_lock(dir->i_sb);
+	lock_depth = reiserfs_write_lock_once(dir->i_sb);
 
 	retval = journal_begin(&th, dir->i_sb, jbegin_count);
 	if (retval) {
@@ -805,8 +806,8 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
-      out_failed:
-	reiserfs_write_unlock(dir->i_sb);
+out_failed:
+	reiserfs_write_unlock_once(dir->i_sb, lock_depth);
 	return retval;
 }
 
-- 
1.6.2.3

