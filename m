Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXEYNIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXEYNIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXEYNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:08:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50312 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXEYNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:08:01 -0400
Message-ID: <4656DF9F.6020203@hitachi.com>
Date: Fri, 25 May 2007 22:07:43 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 3/7] add an interface for core dump filter
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to set/reset flags which determines
each memory segment should be dumped or not when a core file is
generated.

/proc/<pid>/coredump_filter file is provided to access the flags.
You can change the flag status for a particular process by
writing to or reading from the file.

The flag status is inherited to the child process when it is created.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/proc/base.c        |   89 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |   14 ++++++
 kernel/fork.c         |    2 
 3 files changed, 105 insertions(+)

Index: linux-2.6.22-rc2-mm1/fs/proc/base.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/proc/base.c
+++ linux-2.6.22-rc2-mm1/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
+#include <linux/elf.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1808,6 +1809,91 @@ static const struct inode_operations pro
 
 #endif
 
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
+					 size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	int ret;
+
+	if (!task)
+		return -ESRCH;
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (mm) {
+		len = snprintf(buffer, sizeof(buffer), "%08lx\n",
+			       ((mm->flags & MMF_DUMP_FILTER_MASK) >>
+				MMF_DUMP_FILTER_SHIFT));
+		mmput(mm);
+		ret = simple_read_from_buffer(buf, count, ppos, buffer, len);
+	}
+
+	put_task_struct(task);
+
+	return ret;
+}
+
+static ssize_t proc_coredump_filter_write(struct file *file,
+					  const char __user *buf,
+					  size_t count,
+					  loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF], *end;
+	unsigned int val;
+	int ret;
+	int i;
+	unsigned long mask;
+
+	ret = -EFAULT;
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		goto out_no_task;
+
+	ret = -EINVAL;
+	val = (unsigned int)simple_strtoul(buffer, &end, 0);
+	if (*end == '\n')
+		end++;
+	if (end - buffer == 0)
+		goto out_no_task;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		goto out_no_task;
+
+	ret = end - buffer;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_no_mm;
+
+	for (i = 0, mask = 1; i < MMF_DUMP_FILTER_BITS; i++, mask <<= 1) {
+		if (val & mask)
+			set_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
+		else
+			clear_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
+	}
+
+	mmput(mm);
+ out_no_mm:
+	put_task_struct(task);
+ out_no_task:
+	return ret;
+}
+
+static const struct file_operations proc_coredump_filter_operations = {
+	.read		= proc_coredump_filter_read,
+	.write		= proc_coredump_filter_write,
+};
+#endif
+
 /*
  * /proc/self:
  */
@@ -2036,6 +2122,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
+#endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
Index: linux-2.6.22-rc2-mm1/include/linux/sched.h
===================================================================
--- linux-2.6.22-rc2-mm1.orig/include/linux/sched.h
+++ linux-2.6.22-rc2-mm1/include/linux/sched.h
@@ -328,8 +328,22 @@ extern void set_dumpable(struct mm_struc
 extern int get_dumpable(struct mm_struct *mm);
 
 /* mm flags */
+/* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
 #define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+#define MMF_DUMPABLE_BITS 2
+
+/* coredump filter bits */
+#define MMF_DUMP_ANON_PRIVATE	2
+#define MMF_DUMP_ANON_SHARED	3
+#define MMF_DUMP_MAPPED_PRIVATE	4
+#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
+#define MMF_DUMP_FILTER_BITS	4
+#define MMF_DUMP_FILTER_MASK \
+	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+#define MMF_DUMP_FILTER_DEFAULT \
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
 
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
Index: linux-2.6.22-rc2-mm1/kernel/fork.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/kernel/fork.c
+++ linux-2.6.22-rc2-mm1/kernel/fork.c
@@ -335,6 +335,8 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
+	mm->flags = (current->mm) ? current->mm->flags
+				  : MMF_DUMP_FILTER_DEFAULT;
 	mm->core_waiters = 0;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);


