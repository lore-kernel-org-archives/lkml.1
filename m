Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYGVTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYGVTie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGVTiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:38:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34600 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYGVTiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:38:22 -0400
Date: Tue, 22 Jul 2008 21:38:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: avi@qumranet.com, kvm@vger.kernel.org, xiantao.zhang@intel.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH retry] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in
 error handling code
Message-ID: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There is a call to local_irq_restore in the normal exit case, so it would
seem that there should be one on an error return as well.

The semantic patch that finds this problem is as follows:
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
 .../julia/linuxcopy}/arch/ia64/kvm/kvm-ia64.c      |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/home/julia/linux-2.6/arch/ia64/kvm/kvm-ia64.c b/var/julia/linuxcopy/arch/ia64/kvm/kvm-ia64.c
index 2672f4d..7a37d06 100644
--- a/home/julia/linux-2.6/arch/ia64/kvm/kvm-ia64.c
+++ b/var/julia/linuxcopy/arch/ia64/kvm/kvm-ia64.c
@@ -125,9 +125,9 @@ void kvm_arch_hardware_enable(void *garbage)
 				PAGE_KERNEL));
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
+	local_irq_restore(saved_psr);
 	if (slot < 0)
 		return;
-	local_irq_restore(saved_psr);
 
 	spin_lock(&vp_lock);
 	status = ia64_pal_vp_init_env(kvm_vsa_base ?
@@ -160,9 +160,9 @@ void kvm_arch_hardware_disable(void *garbage)
 
 	local_irq_save(saved_psr);
 	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
+	local_irq_restore(saved_psr);
 	if (slot < 0)
 		return;
-	local_irq_restore(saved_psr);
 
 	status = ia64_pal_vp_exit_env(host_iva);
 	if (status)
@@ -1253,6 +1253,7 @@ static int vti_vcpu_setup(struct kvm_vcpu *vcpu, int id)
 uninit:
 	kvm_vcpu_uninit(vcpu);
 fail:
+	local_irq_restore(psr);
 	return r;
 }
 
