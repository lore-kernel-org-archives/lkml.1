Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXIUJl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXIUJl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXIUJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:41:21 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:42238 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327AbXIUJlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:41:20 -0400
Message-ID: <46F391BA.2070906@moving-picture.com>
Date: Fri, 21 Sep 2007 10:41:14 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, aarapov@redhat.com, hpa@zytor.com,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
References: <E1IXziD-0003YJ-0w@moving-picture.com> <20070920164632.fd440b78.akpm@linux-foundation.org>
In-Reply-To: <20070920164632.fd440b78.akpm@linux-foundation.org>
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

Andrew Morton wrote:
> On Wed, 19 Sep 2007 14:35:29 +0100
> "James Pearson" <james-p@moving-picture.com> wrote:
> 
> 
>>From: James Pearson <james-p@moving-picture.com>
>>
>>/proc/PID/environ currently truncates at 4096 characters, patch based on 
>>the /proc/PID/mem code.
> 
> 
> patch needs to be carefully reviewed from the security POV (ie: permissions)
> as well as for correctness.  Does anyone have time to do that?
> 
> 
>>Signed-off-by: James Pearson <james-p@moving-picture.com>
>>
>>--- ./fs/proc/base.c.dist	2007-09-19 12:29:46.244929651 +0100
>>+++ ./fs/proc/base.c	2007-09-19 12:36:18.155648760 +0100
>>@@ -202,27 +202,6 @@ static int proc_root_link(struct inode *
>> 	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
>> 	 security_ptrace(current,task) == 0))
>> 
>>-static int proc_pid_environ(struct task_struct *task, char * buffer)
>>-{
>>-	int res = 0;
>>-	struct mm_struct *mm = get_task_mm(task);
>>-	if (mm) {
>>-		unsigned int len;
>>-
>>-		res = -ESRCH;
>>-		if (!ptrace_may_attach(task))
>>-			goto out;
>>-
>>-		len  = mm->env_end - mm->env_start;
>>-		if (len > PAGE_SIZE)
>>-			len = PAGE_SIZE;
>>-		res = access_process_vm(task, mm->env_start, buffer, len, 0);
>>-out:
>>-		mmput(mm);
>>-	}
>>-	return res;
>>-}
>>-
>> static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>> {
>> 	int res = 0;
>>@@ -740,6 +719,79 @@ static const struct file_operations proc
>> 	.open		= mem_open,
>> };
>> 
>>+static ssize_t environ_read(struct file *file, char __user *buf,
>>+			size_t count, loff_t *ppos)
>>+{
>>+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
>>+	char *page;
>>+	unsigned long src = *ppos;
>>+	int ret = -ESRCH;
>>+	struct mm_struct *mm;
>>+	size_t max_len;
>>+
>>+	if (!task)
>>+		goto out_no_task;
>>+
>>+	if (!ptrace_may_attach(task))
>>+		goto out;
>>+
>>+	ret = -ENOMEM;
>>+	page = (char *)__get_free_page(GFP_TEMPORARY);
> 
> 
> Now I wonder what inspired you to reach for GFP_TEMPORARY?  Perhaps the
> fact that it is crappily named and undocumented.
> 
> This should be GFP_KERNEL - the page you're allocating here is not
> reclaimable by the VM.

The code is based on mem_read() - and that is what mem_read() does in 
2.6.23rc6-mm1 - my previous patch for 2.6.23rc5 used GFP_USER, as that 
is what mem_read() does in 2.6.23rc5.

>>+	if (!page)
>>+		goto out;
>>+
>>+	ret = 0;
>>+
>>+	mm = get_task_mm(task);
>>+	if (!mm)
>>+		goto out_free;
>>+
>>+	max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
>>+
>>+	while (count > 0) {
>>+		int this_len, retval;
>>+
>>+		this_len = mm->env_end - (mm->env_start + src);
>>+
>>+		if (this_len <= 0)
>>+			break;
>>+
>>+		if (this_len > max_len)
>>+			this_len = max_len;
>>+
>>+		retval = access_process_vm(task, (mm->env_start + src),
>>+			page, this_len, 0);
>>+
>>+		if (retval <= 0) {
>>+			ret = retval;
>>+			break;
>>+		}
>>+
>>+		if (copy_to_user(buf, page, retval)) {
>>+			ret = -EFAULT;
>>+			break;
>>+		}
>>+
>>+		ret += retval;
>>+		src += retval;
>>+		buf += retval;
>>+		count -= retval;
>>+	}
> 
> 
> Now that's a funky loop.  Someone please convince me that there is no way
> in which `count - retval' can ever go negative (ie: huge positive).

Again, this is exactly the same as in mem_read()

James Pearson

