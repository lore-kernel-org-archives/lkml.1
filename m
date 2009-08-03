Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZHCV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZHCV77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZHCV76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:59:58 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60352 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZHCV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:59:57 -0400
Subject: [RFC][PATCH 1/2] pin kern mounts as writable
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 03 Aug 2009 14:59:40 -0700
Message-Id: <20090803215940.DF984602@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we are going to continue to use mnt_clone_write() inside
of init_file(), then we're going to need some kind of extra
handling.

What I want to do in the next patch is add a debugging check
in mnt_clone_write() to double-check that there *is* a real
writer on the mount before mnt_clone_write() succeeds.  To
do that, we either need to check for MS_KERNMOUNT around
that debug check, or we need to make sure that these kern
mounts *have* a write already.

I'm choosing to make sure they always have a write.

---

 linux-2.6.git-dave/fs/super.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/super.c~pin-mnt-writable fs/super.c
--- linux-2.6.git/fs/super.c~pin-mnt-writable	2009-08-03 14:47:29.000000000 -0700
+++ linux-2.6.git-dave/fs/super.c	2009-08-03 14:49:49.000000000 -0700
@@ -948,7 +948,19 @@ EXPORT_SYMBOL_GPL(do_kern_mount);
 
 struct vfsmount *kern_mount_data(struct file_system_type *type, void *data)
 {
-	return vfs_kern_mount(type, MS_KERNMOUNT, type->name, data);
+	int err = 0;
+	struct vfsmount *mnt;
+	mnt = vfs_kern_mount(type, MS_KERNMOUNT, type->name, data);
+	if (IS_ERR(mnt))
+		return mnt;
+	/*
+	 * We will never allow this mount to be r/o.  Doing
+	 * this makes it explicit and allows mnt_clone_write()
+	 * to be used unconditionally on this mount.
+	 */
+	err = mnt_want_write(mnt);
+	WARN_ON(err);
+	return mnt;
 }
 
 EXPORT_SYMBOL_GPL(kern_mount_data);
diff -puN include/linux/mount.h~pin-mnt-writable include/linux/mount.h
_
