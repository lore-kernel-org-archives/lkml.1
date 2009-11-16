Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZKPMYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZKPMYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZKPMUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 37/42] KVM: x86: include pvclock MSRs in msrs_to_save
Date: Mon, 16 Nov 2009 14:19:38 +0200
Message-Id: <1258373983-8693-38-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@redhat.com>

For a while now, we are issuing a rdmsr instruction to find out which
msrs in our save list are really supported by the underlying machine.
However, it fails to account for kvm-specific msrs, such as the pvclock
ones.

This patch moves then to the beginning of the list, and skip testing them.

Cc: stable@kernel.org
Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 385cd0a..4de5bc0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -503,16 +503,19 @@ static inline u32 bit(int bitno)
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
  *
  * This list is modified at module load time to reflect the
- * capabilities of the host cpu.
+ * capabilities of the host cpu. This capabilities test skips MSRs that are
+ * kvm-specific. Those are put in the beginning of the list.
  */
+
+#define KVM_SAVE_MSRS_BEGIN	2
 static u32 msrs_to_save[] = {
+	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_K6_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
-	MSR_IA32_TSC, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
-	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA
+	MSR_IA32_TSC, MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA
 };
 
 static unsigned num_msrs_to_save;
@@ -2446,7 +2449,8 @@ static void kvm_init_msr_list(void)
 	u32 dummy[2];
 	unsigned i, j;
 
-	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
+	/* skip the first msrs in the list. KVM-specific */
+	for (i = j = KVM_SAVE_MSRS_BEGIN; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
 			continue;
 		if (j < i)
-- 
1.6.5.2

