Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYBEFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYBEFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYBEFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:55:35 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37217 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbYBEFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:55:35 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] RUSAGE_THREAD
Date: Tue, 5 Feb 2008 11:25:50 +0530
User-Agent: KMail/1.9.4
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       vinay@linux.vnet.ibm.com, drpeper@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051125.50423.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This adds the RUSAGE_THREAD option for the getrusage system call.
This is essentially Roland's patch from http://lkml.org/lkml/2008/1/18/589, 
but the line about RUSAGE_LWP line has been removed, as suggested
by Ulrich and Christoph.

Thanks,
Sripathi.

This adds the RUSAGE_THREAD option for the getrusage system call.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
---
 include/linux/resource.h |    1 +
 kernel/sys.c             |   31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff -uprN linux-2.6.24_org/include/linux/resource.h linux-2.6.24/include/linux/resource.h
--- linux-2.6.24_org/include/linux/resource.h	2008-02-05 10:13:04.000000000 +0530
+++ linux-2.6.24/include/linux/resource.h	2008-02-05 10:14:59.000000000 +0530
@@ -19,6 +19,7 @@ struct task_struct;
 #define	RUSAGE_SELF	0
 #define	RUSAGE_CHILDREN	(-1)
 #define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
+#define	RUSAGE_THREAD	1		/* only the calling thread */
 
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
diff -uprN linux-2.6.24_org/kernel/sys.c linux-2.6.24/kernel/sys.c
--- linux-2.6.24_org/kernel/sys.c	2008-02-05 10:13:02.000000000 +0530
+++ linux-2.6.24/kernel/sys.c	2008-02-05 10:13:21.000000000 +0530
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
@@ -1563,6 +1576,11 @@ static void k_getrusage(struct task_stru
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
@@ -1595,14 +1613,7 @@ static void k_getrusage(struct task_stru
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
@@ -1614,6 +1625,7 @@ static void k_getrusage(struct task_stru
 	unlock_task_sighand(p, &flags);
 	rcu_read_unlock();
 
+out:
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);
 }
@@ -1627,7 +1639,8 @@ int getrusage(struct task_struct *p, int
 
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
 {
-	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+	    who != RUSAGE_THREAD)
 		return -EINVAL;
 	return getrusage(current, who, ru);
 }
