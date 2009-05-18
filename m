Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZERJ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZERJ3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZERJXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38404 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 11/43] KVM: x86: silence preempt warning on kvm_write_guest_time
Date: Mon, 18 May 2009 12:22:33 +0300
Message-Id: <1242638585-18470-12-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt T. Yourst <yourst@users.sourceforge.net>

This issue just appeared in kvm-84 when running on 2.6.28.7 (x86-64)
with PREEMPT enabled.

We're getting syslog warnings like this many (but not all) times qemu
tells KVM to run the VCPU:

BUG: using smp_processor_id() in preemptible [00000000] code:
qemu-system-x86/28938
caller is kvm_arch_vcpu_ioctl_run+0x5d1/0xc70 [kvm]
Pid: 28938, comm: qemu-system-x86 2.6.28.7-mtyrel-64bit
Call Trace:
debug_smp_processor_id+0xf7/0x100
kvm_arch_vcpu_ioctl_run+0x5d1/0xc70 [kvm]
? __wake_up+0x4e/0x70
? wake_futex+0x27/0x40
kvm_vcpu_ioctl+0x2e9/0x5a0 [kvm]
enqueue_hrtimer+0x8a/0x110
_spin_unlock_irqrestore+0x27/0x50
vfs_ioctl+0x31/0xa0
do_vfs_ioctl+0x74/0x480
sys_futex+0xb4/0x140
sys_ioctl+0x99/0xa0
system_call_fastpath+0x16/0x1b

As it turns out, the call trace is messed up due to gcc's inlining, but
I isolated the problem anyway: kvm_write_guest_time() is being used in a
non-thread-safe manner on preemptable kernels.

Basically kvm_write_guest_time()'s body needs to be surrounded by
preempt_disable() and preempt_enable(), since the kernel won't let us
query any per-CPU data (indirectly using smp_processor_id()) without
preemption disabled. The attached patch fixes this issue by disabling
preemption inside kvm_write_guest_time().

[marcelo: surround only __get_cpu_var calls since the warning
is harmless]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 49079a4..cac6e63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -630,10 +630,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	if ((!vcpu->time_page))
 		return;
 
+	preempt_disable();
 	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
 		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
 		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	}
+	preempt_enable();
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-- 
1.6.0.6

