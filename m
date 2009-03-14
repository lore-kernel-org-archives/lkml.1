Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZCNPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZCNPCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZCNPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:02:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:56116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZCNPCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:02:21 -0400
Subject: [PATCH -tip] x86: kdebugfs.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:31:57 +0530
Message-Id: <1237042917.4546.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: kdebugfs.c cleanup

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/kdebugfs.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index ff7d3b0..3d292f0 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -8,11 +8,11 @@
  */
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
-#include <linux/stat.h>
+#include <linux/module.h>
 #include <linux/init.h>
+#include <linux/stat.h>
 #include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/module.h>
 
 #include <asm/setup.h>
 
@@ -26,9 +26,8 @@ struct setup_data_node {
 	u32 len;
 };
 
-static ssize_t
-setup_data_read(struct file *file, char __user *user_buf, size_t count,
-		loff_t *ppos)
+static ssize_t setup_data_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
 {
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
@@ -39,20 +38,21 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 
 	if (pos < 0)
 		return -EINVAL;
+
 	if (pos >= node->len)
 		return 0;
 
 	if (count > node->len - pos)
 		count = node->len - pos;
+
 	pa = node->paddr + sizeof(struct setup_data) + pos;
 	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
 	if (PageHighMem(pg)) {
 		p = ioremap_cache(pa, count);
 		if (!p)
 			return -ENXIO;
-	} else {
+	} else
 		p = __va(pa);
-	}
 
 	remain = copy_to_user(user_buf, p, count);
 
@@ -70,12 +70,13 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 static int setup_data_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
+
 	return 0;
 }
 
 static const struct file_operations fops_setup_data = {
-	.read =		setup_data_read,
-	.open =		setup_data_open,
+	.read		= setup_data_read,
+	.open		= setup_data_open,
 };
 
 static int __init
@@ -92,16 +93,19 @@ create_setup_data_node(struct dentry *parent, int no,
 		error = -ENOMEM;
 		goto err_return;
 	}
+
 	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
 	if (!type) {
 		error = -ENOMEM;
 		goto err_dir;
 	}
+
 	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
 	if (!data) {
 		error = -ENOMEM;
 		goto err_type;
 	}
+
 	return 0;
 
 err_type:
@@ -135,6 +139,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			error = -ENOMEM;
 			goto err_dir;
 		}
+
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
 		if (PageHighMem(pg)) {
 			data = ioremap_cache(pa_data, sizeof(*data));
@@ -143,9 +148,8 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 				error = -ENXIO;
 				goto err_dir;
 			}
-		} else {
+		} else
 			data = __va(pa_data);
-		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -155,10 +159,13 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 
 		if (PageHighMem(pg))
 			iounmap(data);
+
 		if (error)
 			goto err_dir;
+
 		no++;
 	}
+
 	return 0;
 
 err_dir:
@@ -182,21 +189,25 @@ static int __init boot_params_kdebugfs_init(void)
 		error = -ENOMEM;
 		goto err_return;
 	}
+
 	version = debugfs_create_x16("version", S_IRUGO, dbp,
 				     &boot_params.hdr.version);
 	if (!version) {
 		error = -ENOMEM;
 		goto err_dir;
 	}
+
 	data = debugfs_create_blob("data", S_IRUGO, dbp,
 				   &boot_params_blob);
 	if (!data) {
 		error = -ENOMEM;
 		goto err_version;
 	}
+
 	error = create_setup_data_nodes(dbp);
 	if (error)
 		goto err_data;
+
 	return 0;
 
 err_data:
@@ -208,7 +219,7 @@ err_dir:
 err_return:
 	return error;
 }
-#endif
+#endif /* CONFIG_DEBUG_BOOT_PARAMS */
 
 static int __init arch_kdebugfs_init(void)
 {
-- 
1.6.0.6



