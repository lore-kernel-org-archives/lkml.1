Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZFBOhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZFBOhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZFBOhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:37:03 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:15832
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752333AbZFBOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:37:02 -0400
X-SpamScore: 13
X-BigFish: VPS13(zz9321rzz1202hzzz32i17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KKM8LE-03-J7A-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] dma-debug: add debugfs file for driver filter
Date: Tue, 2 Jun 2009 16:36:42 +0200
Message-ID: <1243953404-31799-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
References: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Jun 2009 14:36:48.0047 (UTC) FILETIME=[8F482BF0:01C9E38F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dma-api/driver_filter file to debugfs. The root user
can write a driver name into this file to see only dma-api errors for
that particular driver in the kernel log. Writing an empty string to
that file disables the driver filter.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 101 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index c01f647..c6330b1 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -23,9 +23,11 @@
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -98,6 +100,7 @@ static struct dentry *show_all_errors_dent  __read_mostly;
 static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
+static struct dentry *filter_dent           __read_mostly;
 
 /* per-driver filter related state */
 
@@ -160,7 +163,8 @@ static bool driver_filter(struct device *dev)
 		read_lock_irqsave(&driver_name_lock, flags);
 
 		if (drv->name &&
-		    strncmp(current_driver_name, drv->name, 63) == 0) {
+		    strncmp(current_driver_name, drv->name,
+			    NAME_MAX_LEN-1) == 0) {
 			current_driver = drv;
 			ret = true;
 		}
@@ -454,6 +458,97 @@ out_err:
 	return -ENOMEM;
 }
 
+static ssize_t filter_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	unsigned long flags;
+	char buf[NAME_MAX_LEN + 1];
+	int len;
+
+	if (!current_driver_name[0])
+		return 0;
+
+	/*
+	 * We can't copy to userspace directly because current_driver_name can
+	 * only be read under the driver_name_lock with irqs disabled. So
+	 * create a temporary copy first.
+	 */
+	read_lock_irqsave(&driver_name_lock, flags);
+	len = scnprintf(buf, NAME_MAX_LEN + 1, "%s\n", current_driver_name);
+	read_unlock_irqrestore(&driver_name_lock, flags);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t filter_write(struct file *file, const char __user *userbuf,
+			    size_t count, loff_t *ppos)
+{
+	unsigned long flags;
+	char buf[NAME_MAX_LEN];
+	size_t len = NAME_MAX_LEN - 1;
+	int i;
+
+	/*
+	 * We can't copy from userspace directly. Access to
+	 * current_driver_name is protected with a write_lock with irqs
+	 * disabled. Since copy_from_user can fault and may sleep we
+	 * need to copy to temporary buffer first
+	 */
+	len = min(count, len);
+	if (copy_from_user(buf, userbuf, len))
+		return -EFAULT;
+
+	buf[len] = 0;
+
+	write_lock_irqsave(&driver_name_lock, flags);
+
+	/* Now handle the string we got from userspace very carefully.
+	 * The rules are:
+	 *         - only use the first token we got
+	 *         - token delimiter is everything looking like a space
+	 *           character (' ', '\n', '\t' ...)
+	 *
+	 */
+	if (!isalnum(buf[0])) {
+		/*
+		   If the first character userspace gave us is not
+		 * alphanumerical then assume the filter should be
+		 * switched off.
+		 */
+		if (current_driver_name[0])
+			printk(KERN_INFO "DMA-API: switching off dma-debug "
+					 "driver filter\n");
+		current_driver_name[0] = 0;
+		current_driver = NULL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Now parse out the first token and use it as the name for the
+	 * driver to filter for.
+	 */
+	for (i = 0; i < NAME_MAX_LEN; ++i) {
+		current_driver_name[i] = buf[i];
+		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
+			break;
+	}
+	current_driver_name[i] = 0;
+	current_driver = NULL;
+
+	printk(KERN_INFO "DMA-API: enable driver filter for driver [%s]\n",
+	       current_driver_name);
+
+out_unlock:
+	write_unlock_irqrestore(&driver_name_lock, flags);
+
+	return count;
+}
+
+const struct file_operations filter_fops = {
+	.read  = filter_read,
+	.write = filter_write,
+};
+
 static int dma_debug_fs_init(void)
 {
 	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
@@ -497,6 +592,11 @@ static int dma_debug_fs_init(void)
 	if (!min_free_entries_dent)
 		goto out_err;
 
+	filter_dent = debugfs_create_file("driver_filter", 0644,
+					  dma_debug_dent, NULL, &filter_fops);
+	if (!filter_dent)
+		goto out_err;
+
 	return 0;
 
 out_err:
-- 
1.6.3.1


