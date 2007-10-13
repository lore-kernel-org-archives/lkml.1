Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXJMFCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXJMFCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXJMFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:01:41 -0400
Received: from [212.12.190.91] ([212.12.190.91]:59721 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751631AbXJMFBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:01:39 -0400
From: Al Boldi <a1426z@gawab.com>
To: Gustavo Chain <g@0xff.cl>
Subject: Re: [PATCH] Reserve N process to root
Date: Sat, 13 Oct 2007 08:01:27 +0300
User-Agent: KMail/1.5
Cc: LKML Kernel <linux-kernel@vger.kernel.org>
References: <200710120002.37341.a1426z@gawab.com> <200710120929.10770.a1426z@gawab.com> <20071012213436.0b53fa23@0xff.cl>
In-Reply-To: <20071012213436.0b53fa23@0xff.cl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710130801.27744.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo Chain wrote:
> Al Boldi <a1426z@gawab.com> escribió:
> > Kyle Moffett wrote:
> > > On Oct 12, 2007, at 01:37:23, Al Boldi wrote:
> > > > You have a point, and resource-controllers can probably control
> > > > DoS a lot better, but the they also incur more overhead.  Think
> > > > of this "lockout prevention" patch as a near zero overhead safety
> > > > valve.
> > >
> > > But why do you need to add "lockout prevention" if it already
> > > exists?
> >
> > I said this before, but I'll say it again: it's about overhead!
> >
> > > With CFS' extremely efficient per-user-scheduling (hopefully
> > > soon to be the default) there are only two forms of lockout by non-
> > > root processes:  (1) Running out of PIDs in the box's PID-space
> > > (think tens or hundreds of thousands of processes), or (2) Swap-
> > > storming the box to death.  To put it bluntly trying to reserve free
> > > PID slots is attacking the wrong end of the problem and your so
> > > called "lockout prevention" could very easily ensure that 10 PIDs
> > > are available even if the user has swapstormed the box with the
> > > PIDs he does have.
> >
> > I think you are reading this wrong.  It's not about reserving PIDs,
> > it's about exceeding the max-threads limit.  This limit is global and
> > affects every user including root, which is good, as this allows the
> > sysadmin to fence the system into a controllable state.  So once the
> > system reaches the fence, sysadmin-intervention allows root to exceed
> > the fence.
> >
> > Again, this is much nicer with real resource-controllers, but again
> > it's also more overhead.
>
> Just an _if()_ ?
>
> may be enable it as an option in kernel config ?

Here is the patch again:

[PATCH 1/1] threads_max: Simple lockout prevention patch

Simple attempt to provide a backdoor in a process lockout situation.

echo $$ > /proc/sys/kernel/su-pid allows pid to exceed the threads_max limit.

Note that this patch incurs zero runtime-overhead.

Signed-off-by: Al Boldi <a1426z@gawab.com>

---
(patch against 2.6.14)

--- kernel/fork.c.orig  2005-11-14 20:55:33.000000000 +0300
+++ kernel/fork.c       2005-11-14 20:58:25.000000000 +0300
@@ -57,6 +57,7 @@
 int nr_threads;                /* The idle threads do not count.. */
 
 int max_threads;               /* tunable limit on nr_threads */
+int su_pid;            /* BackDoor pid to exceed limit on nr_threads */
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
@@ -926,6 +927,7 @@
         * to stop root fork bombs.
         */
        if (nr_threads >= max_threads)
+       if (p->pid != su_pid)
                goto bad_fork_cleanup_count;
 
        if (!try_module_get(p->thread_info->exec_domain->module))


--- kernel/sysctl.c.orig        2005-11-14 20:58:45.000000000 +0300
+++ kernel/sysctl.c     2005-11-14 21:01:20.000000000 +0300
@@ -57,6 +57,7 @@
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int max_threads;
+extern int su_pid;
 extern int sysrq_enabled;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -509,6 +510,14 @@
                .proc_handler   = &proc_dointvec,
        },
        {
+               .ctl_name       = KERN_SU_PID,
+               .procname       = "su-pid",
+               .data           = &su_pid,
+               .maxlen         = sizeof(int),
+               .mode           = 0644,
+               .proc_handler   = &proc_dointvec,
+       },
+       {
                .ctl_name       = KERN_RANDOM,
                .procname       = "random",
                .mode           = 0555,


--- include/linux/sysctl.h.orig 2005-11-14 20:54:55.000000000 +0300
+++ include/linux/sysctl.h      2005-11-14 20:55:15.000000000 +0300
@@ -146,6 +146,7 @@
        KERN_RANDOMIZE=68, /* int: randomize virtual address space */
        KERN_SETUID_DUMPABLE=69, /* int: behaviour of dumps for setuid core 
*/
        KERN_SPIN_RETRY=70,     /* int: number of spinlock retries */
+       KERN_SU_PID=71,         /* int: BackDoor pid to exceed Maximum
+                               /*      nr of threads in the system */
 };


