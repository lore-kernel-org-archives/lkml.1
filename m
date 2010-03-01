Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0CAPof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:44:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CAPod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:44:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hwOBzlykmRa3y+baG8Bclrq4tS3jHiECA72LWFKrk4D63bYt4WEWbt3VnQbH52Cdk
	iHW0hwRCxz81b1bb9j2Hw==
MIME-Version: 1.0
In-Reply-To: <1267271025.22519.740.camel@laptop>
References: <20100227020242.1384.9945.stgit@austin.mtv.corp.google.com> 
	<1267271025.22519.740.camel@laptop>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 1 Mar 2010 07:44:04 -0800
Message-ID: <af41c7c41003010744m54fc325bjccae0ff6965656eb@mail.gmail.com>
Subject: Re: [PATCH][RESEND] Export per-tid and per-tgid cputime in 
	nanoseconds.
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, kenchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 3:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, 2010-02-26 at 18:03 -0800, Divyesh Shah wrote:
> > This can be used by applications to get finer granularity cputime usage on
> > platforms that use timestamp counters or HPET.
>
> I guess the patch looks good, I'm just not sure what HPET got to do with
> anything.. the scheduler certainly doesn't use HPET for timekeeping, its
> terribly slow to read.

Yes you're right. Please ignore the HPET comment.

>
> Also, it would be good to get some more justification than 'some
> applications can use this', which is basically a truism for any patch
> that adds a user interface.

1) This should be useful for a shared or virtualized environment where
the shared management infrastructure needs to charge each application
as accurately as possible for cpu usage.
2) An application that services different users and does some
cpu-intensive work may want to measure cpu time spent for each user by
the serving thread.

I think applications like web servers, remote database servers, etc.
fit into the second category.

For units of work smaller than a jiffy, this really helps as some
threads could potentially hide from the jiffy based accounting.

Please let me know if you want me to send the patch again with the
corrected description and added justification.

>
> > Signed-off-by: Divyesh Shah<dpshah@google.com>
> > ---
> >
> >  fs/proc/array.c    |   40 ++++++++++++++++++++++++++++++++++++++++
> >  fs/proc/base.c     |    2 ++
> >  fs/proc/internal.h |    2 ++
> >  3 files changed, 44 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > index 13b5d07..54604b8 100644
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -547,3 +547,43 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
> >
> >       return 0;
> >  }
> > +
> > +static int do_task_cputime(struct task_struct *task, char * buffer, int whole)
> > +{
> > +     int res;
> > +     unsigned long flags;
> > +     unsigned long long sum_exec_runtime = 0;
> > +     struct task_struct *t;
> > +
> > +     if (lock_task_sighand(task, &flags)) {
> > +             if (whole) {
> > +                     t = task;
> > +                     /*
> > +                      * Add up live thread sum_exec_runtime at the group
> > +                      * level.
> > +                      */
> > +                     do {
> > +                             sum_exec_runtime += t->se.sum_exec_runtime;
> > +                             t = next_thread(t);
> > +                     } while (t != task);
> > +                     sum_exec_runtime += task->signal->sum_sched_runtime;
> > +             }
> > +             unlock_task_sighand(task, &flags);
> > +     }
> > +
> > +     if (!whole)
> > +             sum_exec_runtime = task->se.sum_exec_runtime;
> > +
> > +     res = sprintf(buffer,"%llu\n", sum_exec_runtime);
> > +     return res;
> > +}
> > +
> > +int proc_tid_cputime(struct task_struct *task, char * buffer)
> > +{
> > +     return do_task_cputime(task, buffer, 0);
> > +}
> > +
> > +int proc_tgid_cputime(struct task_struct *task, char * buffer)
> > +{
> > +     return do_task_cputime(task, buffer, 1);
> > +}
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 58324c2..8fbc785 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -2595,6 +2595,7 @@ static const struct pid_entry tgid_base_stuff[] = {
> >       REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
> >  #endif
> >       REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
> > +     INF("cputime_ns", S_IRUGO, proc_tgid_cputime),
> >       LNK("cwd",        proc_cwd_link),
> >       LNK("root",       proc_root_link),
> >       LNK("exe",        proc_exe_link),
> > @@ -2930,6 +2931,7 @@ static const struct pid_entry tid_base_stuff[] = {
> >       REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
> >  #endif
> >       REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
> > +     INF("cputime_ns", S_IRUGO, proc_tid_cputime),
> >       LNK("cwd",       proc_cwd_link),
> >       LNK("root",      proc_root_link),
> >       LNK("exe",       proc_exe_link),
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index 1f24a3e..f9e9799 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -51,6 +51,8 @@ extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
> >                               struct pid *pid, struct task_struct *task);
> >  extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
> >                               struct pid *pid, struct task_struct *task);
> > +extern int proc_tid_cputime(struct task_struct *, char *);
> > +extern int proc_tgid_cputime(struct task_struct *, char *);
> >  extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
> >
> >  extern const struct file_operations proc_maps_operations;
> >
>
>
