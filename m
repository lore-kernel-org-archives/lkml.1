Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYADPjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYADPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYADPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:38:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:51772 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYADPi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h+yPFkoblKoeZQSCRu8plG4YZJhhprcqWX47CgiAlg5qUYzyN5fahqr4WAsP4CEM4Z0Er1jlBVgZIQrIXvmmMwtgBLRDKvHMlV6ZhqeoWY1S1FokO1goSkfize/OKu/k5y4OdfLgbv5xy+xEXKeKYhljPsfBkaKsLts+mmpLhx0=
Message-ID: <91b13c310801040738h75465241wa1179d0e06131354@mail.gmail.com>
Date: Fri, 4 Jan 2008 23:38:52 +0800
From: "rae l" <crquan@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by read-write /proc/<pid>/smp_affinity
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       emdow@us.ibm.com
In-Reply-To: <20080104015421.cc7a89f7.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
	 <20080104015421.cc7a89f7.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d2be88406fdc1d28a7cf0b1a13ca761d625820a5 Mon Sep 17 00:00:00 2001
From: Denis Cheng <crquan@gmail.com>
Date: Fri, 4 Jan 2008 14:50:54 +0800
Subject: [PATCH] PROC_FS: get and set the smp affinity of tasks by
read-write /proc/<pid>/smp_affinity

this adds a read-write /proc/<pid>/smp_affinity entry,
just like what /proc/irq/<irq>/smp_affinity does,
so now we can get and set the affinity of tasks by procfs,
this is especially useful used in shell scripts.

this also adds a read-write /proc/<pid>/tasks/<tid>/smp_affinity
for the same purpose.

Cc: Eli M Dow <emdow@us.ibm.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
length check copied from kernel/irq/proc.c, now 'page' buffer couldn't
be overrun,

Another way, although Documentation/filesystems/proc.txt is heavily outdated,
I'll add introduction of smp_affinity.

 fs/proc/base.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..d768d66 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1083,6 +1083,65 @@ static const struct file_operations
proc_pid_sched_operations = {

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
+	if (!page) {
+		length = -ENOMEM;
+		goto out;
+	}
+
+	length = cpumask_scnprintf(page, count, mask);
+	if (count - length < 2) {
+		length = -EINVAL;
+		goto out_free_page;
+	}
+	length += sprintf(page + length, "\n");
+	length = simple_read_from_buffer(buf, count, ppos, page, length);
+
+out_free_page:
+	free_page((unsigned long)page);
+out:
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
@@ -2230,6 +2289,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, pid_schedstat),
 #endif
+#ifdef CONFIG_SMP
+	REG("smp_affinity", S_IRUGO|S_IWUSR, smp_affinity),
+#endif
 #ifdef CONFIG_PROC_PID_CPUSET
 	REG("cpuset",     S_IRUGO, cpuset),
 #endif
@@ -2555,6 +2617,9 @@ static const struct pid_entry tid_base_stuff[] = {
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
