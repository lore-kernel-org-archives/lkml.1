Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbZFPTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbZFPTmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZFPTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:42:13 -0400
Received: from sous-sol.org ([216.99.217.87]:47056 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbZFPTmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:42:12 -0400
Date: Tue, 16 Jun 2009 12:42:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alessio Igor Bogani <abogani@texware.it>, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/super.c BKL push down fixup
Message-ID: <20090616194205.GH30071@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ sudo mount -oremount,ro /
[44126.724760] ------------[ cut here ]------------
[44126.725188] kernel BUG at lib/kernel_lock.c:126!

Commit "337eb00: Push BKL down into ->remount_fs()" does not completely
push BKL down, leaving a few stray unlock_kernel() calls behind on error
paths.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/super.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 83b4741..0b494b5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -545,24 +545,19 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb)) {
-			unlock_kernel();
+		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
-		}
+
 		retval = vfs_dq_off(sb, 1);
-		if (retval < 0 && retval != -ENOSYS) {
-			unlock_kernel();
+		if (retval < 0 && retval != -ENOSYS)
 			return -EBUSY;
-		}
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval) {
-			unlock_kernel();
+		if (retval)
 			return retval;
-		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
