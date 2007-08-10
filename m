Return-Path: <linux-kernel-owner+w=401wt.eu-S940005AbXHJP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940005AbXHJP7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939783AbXHJP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:59:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49199 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938219AbXHJP7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:59:16 -0400
Message-ID: <46BC8B59.3060908@bull.net>
Date: Fri, 10 Aug 2007 17:59:21 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2][KVM] modify account_system_time() to add cputime to cpustat->guest
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:04:17,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:04:18,
	Serialize complete at 10/08/2007 18:04:18
Content-Type: multipart/mixed;
 boundary="------------080409050804080108030907"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080409050804080108030907
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

modify account_system_time() to add cputime to cpustat->guest if we are running
a VCPU. We add this cputime to cpustat->user too instead of cpustat->system
because this part of KVM code is in fact user code although it is executed in
the kernel. We duplicate VCPU time between guest and user to allow an unmodified
"top(1)" to display correct value. A modified "top(1)" is able to display good
cpu user time and cpu guest time by subtracting cpu guest time from cpu user time.

Signed-Off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------080409050804080108030907
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="kvm_stat_guest"
Content-Disposition: inline;
 filename="kvm_stat_guest"

Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c	2007-08-10 16:49:40.000000000 +0200
+++ kvm/drivers/kvm/vmx.c	2007-08-10 17:21:46.000000000 +0200
@@ -2078,6 +2078,7 @@
 	local_irq_disable();
 
 	vcpu->guest_mode = 1;
+	current->flags |= PF_VCPU;
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c	2007-08-10 16:49:40.000000000 +0200
+++ kvm/drivers/kvm/svm.c	2007-08-10 16:52:29.000000000 +0200
@@ -1404,6 +1404,7 @@
 	clgi();
 
 	vcpu->guest_mode = 1;
+	current->flags |= PF_VCPU;
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-10 16:49:40.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-10 16:52:29.000000000 +0200
@@ -1310,6 +1310,7 @@
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
+#define PF_VCPU		0x00000010	/* I'm virtual CPU */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c	2007-08-10 16:49:40.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-10 17:21:30.000000000 +0200
@@ -3246,10 +3246,18 @@
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+	tmp = cputime_to_cputime64(cputime);
+	if (p->flags & PF_VCPU) {
+		p->utime = cputime_add(p->utime, cputime);
+		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		p->flags &= ~PF_VCPU;
+		return;
+	}
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	else if (softirq_count())

--------------080409050804080108030907--
