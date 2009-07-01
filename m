Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZGABTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZGABTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbZGAAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:36:04 -0400
Received: from kroah.org ([198.145.64.141]:60775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761570AbZGAAgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:36:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:46 2009
Message-Id: <20090701002446.414993796@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 108/108] KVM: x86: silence preempt warning on kvm_write_guest_time
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-silence-preempt-warning-on-kvm_write_guest_time.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt T. Yourst <yourst@users.sourceforge.net>

commit 2dea4c84bc936731668b5a7a9fba5b436a422668 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -634,10 +634,12 @@ static void kvm_write_guest_time(struct 
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


