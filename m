Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbXEYMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbXEYMr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbXEYMru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:47:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbXEYMrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:47:49 -0400
Date: Fri, 25 May 2007 14:46:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070525124652.GA24038@elte.hu>
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524080959.GA29151@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> btw., CFS does this change to fs/proc/array.c:
> 
> @@ -410,6 +408,14 @@ static int do_task_stat(struct task_stru
>  	/* convert nsec -> ticks */
>  	start_time = nsec_to_clock_t(start_time);
>  
> +	/*
> +	 * Use CFS's precise accounting, if available:
> +	 */
> +	if (!has_rt_policy(task)) {
> +		utime = nsec_to_clock_t(task->sum_exec_runtime);
> +		stime = 0;
> +	}
> +
>  	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
>  %lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu %llu\n",
> 
> if you have some spare capacity to improve this code, it could be 
> further enhanced by not setting 'stime' to zero, but using the 
> existing jiffies based utime/stime statistics as a _ratio_ to split up 
> the precise p->sum_exec_runtime. That way we dont have to add precise 
> accounting to syscall entry/exit points (that would be quite 
> expensive), but still the sum of utime+stime would be very precise. 
> (and that's what matters most anyway)

i found an accounting bug in this: it didnt sum up threads correctly. 
The patch below fixes this. The stime == 0 problem is still there 
though.

	Ingo

Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -310,6 +310,29 @@ int proc_pid_status(struct task_struct *
 	return buffer - orig;
 }
 
+static clock_t task_utime(struct task_struct *p)
+{
+	/*
+	 * Use CFS's precise accounting, if available:
+	 */
+	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
+		return nsec_to_clock_t(p->sum_exec_runtime);
+
+	return cputime_to_clock_t(p->utime);
+}
+
+static clock_t task_stime(struct task_struct *p)
+{
+	/*
+	 * Use CFS's precise accounting, if available:
+	 */
+	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
+		return 0;
+
+	return cputime_to_clock_t(p->stime);
+}
+
+
 static int do_task_stat(struct task_struct *task, char * buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -324,7 +347,8 @@ static int do_task_stat(struct task_stru
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime, utime, stime;
+	cputime_t cutime, cstime;
+	clock_t utime, stime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -342,7 +366,8 @@ static int do_task_stat(struct task_stru
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = cputime_zero;
+	cutime = cstime = cputime_zero;
+	utime = stime = 0;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -368,15 +393,15 @@ static int do_task_stat(struct task_stru
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
+				utime += task_utime(t);
+				stime += task_stime(t);
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime = cputime_add(utime, sig->utime);
-			stime = cputime_add(stime, sig->stime);
+			utime += cputime_to_clock_t(sig->utime);
+			stime += cputime_to_clock_t(sig->stime);
 		}
 
 		sid = signal_session(sig);
@@ -392,8 +417,8 @@ static int do_task_stat(struct task_stru
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		utime = task->utime;
-		stime = task->stime;
+		utime = task_utime(task);
+		stime = task_stime(task);
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
@@ -408,14 +433,6 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	/*
-	 * Use CFS's precise accounting, if available:
-	 */
-	if (!has_rt_policy(task)) {
-		utime = nsec_to_clock_t(task->sum_exec_runtime);
-		stime = 0;
-	}
-
 	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu %llu\n",
