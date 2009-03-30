Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZC3AW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZC3AW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZC3AWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:22:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:6798 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZC3AWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OFFlT4sCi48rnmRXtRFgJXQtsVM0mg6a7QeiN8doNBnvwOJSgw6ii2FxFEyXmY0kfO
         3J99l2M/RQpNz37WbOqcV1DNTzX9yjcLdYn5agZMUiI1Q9BXimrQSriYp1B0pg7iIJJx
         IzqeC/OmWqgis8fxtvNoyAbFGVw3N+HcJmkqA=
Date: Mon, 30 Mar 2009 04:29:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090330002944.GA3057@x200.localdomain>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329232422.GA9873@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 01:24:22AM +0200, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > I have personally stopped sending anything against pure arch/x86/ 
> > if there is even a smallest chance it can be prettyfied like this.
> 
> Before you volunteer reviewing x86 code for us (thanks for that!), 
> may i direct your urgent attention

Urgent?

> at code in your own area of responsibility - such as fs/proc/base.c:
> 
>     total: 85 errors, 39 warnings, 2 checks, 3147 lines checked
> 
> I filtered out the relevant ones for you below.

I many times beat my hands from doing that to not screw other patches,
to not make rejects for backporters, to not make some idiotic mistake
during, to not fill history with uninteresting changes and you show me
checkpatch.pl output. Is that all your arguments?

I also filtered relevant ones for you.

> ERROR: space required before the open parenthesis '('
> #154: FILE: proc/base.c:154:
> +	if(fs)

Fixed in mainline while fixing setuid(2) bug.

> ERROR: code indent should use tabs where possible
> #276: FILE: proc/base.c:276:
> + ^Ilen = mm->arg_end - mm->arg_start;$

Code uses SpaceTab, not doesn't use tabs.
 
> WARNING: externs should be avoided in .c files
> #452: FILE: proc/base.c:452:
> +unsigned long badness(struct task_struct *p, unsigned long uptime);

Now there is good header for this one -- oom.h

> ERROR: space required before the open brace '{'
> #1281: FILE: proc/base.c:1281:
> +	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){

->exe_file is bogus in a ways which has no relation to coding style,
I recently sent patch to remove it.

> ERROR: "foo * bar" should be "foo *bar"
> #2099: FILE: proc/base.c:2099:
> +	struct inode * inode = file->f_path.dentry->d_inode;
> 
> ERROR: "(foo*)" should be "(foo *)"
> #2108: FILE: proc/base.c:2108:
> +				      (char*)file->f_path.dentry->d_name.name,

These two are good ones to show how checkpatch.pl enables wrong patches.
These two should be fixed like below, not like script suggests:

	--- a/fs/proc/base.c
	+++ b/fs/proc/base.c
	@@ -2101,7 +2101,8 @@ out_no_task:
	 static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
	 				  size_t count, loff_t *ppos)
	 {
	-	struct inode * inode = file->f_path.dentry->d_inode;
	+	struct dentry *dentry = file->f_path.dentry;
	+	struct inode *inode = dentry->d_inode;
	 	char *p = NULL;
	 	ssize_t length;
	 	struct task_struct *task = get_proc_task(inode);
	@@ -2109,9 +2110,7 @@ static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
	 	if (!task)
	 		return -ESRCH;
	 
	-	length = security_getprocattr(task,
	-				      (char*)file->f_path.dentry->d_name.name,
	-				      &p);
	+	length = security_getprocattr(task, (char *)dentry->d_name.name, &p);
	 	put_task_struct(task);
	 	if (length > 0)
	 		length = simple_read_from_buffer(buf, count, ppos, p, length);

> ERROR: "foo * bar" should be "foo *bar"
> #2120: FILE: proc/base.c:2120:
> +	struct inode * inode = file->f_path.dentry->d_inode;
> 
> ERROR: "(foo*)" should be "(foo *)"
> #2137: FILE: proc/base.c:2137:
> +	page = (char*)__get_free_page(GFP_TEMPORARY);
> 
> ERROR: "(foo*)" should be "(foo *)"
> #2146: FILE: proc/base.c:2146:
> +				      (char*)file->f_path.dentry->d_name.name,

Same for these two.
 
> ERROR: "(foo*)" should be "(foo *)"
> #2147: FILE: proc/base.c:2147:
> +				      (void*)page, count);

Cast should be deleted because function takes "void *".

> total: 85 errors, 39 warnings, 2 checks, 3147 lines checked
> 
> fs/proc/base.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.

So, for 85 "errors" we have 1 prototype in wrong place, two real patches
which would be broken by rejects and 3 bogus chunks missing the point.
