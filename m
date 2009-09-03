Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZICU0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZICU0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZICU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbZICU0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:26:09 -0400
Date: Thu, 3 Sep 2009 16:25:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Message-Id: <9482c1ed2ef2dba9d21b0a0f4671b3b68cdc30ee.1252007851.git.jbaron@redhat.com>
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com>
Subject: [PATCH 2/4] RFC: jump label example usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example cases to see how jump patching can be used:

echo a '1' into <debugfs>/jump/enabled to see a 'doing tracing' printk
echo a '0' into <debugfs>/jump/enabled to see a 'not doing tracing' printk

The codepaths are updated using code patching.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 kernel/jump_label.c |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index f6be1eb..0bc0b2d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -120,10 +120,143 @@ int run_make_nop(char *name)
 
 #endif
 
+static ssize_t read_enabled_file_jump(struct file *file,
+		char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+	ssize_t val;
+
+	if (jump_enabled)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+
+	val = simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+	JUMP_LABEL_IF(trace, trace_label, jump_enabled);
+	printk("not doing tracing\n");
+if (0) {
+trace_label:
+	printk("doing tracing: %d\n", file);
+}
+	printk("val is: %d\n", val);
+	return val;
+}
+
+static ssize_t read_enabled_file_jump2(struct file *file,
+               char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+	ssize_t val;
+
+	if (jump_enabled2)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+
+	val = simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+	JUMP_LABEL_IF(trace2, trace_label, jump_enabled2);
+	printk("not doing tracing 2\n");
+if (0) {
+trace_label:
+	printk("doing tracing 2: %d\n", file);
+}
+	printk("val is: %d\n", val);
+	return val;
+}
+
+static ssize_t write_enabled_file_jump(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		jump_enabled = 1;
+		run_make_jump("trace");
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		jump_enabled = 0;
+		run_make_nop("trace");
+		break;
+	}
+
+	return count;
+}
+
+static ssize_t write_enabled_file_jump2(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		jump_enabled2 = 1;
+		run_make_jump("trace2");
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		jump_enabled2 = 0;
+		run_make_nop("trace2");
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_jump = {
+	.read =         read_enabled_file_jump,
+	.write =        write_enabled_file_jump,
+};
+
+static struct file_operations fops_jump2 = {
+	.read =         read_enabled_file_jump2,
+	.write =        write_enabled_file_jump2,
+};
+
 static int __jump_label_init(void)
 {
+	struct dentry *dir, *file;
+	unsigned int value = 1;
 	struct jump_entry *iter;
 
+	dir = debugfs_create_dir("jump", NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	file = debugfs_create_file("enabled", 0600, dir,
+					&value, &fops_jump);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	file = debugfs_create_file("enabled2", 0600, dir,
+					&value, &fops_jump2);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
 
 #ifdef HAVE_STATIC_JUMP
 	printk("__start___jump_table is: %p\n", __start___jump_table);
-- 
1.6.2.5

