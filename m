Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbXHTNOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbXHTNOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbXHTNOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:14:05 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39467 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489AbXHTNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:14:01 -0400
Message-ID: <46C9939F.90109@bull.net>
Date: Mon, 20 Aug 2007 15:14:07 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: [PATCH 3/4] modify account_system_time() to update guest time in
 cpustat and task_struct
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:19:14,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:19:16,
	Serialize complete at 20/08/2007 15:19:16
Content-Type: multipart/mixed;
 boundary="------------060300050103040408070503"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060300050103040408070503
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

--------------060300050103040408070503
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="account_guest"
Content-Disposition: inline;
 filename="account_guest"

Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-20 13:20:12.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-20 13:21:24.000000000 +0200
@@ -1317,6 +1317,7 @@ static inline void put_task_struct(struc
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
+#define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c	2007-08-20 11:11:30.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-20 13:21:24.000000000 +0200
@@ -3246,10 +3246,24 @@ void account_system_time(struct task_str
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+	tmp = cputime_to_cputime64(cputime);
+#ifdef CONFIG_GUEST_ACCOUNTING
+	if (p->flags & PF_VCPU) {
+		p->utime = cputime_add(p->utime, cputime);
+		p->gtime = cputime_add(p->gtime, cputime);
+
+		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+		p->flags &= ~PF_VCPU;
+
+		return;
+	}
+#endif
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	else if (softirq_count())

--------------060300050103040408070503--
