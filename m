Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZL3DSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZL3DSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZL3DSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:18:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZL3DSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:18:50 -0500
Message-ID: <4B3AC629.4030504@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 11:16:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: record relocation offset
References: <4B3AC5CD.1000502@cn.fujitsu.com>
In-Reply-To: <4B3AC5CD.1000502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record relocation offset, perf tools will use it
to adjust kernel symbol address

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/boot/compressed/head_32.S |    2 ++
 arch/x86/boot/compressed/head_64.S |    3 +++
 arch/x86/include/asm/bootparam.h   |    3 ++-
 arch/x86/kernel/asm-offsets_32.c   |    1 +
 arch/x86/kernel/asm-offsets_64.c   |    1 +
 arch/x86/kernel/cpu/perf_event.c   |    4 ++++
 6 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index f543b70..dc9748a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -151,6 +151,8 @@ relocated:
 	movl	%ebp, %ebx
 	subl	$LOAD_PHYSICAL_ADDR, %ebx
 	jz	2f	/* Nothing to be done if loaded at compiled addr. */
+
+	movl	%ebx, BP_relocate_offset(%esi)
 /*
  * Process relocations.
  */
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..8170f32 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -90,6 +90,9 @@ ENTRY(startup_32)
 	addl	%eax, %ebx
 	notl	%eax
 	andl	%eax, %ebx
+	movl	%ebx, %eax
+	subl	$LOAD_PHYSICAL_ADDR, %eax
+	movl    %eax, BP_relocate_offset(%esi)
 #else
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 6be33d8..80b8d1f 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -88,7 +88,8 @@ struct boot_params {
 	__u8  _pad2[4];					/* 0x054 */
 	__u64  tboot_addr;				/* 0x058 */
 	struct ist_info ist_info;			/* 0x060 */
-	__u8  _pad3[16];				/* 0x070 */
+	__s32 relocate_offset;				/* 0x070 */
+	__u8  _pad3[12];				/* 0x074 */
 	__u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
 	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
 	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index dfdbf64..8028e3b 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -148,4 +148,5 @@ void foo(void)
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+	OFFSET(BP_relocate_offset, boot_params, relocate_offset);
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 4a6aeed..fbfa5f3 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -127,6 +127,7 @@ int main(void)
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+	OFFSET(BP_relocate_offset, boot_params, relocate_offset);
 
 	BLANK();
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c223b7e..11d2a7d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -26,8 +26,10 @@
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
+#include <asm/setup.h>
 
 static u64 perf_event_mask __read_mostly;
+static s32 relocate_offset;
 
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS	4
@@ -2173,6 +2175,8 @@ void __init init_hw_perf_events(void)
 
 	pr_info("Performance Events: ");
 
+	relocate_offset = boot_params.relocate_offset;
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		err = intel_pmu_init();
-- 
1.6.1.2


