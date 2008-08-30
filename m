Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYH3F0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYH3F0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYH3F0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:26:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:28954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYH3F0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gSk9vIRY+wWyJAU3I1bLXIEB7VNFZFJ86yA2n/aa7WsE2rME61d+BrgrheBudTNmYL
         y8pqFCLTiG/MAenbPpSkHE6262En7RRdAHh/HImueWmxrpbhYm3aobHgmyrfSXWegdqJ
         ETAC2bSK4hy5MW8MPwgvTE4GmdCo5MNj7F8gE=
Date: Sat, 30 Aug 2008 09:28:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: move sysrq-trigger out of fs/proc/
Message-ID: <20080830052815.GA25179@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/sysrq.c |   30 ++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c  |   26 --------------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -23,6 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/sysrq.h>
 #include <linux/kbd_kern.h>
+#include <linux/proc_fs.h>
 #include <linux/quotaops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -533,3 +534,32 @@ int unregister_sysrq_key(int key, struct sysrq_key_op *op_p)
 	return __sysrq_swap_key_ops(key, NULL, op_p);
 }
 EXPORT_SYMBOL(unregister_sysrq_key);
+
+#ifdef CONFIG_PROC_FS
+/*
+ * writing 'C' to /proc/sysrq-trigger is like sysrq-C
+ */
+static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	if (count) {
+		char c;
+
+		if (get_user(c, buf))
+			return -EFAULT;
+		__handle_sysrq(c, NULL, 0);
+	}
+	return count;
+}
+
+static const struct file_operations proc_sysrq_trigger_operations = {
+	.write		= write_sysrq_trigger,
+};
+
+static int __init sysrq_init(void)
+{
+	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
+	return 0;
+}
+module_init(sysrq_init);
+#endif
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -45,7 +45,6 @@
 #include <linux/blkdev.h>
 #include <linux/hugetlb.h>
 #include <linux/jiffies.h>
-#include <linux/sysrq.h>
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
@@ -732,28 +731,6 @@ static int execdomains_read_proc(char *page, char **start, off_t off,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
-#ifdef CONFIG_MAGIC_SYSRQ
-/*
- * writing 'C' to /proc/sysrq-trigger is like sysrq-C
- */
-static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
-				   size_t count, loff_t *ppos)
-{
-	if (count) {
-		char c;
-
-		if (get_user(c, buf))
-			return -EFAULT;
-		__handle_sysrq(c, NULL, 0);
-	}
-	return count;
-}
-
-static const struct file_operations proc_sysrq_trigger_operations = {
-	.write		= write_sysrq_trigger,
-};
-#endif
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -962,7 +939,4 @@ void __init proc_misc_init(void)
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 #endif
-#ifdef CONFIG_MAGIC_SYSRQ
-	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
-#endif
 }

