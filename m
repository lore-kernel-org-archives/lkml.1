Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbXEJWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbXEJWi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbXEJWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:38:49 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54362 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXEJWis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:38:48 -0400
Date: Thu, 10 May 2007 18:38:43 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>, Doug Chapman <doug.chapman@hp.com>,
       Trond Myklebust <trond@netapp.com>
Subject: [PATCH] locks: fix F_GETLK regression (failure to find conflicts)
Message-ID: <20070510223843.GB13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com> <20070510193050.GQ13719@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510193050.GQ13719@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 9d6a8c5c213e34c475e72b245a8eb709258e968c we changed posix_test_lock
to modify its single file_lock argument instead of taking separate input
and output arguments.  This makes it no longer safe to set the output
lock's fl_type to F_UNLCK before looking for a conflict, since that
means searching for a conflict against a lock with type F_UNLCK.

This fixes a regression which causes F_GETLK to incorrectly report no
conflict on most filesystems (including any filesystem that doesn't do
its own locking).

Also fix posix_lock_to_flock() to copy the lock type.  This isn't
strictly necessary, since the caller already does this; but it seems
less likely to cause confusion in the future.

Thanks to Doug Chapman for the bug report.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/locks.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 671a034..8ec16ab 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -669,7 +669,6 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 
-	fl->fl_type = F_UNLCK;
 	lock_kernel();
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
@@ -681,7 +680,8 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 		__locks_copy_lock(fl, cfl);
 		unlock_kernel();
 		return 1;
-	}
+	} else
+		fl->fl_type = F_UNLCK;
 	unlock_kernel();
 	return 0;
 }
@@ -1632,6 +1632,7 @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
 		fl->fl_end - fl->fl_start + 1;
 	flock->l_whence = 0;
+	flock->l_type = fl->fl_type;
 	return 0;
 }
 
-- 
1.5.1.1.107.g7a159

