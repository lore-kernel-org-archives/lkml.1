Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAGNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAGNTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYAGNTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:19:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbYAGNTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:19:08 -0500
Date: Mon, 7 Jan 2008 14:18:35 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
 priority
Message-ID: <20080107141835.44bdc7c6@brian.englab.brq.redhat.com>
In-Reply-To: <20080107022513.3ac05734.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<20080107110603.09b72450@brian.englab.brq.redhat.com>
	<20080107022513.3ac05734.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 02:25:13 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 7 Jan 2008 11:06:03 +0100 Michal Schmidt
> <mschmidt@redhat.com> wrote:
> 
> > On Sat, 22 Dec 2007 01:30:21 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Mon, 17 Dec 2007 23:43:14 +0100 Michal Schmidt
> > > <mschmidt@redhat.com> wrote:
> > > 
> > > > kthreadd, the creator of other kernel threads, runs as a normal
> > > > priority task. This is a potential for priority inversion when a
> > > > task wants to spawn a high-priority kernel thread. A middle
> > > > priority SCHED_FIFO task can block kthreadd's execution
> > > > indefinitely and thus prevent the timely creation of the
> > > > high-priority kernel thread. 
> > > > This causes a practical problem. When a runaway real-time task
> > > > is eating 100% CPU and we attempt to put the CPU offline,
> > > > sometimes we block while waiting for the creation of the
> > > > highest-priority "kstopmachine" thread. 
> > > > 
> > > > The fix is to run kthreadd with the highest possible SCHED_FIFO
> > > > priority. Its children must still run as slightly negatively
> > > > reniced SCHED_NORMAL tasks.
> > > 
> > > Did you hit this problem with the stock kernel, or have you been
> > > working on other stuff?
> > 
> > This was with RHEL5 and with current Fedora kernels.
> > 
> > > A locked-up SCHED_FIFO process will cause kernel threads all
> > > sorts of problems.  You've hit one instance, but there will be
> > > others. (pdflush stops working, for one).
> > > 
> > > The general approach we've taken to this is "don't do that".
> > > Yes, we could boost lots of kernel threads in the way which this
> > > patch does but this actually takes control *away* from
> > > userspace.  Userspace no longer has the ability to guarantee
> > > itself minimum possible latency without getting preempted by
> > > kernel threads.
> > > 
> > > And yes, giving userspace this minimum-latency capability does
> > > imply that userspace has a responsibility to not 100% starve
> > > kernel threads.  It's a reasonable compromise, I think?
> > 
> > You're right. We should not run kthreadd with SCHED_FIFO by default.
> > But the user should be able to change it using chrt if he wants to
> > avoid this particular problem. So how about this instead?:
> > 
> > 
> > 
> > kthreadd, the creator of other kernel threads, runs as a normal
> > priority task. This is a potential for priority inversion when a
> > task wants to spawn a high-priority kernel thread. A middle
> > priority SCHED_FIFO task can block kthreadd's execution
> > indefinitely and thus prevent the timely creation of the
> > high-priority kernel thread.
> > 
> > This causes a practical problem. When a runaway real-time task is
> > eating 100% CPU and we attempt to put the CPU offline, sometimes we
> > block while waiting for the creation of the highest-priority
> > "kstopmachine" thread.
> > 
> > This could be solved by always running kthreadd with the highest
> > possible SCHED_FIFO priority, but that would be undesirable policy
> > decision in the kernel. kthreadd would cause unwanted latencies
> > even for the realtime users who know what they're doing.
> > 
> > Let's not make the decision for the user. Just allow the
> > administrator to change kthreadd's priority safely if he chooses to
> > do it. Ensure that the kernel threads are created with the usual
> > nice level even if kthreadd's priority is changed from the default.
> > 
> > Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> > ---
> >  kernel/kthread.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index dcfe724..e832a85 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -94,10 +94,21 @@ static void create_kthread(struct
> > kthread_create_info *create) if (pid < 0) {
> >  		create->result = ERR_PTR(pid);
> >  	} else {
> > +		struct sched_param param = { .sched_priority = 0 };
> >  		wait_for_completion(&create->started);
> >  		read_lock(&tasklist_lock);
> >  		create->result = find_task_by_pid(pid);
> >  		read_unlock(&tasklist_lock);
> > +		/*
> > +		 * root may want to change our (kthreadd's)
> > priority to
> > +		 * realtime to solve a corner case priority
> > inversion problem
> > +		 * (a realtime task consuming 100% CPU blocking
> > the creation of
> > +		 * kernel threads). The kernel thread should not
> > inherit the
> > +		 * higher priority. Let's always create it with
> > the usual nice
> > +		 * level.
> > +		 */
> > +		sched_setscheduler(create->result, SCHED_NORMAL,
> > &param);
> > +		set_user_nice(create->result, -5);
> >  	}
> >  	complete(&create->done);
> >  }
> 
> Seems reasonable.
> 
> As a followup thing, we now have two hard-coded magical -5's in
> kthread.c. It'd be nice to add a #define for this.

Done.

> It'd be nicer to work out where on earth that -5 came from too ;)
> 
> Readers might wonder why kthreadd children disinherit kthreadd's
> policy and priority, but retain its cpus_allowed (and whatever other
> stuff root could have altered?)

It's a good idea to reset the CPU mask too.


Allow the administrator to change kthreadd's priority and affinity.
Ensure that the kernel threads are created with the usual nice level
and affinity even if kthreadd's properties were changed from the
default.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index dcfe724..0ac8878 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -15,6 +15,8 @@
 #include <linux/mutex.h>
 #include <asm/semaphore.h>
 
+#define KTHREAD_NICE_LEVEL (-5)
+
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
@@ -94,10 +96,18 @@ static void create_kthread(struct kthread_create_info *create)
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
 	} else {
+		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
 		read_lock(&tasklist_lock);
 		create->result = find_task_by_pid(pid);
 		read_unlock(&tasklist_lock);
+		/*
+		 * root may have changed our (kthreadd's) priority or CPU mask.
+		 * The kernel thread should not inherit these properties.
+		 */
+		sched_setscheduler(create->result, SCHED_NORMAL, &param);
+		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
+		set_cpus_allowed(create->result, CPU_MASK_ALL);
 	}
 	complete(&create->done);
 }
@@ -221,7 +231,7 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_user_nice(tsk, -5);
+	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed(tsk, CPU_MASK_ALL);
 
 	current->flags |= PF_NOFREEZE;
