Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXJQNHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXJQNHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbXJQNH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:07:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52635 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbXJQNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:07:24 -0400
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, borntraeger@de.ibm.com,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH] clear PF_VCPU in kvm_guest_exit()
Date: Wed, 17 Oct 2007 15:08:05 +0200
Message-Id: <11926264852739-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <47135D1B.1060004@bull.net>
References: <47135D1B.1060004@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/10/2007 15:13:49,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/10/2007 15:13:50,
	Serialize complete at 17/10/2007 15:13:50
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clear PF_VCPU in kvm_guest_exit() and move kvm_guest_exit() after 
local_irq_enable().

According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move 
it after local_irq_enable().

http://lkml.org/lkml/2007/10/15/114

To simplify s390 port, we don't clear it in account_system_time().

http://lkml.org/lkml/2007/10/15/183

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    3 ++-
 kernel/sched.c         |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e9dbf67..e8b4902 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -677,6 +677,7 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
+	current->flags &= ~PF_VCPU;
 }
 
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 87275be..a9db477 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2194,12 +2194,13 @@ again:
 
 	kvm_x86_ops->run(vcpu, kvm_run);
 
-	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
 	++vcpu->stat.exits;
 
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

