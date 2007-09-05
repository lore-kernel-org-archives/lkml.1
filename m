Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXIERUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXIERUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXIERUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:20:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15619 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXIERUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:20:35 -0400
Date: Wed, 5 Sep 2007 10:18:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Pearson <james-p@moving-picture.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
Message-Id: <20070905101804.eafd0da4.randy.dunlap@oracle.com>
In-Reply-To: <46DEE0C9.1000402@moving-picture.com>
References: <4474B7DB.8000304@moving-picture.com>
	<200605242029.k4OKTn9C031700@terminus.zytor.com>
	<447EF58C.6000605@moving-picture.com>
	<52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com>
	<46C33700.1060605@zytor.com>
	<46D6CBED.4040301@moving-picture.com>
	<h87in5sgal.fsf@pepelac.englab.brq.redhat.com>
	<46DE6196.3050605@zytor.com>
	<46DEE0C9.1000402@moving-picture.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2007 18:00:57 +0100 James Pearson wrote:

> H. Peter Anvin wrote:
> > Anton Arapov wrote:
> > 
> >>   Hey guys, the future of this patch is important for me. What do you 
> >> think, has this patch any chances to be committed to upstream?
> >>
> >> James Pearson <james-p@moving-picture.com> writes:
> >>
> >>> H. Peter Anvin wrote:
> >>> There isn't that much that is duplicated - and there are also bits of
> >>> the /proc/PID/mem code that are not needed in this case, so I'm not
> >>> really sure if it is worth doing.
> >>>
> >>> I did submit a patch a few months ago - see:
> >>>
> >>> <http://marc.info/?l=linux-kernel&m=117862109623007&w=2>
> >>
> >>
> > 
> > Looks reasonable to me, except for the one overlong line.
> > 
> 
> OK, here is the patch (without the long line) against 2.6.23-rc5 - what 
> else needs to be done to get it committed?

Hi,

a.  It needs a changelog that describes the problem and the patch.
b.  It needs to apply cleanly to a current kernel.
    (It does not apply cleanly now due to some odd line breaks [see #1
    below.)
c.  It needs to use tabs instead of spaces.  That will probably help
    on item b as well.

linux-2.6.23-rc5> dryrun < ~/fs-proc-read-sizes.patch 
4 out of 4 hunks FAILED -- saving rejects to file fs/proc/base.c.rej

Even using patch -l (--ignore-whitespace), it fails with:

linux-2.6.23-rc5> patch -p1 -bl --dry-run --verbose < ~/fs-proc-read-sizes.patch 
Hmm...  Looks like a unified diff to me...
The text leading up to this was:
--------------------------
|--- ./fs/proc/base.c.dist       2007-09-01 07:08:24.000000000 +0100
|+++ ./fs/proc/base.c    2007-09-05 14:08:15.762518000 +0100
--------------------------
Patching file fs/proc/base.c using Plan A...
Hunk #1 FAILED at 199.
Hunk #2 FAILED at 637.
Hunk #3 succeeded at 2106 with fuzz 1.
Hunk #4 succeeded at 2393 with fuzz 1.
2 out of 4 hunks FAILED -- saving rejects to file fs/proc/base.c.rej
done





> --- ./fs/proc/base.c.dist       2007-09-01 07:08:24.000000000 +0100
> +++ ./fs/proc/base.c    2007-09-05 14:08:15.762518000 +0100
> @@ -199,27 +199,6 @@ static int proc_root_link(struct inode *
>           (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
>           security_ptrace(current,task) == 0))
> 
> -static int proc_pid_environ(struct task_struct *task, char * buffer)
> -{
> -       int res = 0;
> -       struct mm_struct *mm = get_task_mm(task);
> -       if (mm) {
> -               unsigned int len;
> -
> -               res = -ESRCH;
> -               if (!ptrace_may_attach(task))
> -                       goto out;
> -
> -               len  = mm->env_end - mm->env_start;
> -               if (len > PAGE_SIZE)
> -                       len = PAGE_SIZE;
> -               res = access_process_vm(task, mm->env_start, buffer, 
> len, 0);

#1 ^^^^^^^

> -out:
> -               mmput(mm);
> -       }
> -       return res;
> -}
> -
>   static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>   {
>          int res = 0;
> @@ -658,6 +637,85 @@ static const struct file_operations proc
>          .open           = mem_open,
>   };
> 
> +static ssize_t environ_read(struct file * file, char __user * buf,
> +                       size_t count, loff_t *ppos)
> +{
> +       struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
> +       char *page;
> +       unsigned long src = *ppos;
> +       int ret = -ESRCH;
> +       struct mm_struct *mm;
> +       size_t max_len;
> +
> +       if (!task)
> +               goto out_no_task;
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
> +                       page, this_len, 0);
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
> +       put_task_struct(task);
> +out_no_task:
> +       return ret;
> +}
> +
> +static const struct file_operations proc_environ_operations = {
> +       .read           = environ_read,
> +};
> +
>   static ssize_t oom_adjust_read(struct file *file, char __user *buf,
>                                  size_t count, loff_t *ppos)
>   {
> @@ -2048,7 +2106,7 @@ static const struct pid_entry tgid_base_
>          DIR("task",       S_IRUGO|S_IXUGO, task),
>          DIR("fd",         S_IRUSR|S_IXUSR, fd),
>          DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
> -       INF("environ",    S_IRUSR, pid_environ),
> +       REG("environ",    S_IRUSR, environ),
>          INF("auxv",       S_IRUSR, pid_auxv),
>          INF("status",     S_IRUGO, pid_status),
>   #ifdef CONFIG_SCHED_DEBUG
> @@ -2335,7 +2393,7 @@ out_no_task:
>   static const struct pid_entry tid_base_stuff[] = {
>          DIR("fd",        S_IRUSR|S_IXUSR, fd),
>          DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
> -       INF("environ",   S_IRUSR, pid_environ),
> +       REG("environ",   S_IRUSR, environ),
>          INF("auxv",      S_IRUSR, pid_auxv),
>          INF("status",    S_IRUGO, pid_status),
>   #ifdef CONFIG_SCHED_DEBUG
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
