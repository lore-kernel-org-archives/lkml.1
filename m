Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZJFRZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZJFRZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZJFRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbZJFRZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:25:17 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] fix msr list
Date: Tue,  6 Oct 2009 13:24:50 -0400
Message-Id: <1254849890-3916-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a while now, we are issuing a rdmsr instruction to find out which msrs in our
save list are really supported by the underlying machine. However, it fails to account
for kvm-specific msrs, such as the pvclock ones.

This patch moves then to the beginning of the list, and skip testing them.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11a6f2f..747e566 100644
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
1.6.2.2

