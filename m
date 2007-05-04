Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXEDObF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXEDObF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXEDObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:31:05 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:40409 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755343AbXEDObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:31:00 -0400
Message-ID: <463B43A1.6050409@moving-picture.com>
Date: Fri, 04 May 2007 15:30:57 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Don't truncate /proc/PID/environ at 4096 characters
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

/proc/PID/environ currently truncates at 4096 characters, patch based on 
the /proc/PID/mem code.

Signed-off-by: James Pearson <james-p@moving-picture.com>

--- ./fs/proc/base.c.dist       2007-04-26 04:08:32.000000000 +0100
+++ ./fs/proc/base.c    2007-04-27 16:32:44.277664457 +0100
@@ -196,22 +196,6 @@
          (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
          security_ptrace(current,task) == 0))

-static int proc_pid_environ(struct task_struct *task, char * buffer)
-{
-       int res = 0;
-       struct mm_struct *mm = get_task_mm(task);
-       if (mm) {
-               unsigned int len = mm->env_end - mm->env_start;
-               if (len > PAGE_SIZE)
-                       len = PAGE_SIZE;
-               res = access_process_vm(task, mm->env_start, buffer,
len, 0);
-               if (!ptrace_may_attach(task))
-                       res = -ESRCH;
-               mmput(mm);
-       }
-       return res;
-}
-
  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
  {
         int res = 0;
@@ -653,6 +637,84 @@
         .open           = mem_open,
  };

+static ssize_t environ_read(struct file * file, char __user * buf,
+                       size_t count, loff_t *ppos)
+{
+       struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+       char *page;
+       unsigned long src = *ppos;
+       int ret = -ESRCH;
+       struct mm_struct *mm;
+       size_t max_len;
+
+       if (!task)
+               goto out_no_task;
+
+       if (!ptrace_may_attach(task))
+               goto out;
+
+       ret = -ENOMEM;
+       page = (char *)__get_free_page(GFP_USER);
+       if (!page)
+               goto out;
+
+       ret = 0;
+
+       mm = get_task_mm(task);
+       if (!mm)
+               goto out_free;
+
+       max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
+
+       while (count > 0) {
+               int this_len, retval;
+
+               this_len = mm->env_end - (mm->env_start + src);
+
+               if (this_len <= 0) {
+                       break;
+               }
+
+               if (this_len > max_len)
+                       this_len = max_len;
+
+               retval = access_process_vm(task, (mm->env_start + src), 
page, this_len, 0);
+
+               if (!ptrace_may_attach(task)) {
+                       ret = -ESRCH;
+                       break;
+               }
+
+               if (retval <= 0) {
+                       ret = retval;
+                       break;
+               }
+
+               if (copy_to_user(buf, page, retval)) {
+                       ret = -EFAULT;
+                       break;
+               }
+
+               ret += retval;
+               src += retval;
+               buf += retval;
+               count -= retval;
+       }
+       *ppos = src;
+
+       mmput(mm);
+out_free:
+       free_page((unsigned long) page);
+out:
+       put_task_struct(task);
+out_no_task:
+       return ret;
+}
+
+static struct file_operations proc_environ_operations = {
+       .read           = environ_read,
+};
+
  static ssize_t oom_adjust_read(struct file *file, char __user *buf,
                                 size_t count, loff_t *ppos)
  {
@@ -1831,7 +1893,7 @@
  static struct pid_entry tgid_base_stuff[] = {
         DIR("task",       S_IRUGO|S_IXUGO, task),
         DIR("fd",         S_IRUSR|S_IXUSR, fd),
-       INF("environ",    S_IRUSR, pid_environ),
+       REG("environ",    S_IRUSR, environ),
         INF("auxv",       S_IRUSR, pid_auxv),
         INF("status",     S_IRUGO, pid_status),
         INF("cmdline",    S_IRUGO, pid_cmdline),
@@ -2113,7 +2175,7 @@
   */
  static struct pid_entry tid_base_stuff[] = {
         DIR("fd",        S_IRUSR|S_IXUSR, fd),
-       INF("environ",   S_IRUSR, pid_environ),
+       REG("environ",   S_IRUSR, environ),
         INF("auxv",      S_IRUSR, pid_auxv),
         INF("status",    S_IRUGO, pid_status),
         INF("cmdline",   S_IRUGO, pid_cmdline),

