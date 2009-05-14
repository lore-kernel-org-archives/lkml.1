Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbZENG2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbZENG2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZENG2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:28:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:37282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZENG2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:28:22 -0400
Subject: [PATCH -tip] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with
 MSR_IA32_TSC of msr-index.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1242279010.4574.6.camel@localhost.localdomain>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
	 <1242032701.3114.4.camel@localhost.localdomain>
	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
	 <1242279010.4574.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 11:57:22 +0530
Message-Id: <1242282442.4574.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use standard msr-index.h's MSR declaration.

MSR_IA32_TSC is better than MSR_IA32_TIME_STAMP_COUNTER as it also solves
80 column issue.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/svm.c              |    4 ++--
 arch/x86/kvm/vmx.c              |    4 ++--
 arch/x86/kvm/x86.c              |    5 ++---
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f0faf58..824f5e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -750,8 +750,6 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
 
-#define MSR_IA32_TIME_STAMP_COUNTER		0x010
-
 #define TSS_IOPB_BASE_OFFSET 0x66
 #define TSS_BASE_SIZE 0x68
 #define TSS_IOPB_SIZE (65536 / 8)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1821c20..f149d17 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1889,7 +1889,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TIME_STAMP_COUNTER: {
+	case MSR_IA32_TSC: {
 		u64 tsc;
 
 		rdtscll(tsc);
@@ -1979,7 +1979,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TIME_STAMP_COUNTER: {
+	case MSR_IA32_TSC: {
 		u64 tsc;
 
 		rdtscll(tsc);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bb48133..c8d3234 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -897,7 +897,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_index, pdata);
 #endif
-	case MSR_IA32_TIME_STAMP_COUNTER:
+	case MSR_IA32_TSC:
 		data = guest_read_tsc();
 		break;
 	case MSR_IA32_SYSENTER_CS:
@@ -957,7 +957,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_TIME_STAMP_COUNTER:
+	case MSR_IA32_TSC:
 		rdtscll(host_tsc);
 		guest_write_tsc(data, host_tsc);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e4a0ef..db0fd7d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -465,7 +465,7 @@ static u32 msrs_to_save[] = {
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
-	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	MSR_IA32_TSC, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA
 };
 
@@ -637,8 +637,7 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	kvm_get_msr(v, MSR_IA32_TIME_STAMP_COUNTER,
-			  &vcpu->hv_clock.tsc_timestamp);
+	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
 	ktime_get_ts(&ts);
 	local_irq_restore(flags);
 
-- 
1.6.0.6



