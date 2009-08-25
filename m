Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZHYCdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZHYCdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZHYCdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:33:03 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48626 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZHYCc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fQCD/oY+HjQyQoS/xiAoapFDqTS50hZvQbWP96FVMhC3uYy2PGR7GGTbEellwAbLpM
         5FDM/A1/ioI/vmAS7I4J7slzfM8sG2J2EnNIlgfMLn8Xs8uAETbjz8fKq+TaKVX59wk4
         oMUb3IxwuBtXjoGord8oypczVj9u7iiZ7kUPA=
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
Subject: [PATCH 3/4] kill-the-bkl/reiserfs: fix recursive reiserfs write lock in reiserfs_commit_write()
Date: Tue, 25 Aug 2009 04:32:49 +0200
Message-Id: <1251167570-5233-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_commit_write() is always called with the write lock held.
Thus the current calls to reiserfs_write_lock() in this function are
acquiring the lock recursively.
We can safely drop them.

This also solves further assumptions for this lock to be really
released while calling reiserfs_write_unlock().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/inode.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 853f4f6..965c8ea 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2795,7 +2795,6 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 	 */
 	if (pos > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
-		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
 		   can have a tail, unmark it as needing a tail
 		   packing */
@@ -2806,10 +2805,9 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 			REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
 
 		ret = journal_begin(&myth, inode->i_sb, 1);
-		if (ret) {
-			reiserfs_write_unlock(inode->i_sb);
+		if (ret)
 			goto journal_error;
-		}
+
 		reiserfs_update_inode_transaction(inode);
 		inode->i_size = pos;
 		/*
@@ -2821,16 +2819,13 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 		reiserfs_update_sd(&myth, inode);
 		update_sd = 1;
 		ret = journal_end(&myth, inode->i_sb, 1);
-		reiserfs_write_unlock(inode->i_sb);
 		if (ret)
 			goto journal_error;
 	}
 	if (th) {
-		reiserfs_write_lock(inode->i_sb);
 		if (!update_sd)
 			mark_inode_dirty(inode);
 		ret = reiserfs_end_persistent_transaction(th);
-		reiserfs_write_unlock(inode->i_sb);
 		if (ret)
 			goto out;
 	}
@@ -2840,11 +2835,9 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 
       journal_error:
 	if (th) {
-		reiserfs_write_lock(inode->i_sb);
 		if (!update_sd)
 			reiserfs_update_sd(th, inode);
 		ret = reiserfs_end_persistent_transaction(th);
-		reiserfs_write_unlock(inode->i_sb);
 	}
 
 	return ret;
-- 
1.6.2.3

