Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXHSM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXHSM5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXHSM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:57:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:35198 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXHSM5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:57:13 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ornati@fastwebnet.it, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] KVM: Avoid calling smp_call_function_single() with interrupts disabled
Date: Sun, 19 Aug 2007 15:57:26 +0300
Message-Id: <11875282461120-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When taking a cpu down, we need to hardware_disable() it.  Unfortunately,
the CPU_DYING notifier is called with interrupts disabled, which means
we can't use smp_call_function_single().  Fortunately, the CPU_DYING notifier
is always called on the dying cpu, so we don't need to use the function at
all and can simply call hardware_disable() directly.

Tested-by: Paolo Ornati <ornati@fastwebnet.it>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---

Linus, please apply to -rc.

 drivers/kvm/kvm_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9685609..cd05579 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2974,6 +2974,10 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	switch (val) {
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
+		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
+		       cpu);
+		hardware_disable(NULL);
+		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
-- 
1.5.2.4

