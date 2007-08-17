Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXHQONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXHQONE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXHQOMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:12:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47498 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXHQOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:12:52 -0400
Message-ID: <46C5ACE8.2050004@bull.net>
Date: Fri, 17 Aug 2007 16:12:56 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net> <46C59AB1.6070505@qumranet.com>
In-Reply-To: <46C59AB1.6070505@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 16:18:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 16:18:02,
	Serialize complete at 17/08/2007 16:18:02
Content-Type: multipart/mixed;
 boundary="------------010603080806080009030604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010603080806080009030604
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

Avi Kivity wrote:
[...]
> 
> The normal user/system accounting has the same issue, no?  Whereever we
> happen to land (kernel or user) gets the whole tick.
> 
> So I think it is okay to have the same limitation for guest time.
> 

So this is how it looks like.
PATCH 1 and 2 are always a prerequisite.

Laurent

--------------010603080806080009030604
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="account_guest"
Content-Disposition: inline;
 filename="account_guest"

Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-17 15:07:02.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-17 15:08:19.000000000 +0200
@@ -1310,6 +1310,7 @@
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
+#define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c	2007-08-17 14:42:43.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-17 15:16:20.000000000 +0200
@@ -3246,10 +3246,22 @@
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+	tmp = cputime_to_cputime64(cputime);
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
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	else if (softirq_count())

--------------010603080806080009030604
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="kvm_account_guest"
Content-Disposition: inline;
 filename="kvm_account_guest"

Index: kvm/drivers/kvm/kvm.h
===================================================================
--- kvm.orig/drivers/kvm/kvm.h	2007-08-17 15:26:16.000000000 +0200
+++ kvm/drivers/kvm/kvm.h	2007-08-17 15:29:46.000000000 +0200
@@ -589,6 +589,19 @@
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
+#ifndef PF_VCPU
+#define PF_VCPU	0	/* no kernel support */
+#endif
+
+static inline void kvm_guest_enter(void)
+{
+	current->flags |= PF_VCPU;
+}
+
+static inline void kvm_guest_exit(void)
+{
+}
+
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c	2007-08-17 15:26:16.000000000 +0200
+++ kvm/drivers/kvm/svm.c	2007-08-17 15:27:03.000000000 +0200
@@ -1404,6 +1404,7 @@
 	clgi();
 
 	vcpu->guest_mode = 1;
+	kvm_guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
@@ -1536,6 +1537,7 @@
 #endif
 		: "cc", "memory" );
 
+	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 
 	if (vcpu->fpu_active) {
Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c	2007-08-17 15:26:16.000000000 +0200
+++ kvm/drivers/kvm/vmx.c	2007-08-17 15:27:45.000000000 +0200
@@ -2078,6 +2078,7 @@
 	local_irq_disable();
 
 	vcpu->guest_mode = 1;
+	kvm_guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
@@ -2198,6 +2199,7 @@
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 

--------------010603080806080009030604--
