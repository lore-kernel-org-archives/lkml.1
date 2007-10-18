Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbXJRNSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbXJRNSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXJRNSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:18:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45591 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJRNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:18:23 -0400
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, borntraeger@de.ibm.com,
       kvm-devel@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH] move kvm_guest_exit() after local_irq_enable()
Date: Thu, 18 Oct 2007 15:19:01 +0200
Message-Id: <11927135412363-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <47135D1B.1060004@bull.net>
References: <47135D1B.1060004@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 15:24:44,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 15:24:46,
	Serialize complete at 18/10/2007 15:24:46
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move
it after local_irq_enable().

http://lkml.org/lkml/2007/10/15/114

To simplify s390 port, we don't clear it in account_system_time().

http://lkml.org/lkml/2007/10/15/183

---
 drivers/kvm/kvm_main.c |    5 ++++-
 kernel/sched.c         |    1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 87275be..b9cd1f0 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2194,12 +2194,15 @@ again:
 
 	kvm_x86_ops->run(vcpu, kvm_run);
 
-	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
 	++vcpu->stat.exits;
 
+	barrier();
+
+	kvm_guest_exit();
+
 	preempt_enable();
 
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index b27ab3e..57fac22 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3315,7 +3315,6 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 #ifdef CONFIG_GUEST_ACCOUNTING
 	if (p->flags & PF_VCPU) {
 		account_guest_time(p, cputime);
-		p->flags &= ~PF_VCPU;
 		return;
 	}
 #endif
-- 
1.5.2.4

