Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYIYL6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYIYL6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYIYLzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbYIYLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 08/39] KVM: Device assignment: Check for privileges before assigning irq
Date: Thu, 25 Sep 2008 14:54:40 +0300
Message-Id: <1222343711-12508-9-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

Even though we don't share irqs at the moment, we should ensure
regular user processes don't try to allocate system resources.

We check for capability to access IO devices (CAP_SYS_RAWIO) before
we request_irq on behalf of the guest.

Noticed by Avi.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a03375..fffdf4f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -191,6 +191,11 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		  kvm_assigned_dev_interrupt_work_handler);
 
 	if (irqchip_in_kernel(kvm)) {
+		if (!capable(CAP_SYS_RAWIO)) {
+			return -EPERM;
+			goto out;
+		}
+
 		if (assigned_irq->host_irq)
 			match->host_irq = assigned_irq->host_irq;
 		else
-- 
1.6.0.1

