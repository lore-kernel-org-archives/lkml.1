Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZEACpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZEACpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZEACo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:44:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:28508 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZEACo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P7yZQ73XER3xO5TryrRtVU34z3pMzlirbrr5kCLEhJO8zH6W2n6POWyKdTte55mO2v
         bzlxwB5P9247UXTh5dxZtT0vxGRwqOqGiZmMjX4LExz8HNMNCOzyY4Xg+LPfSmldzBg5
         UNHcpCsd/j40MJSS+jKKLLDv9SjMrMdEXMTH0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/6] kill-the-BKL/reiserfs: release write lock on fs_changed()
Date: Fri,  1 May 2009 04:44:17 +0200
Message-Id: <1241145862-21700-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs_changed() is a macro used by reiserfs to check whether its tree has been
rebalanced. It has been designed to check parallel changes on the tree after
calling a sleeping function, which released the Bkl.

fs_changed() also calls cond_resched(), so that if rescheduling is needed,
we are in the best place to do that, since we check if the tree has changed
just after (because of the bkl release on schedule()).

Even if we are not anymore using the Bkl, we still want to release the lock
while we reschedule, so that other waiters for the lock can acquire it safely,
because of the following __fs_changed() check.

[ Impact: release the reiserfs write lock when it is not needed ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/reiserfs_fs.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 6587b4e..397d281 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1302,7 +1302,13 @@ static inline loff_t max_reiserfs_offset(struct inode *inode)
 #define get_generation(s) atomic_read (&fs_generation(s))
 #define FILESYSTEM_CHANGED_TB(tb)  (get_generation((tb)->tb_sb) != (tb)->fs_gen)
 #define __fs_changed(gen,s) (gen != get_generation (s))
-#define fs_changed(gen,s) ({cond_resched(); __fs_changed(gen, s);})
+#define fs_changed(gen,s)		\
+({					\
+	reiserfs_write_unlock(s);	\
+	cond_resched();			\
+	reiserfs_write_lock(s);		\
+	__fs_changed(gen, s);		\
+})
 
 /***************************************************************************/
 /*                  FIXATE NODES                                           */
-- 
1.6.2.3

