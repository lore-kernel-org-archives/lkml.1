Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYJPRQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYJPRQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYJPROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:04 -0400
Received: from kroah.org ([198.145.64.141]:46918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754894AbYJPROC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/46] sysfs: crash debugging
Date: Thu, 16 Oct 2008 10:10:03 -0700
Message-Id: <1224177047-11859-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Print the name of the last-accessed sysfs file when we oops, to help track
down oopses which occur in sysfs store/read handlers.  Because these oopses
tend to not leave any trace of the offending code in the stack traces.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/dumpstack_32.c |    2 ++
 arch/x86/kernel/dumpstack_64.c |    2 ++
 fs/sysfs/file.c                |   13 +++++++++++++
 include/linux/sysfs.h          |    6 ++++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 201ee35..1a78180 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
+#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
@@ -343,6 +344,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
+	sysfs_printk_last_file();
 	if (notify_die(DIE_OOPS, str, regs, err,
 			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 086cc81..96a5db7 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
+#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
@@ -489,6 +490,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
+	sysfs_printk_last_file();
 	if (notify_die(DIE_OOPS, str, regs, err,
 			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index c9e4e50..ce8339c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -19,10 +19,18 @@
 #include <linux/poll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/limits.h>
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
 
+/* used in crash dumps to help with debugging */
+static char last_sysfs_file[PATH_MAX];
+void sysfs_printk_last_file(void)
+{
+	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
+}
+
 /*
  * There's one sysfs_buffer for each open file and one
  * sysfs_open_dirent for each sysfs_dirent with one or more open
@@ -328,6 +336,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_buffer *buffer;
 	struct sysfs_ops *ops;
 	int error = -EACCES;
+	char *p;
+
+	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
+	if (p)
+		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active_two(attr_sd))
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 37fa241..8ec406a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -119,6 +119,8 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
 
+void sysfs_printk_last_file(void);
+
 extern int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
@@ -231,6 +233,10 @@ static inline int __must_check sysfs_init(void)
 	return 0;
 }
 
+static inline void sysfs_printk_last_file(void)
+{
+}
+
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
-- 
1.6.0.2

