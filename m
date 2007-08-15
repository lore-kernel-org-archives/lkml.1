Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbXHOQy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbXHOQy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXHOQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:54:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:43430 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809AbXHOQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mhgUGAchKv1NmQYny45fOeKiMb21JQbYCGuQWh96ebmnmY6JMnAcVElIG1GDnK5a6tiOxeCxmKOmyQo0V4ADIruqP+l1Ly9Xe7lNjZy5bGLX2dsumpputhpc8lL1Hy+UzPj2TG4IFm63VPqUNjYiyT7pWaD0CZIdlERlIL6j/H8=
Message-ID: <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
Date: Wed, 15 Aug 2007 11:54:35 -0500
From: "Guy Streeter" <guy.streeter@gmail.com>
To: "James Pearson" <james-p@moving-picture.com>
Subject: Re: 4096 byte limit to /proc/PID/environ ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <447EF58C.6000605@moving-picture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4474B7DB.8000304@moving-picture.com>
	 <200605242029.k4OKTn9C031700@terminus.zytor.com>
	 <447EF58C.6000605@moving-picture.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/06, James Pearson <james-p@moving-picture.com> wrote:
> H. Peter Anvin wrote:
> > I think this is the wrong approach.
> >
> > Many of these should probably be converted to seq_file, but in the
> > particular case of environ, the right approach is to observe the fact
> > that reading environ is just like reading /proc/PID/mem, except:
> >
> >  a. the access restrictions are less strict, and
> >  b. there is a range restriction, which needs to be enforced, and
> >  c. there is an offset.
> >
> > Pretty much, take the guts from /proc/PID/mem and generalize it
> > slightly, and you have the code that can run either /proc/PID/mem or
> > /proc/PID/environ.
>
> The following patch is based on the /proc/PID/mem code appears to work fine.
>
> James Pearson
>
>
> --- ./fs/proc/base.c.dist       2006-05-11 02:56:24.000000000 +0100
> +++ ./fs/proc/base.c    2006-06-01 13:40:50.865851007 +0100
> @@ -409,22 +409,6 @@
>           (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
>           security_ptrace(current,task) == 0))
>
> -static int proc_pid_environ(struct task_struct *task, char * buffer)
> -{
> -       int res = 0;
> -       struct mm_struct *mm = get_task_mm(task);
> -       if (mm) {
> -               unsigned int len = mm->env_end - mm->env_start;
> -               if (len > PAGE_SIZE)
> -                       len = PAGE_SIZE;
> -               res = access_process_vm(task, mm->env_start, buffer,
> len, 0);
> -               if (!ptrace_may_attach(task))
> -                       res = -ESRCH;
> -               mmput(mm);
> -       }
> -       return res;
> -}
> -
>   static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>   {
>          int res = 0;
> @@ -897,6 +881,80 @@
>          .open           = mem_open,
>   };
>
> +static ssize_t env_read(struct file * file, char __user * buf,
> +                       size_t count, loff_t *ppos)
> +{
> +       struct task_struct *task = proc_task(file->f_dentry->d_inode);
> +       char *page;
> +       unsigned long src = *ppos;
> +       int ret = -ESRCH;
> +       struct mm_struct *mm;
> +       size_t max_len;
> +
> +       if (!ptrace_may_attach(task))
> +               goto out;
> +
> +       ret = -ENOMEM;
> +       page = (char *)__get_free_page(GFP_USER);
> +       if (!page)
> +               goto out;
> +
> +       ret = 0;
> +
> +       mm = get_task_mm(task);
> +       if (!mm)
> +               goto out_free;
> +
> +       ret = 0;
> +       max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
> +
> +       while (count > 0) {
> +               int this_len, retval;
> +
> +               this_len = mm->env_end - (mm->env_start + src);
> +
> +               if (this_len <= 0) {
> +                       break;
> +               }
> +
> +               if (this_len > max_len)
> +                       this_len = max_len;
> +
> +               retval = access_process_vm(task, (mm->env_start + src),
> page, this_len, 0);
> +
> +               if (!ptrace_may_attach(task)) {
> +                       ret = -ESRCH;
> +                       break;
> +               }
> +
> +               if (retval <= 0) {
> +                       ret = retval;
> +                       break;
> +               }
> +
> +               if (copy_to_user(buf, page, retval)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               ret += retval;
> +               src += retval;
> +               buf += retval;
> +               count -= retval;
> +       }
> +       *ppos = src;
> +
> +       mmput(mm);
> +out_free:
> +       free_page((unsigned long) page);
> +out:
> +       return ret;
> +}
> +
> +static struct file_operations proc_env_operations = {
> +       .read           = env_read,
> +};
> +
>   static ssize_t oom_adjust_read(struct file *file, char __user *buf,
>                                  size_t count, loff_t *ppos)
>   {
> @@ -1675,11 +1733,6 @@
>                          inode->i_op = &proc_pid_link_inode_operations;
>                          ei->op.proc_get_link = proc_root_link;
>                          break;
> -               case PROC_TID_ENVIRON:
> -               case PROC_TGID_ENVIRON:
> -                       inode->i_fop = &proc_info_file_operations;
> -                       ei->op.proc_read = proc_pid_environ;
> -                       break;
>                  case PROC_TID_AUXV:
>                  case PROC_TGID_AUXV:
>                          inode->i_fop = &proc_info_file_operations;
> @@ -1723,6 +1776,10 @@
>                          inode->i_op = &proc_mem_inode_operations;
>                          inode->i_fop = &proc_mem_operations;
>                          break;
> +               case PROC_TID_ENVIRON:
> +               case PROC_TGID_ENVIRON:
> +                       inode->i_fop = &proc_env_operations;
> +                       break;
>   #ifdef CONFIG_SECCOMP
>                  case PROC_TID_SECCOMP:
>                  case PROC_TGID_SECCOMP:
> -

This thread has gone stale. The PAGE_SIZE limit still exists. Is this
solution acceptable?

thanks,
--Guy Streeter
