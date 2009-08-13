Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZHMCHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZHMCHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZHMCHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:07:41 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:64335 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHMCHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hDg0OpqrvpWijiN/J6NA8O1uUoGwlsGsf/zj7PJjm6ryL4GSaGFpKF2eHLt9KXhpoT
         tFrd7FQNsQSFDrZlCQ5AfXG8dm+q/fK979kpN4NC50O8mXDn9v56HaCLu+hVCFX3t/aV
         ZfaXXn8F3aLuOqsY2UqtzNGj91u7GdBbYzEy8=
Date: Thu, 13 Aug 2009 10:09:52 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Vincent Li <macli@brc.ubc.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input
	sanity check
Message-ID: <20090813020952.GA5031@cr0.nay.redhat.com>
References: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 04:29:54PM -0700, Vincent Li wrote:
>v1 fix the compiling errors and keep the type variable name.
>
>Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
>at the end of the function, David Rientjes suggested to use strict_strtol to replace
>simple_strtol, this patch cover above suggestions, add removing of leading and trailing
>whitespace from user input. It does not change function behavious.
>


Sorry, what real benefits can we get from this patch?

With this patch, we can accept input like:

echo '                    1' > /proc/<pid>/clear_refs

right?

If this is really necessary, why not other files similar to 'clear_refs'?

How about adding strstrip() for simple_strtol()?


>This patch is rebased on mmotm-2009-08-04-14-22.
>
>Signed-off-by: Vincent Li <macli@brc.ubc.ca>
>---
> fs/proc/task_mmu.c |   14 ++++++--------
> 1 files changed, 6 insertions(+), 8 deletions(-)
>
>diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>index 2079969..c7cf8f3 100644
>--- a/fs/proc/task_mmu.c
>+++ b/fs/proc/task_mmu.c
>@@ -491,21 +491,20 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> 				size_t count, loff_t *ppos)
> {
> 	struct task_struct *task;
>-	char buffer[PROC_NUMBUF], *end;
>+	char buffer[PROC_NUMBUF];
> 	struct mm_struct *mm;
> 	struct vm_area_struct *vma;
>-	int type;
>+	long type;
> 
> 	memset(buffer, 0, sizeof(buffer));
> 	if (count > sizeof(buffer) - 1)
> 		count = sizeof(buffer) - 1;
> 	if (copy_from_user(buffer, buf, count))
> 		return -EFAULT;
>-	type = simple_strtol(buffer, &end, 0);
>+	if (strict_strtol(strstrip(buffer), 10, &type))
>+		return -EINVAL;
> 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
> 		return -EINVAL;
>-	if (*end == '\n')
>-		end++;
> 	task = get_proc_task(file->f_path.dentry->d_inode);
> 	if (!task)
> 		return -ESRCH;
>@@ -541,9 +540,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> 		mmput(mm);
> 	}
> 	put_task_struct(task);
>-	if (end - buffer == 0)
>-		return -EIO;
>-	return end - buffer;
>+
>+	return count;
> }
> 
> const struct file_operations proc_clear_refs_operations = {
>-- 
>1.6.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
