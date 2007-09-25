Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbXIYQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbXIYQpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbXIYQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:44:50 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:37552 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757424AbXIYQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:44:48 -0400
From: "James Pearson" <james-p@moving-picture.com>
Date: Tue, 25 Sep 2007 17:44:38 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
Cc: aarapov@redhat.com, akpm@linux-foundation.org, hpa@zytor.com,
       moezzia@gmail.com
Message-Id: <E1IaDWY-0008Pn-2l@moving-picture.com>
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Pearson wrote:
> Arvin Moezzi wrote:
> 
>> I think that's not true. 'count' is changing through the iteration.
>> The difference in the mem_read():
>>
>> * while (count > 0) {
>> *     int this_len, retval;
>> *
>> *      this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
>> *      retval = access_process_vm(task, src, page, this_len, 0);
>> *
>> *      ...
>> * }
>>
>> is the fact, that this_len = min(PAGE_SIZE, count) is in the
>> iteration block, hence retval <= this_len <= count in each iteration
>> step. So this is ok. But IMHO in your code 'retval' may be bigger than
>> 'count' in the last iteration of the block, because 'max_len' is fix
>> through your iteration but 'count' is changing. Or am i missing
>> something?
> 
> 
> Yes, you are correct ...

Here is a new patch that fixes the above issue ...

However, I'm not sure if I should be using GFP_TEMPORARY, GFP_KERNEL or
GFP_USER ?

Thanks

James Pearson


Patch against 2.6.23-rc6-mm1

---

/proc/PID/environ currently truncates at 4096 characters, patch based on 
the /proc/PID/mem code.

Signed-off-by: James Pearson <james-p@moving-picture.com>

--- ./fs/proc/base.c.dist	2007-09-19 12:29:46.244929651 +0100
+++ ./fs/proc/base.c	2007-09-25 12:40:53.194497911 +0100
@@ -202,27 +202,6 @@ static int proc_root_link(struct inode *
 	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
 	 security_ptrace(current,task) == 0))
 
-static int proc_pid_environ(struct task_struct *task, char * buffer)
-{
-	int res = 0;
-	struct mm_struct *mm = get_task_mm(task);
-	if (mm) {
-		unsigned int len;
-
-		res = -ESRCH;
-		if (!ptrace_may_attach(task))
-			goto out;
-
-		len  = mm->env_end - mm->env_start;
-		if (len > PAGE_SIZE)
-			len = PAGE_SIZE;
-		res = access_process_vm(task, mm->env_start, buffer, len, 0);
-out:
-		mmput(mm);
-	}
-	return res;
-}
-
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
@@ -740,6 +719,76 @@ static const struct file_operations proc
 	.open		= mem_open,
 };
 
+static ssize_t environ_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	char *page;
+	unsigned long src = *ppos;
+	int ret = -ESRCH;
+	struct mm_struct *mm;
+
+	if (!task)
+		goto out_no_task;
+
+	if (!ptrace_may_attach(task))
+		goto out;
+
+	ret = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out;
+
+	ret = 0;
+
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_free;
+
+	while (count > 0) {
+		int this_len, retval, max_len;
+
+		this_len = mm->env_end - (mm->env_start + src);
+
+		if (this_len <= 0)
+			break;
+
+		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
+		this_len = (this_len > max_len) ? max_len : this_len;
+
+		retval = access_process_vm(task, (mm->env_start + src),
+			page, this_len, 0);
+
+		if (retval <= 0) {
+			ret = retval;
+			break;
+		}
+
+		if (copy_to_user(buf, page, retval)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret += retval;
+		src += retval;
+		buf += retval;
+		count -= retval;
+	}
+	*ppos = src;
+
+	mmput(mm);
+out_free:
+	free_page((unsigned long) page);
+out:
+	put_task_struct(task);
+out_no_task:
+	return ret;
+}
+
+static const struct file_operations proc_environ_operations = {
+	.read		= environ_read,
+};
+
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -2092,7 +2141,7 @@ static const struct pid_entry tgid_base_
 	DIR("task",       S_IRUGO|S_IXUGO, task),
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
-	INF("environ",    S_IRUSR, pid_environ),
+	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
 	INF("limits",	  S_IRUSR, pid_limits),
@@ -2421,7 +2470,7 @@ out_no_task:
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
-	INF("environ",   S_IRUSR, pid_environ),
+	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
 	INF("limits",	 S_IRUSR, pid_limits),
