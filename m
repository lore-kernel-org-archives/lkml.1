Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZEXQBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZEXQBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZEXPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 09/45] KVM: Wake up waitqueue before calling get_cpu()
Date: Sun, 24 May 2009 18:49:54 +0300
Message-Id: <1243180230-2480-10-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This moves the get_cpu() call down to be called after we wake up the
waiters. Therefore the waitqueue locks can safely be rt mutex.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f4dc86..c92d42b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4565,7 +4565,7 @@ static void vcpu_kick_intr(void *info)
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int ipi_pcpu = vcpu->cpu;
-	int cpu = get_cpu();
+	int cpu;
 
 	if (waitqueue_active(&vcpu->wq)) {
 		wake_up_interruptible(&vcpu->wq);
@@ -4575,6 +4575,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * We may be called synchronously with irqs disabled in guest mode,
 	 * So need not to call smp_call_function_single() in that case.
 	 */
+	cpu = get_cpu();
 	if (vcpu->guest_mode && vcpu->cpu != cpu)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
 	put_cpu();
-- 
1.6.0.6

