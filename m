Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZHME6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZHME6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZHME6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:58:33 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:51246 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZHME6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:58:33 -0400
Date: Wed, 12 Aug 2009 22:20:28 -0700 (PDT)
From: Vincent Li <macli@brc.ubc.ca>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input
 sanity check
In-Reply-To: <20090813020952.GA5031@cr0.nay.redhat.com>
Message-ID: <alpine.DEB.1.00.0908122143060.22452@mail.selltech.ca>
References: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca> <20090813020952.GA5031@cr0.nay.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Amerigo Wang wrote:

> On Wed, Aug 12, 2009 at 04:29:54PM -0700, Vincent Li wrote:
> >v1 fix the compiling errors and keep the type variable name.
> >
> >Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
> >at the end of the function, David Rientjes suggested to use strict_strtol to replace
> >simple_strtol, this patch cover above suggestions, add removing of leading and trailing
> >whitespace from user input. It does not change function behavious.
> >
> 
> 
> Sorry, what real benefits can we get from this patch?

It removes the redundant and weird zero-length check at the end of the 
function since the the function already check the returning value of 
simple_strtol, if it is zero-length input, the function should already 
return error -EINVAL. Also using strict_strtol would only accept ascii 
numbers, not something like:

echo 1foo > /proc/pid/clear_refs

> 
> With this patch, we can accept input like:
> 
> echo '                    1' > /proc/<pid>/clear_refs
> 
> right?

It will accept 'echo     1    > /proc/pid/clear_refs', but I think 
nobody will do that on purpose, only accidently typed one or two space 
before or after.

> 
> If this is really necessary, why not other files similar to 'clear_refs'?
> 

I did the same to other functions, but Andrew pointed out making changes 
without fully understanding the patch impact would be risky and break 
existing applications, So I need to fully understand what those functions 
do before I make any changes.
 
> How about adding strstrip() for simple_strtol()? 
> 

simple_strtol will accept 'echo 1foo > /proc/pid/clear_refs' which is not 
ideal.

> 
> >This patch is rebased on mmotm-2009-08-04-14-22.
> >
> >Signed-off-by: Vincent Li <macli@brc.ubc.ca>
> >---
> > fs/proc/task_mmu.c |   14 ++++++--------
> > 1 files changed, 6 insertions(+), 8 deletions(-)
> >
> >diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >index 2079969..c7cf8f3 100644
> >--- a/fs/proc/task_mmu.c
> >+++ b/fs/proc/task_mmu.c
> >@@ -491,21 +491,20 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > 				size_t count, loff_t *ppos)
> > {
> > 	struct task_struct *task;
> >-	char buffer[PROC_NUMBUF], *end;
> >+	char buffer[PROC_NUMBUF];
> > 	struct mm_struct *mm;
> > 	struct vm_area_struct *vma;
> >-	int type;
> >+	long type;
> > 
> > 	memset(buffer, 0, sizeof(buffer));
> > 	if (count > sizeof(buffer) - 1)
> > 		count = sizeof(buffer) - 1;
> > 	if (copy_from_user(buffer, buf, count))
> > 		return -EFAULT;
> >-	type = simple_strtol(buffer, &end, 0);
> >+	if (strict_strtol(strstrip(buffer), 10, &type))
> >+		return -EINVAL;
> > 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
> > 		return -EINVAL;
> >-	if (*end == '\n')
> >-		end++;
> > 	task = get_proc_task(file->f_path.dentry->d_inode);
> > 	if (!task)
> > 		return -ESRCH;
> >@@ -541,9 +540,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > 		mmput(mm);
> > 	}
> > 	put_task_struct(task);
> >-	if (end - buffer == 0)
> >-		return -EIO;
> >-	return end - buffer;
> >+
> >+	return count;
> > }
> > 
> > const struct file_operations proc_clear_refs_operations = {
> >-- 
> >1.6.0.4
> >

Vincent Li
Biomedical Research Center
University of British Columbia
