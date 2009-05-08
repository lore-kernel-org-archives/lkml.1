Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZEHSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZEHSgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbZEHSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18303 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbZEHSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nd7NVud0gWWGAcosw8GJcyNRnBWeXy2f72+HGZFBH+cOmJrSR8ouXzeiBR8san1Xxq
         Mb3FvpBZj1ZLxL8p4HoGyBulhd1BKOSMNDlAFg3GNyCbGMusbirhhuUY7EhhHqYT5O3s
         3Cn9q4Blf9Dh+GFvbliy+5qm5Bo5fa03LsFq4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/7] kill-the-bkl/reiserfs: conditionaly release the write lock on fs_changed()
Date: Fri,  8 May 2009 20:35:19 +0200
Message-Id: <1241807725-6263-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of fs_changed() is to check whether the tree changed during a
schedule(). This is a BKL legacy.

A recent patch added an explicit unconditional release/reacquire of the
write lock around the cond_resched() called inside fs_changed.

But it's wasteful to unconditionally do that, we are creating superfluous
lock contention in !TIF_NEED_RESCHED case.

This patch manage that by calling reiserfs_cond_resched() from fs_changed()
which only releases the lock if we are going to reschedule.

[ Impact: inject less lock contention and tree job retries ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/reiserfs_fs.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 995bdf9..39bd4ea 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1317,9 +1317,7 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
 #define __fs_changed(gen,s) (gen != get_generation (s))
 #define fs_changed(gen,s)		\
 ({					\
-	reiserfs_write_unlock(s);	\
-	cond_resched();			\
-	reiserfs_write_lock(s);		\
+	reiserfs_cond_resched(s);	\
 	__fs_changed(gen, s);		\
 })
 
-- 
1.6.2.3

