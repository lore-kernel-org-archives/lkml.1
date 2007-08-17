Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXHQLv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXHQLv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXHQLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:51:45 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57272 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXHQLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:51:44 -0400
Message-ID: <46C58BD5.3090207@bull.net>
Date: Fri, 17 Aug 2007 13:51:49 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 3/4, second shot]Introduce "account_guest_time"
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>	 <46C4725A.4070607@bull.net>  <46C4740F.2050701@bull.net>	 <1187303955.6449.7.camel@localhost.localdomain> <46C54FB8.7050504@bull.net> <1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net>
In-Reply-To: <46C56774.2030009@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 13:56:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 13:56:54,
	Serialize complete at 17/08/2007 13:56:54
Content-Type: multipart/mixed;
 boundary="------------070305070409050007030503"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070305070409050007030503
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1

This is another way to compute guest time... I remove the "account modifi=
ers"
mechanism and call directly account_guest_time() from account_system_time=
().
account_system_time() computes user, system and guest times according val=
ue
accumulated in vtime (a ktime_t) in task_struct by the virtual machine.
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------070305070409050007030503
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 name="account_guest"
Content-Disposition: inline;
 filename="account_guest"

Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-17 10:18:53.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-17 12:33:22.000000000 +0200
@@ -1192,6 +1192,9 @@
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+#ifdef CONFIG_GUEST_ACCOUNTING
+	ktime_t vtime;
+#endif
 };
 
 /*
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c	2007-08-17 10:18:53.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-17 12:33:07.000000000 +0200
@@ -3233,6 +3233,37 @@
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 }
 
+#ifdef CONFIG_GUEST_ACCOUNTING
+/*
+ * Account guest time to a process
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in kernel space since the last update
+ */
+
+static cputime_t account_guest_time(struct task_struct *p, cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	ktime_t kmsec = ktime_set(0, NSEC_PER_MSEC);
+	cputime_t cmsec = msecs_to_cputime(1);
+
+	while ((ktime_to_ns(p->vtime) >= NSEC_PER_MSEC) &&
+		(cputime_to_msecs(cputime) >= 1)) {
+		p->vtime = ktime_sub(p->vtime, kmsec);
+		p->utime = cputime_add(p->utime, cmsec);
+		p->gtime = cputime_add(p->gtime, cmsec);
+
+		cpustat->guest = cputime64_add(cpustat->guest,
+				cputime_to_cputime64(cmsec));
+		cpustat->user = cputime64_add(cpustat->user,
+		cputime_to_cputime64(cmsec));
+
+		cputime = cputime_sub(cputime, cmsec);
+	}
+
+	return cputime;
+}
+#endif
+
 /*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3246,6 +3277,10 @@
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime = account_guest_time(p, cputime);
+#endif
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */

--------------070305070409050007030503--
