Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXHPITF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXHPITF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761723AbXHPISp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:18:45 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:30174 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbXHPISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:18:43 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RFC] Re: accounting regression since rc1
Date: Thu, 16 Aug 2007 10:17:56 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com>
In-Reply-To: <200708141037.48001.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708161017.56971.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

this patch fixes the accounting regression for CONFIG_VIRT_CPU_ACCOUNTING. It 
reverts parts of commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa by converting 
fs/proc/array.c back to cputime_t. The new functions task_utime and 
task_stime now return cputime_t instead of clock_t. If 
CONFIG_VIRT_CPU_ACCOUTING is set, task->utime and task->stime are returned 
directly instead of using sum_exec_runtime. 

Patch is tested on s390x with and without VIRT_CPU_ACCOUTING as well as on 
i386. Not tested on ppc64 - Paul?

Feedback is welcome.

Signed-Off-By: Christian Borntraeger <borntraeger@de.ibm.com>

---
 fs/proc/array.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -320,7 +320,18 @@ int proc_pid_status(struct task_struct *
 	return buffer - orig;
 }
 
-static clock_t task_utime(struct task_struct *p)
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING)
+static cputime_t task_utime(struct task_struct *p)
+{
+	return p->utime;
+}
+
+static cputime_t task_stime(struct task_struct *p)
+{
+	return p->stime;
+}
+#else
+static cputime_t task_utime(struct task_struct *p)
 {
 	clock_t utime = cputime_to_clock_t(p->utime),
 		total = utime + cputime_to_clock_t(p->stime);
@@ -337,10 +348,10 @@ static clock_t task_utime(struct task_st
 	}
 	utime = (clock_t)temp;
 
-	return utime;
+	return clock_t_to_cputime(utime);
 }
 
-static clock_t task_stime(struct task_struct *p)
+static cputime_t task_stime(struct task_struct *p)
 {
 	clock_t stime;
 
@@ -349,10 +360,12 @@ static clock_t task_stime(struct task_st
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) - task_utime(p);
+	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
+			cputime_to_clock_t(task_utime(p));
 
-	return stime;
+	return clock_t_to_cputime(stime);
 }
+#endif
 
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
@@ -368,8 +381,7 @@ static int do_task_stat(struct task_stru
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime;
-	clock_t utime, stime;
+	cputime_t cutime, cstime, utime, stime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -387,8 +399,7 @@ static int do_task_stat(struct task_stru
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = cputime_zero;
-	utime = stime = 0;
+	cutime = cstime = utime = stime = cputime_zero;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -414,15 +425,15 @@ static int do_task_stat(struct task_stru
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime += task_utime(t);
-				stime += task_stime(t);
+				utime = cputime_add(utime, task_utime(t));
+				stime = cputime_add(stime, task_stime(t));
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime += cputime_to_clock_t(sig->utime);
-			stime += cputime_to_clock_t(sig->stime);
+			utime = cputime_add(utime, sig->utime);
+			stime = cputime_add(stime, sig->stime);
 		}
 
 		sid = signal_session(sig);
@@ -471,8 +482,8 @@ static int do_task_stat(struct task_stru
 		cmin_flt,
 		maj_flt,
 		cmaj_flt,
-		utime,
-		stime,
+		cputime_to_clock_t(utime),
+		cputime_to_clock_t(stime),
 		cputime_to_clock_t(cutime),
 		cputime_to_clock_t(cstime),
 		priority,
