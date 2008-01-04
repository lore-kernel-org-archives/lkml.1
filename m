Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYADHEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYADHEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYADHD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:03:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:65404 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYADHD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mRKm7iD2PXvyFzyj/XKY4NXgDas1Q7jkQqfPUGakYTd8uMVMdS66LxhTn3jziB/HrVbxgjbDCi3BWBrbCVL2mbK1hyOTPQZTdXaNkXc0uGKZXBSxJMqcVgmcKg6VzmnAgPUIeyJSyBLc8vQB8GOKDPAgVK2nB+uiBJHKTezDVyE=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Eli M Dow <emdow@us.ibm.com>
Subject: [PATCH] PROC_FS: get and set the smp affinity of tasks by read-write /proc/<pid>/smp_affinity
Date: Fri,  4 Jan 2008 15:03:41 +0800
Message-Id: <1199430221-28417-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this adds a read-write /proc/<pid>/smp_affinity entry,
just like what /proc/irq/<irq>/smp_affinity does,
so now we can get and set the affinity of tasks by procfs,
this is especially useful used in shell scripts.

this also adds a read-write /proc/<pid>/tasks/<tid>/smp_affinity
for the same purpose.

Cc: Eli M Dow <emdow@us.ibm.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/proc/base.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..ca0cbc2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1083,6 +1083,57 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
+#ifdef CONFIG_SMP
+static ssize_t smp_affinity_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	cpumask_t mask;
+	char *page;
+	ssize_t length;
+	pid_t pid = pid_nr(proc_pid(file->f_dentry->d_inode));
+
+	length = sched_getaffinity(pid, &mask);
+	if (length < 0)
+		return length;
+
+	if (count > PROC_BLOCK_SIZE)
+		count = PROC_BLOCK_SIZE;
+
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		return -ENOMEM;
+
+	length = cpumask_scnprintf(page, count, mask);
+	length += sprintf(page + length, "\n");
+	length = simple_read_from_buffer(buf, count, ppos, page, length);
+	free_page((unsigned long) page);
+
+	return length;
+}
+
+static ssize_t smp_affinity_write(struct file *file,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	cpumask_t mask;
+	int ret;
+	pid_t pid = pid_nr(proc_pid(file->f_dentry->d_inode));
+
+	ret = cpumask_parse_user(buf, count, mask);
+	if (ret < 0)
+		return ret;
+	ret = sched_setaffinity(pid, mask);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static const struct file_operations proc_smp_affinity_operations = {
+	.read  = smp_affinity_read,
+	.write = smp_affinity_write,
+};
+#endif
+
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
@@ -2230,6 +2281,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif
+#ifdef CONFIG_SMP
+	REG("smp_affinity", S_IRUGO|S_IWUSR, smp_affinity),
+#endif
 #ifdef CONFIG_PROC_PID_CPUSET
 	REG("cpuset",     S_IRUGO, cpuset),
 #endif
@@ -2555,6 +2609,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, pid_schedstat),
 #endif
+#ifdef CONFIG_SMP
+	REG("smp_affinity", S_IRUGO|S_IWUSR, smp_affinity),
+#endif
 #ifdef CONFIG_PROC_PID_CPUSET
 	REG("cpuset",    S_IRUGO, cpuset),
 #endif
-- 
1.5.3.5

