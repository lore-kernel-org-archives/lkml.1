Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYC0HIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYC0HIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYC0HIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:08:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:55253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYC0HIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:08:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="223795467"
Subject: [PATCH -mm 3/4] x86_64 boot: export linked list of struct
	setup_data via debugfs
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2008 15:09:10 +0800
Message-Id: <1206601750.3067.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 27 Mar 2008 07:06:10.0187 (UTC) FILETIME=[090225B0:01C88FD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export linked list of struct setup_data via debugfs.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/kdebugfs.c |  139 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c |    2 
 2 files changed, 141 insertions(+)

--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -10,10 +10,144 @@
 #include <linux/debugfs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
 
 #include <asm/setup.h>
 
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
+struct setup_data_node {
+	u64 paddr;
+	u32 type;
+	u32 len;
+};
+
+static ssize_t setup_data_read(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct setup_data_node *node = file->private_data;
+	loff_t pos = *ppos;
+	unsigned long remain;
+	struct page *pg;
+	void *p;
+	u64 pa;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= node->len)
+		return 0;
+	if (count > node->len - pos)
+		count = node->len - pos;
+	pa = node->paddr + sizeof(struct setup_data) + pos;
+	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
+	if (PageHighMem(pg)) {
+		p = ioremap_cache(pa, count);
+		if (!p)
+			return -ENXIO;
+	} else
+		p = __va(pa);
+	remain = copy_to_user(user_buf, p, count);
+	if (PageHighMem(pg))
+		iounmap(p);
+	if (remain)
+		return -EFAULT;
+	*ppos = pos + count;
+	return count;
+}
+
+static int setup_data_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations fops_setup_data = {
+	.read =		setup_data_read,
+	.open =		setup_data_open,
+};
+
+static int __init create_setup_data_node(struct dentry *parent,
+					 int no,
+					 struct setup_data_node *node)
+{
+	int error;
+	struct dentry *d, *type, *data;
+	char buf[16];
+
+	sprintf(buf, "%d", no);
+	d = debugfs_create_dir(buf, parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
+	if (!type) {
+		error = -ENOMEM;
+		goto err_dir;
+	}
+	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_type;
+	}
+	return 0;
+err_type:
+	debugfs_remove(type);
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
+static int __init create_setup_data_nodes(struct dentry *parent)
+{
+	int error, no = 0;
+	struct dentry *d;
+	struct setup_data *data;
+	u64 pa_data;
+	struct page *pg;
+	struct setup_data_node *node;
+
+	d = debugfs_create_dir("setup_data", parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		if (!node) {
+			error = -ENOMEM;
+			goto err_dir;
+		}
+		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
+		if (PageHighMem(pg)) {
+			data = ioremap_cache(pa_data, sizeof(*data));
+			if (!data) {
+				error = -ENXIO;
+				goto err_dir;
+			}
+		} else
+			data = __va(pa_data);
+		node->paddr = pa_data;
+		node->type = data->type;
+		node->len = data->len;
+		error = create_setup_data_node(d, no, node);
+		pa_data = data->next;
+		if (PageHighMem(pg))
+			iounmap(data);
+		if (error)
+			goto err_dir;
+		no++;
+	}
+	return 0;
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
 static struct debugfs_blob_wrapper boot_params_blob = {
 	.data = &boot_params,
 	.size = sizeof(boot_params),
@@ -41,7 +175,12 @@ static int __init boot_params_kdebugfs_i
 		error = -ENOMEM;
 		goto err_version;
 	}
+	error = create_setup_data_nodes(dbp);
+	if (error)
+		goto err_data;
 	return 0;
+err_data:
+	debugfs_remove(data);
 err_version:
 	debugfs_remove(version);
 err_dir:
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -280,7 +280,9 @@ static void __init parse_setup_data(void
 		default:
 			break;
 		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
 		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
 		pa_data = data->next;
 		early_iounmap(data, PAGE_SIZE);
 	}

