Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXITR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXITR5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbXITR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:57:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbXITR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:57:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:content-type:organization:date:
	message-id:mime-version:x-mailer:content-transfer-encoding;
	b=owxj7AKBmp5zGo1Ib5dKbJQ5t5Edf9DPhe+DEB1sVDg1HL4bbn1UrUQX/pOlRH+UC
	FQwK+c2HT3OTpoPZzXB5w==
Subject: [PATCH getrusage: return ru_maxrss
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 20 Sep 2007 10:57:19 -0700
Message-Id: <1190311039.13070.19.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Properly support the ru_maxrss field of the rusage structure returned by
getrusage().  This patch includes documentation both of the getrusage()
implementation in general and of the ru_maxrss implementation
specifically.  This implementation matches that of FreeBSD, which is the
only other OS of which I'm aware that implements this field.

Like a number of other folks, we recently had a need for a non-/proc way
of getting the RSS of a process and happened on getrusage().  Unlike the
rest, though, we fixed the system call to do what we want.  I wrote a
wrong implementation and submitted it while I was sick; this time I took
my time and I think I got it right.

A test program that has been run against a number of systems (of which
only FreeBSD and Linux 2.6 with this patch applied passed) is also
available at
	http://www.exit.com/Archives/Linux/

Signed-off-by:  Frank Mayhar <fmayhar@google.com>

---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3de7901..85735af 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -518,6 +518,7 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
+	unsigned long cmaxrss;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
@@ -1027,6 +1028,8 @@ #endif
 	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
+/* maxrss gets the hiwater_rss in do_exit() */
+	unsigned long maxrss;
 
   	cputime_t it_prof_expires, it_virt_expires;
 	unsigned long long it_sched_expires;
diff --git a/kernel/exit.c b/kernel/exit.c
index 06b24b3..390d834 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -127,6 +127,8 @@ static void __exit_signal(struct task_st
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
+		if (tsk->maxrss > sig->cmaxrss)
+			sig->cmaxrss = tsk->maxrss;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -957,6 +959,14 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->mm) {
 		update_hiwater_rss(tsk->mm);
 		update_hiwater_vm(tsk->mm);
+		BUG_ON(tsk->maxrss != 0);
+		/*
+		 * Store the hiwater_rss in a task field, since when we need
+		 * it in __exit_signal() the mm structure is gone; we can't
+		 * stuff it in the signal structure since then we would be
+		 * racing with wait_task_zombie().
+		 */
+		tsk->maxrss = tsk->mm->hiwater_rss;
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
@@ -1265,6 +1275,17 @@ static int wait_task_zombie(struct task_
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
+		/*
+		 * Save the maximum RSS of this task and all its terminated,
+		 * waited-for children.  Don't accumulate the RSS since, one,
+		 * other operating systems (FreeBSD, AIX) do it this way and,
+		 * two, the cumulative RSS of a long-lived process with lots
+		 * of sequential child process would be meaningless.
+		 */
+		if (sig->cmaxrss > psig->cmaxrss)
+			psig->cmaxrss = sig->cmaxrss;
+		if (p->maxrss > psig->cmaxrss)
+			psig->cmaxrss = p->maxrss;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 7332e23..fae76dd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -536,6 +536,7 @@ static int copy_mm(unsigned long clone_f
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
+	tsk->maxrss = 0;
 
 	tsk->mm = NULL;
 	tsk->active_mm = NULL;
@@ -881,6 +882,7 @@ static inline int copy_signal(unsigned l
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	sig->sum_sched_runtime = 0;
+	sig->cmaxrss = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
diff --git a/kernel/sys.c b/kernel/sys.c
index 1b33b05..e450bab 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2099,6 +2099,7 @@ static void k_getrusage(struct task_stru
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			r->ru_maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -2124,11 +2125,15 @@ static void k_getrusage(struct task_stru
 				r->ru_oublock += task_io_get_oublock(t);
 				t = next_thread(t);
 			} while (t != p);
+			update_hiwater_rss(p->mm);
+			if (r->ru_maxrss < p->mm->hiwater_rss)
+				r->ru_maxrss = p->mm->hiwater_rss;
 			break;
 
 		default:
 			BUG();
 	}
+	r->ru_maxrss <<= PAGE_SHIFT - 10; /* Convert from pages to kilobytes. */
 
 	unlock_task_sighand(p, &flags);
 	rcu_read_unlock();

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

