Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbYEUXgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbYEUXgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYEUXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:36:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40220 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYEUXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:36:13 -0400
Date: Wed, 21 May 2008 16:35:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mark <markkicks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Message-Id: <20080521163503.000afd61.randy.dunlap@oracle.com>
In-Reply-To: <82fa9e310805211551oea0dfd9mdb7dfaed2b2d98fc@mail.gmail.com>
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	<20080521132845.72db5748.randy.dunlap@oracle.com>
	<82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	<48348AFA.1070900@oracle.com>
	<82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
	<20080521143248.baee1391.randy.dunlap@oracle.com>
	<82fa9e310805211551oea0dfd9mdb7dfaed2b2d98fc@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 15:51:55 -0700 mark wrote:

> On Wed, May 21, 2008 at 2:32 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Wed, 21 May 2008 14:08:53 -0700 mark wrote:
> >
> >> On Wed, May 21, 2008 at 1:50 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> > mark wrote:
> >> >>
> >> >> On Wed, May 21, 2008 at 1:28 PM, Randy Dunlap <randy.dunlap@oracle.com>
> >> >> wrote:
> >> >>>
> >> >>> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
> >> >>>>
> >> >>>> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
> >> >>>> error when I try to login to the box, kill a pr start a python app, or
> >> >>>> do anything on a regular basis.
> >> >>>>
> >> >>>> fork: Resource temporarily unavailable

[snip]

> >> >>> The only place that fork() returns EAGAIN is for number of
> >> >>> processes being >= its limit.  Does this user already have >= 1024
> >> >>> processes?
> >> >>
> >> >> No, it is around 400
> >> >
> >> > Well, my comment was wrong anyway.  There are several other tests just
> >> > below number of user processes that also return EAGAIN, like:
> >> >
> >> > - total number of threads being too large
> >
> > Total number of threads currently running is in /proc/loadavg:
> >
> >> cat /proc/loadavg
> > 1.56 0.58 0.27 2/203 28500
> >
> > It's the number following the '/', e.g., 203 on my desktop system.
> >
> > max_threads allowed is a sysctl, so you can tune it if needed.
> > It's in /proc/sys/kernel/threads-max:
> >
> >> cat /proc/sys/kernel/threads-max
> > 32624
> > I sort of doubt that one is the problem, but you can tell us.
> 
> cat /proc/loadavg
> 0.39 0.45 0.57 1/1412 12032
> cat /proc/sys/kernel/threads-max
> 274432
> you are right, i guess this is not the problem.
> 
> 
> >> > - error on grabbing a module reference count (?)
> >> > - error on grabbing a binfmt module reference
> >>
> >> as a user how do i identify what is wrong, and fix this? for total
> >> number of threads -> is there anyway i can find out if this is causing
> >> the problem? my system is running around 80 multi-threaded python web
> >> apps.
> >
> > I can send you some debug patches that will print out the specific
> > problem area.  Do you want to do that?  Can you rebuild and install
> > a new kernel?
> Is it possible to get this debug messages by turning on some flags?
> If not yes, pl. send debug patches. its a live box and  I will try to do it!
> 
> This is my system / kernel info:
> uname -a
> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
> x86_64 x86_64 x86_64 GNU/Linux

I made a small patch to a vanilla kernel.org 2.6.25.3 kernel tree.
Hopefully it applies cleanly to that fc9 kernel source, but check/verify
that first before going any further.

After building and booting with this patch, there will be kernel
messages whenever fork's "copy_process" function fails with -EAGAIN (-11),
which is reported to userspace as errno = 11 (Resource temporarily
unavailable).  Hopefully this will identify which test is failing,
but there's a chance that something else is going on and that this
patch does not find the problem.

Anyway, good luck and please report back on it.

---

---
 kernel/fork.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6.25.3.orig/kernel/fork.c
+++ linux-2.6.25.3/kernel/fork.c
@@ -1049,8 +1049,10 @@ static struct task_struct *copy_process(
 	if (atomic_read(&p->user->processes) >=
 			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->user != current->nsproxy->user_ns->root_user)
+		    p->user != current->nsproxy->user_ns->root_user) {
+			printk(KERN_INFO "%s: error on #processes\n", __func__);
 			goto bad_fork_free;
+		}
 	}
 
 	atomic_inc(&p->user->__count);
@@ -1062,14 +1064,20 @@ static struct task_struct *copy_process(
 	 * triggers too late. This doesn't hurt, the check is only there
 	 * to stop root fork bombs.
 	 */
-	if (nr_threads >= max_threads)
+	if (nr_threads >= max_threads) {
+		printk(KERN_INFO "%s: error on #threads\n", __func__);
 		goto bad_fork_cleanup_count;
+	}
 
-	if (!try_module_get(task_thread_info(p)->exec_domain->module))
+	if (!try_module_get(task_thread_info(p)->exec_domain->module)) {
+		printk(KERN_INFO "%s: error on exec_domain->module\n", __func__);
 		goto bad_fork_cleanup_count;
+	}
 
-	if (p->binfmt && !try_module_get(p->binfmt->module))
+	if (p->binfmt && !try_module_get(p->binfmt->module)) {
+		printk(KERN_INFO "%s: error on binfmt->module\n", __func__);
 		goto bad_fork_cleanup_put_domain;
+	}
 
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
