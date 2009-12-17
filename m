Return-Path: <linux-kernel-owner+w=401wt.eu-S936679AbZLQEmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679AbZLQEmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936673AbZLQEm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:42:26 -0500
Received: from kroah.org ([198.145.64.141]:55379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763857AbZLQED6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.215895711@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [033/151] KVM: x86: include pvclock MSRs in msrs_to_save
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Glauber Costa <glommer@redhat.com>

commit e3267cbbbfbcbe9c18833e89b10beabb1117cb55 upstream.

For a while now, we are issuing a rdmsr instruction to find out which
msrs in our save list are really supported by the underlying machine.
However, it fails to account for kvm-specific msrs, such as the pvclock
ones.

This patch moves then to the beginning of the list, and skip testing them.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -484,16 +484,19 @@ static inline u32 bit(int bitno)
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
@@ -2433,7 +2436,8 @@ static void kvm_init_msr_list(void)
 	u32 dummy[2];
 	unsigned i, j;
 
-	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
+	/* skip the first msrs in the list. KVM-specific */
+	for (i = j = KVM_SAVE_MSRS_BEGIN; i < ARRAY_SIZE(msrs_to_save); i++) {
 		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
 			continue;
 		if (j < i)


