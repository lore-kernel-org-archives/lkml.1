Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbXIJOOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbXIJOOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760380AbXIJONR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:13:17 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45382 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325AbXIJONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:13:15 -0400
Message-ID: <46E550EA.1030809@bull.net>
Date: Mon, 10 Sep 2007 16:12:58 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND 2][PATCH 3/4] modify account_system_time() to update guest
 time in cpustat and task_struct
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:53,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:54,
	Serialize complete at 10/09/2007 16:18:54
Content-Type: multipart/mixed;
 boundary="------------090807010808010900060900"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090807010808010900060900
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
are running a VCPU. We add this cputime to  cpustat->user instead of
cpustat->system because this part of KVM code is in fact user code although it
is executed in the kernel. We duplicate VCPU time between guest and user to
allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
able to display good cpu user time and cpu guest time by subtracting cpu guest
time from cpu user time. Update "gtime" in task_struct accordingly.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth



--------------090807010808010900060900
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="account_guest"
Content-Disposition: inline;
 filename="account_guest"

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2007-09-10 14:19:30.000000000 +0200
+++ linux-2.6/include/linux/sched.h	2007-09-10 14:22:07.000000000 +0200
@@ -1316,6 +1316,7 @@ static inline void put_task_struct(struc
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
+#define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2007-09-10 14:15:54.000000000 +0200
+++ linux-2.6/kernel/sched.c	2007-09-10 14:56:41.000000000 +0200
@@ -3277,6 +3277,25 @@ void account_user_time(struct task_struc
 }
 
 /*
+ * Account guest cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in virtual machine since the last update
+ */
+void account_guest_time(struct task_struct *p, cputime_t cputime)
+{
+	cputime64_t tmp;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+
+	tmp = cputime_to_cputime64(cputime);
+
+	p->utime = cputime_add(p->utime, cputime);
+	p->gtime = cputime_add(p->gtime, cputime);
+
+	cpustat->user = cputime64_add(cpustat->user, tmp);
+	cpustat->guest = cputime64_add(cpustat->guest, tmp);
+}
+
+/*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3289,6 +3308,12 @@ void account_system_time(struct task_str
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+	if (p->flags & PF_VCPU) {
+		account_guest_time(p, cputime);
+		p->flags &= ~PF_VCPU;
+		return;
+	}
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */

--------------090807010808010900060900--
