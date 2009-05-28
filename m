Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZE1PVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZE1PVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZE1PUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:20:53 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:20862
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758840AbZE1PUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:20:50 -0400
X-BigFish: VPS13(zz9321rzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KKD1AC-02-Y9U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] dma-debug: add debugfs file for driver filter
Date: Thu, 28 May 2009 17:19:29 +0200
Message-ID: <1243523971-12681-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 May 2009 15:19:34.0404 (UTC) FILETIME=[B4E26C40:01C9DFA7]
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
 lib/dma-debug.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index e953270..65043c7 100644
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
 
@@ -160,7 +163,8 @@ static inline bool driver_filter(struct device *dev)
 		read_lock_irqsave(&driver_name_lock, flags);
 
 		if (drv->name &&
-		    strncmp(current_driver_name, drv->name, 63) == 0) {
+		    strncmp(current_driver_name, drv->name,
+			    NAME_MAX_LEN-1) == 0) {
 			current_driver = drv;
 			ret = true;
 		}
@@ -454,6 +458,86 @@ out_err:
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
+	strncpy(buf, current_driver_name, NAME_MAX_LEN - 1);
+	read_unlock_irqrestore(&driver_name_lock, flags);
+
+	/* make it look nice :-) */
+	len = strnlen(buf, NAME_MAX_LEN - 1);
+	buf[len]     = '\n';
+	buf[len + 1] = 0;
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len + 1);
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
+	buf[NAME_MAX_LEN - 1] = 0;
+
+	write_lock_irqsave(&driver_name_lock, flags);
+	if (!isalnum(buf[0])) {
+		if (current_driver_name[0])
+			printk(KERN_INFO "DMA-API: switching off dma-debug "
+					 "driver filter\n");
+		current_driver_name[0] = 0;
+		current_driver = NULL;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < NAME_MAX_LEN; ++i) {
+		current_driver_name[i] = buf[i];
+		if (isspace(buf[i]) || buf[i] == ' ' ||
+		    buf[i] == '\t' || buf[i] == 0)
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
@@ -497,6 +581,11 @@ static int dma_debug_fs_init(void)
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


