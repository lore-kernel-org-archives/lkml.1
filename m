Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYJQMud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYJQMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYJQMtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:49:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:1866 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbYJQMtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UDZniBN7A5wmwsbLWtW3feulDO3rtEiIXLrnPsSrJCAx2EcwVJ+0fOPMb7/yLxH+SA
         X9eT2jtHppVizWG4MYnjpIH4v6JEEFUW5ImrdaeQG1D1kpcdxPBoNCErlRR+19WFLJRr
         WD/nBtsN/tbSP1gOaOAsODt2kuK+BgJWIR8yk=
Date: Fri, 17 Oct 2008 16:52:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au
Subject: [PATCH 26/31] proc: move /proc/modules boilerplate to
	kernel/module.c
Message-ID: <20081017125235.GA22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From ef4a360b6157d71825846f4853c2eee0c2cf27cb Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 13:19:27 +0400
Subject: [PATCH 26/31] proc: move /proc/modules boilerplate to kernel/module.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c |   17 --------------
 kernel/module.c     |   59 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 67b02ee..429376e 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,20 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-#ifdef CONFIG_MODULES
-extern const struct seq_operations modules_op;
-static int modules_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &modules_op);
-}
-static const struct file_operations proc_modules_operations = {
-	.open		= modules_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-#endif
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -208,9 +194,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_MODULES
-	proc_create("modules", 0, NULL, &proc_modules_operations);
-#endif
 #ifdef CONFIG_SCHEDSTATS
 	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index b7205f6..74d5008 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -20,11 +20,13 @@
 #include <linux/moduleloader.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
@@ -2558,23 +2560,6 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 }
 #endif /* CONFIG_KALLSYMS */
 
-/* Called by the /proc file system to return a list of modules. */
-static void *m_start(struct seq_file *m, loff_t *pos)
-{
-	mutex_lock(&module_mutex);
-	return seq_list_start(&modules, *pos);
-}
-
-static void *m_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	return seq_list_next(p, &modules, pos);
-}
-
-static void m_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&module_mutex);
-}
-
 static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
@@ -2606,6 +2591,24 @@ static char *module_flags(struct module *mod, char *buf)
 	return buf;
 }
 
+#ifdef CONFIG_PROC_FS
+/* Called by the /proc file system to return a list of modules. */
+static void *m_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&module_mutex);
+	return seq_list_start(&modules, *pos);
+}
+
+static void *m_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	return seq_list_next(p, &modules, pos);
+}
+
+static void m_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&module_mutex);
+}
+
 static int m_show(struct seq_file *m, void *p)
 {
 	struct module *mod = list_entry(p, struct module, list);
@@ -2636,13 +2639,33 @@ static int m_show(struct seq_file *m, void *p)
    Where refcount is a number or -, and deps is a comma-separated list
    of depends or -.
 */
-const struct seq_operations modules_op = {
+static const struct seq_operations modules_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
 	.show	= m_show
 };
 
+static int modules_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &modules_op);
+}
+
+static const struct file_operations proc_modules_operations = {
+	.open		= modules_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_modules_init(void)
+{
+	proc_create("modules", 0, NULL, &proc_modules_operations);
+	return 0;
+}
+module_init(proc_modules_init);
+#endif
+
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {
-- 
1.5.6.5

