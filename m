Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYIJL5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYIJL5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYIJL5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:57:14 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:46591 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYIJL5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=X5CqfD0OCKLtW9g32+7UuYUejx5LGXxVUBlt7GaOJlEkpvcePmpNAZqEBFiwb6fqFT
         3ZM34zuttiCjVl23KdMIEkw/LY6G7YCpzjvdEcrvmWycSCXF2+0PqBPo8NVhcb8T8Aeo
         8nkkHeUn+YTpMh8J3OhuLg4PsDhgGpaA3IITQ=
Message-ID: <cfd18e0f0809100457u13b8c25ax7c631f81eddb7893@mail.gmail.com>
Date: Wed, 10 Sep 2008 13:57:09 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD extension
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <1221038894.8848.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220278355.3866.21.camel@localhost.localdomain>
	 <517f3f820809090845o5dc772f8r2308a6c010f69561@mail.gmail.com>
	 <1221038894.8848.9.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys,

On 9/10/08, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> On Tue, 2008-09-09 at 17:45 +0200, Michael Kerrisk wrote:
> > > Patch is run tested. I will post test program etc as a reply.
> >
> > Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>
> >
> > Please do CC me on API changes, so that they might get documented in
> > the man pages.
> >
> > Thanks for this work.  (I'm not sure whether or not it's a response to
> > my bug report, http://bugzilla.kernel.org/show_bug.cgi?id=6258 )
>
> I worked on it because of this bug report:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=455251

(That report is inaccessible, although I have some kind of bugzilla
login there: "You are not authorized to access bug #455251.")

> > I tested your patch.  Most things seem to work as I would expect, but
> > there is one strangeness.
> >
> > I would expect
> > setpriority(PRIO_PROCESS, getpid())
> > and
> > setpriority(PRIO_PROCESS, 0)
> > to have the same affect (because: which == PRIO_PRCESS, who == 0
> > conventionally means "the calling process").
> >
> > But they do not: the latter call only changes the priority of the
> > calling thread.  Is this intended?
>
> No, it was not intended. I think this error is here:
>
> +               case PRIO_PROCESS:
> +                       if (who)
> +                               pid = find_vpid(who);
> +                       else {
> +                               pid = task_pid(current);
> +                               who = current->pid;
> +                       }
>
> I was confused. ->pid is TID, had to use ->tgid to get PID.

(Indeed as I read Chris Freiesen's mail I almost tripped up with the
same confusion.  The source code names of these fields can easily lead
to confusions like that.)

> The fix: replace
> who = current->pid;
> with
> who = current->tgid;
> There are two places where you need to do it.
>
> Updated patch is below.

Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>

With your suggested change, things now work as I would expect.  Thanks!

Cheers,

Michael

> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> --
> vda
>
>
>
> diff --git a/include/linux/resource.h b/include/linux/resource.h
> index aaa423a..f292690 100644
> --- a/include/linux/resource.h
> +++ b/include/linux/resource.h
> @@ -51,6 +51,7 @@ struct rlimit {
>  #define        PRIO_PROCESS    0
>  #define        PRIO_PGRP       1
>  #define        PRIO_USER       2
> +#define        PRIO_THREAD     3
>
>  /*
>  * Limit the stack by to some sane default: root can always
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 038a7bc..d339c1a 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -142,9 +142,9 @@ asmlinkage long sys_setpriority(int which, int who,
> int niceval)
>        struct task_struct *g, *p;
>        struct user_struct *user;
>        int error = -EINVAL;
> -       struct pid *pgrp;
> +       struct pid *pgrp, *pid;
>
> -       if (which > PRIO_USER || which < PRIO_PROCESS)
> +       if (which > PRIO_THREAD || which < PRIO_PROCESS)
>                goto out;
>
>        /* normalize: avoid signed division (rounding problems) */
> @@ -156,7 +156,7 @@ asmlinkage long sys_setpriority(int which, int who,
> int niceval)
>
>        read_lock(&tasklist_lock);
>        switch (which) {
> -               case PRIO_PROCESS:
> +               case PRIO_THREAD:
>                        if (who)
>                                p = find_task_by_vpid(who);
>                        else
> @@ -164,6 +164,19 @@ asmlinkage long sys_setpriority(int which, int who,
> int niceval)
>                        if (p)
>                                error = set_one_prio(p, niceval, error);
>                        break;
> +               case PRIO_PROCESS:
> +                       if (who)
> +                               pid = find_vpid(who);
> +                       else {
> +                               pid = task_pid(current);
> +                               who = current->tgid;
> +                       }
> +                       do_each_pid_thread(pid, PIDTYPE_PID, p) {
> +                               if (who == p->pid || who == p->tgid) {
> +                                       error = set_one_prio(p, niceval, error);
> +                               }
> +                       } while_each_pid_thread(pid, PIDTYPE_PID, p);
> +                       break;
>                case PRIO_PGRP:
>                        if (who)
>                                pgrp = find_vpid(who);
> @@ -206,14 +219,14 @@ asmlinkage long sys_getpriority(int which, int
> who)
>        struct task_struct *g, *p;
>        struct user_struct *user;
>        long niceval, retval = -ESRCH;
> -       struct pid *pgrp;
> +       struct pid *pgrp, *pid;
>
> -       if (which > PRIO_USER || which < PRIO_PROCESS)
> +       if (which > PRIO_THREAD || which < PRIO_PROCESS)
>                return -EINVAL;
>
>        read_lock(&tasklist_lock);
>        switch (which) {
> -               case PRIO_PROCESS:
> +               case PRIO_THREAD:
>                        if (who)
>                                p = find_task_by_vpid(who);
>                        else
> @@ -224,6 +237,21 @@ asmlinkage long sys_getpriority(int which, int who)
>                                        retval = niceval;
>                        }
>                        break;
> +               case PRIO_PROCESS:
> +                       if (who)
> +                               pid = find_vpid(who);
> +                       else {
> +                               pid = task_pid(current);
> +                               who = current->tgid;
> +                       }
> +                       do_each_pid_thread(pid, PIDTYPE_PID, p) {
> +                               if (who == p->pid || who == p->tgid) {
> +                                       niceval = 20 - task_nice(p);
> +                                       if (niceval > retval)
> +                                               retval = niceval;
> +                               }
> +                       } while_each_pid_thread(pid, PIDTYPE_PID, p);
> +                       break;
>                case PRIO_PGRP:
>                        if (who)
>                                pgrp = find_vpid(who);
>
>
>
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
