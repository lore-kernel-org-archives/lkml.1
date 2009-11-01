Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZKAL4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZKAL4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 06:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZKAL4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 06:56:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZKAL4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 06:56:31 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] Handle async PF in non preemptable context.
Date: Sun,  1 Nov 2009 13:56:29 +0200
Message-Id: <1257076590-29559-11-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-1-git-send-email-gleb@redhat.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If async page fault is received by idle task or when preemp_count is
not zero guest cannot reschedule, so make "wait for page" hypercall
and comtinue only after a page is ready.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kernel/kvm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 79d291f..1bd8b8d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -162,10 +162,24 @@ int kvm_handle_pf(struct pt_regs *regs, unsigned long error_code)
 	switch (reason) {
 	default:
 		return 0;
-	case KVM_PV_REASON_PAGE_NP:
+	case KVM_PV_REASON_PAGE_NP: {
+		int cpu, idle;
+		cpu = get_cpu();
+		idle = idle_cpu(cpu);
+		put_cpu();
+
+		/*
+		 * We cannot reschedule. Wait for page to be ready.
+		 */
+		if (idle || preempt_count()) {
+			kvm_hypercall0(KVM_HC_WAIT_FOR_ASYNC_PF);
+			break;
+		}
+
 		/* real page is missing. */
 		apf_task_wait(current, token);
 		break;
+	}
 	case KVM_PV_REASON_PAGE_READY:
 		apf_task_wake(token);
 		break;
-- 
1.6.3.3

