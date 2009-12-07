Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbZLGDxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbZLGDxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZLGDxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:53:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934494AbZLGDxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:53:04 -0500
Date: Mon, 07 Dec 2009 03:53:10 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 8/19] file ->get_unmapped_area() shouldn't duplicate work
 of get_unmapped_area()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUes-0007wJ-Pn@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... we should call mm ->get_unmapped_area() instead and let our caller
do the final checks.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/sys_sparc_64.c |   10 +++++++---
 ipc/shm.c                        |   31 +++++++++++++++++--------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ddda12f..d498b32 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -317,10 +317,14 @@ bottomup:
 unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	unsigned long align_goal, addr = -ENOMEM;
+	unsigned long (*get_area)(struct file *, unsigned long,
+				  unsigned long, unsigned long, unsigned long);
+
+	get_area = current->mm->get_unmapped_area;
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		return get_area(NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -333,7 +337,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = get_unmapped_area(NULL, orig_addr, len + (align_goal - PAGE_SIZE), pgoff, flags);
+		addr = get_area(NULL, orig_addr, len + (align_goal - PAGE_SIZE), pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
 			break;
@@ -351,7 +355,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
+		addr = get_area(NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
diff --git a/ipc/shm.c b/ipc/shm.c
index 464694e..11bec62 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -290,28 +290,28 @@ static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
-	return get_unmapped_area(sfd->file, addr, len, pgoff, flags);
-}
-
-int is_file_shm_hugepages(struct file *file)
-{
-	int ret = 0;
-
-	if (file->f_op == &shm_file_operations) {
-		struct shm_file_data *sfd;
-		sfd = shm_file_data(file);
-		ret = is_file_hugepages(sfd->file);
-	}
-	return ret;
+	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len,
+						pgoff, flags);
 }
 
 static const struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
 	.fsync		= shm_fsync,
 	.release	= shm_release,
+};
+
+static const struct file_operations shm_file_operations_huge = {
+	.mmap		= shm_mmap,
+	.fsync		= shm_fsync,
+	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 };
 
+int is_file_shm_hugepages(struct file *file)
+{
+	return file->f_op == &shm_file_operations_huge;
+}
+
 static const struct vm_operations_struct shm_vm_ops = {
 	.open	= shm_open,	/* callback for a new vm-area open */
 	.close	= shm_close,	/* callback for when the vm-area is released */
@@ -889,7 +889,10 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	if (!sfd)
 		goto out_put_dentry;
 
-	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
+	file = alloc_file(path.mnt, path.dentry, f_mode,
+			is_file_hugepages(shp->shm_file) ?
+				&shm_file_operations_huge :
+				&shm_file_operations);
 	if (!file)
 		goto out_free;
 	ima_counts_get(file);
-- 
1.5.6.5


