Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXFQJqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXFQJqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXFQJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:55133 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbXFQJok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Yaozu (Eddie) Dong <eddie.dong@intel.com>
Subject: [PATCH 04/58] KVM: Avoid saving and restoring some host CPU state on lightweight vmexit
Date: Sun, 17 Jun 2007 12:43:45 +0300
Message-Id: <11820734791893-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many msrs and the like will only be used by the host if we schedule() or
return to userspace.  Therefore, we avoid saving them if we handle the
exit within the kernel, and if a reschedule is not requested.

Based on a patch from Eddie Dong <eddie.dong@intel.com> with a couple of
fixes by me.

Signed-off-by: Yaozu(Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    1 +
 drivers/kvm/vmx.c      |  105 +++++++++++++++++++++++++++--------------------
 3 files changed, 62 insertions(+), 45 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 152312c..7facebd 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -252,6 +252,7 @@ struct kvm_stat {
 	u32 halt_exits;
 	u32 request_irq_exits;
 	u32 irq_exits;
+	u32 light_exits;
 };
 
 struct kvm_vcpu {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 8f1f07a..7d68258 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -72,6 +72,7 @@ static struct kvm_stats_debugfs_item {
 	{ "halt_exits", STAT_OFFSET(halt_exits) },
 	{ "request_irq", STAT_OFFSET(request_irq_exits) },
 	{ "irq_exits", STAT_OFFSET(irq_exits) },
+	{ "light_exits", STAT_OFFSET(light_exits) },
 	{ NULL }
 };
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 52bd5f0..84ce0c0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -483,6 +483,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_GS_BASE:
 		vmcs_writel(GUEST_GS_BASE, data);
 		break;
+	case MSR_LSTAR:
+	case MSR_SYSCALL_MASK:
+		msr = find_msr_entry(vcpu, msr_index);
+		if (msr)
+			msr->data = data;
+		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		vmcs_write32(GUEST_SYSENTER_CS, data);
@@ -1820,7 +1827,7 @@ static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int fs_gs_ldt_reload_needed;
 	int r;
 
-again:
+preempted:
 	/*
 	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
 	 * allow segment selectors with cpl > 0 or ti == 1.
@@ -1851,13 +1858,6 @@ again:
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
 
-	kvm_load_guest_fpu(vcpu);
-
-	/*
-	 * Loading guest fpu may have cleared host cr0.ts
-	 */
-	vmcs_writel(HOST_CR0, read_cr0());
-
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
 		save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
@@ -1865,6 +1865,14 @@ again:
 	}
 #endif
 
+again:
+	kvm_load_guest_fpu(vcpu);
+
+	/*
+	 * Loading guest fpu may have cleared host cr0.ts
+	 */
+	vmcs_writel(HOST_CR0, read_cr0());
+
 	asm (
 		/* Store host registers */
 		"pushf \n\t"
@@ -1984,36 +1992,8 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
-	/*
-	 * Reload segment selectors ASAP. (it's needed for a functional
-	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
-	 * relies on having 0 in %gs for the CPU PDA to work.)
-	 */
-	if (fs_gs_ldt_reload_needed) {
-		load_ldt(ldt_sel);
-		load_fs(fs_sel);
-		/*
-		 * If we have to reload gs, we must take care to
-		 * preserve our gs base.
-		 */
-		local_irq_disable();
-		load_gs(gs_sel);
-#ifdef CONFIG_X86_64
-		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
-#endif
-		local_irq_enable();
-
-		reload_tss();
-	}
 	++vcpu->stat.exits;
 
-#ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
-	}
-#endif
-
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
@@ -2035,24 +2015,59 @@ again:
 		if (r > 0) {
 			/* Give scheduler a change to reschedule. */
 			if (signal_pending(current)) {
-				++vcpu->stat.signal_exits;
-				post_kvm_run_save(vcpu, kvm_run);
+				r = -EINTR;
 				kvm_run->exit_reason = KVM_EXIT_INTR;
-				return -EINTR;
+				++vcpu->stat.signal_exits;
+				goto out;
 			}
 
 			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-				++vcpu->stat.request_irq_exits;
-				post_kvm_run_save(vcpu, kvm_run);
+				r = -EINTR;
 				kvm_run->exit_reason = KVM_EXIT_INTR;
-				return -EINTR;
+				++vcpu->stat.request_irq_exits;
+				goto out;
+			}
+			if (!need_resched()) {
+				++vcpu->stat.light_exits;
+				goto again;
 			}
-
-			kvm_resched(vcpu);
-			goto again;
 		}
 	}
 
+out:
+	/*
+	 * Reload segment selectors ASAP. (it's needed for a functional
+	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
+	 * relies on having 0 in %gs for the CPU PDA to work.)
+	 */
+	if (fs_gs_ldt_reload_needed) {
+		load_ldt(ldt_sel);
+		load_fs(fs_sel);
+		/*
+		 * If we have to reload gs, we must take care to
+		 * preserve our gs base.
+		 */
+		local_irq_disable();
+		load_gs(gs_sel);
+#ifdef CONFIG_X86_64
+		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
+#endif
+		local_irq_enable();
+
+		reload_tss();
+	}
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+		load_msrs(vcpu->host_msrs, NR_BAD_MSRS);
+	}
+#endif
+
+	if (r > 0) {
+		kvm_resched(vcpu);
+		goto preempted;
+	}
+
 	post_kvm_run_save(vcpu, kvm_run);
 	return r;
 }
-- 
1.5.0.6

