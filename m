Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYAGLXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYAGLXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYAGLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:22:54 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:38810 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYAGLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NMj0+5rxp3X54eRV2z2nun9hPzHhStjB5yrx0v99m8rjfPZELpDyYNF2FYHzB9GL72vCT2vygH6tHLQC3X4A17ZVhTkujjW+b2dLWJvPRqgJd4zK6cYU+yMEo6KbzEQRiaIblSpz02SBPlRVyj0IVA25AdLqyweXGSCyXz5cIVw=
Message-ID: <3efb10970801070322w38cf53acy75b352c44ad049b8@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:22:51 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Michal Schmidt" <mschmidt@redhat.com>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal priority
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jon Masters" <jcm@redhat.com>,
       "Satoru Takeuchi" <takeuchi_satoru@jp.fujitsu.com>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20080107110603.09b72450@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <20080107110603.09b72450@brian.englab.brq.redhat.com>
X-Google-Sender-Auth: 45e8ea72bcb6877c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal and Andrew,

> Let's not make the decision for the user. Just allow the administrator to
> change kthreadd's priority safely if he chooses to do it. Ensure that the
> kernel threads are created with the usual nice level even if kthreadd's
> priority is changed from the default.

Last year, I posted a patchset (that was meant for Preempt-RT at that
time) to be able to prioritise the interrupt-handler-threads (which
are kthreads) and softirq-threads from the kernel commandline. See
http://lkml.org/lkml/2007/12/19/208

Maybe we can find a way to use a similar mechanism as I used in my
patchset for the priorities of the remaining kthreads.
I do not like the way of forcing userland to change the priorities,
because that would require a userland with the chrt tool installed,
and that is not that practical for embedded systems (in which there
could be cases that there is no userland at all, or the init-process
is the whole embedded application). In that case an option to do it on
the kernel commandline is more practical.

I propose this kernel cmd-line option:
kthread_pmap=somethread:50,otherthread:12,34

Then threads can be started as SCHED_NORMAL, and when overruled inside
the kthread-sources itself, or by the kernel commandline, the user can
set them to something else.

What do you think of this?

(notice that I am reworking the review comments I received on this
patch-series right now, and that I can take such change into account
immediately)

Kind Regards,

Remy

2008/1/7, Michal Schmidt <mschmidt@redhat.com>:
> On Sat, 22 Dec 2007 01:30:21 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Mon, 17 Dec 2007 23:43:14 +0100 Michal Schmidt
> > <mschmidt@redhat.com> wrote:
> >
> > > kthreadd, the creator of other kernel threads, runs as a normal
> > > priority task. This is a potential for priority inversion when a
> > > task wants to spawn a high-priority kernel thread. A middle priority
> > > SCHED_FIFO task can block kthreadd's execution indefinitely and thus
> > > prevent the timely creation of the high-priority kernel thread.
> > >
> > > This causes a practical problem. When a runaway real-time task is
> > > eating 100% CPU and we attempt to put the CPU offline, sometimes we
> > > block while waiting for the creation of the highest-priority
> > > "kstopmachine" thread.
> > >
> > > The fix is to run kthreadd with the highest possible SCHED_FIFO
> > > priority. Its children must still run as slightly negatively reniced
> > > SCHED_NORMAL tasks.
> >
> > Did you hit this problem with the stock kernel, or have you been
> > working on other stuff?
>
> This was with RHEL5 and with current Fedora kernels.
>
> > A locked-up SCHED_FIFO process will cause kernel threads all sorts of
> > problems.  You've hit one instance, but there will be others.
> > (pdflush stops working, for one).
> >
> > The general approach we've taken to this is "don't do that".  Yes, we
> > could boost lots of kernel threads in the way which this patch does
> > but this actually takes control *away* from userspace.  Userspace no
> > longer has the ability to guarantee itself minimum possible latency
> > without getting preempted by kernel threads.
> >
> > And yes, giving userspace this minimum-latency capability does imply
> > that userspace has a responsibility to not 100% starve kernel
> > threads.  It's a reasonable compromise, I think?
>
> You're right. We should not run kthreadd with SCHED_FIFO by default.
> But the user should be able to change it using chrt if he wants to
> avoid this particular problem. So how about this instead?:
>
>
>
> kthreadd, the creator of other kernel threads, runs as a normal priority task.
> This is a potential for priority inversion when a task wants to spawn a
> high-priority kernel thread. A middle priority SCHED_FIFO task can block
> kthreadd's execution indefinitely and thus prevent the timely creation of the
> high-priority kernel thread.
>
> This causes a practical problem. When a runaway real-time task is eating 100%
> CPU and we attempt to put the CPU offline, sometimes we block while waiting for
> the creation of the highest-priority "kstopmachine" thread.
>
> This could be solved by always running kthreadd with the highest possible
> SCHED_FIFO priority, but that would be undesirable policy decision in the
> kernel. kthreadd would cause unwanted latencies even for the realtime users who
> know what they're doing.
>
> Let's not make the decision for the user. Just allow the administrator to
> change kthreadd's priority safely if he chooses to do it. Ensure that the
> kernel threads are created with the usual nice level even if kthreadd's
> priority is changed from the default.
>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  kernel/kthread.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index dcfe724..e832a85 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -94,10 +94,21 @@ static void create_kthread(struct kthread_create_info *create)
>         if (pid < 0) {
>                 create->result = ERR_PTR(pid);
>         } else {
> +               struct sched_param param = { .sched_priority = 0 };
>                 wait_for_completion(&create->started);
>                 read_lock(&tasklist_lock);
>                 create->result = find_task_by_pid(pid);
>                 read_unlock(&tasklist_lock);
> +               /*
> +                * root may want to change our (kthreadd's) priority to
> +                * realtime to solve a corner case priority inversion problem
> +                * (a realtime task consuming 100% CPU blocking the creation of
> +                * kernel threads). The kernel thread should not inherit the
> +                * higher priority. Let's always create it with the usual nice
> +                * level.
> +                */
> +               sched_setscheduler(create->result, SCHED_NORMAL, &param);
> +               set_user_nice(create->result, -5);
>         }
>         complete(&create->done);
>  }
> --
> 1.5.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
