Return-Path: <linux-kernel-owner+w=401wt.eu-S934582AbZLGDxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbZLGDxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbZLGDxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:53:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51480 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565AbZLGDxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:53:14 -0500
Date: Mon, 07 Dec 2009 03:53:20 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 9/19] arm: add arch_mmap_check(), get rid of
 sys_arm_mremap()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUf2-0007wV-Q2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/arm/include/asm/mman.h |    3 +++
 arch/arm/kernel/calls.S     |    2 +-
 arch/arm/kernel/sys_arm.c   |   25 -------------------------
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/mman.h b/arch/arm/include/asm/mman.h
index 8eebf89..41f99c5 100644
--- a/arch/arm/include/asm/mman.h
+++ b/arch/arm/include/asm/mman.h
@@ -1 +1,4 @@
 #include <asm-generic/mman.h>
+
+#define arch_mmap_check(addr, len, flags) \
+	(((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index fafce1b..4f07168 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -172,7 +172,7 @@
 /* 160 */	CALL(sys_sched_get_priority_min)
 		CALL(sys_sched_rr_get_interval)
 		CALL(sys_nanosleep)
-		CALL(sys_arm_mremap)
+		CALL(sys_mremap)
 		CALL(sys_setresuid16)
 /* 165 */	CALL(sys_getresuid16)
 		CALL(sys_ni_syscall)		/* vm86 */
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 78ecaac..3b89744 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -28,10 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-extern unsigned long do_mremap(unsigned long addr, unsigned long old_len,
-			       unsigned long new_len, unsigned long flags,
-			       unsigned long new_addr);
-
 /* common code for old and new mmaps */
 inline long do_mmap2(
 	unsigned long addr, unsigned long len,
@@ -43,9 +39,6 @@ inline long do_mmap2(
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	if (flags & MAP_FIXED && addr < FIRST_USER_ADDRESS)
-		goto out;
-
 	error = -EBADF;
 	if (!(flags & MAP_ANONYMOUS)) {
 		file = fget(fd);
@@ -89,24 +82,6 @@ out:
 	return error;
 }
 
-asmlinkage unsigned long
-sys_arm_mremap(unsigned long addr, unsigned long old_len,
-	       unsigned long new_len, unsigned long flags,
-	       unsigned long new_addr)
-{
-	unsigned long ret = -EINVAL;
-
-	if (flags & MREMAP_FIXED && new_addr < FIRST_USER_ADDRESS)
-		goto out;
-
-	down_write(&current->mm->mmap_sem);
-	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-	up_write(&current->mm->mmap_sem);
-
-out:
-	return ret;
-}
-
 /*
  * Perform the select(nd, in, out, ex, tv) and mmap() system
  * calls.
-- 
1.5.6.5


