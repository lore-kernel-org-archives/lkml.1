Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXIQIgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXIQIgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXIQIcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:45291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 019/104] KVM: Hoist kvm_mmu_reload() out of the critical section
Date: Mon, 17 Sep 2007 10:31:01 +0200
Message-Id: <11900179471229-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
sleep with mutex changes, so I move it above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 2c4f01b..79674a7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1999,16 +1999,16 @@ preempted:
 		kvm_guest_debug_pre(vcpu);
 
 again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		goto out;
-
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
-- 
1.5.3

