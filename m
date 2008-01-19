Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbYASBOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbYASBOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYASBO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:14:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbYASBO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:14:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Vinay Sridhar <vinay@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] RUSAGE_THREAD
In-Reply-To: Vinay Sridhar's message of  Thursday, 17 January 2008 13:57:05 +0530 <1200558425.5992.17.camel@srivinay.in.ibm.com>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20080119011418.850DD26F9FD@magilla.localdomain>
Date: Fri, 18 Jan 2008 17:14:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the RUSAGE_THREAD option for the getrusage system call.
Solaris calls this RUSAGE_LWP and uses the same value (1).
That name is not a natural one for Linux, but we keep it as an alias.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/resource.h |    2 ++
 kernel/sys.c             |   31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index ae13db7..02b3377 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -19,6 +19,8 @@ struct task_struct;
 #define	RUSAGE_SELF	0
 #define	RUSAGE_CHILDREN	(-1)
 #define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
+#define	RUSAGE_THREAD	1		/* only the calling thread */
+#define	RUSAGE_LWP	RUSAGE_THREAD	/* Solaris name for same */
 
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..6a62bc4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1554,6 +1554,19 @@ out:
  *
  */
 
+static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r,
+				     cputime_t *utimep, cputime_t *stimep)
+{
+	*utimep = cputime_add(*utimep, t->utime);
+	*stimep = cputime_add(*stimep, t->stime);
+	r->ru_nvcsw += t->nvcsw;
+	r->ru_nivcsw += t->nivcsw;
+	r->ru_minflt += t->min_flt;
+	r->ru_majflt += t->maj_flt;
+	r->ru_inblock += task_io_get_inblock(t);
+	r->ru_oublock += task_io_get_oublock(t);
+}
+
 static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
@@ -1563,6 +1576,11 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
+	if (who == RUSAGE_THREAD) {
+		accumulate_thread_rusage(p, r, &utime, &stime);
+		goto out;
+	}
+
 	rcu_read_lock();
 	if (!lock_task_sighand(p, &flags)) {
 		rcu_read_unlock();
@@ -1595,14 +1613,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_oublock += p->signal->oublock;
 			t = p;
 			do {
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
-				r->ru_nvcsw += t->nvcsw;
-				r->ru_nivcsw += t->nivcsw;
-				r->ru_minflt += t->min_flt;
-				r->ru_majflt += t->maj_flt;
-				r->ru_inblock += task_io_get_inblock(t);
-				r->ru_oublock += task_io_get_oublock(t);
+				accumulate_thread_rusage(t, r, &utime, &stime);
 				t = next_thread(t);
 			} while (t != p);
 			break;
@@ -1614,6 +1625,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	unlock_task_sighand(p, &flags);
 	rcu_read_unlock();
 
+out:
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);
 }
@@ -1627,7 +1639,8 @@ int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
 
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
 {
-	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+	    who != RUSAGE_THREAD)
 		return -EINVAL;
 	return getrusage(current, who, ru);
 }
