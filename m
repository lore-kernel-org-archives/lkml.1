Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZJEA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZJEA4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311AbZJEA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:56:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37735 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbZJEA43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:56:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <3e8340490910041105p327396e8v39b1a3454c0922bf@mail.gmail.com>
References: <2f11576a0910040744u575d3afbwd2e27e811060f206@mail.gmail.com> <3e8340490910041105p327396e8v39b1a3454c0922bf@mail.gmail.com>
Message-Id: <20091005095121.5F7A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 09:55:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Oct 4, 2009 at 10:44 AM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
> > Hi
> >
> >
> >>>>> -       // If the nul at the end of args has been overwritten, then
> >>>>> -       // assume application is using setproctitle(3).
> >>>>> -       if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> >>>>> +       if (mm->arg_end != mm->env_start) {
> >>>>> +               // PR_SET_PROCTITLE_AREA used
> >>>>> +               res = strnlen(buffer, res);
> >>>>
> >>>> Is this check really needed? Surely it's enough to simply state that
> >>>> behavior if the area isn't null-terminated is undefined.
> >>>
> >>> Well, that depends. I was hoping to use the syscall only once per process.
> >>> That would allow me to just update the process title whenever I feel like
> >>> it, possibly hundreds of times per second. This is much cheaper if I don't
> >>> have to use a syscall every time.
> >>>
> >>> So if I'm setting the PR_SET_PROCTITLE_AREA initially to e.g. 1 kB memory
> >>> area, without the above code ps will show it entirely regardless of any \0
> >>> characters (because parameters are separated by \0).
> >>
> >> That makes sense - but note that it's not completely atomic still -
> >> with a syscall you could insert some kind of barrier (rwsem?) to
> >> ensure other processes don't see a halfway updated process name. With
> >> infrequent updates this isn't a problem, but if you're really
> >> intending to update it at a rate where syscall overhead becomes a
> >> problem, then you're also going to see these kinds of issues as well.
> >
> >
> > Yes.  this patch seems buggy. The lock is necessary.
> > following scenario makes disaster, I think.
> >
> > CPU0 (prctl caller)                                CPU1 (ps)
> > -------------------------------------------------------------------------------------------
> > mm->arg_start = arg2;
> >                                                                len =
> > mm->arg_end - mm->arg_start; in proc_pid_cmdline()
> > mm->arg_end = arg3;
> >
> 
> Since len is unsigned and clamped to PAGE_SIZE, the worst this will do
> is expose one page of userspace memory starting at the new value of
> arg_start. Note that this can also happen currently, exposing one env
> variable, when all NULs in the argument array have been overwritten,
> but before the new NUL has been written (that is, there is no NUL
> terminator from arg_start until the end of envp[0]).
> 
> It is, however, still undesirable, of course, particularly if
> userspace isn't prepared for this kind of thing to happen.

The improvement idea is here.


Changelog
  - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
 -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)

======================================================================
Subject: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()

Currently, glibc2 doesn't have setproctitle(3). it lead userland daemon
 to use brutal stack modification.

In the first implession, It seems no problem at all. however, carefully
inspection spot the weaknes of the way.

example:

 % ps -ef |grep avahi-daemon
 avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]
 avahi     1680  1679  0 09:20 ?        00:00:00 avahi-daemon: chroot helper

 # cat /proc/1679/cmdline
 avahi-daemon: running [kosadesk.local]

ok. seems good.
but...

 # cat /proc/1679/environ
 adesk.local]

Doh, this daemon has overwritten envrionment string area.

Recently, many security folks is thinking information leak is
security risk. then many administrator unset almost environment
variable before starting the daemon.
  e.g.
    env - MINIMUM-NEED-VAR=foo /path/to/daemon

it mean, we don't have enough string space now.

Thus, this patch implement new prctl. prctl(PR_SET_PROCTITLE_AREA)
updates mm_struct->arg_start and arg_end to the given pointers,
which makes it possible for user space to implement
setproctitle(3) cleanly.


 test program:
 ================================================
 #define ERR(str) (perror(str), exit(1))

 void settitle(char* title){
         int err;

         err = prctl(34, title, strlen(title)+1);
         if (err < 0)
                 ERR("prctl ");
 }

 void main(void){
         long i;
         char buf[1024];

         for (i = 0; i < 10000000000LL; i++){
                 sprintf(buf, "loooooooooooooooooooooooong string %d",i);
                 settitle(buf);
         }
 }
 ==================================================

Cc: Bryan Donlan <bdonlan@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Timo Sirainen <tss@iki.fi>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c        |   46 +++++++++++++++++++++++++++++++++++-----------
 include/linux/prctl.h |    4 ++++
 kernel/sys.c          |   23 +++++++++++++++++++++++
 3 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f742f6..f266482 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -254,22 +254,46 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
 	unsigned int len;
-	struct mm_struct *mm = get_task_mm(task);
-	if (!mm)
+	struct mm_struct *mm;
+	unsigned long arg_start;
+	unsigned long arg_end;
+
+	task_lock(task);
+	mm = task->mm;
+	if (task->flags & PF_KTHREAD)
+		mm = NULL;
+	if (!mm) {
+		task_unlock(task);
 		goto out;
-	if (!mm->arg_end)
-		goto out_mm;	/* Shh! No looking before we're done */
+	}
+
+	atomic_inc(&mm->mm_users);
+
+	/* task_lock protect mm->arg_{start,end} too */
+	arg_start = mm->arg_start;
+	arg_end   = mm->arg_end;
+	len = arg_end - arg_start;
+
+	task_unlock(task);
+
+	/* The process was not constructed yet? */
+	if (!arg_end)
+		goto out_mm;
 
- 	len = mm->arg_end - mm->arg_start;
- 
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
- 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
 
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
-	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
+	res = access_process_vm(task, arg_start, buffer, len, 0);
+
+	if (arg_end != mm->env_start)
+		/* PR_SET_PROCTITLE_AREA used */
+		res = strnlen(buffer, res);
+	else if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
+		/*
+		 * If the nul at the end of args has been overwritten, then
+		 * assume application is using sendmail's SPT_REUSEARGV style
+		 * argv override.
+		 */
 		len = strnlen(buffer, res);
 		if (len < res) {
 		    res = len;
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index b00df4c..feffb17 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -88,4 +88,8 @@
 #define PR_TASK_PERF_COUNTERS_DISABLE		31
 #define PR_TASK_PERF_COUNTERS_ENABLE		32
 
+
+/* Set process title memory area for setproctitle() */
+#define PR_SET_PROCTITLE_AREA 34
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index b3f1097..fe4fbf1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1528,6 +1528,29 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				current->timer_slack_ns = arg2;
 			error = 0;
 			break;
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+			unsigned long addr = arg2;
+			unsigned long len = arg3;
+			unsigned long end = arg2 + arg3;
+
+			if (len > PAGE_SIZE)
+				return -EINVAL;
+
+			if (addr >= end)
+				return -EINVAL;
+
+			if (!access_ok(VERIFY_READ, addr, len)) {
+				return -EFAULT;
+			}
+
+			task_lock(current);
+			mm->arg_start = addr;
+			mm->arg_end = addr + len;
+			task_unlock(current);
+
+			return 0;
+		}
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.2.5





