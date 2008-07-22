Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYGVQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYGVQoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYGVQo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:44:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35233 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYGVQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:44:28 -0400
Date: Tue, 22 Jul 2008 18:44:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: avi@qumranet.com, kvm@vger.kernel.org, xiantao.zhang@intel.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in error
 handling code
Message-ID: <Pine.LNX.4.64.0807221843140.2670@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There is a call to local_irq_restore in the normal exit case, so it would
seem that there should be one on an error return as well.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
expression E,E1,E2;
@@

local_irq_save(l);
... when != local_irq_restore(l)
    when != spin_unlock_irqrestore(E,l)
    when any
    when strict
(
if (...) { ... when != local_irq_restore(l)
               when != spin_unlock_irqrestore(E1,l)
+   local_irq_restore(l);
    return ...;
}
|
if (...)
+   {local_irq_restore(l);
    return ...;
+   }
|
spin_unlock_irqrestore(E2,l);
|
local_irq_restore(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/ia64/kvm/kvm-ia64.c      |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 318b811..14e5c99 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -125,8 +125,10 @@ void kvm_arch_hardware_enable(void *garbage)
 				PAGE_KERNEL));
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
-	if (slot < 0)
+	if (slot < 0) {
+		local_irq_restore(saved_psr);
 		return;
+	}
 	local_irq_restore(saved_psr);
 
 	spin_lock(&vp_lock);
@@ -160,8 +162,10 @@ void kvm_arch_hardware_disable(void *garbage)
 
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
-	if (slot < 0)
+	if (slot < 0) {
+		local_irq_restore(saved_psr);
 		return;
+	}
 	local_irq_restore(saved_psr);
 
 	status = ia64_pal_vp_exit_env(host_iva);
@@ -1258,6 +1262,7 @@ static int vti_vcpu_setup(struct kvm_vcpu *vcpu, int id)
 uninit:
 	kvm_vcpu_uninit(vcpu);
 fail:
+	local_irq_restore(psr);
 	return r;
 }
 
