Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZIHU0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZIHU0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIHU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:26:08 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:56785 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbZIHU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:26:07 -0400
X-Trace: 256333878/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.33.172/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.33.172
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEALhapkpPRSGs/2dsb2JhbACBU45kAc44hBgF
X-IronPort-AV: E=Sophos;i="4.44,354,1249254000"; 
   d="scan'208";a="256333878"
Date: Tue, 8 Sep 2009 21:25:11 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: depend on shmem
Message-ID: <Pine.LNX.4.64.0909082111400.11481@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SHMEM off gives you (ramfs masquerading as) tmpfs, even when
CONFIG_TMPFS is off: that's a little anomalous, and I'd intended to
make more sense of it by removing CONFIG_TMPFS altogether, always
enabling its code when CONFIG_SHMEM; but so many defconfigs have
CONFIG_SHMEM on CONFIG_TMPFS off that we'd better leave that as is.

But there is no point in asking for CONFIG_TMPFS if CONFIG_SHMEM is
off: make TMPFS depend on SHMEM, which also prevents TMPFS_POSIX_ACL
shmem_acl.o being pointlessly built into the kernel when SHMEM is off.

And a selfish change, to prevent the world from being rebuilt when I
switch between CONFIG_SHMEM on and off: the only CONFIG_SHMEM in the
header files is mm.h shmem_lock() - give that a shmem.c stub instead.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 fs/Kconfig         |    1 +
 include/linux/mm.h |   11 +----------
 mm/shmem.c         |    5 +++++
 3 files changed, 7 insertions(+), 10 deletions(-)

--- mmotm/fs/Kconfig	2009-09-05 14:40:15.000000000 +0100
+++ linux/fs/Kconfig	2009-09-08 16:37:54.000000000 +0100
@@ -110,6 +110,7 @@ source "fs/sysfs/Kconfig"
 
 config TMPFS
 	bool "Virtual memory file system support (former shm fs)"
+	depends on SHMEM
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.
 
--- mmotm/include/linux/mm.h	2009-09-05 14:40:16.000000000 +0100
+++ linux/include/linux/mm.h	2009-09-08 16:37:54.000000000 +0100
@@ -711,17 +711,8 @@ extern void pagefault_out_of_memory(void
 
 extern void show_free_areas(void);
 
-#ifdef CONFIG_SHMEM
-extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
-#else
-static inline int shmem_lock(struct file *file, int lock,
-			    struct user_struct *user)
-{
-	return 0;
-}
-#endif
+int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
-
 int shmem_zero_setup(struct vm_area_struct *);
 
 #ifndef CONFIG_MMU
--- mmotm/mm/shmem.c	2009-09-05 14:40:16.000000000 +0100
+++ linux/mm/shmem.c	2009-09-08 16:37:54.000000000 +0100
@@ -2596,6 +2596,11 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
+int shmem_lock(struct file *file, int lock, struct user_struct *user)
+{
+	return 0;
+}
+
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
