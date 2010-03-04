Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0CDBYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:24:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:19907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0CDBYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:24:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,577,1262592000"; 
   d="scan'208";a="545875273"
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, mingo@elte.hu, hpa@zytor.com, colin.king@canonical.com,
       Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH] i386: do a global tlb flush in S4 resume
Date: Thu,  4 Mar 2010 09:23:19 +0800
Message-Id: <1267665799-670-1-git-send-email-shaohua.li@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin reported a strange oops in S4 resume code path (see below). The test
system has i5/i7 CPU. The kernel doesn't open PAE, so 4M page table is used.
The oops always happen a virtual address 0xc03ff000, which is mapped to the
last 4k of first 4M memory. Doing a global tlb flush fixes the issue.

EIP: 0060:[<c0493a01>] EFLAGS: 00010086 CPU: 0
EIP is at copy_loop+0xe/0x15
EAX: 36aeb000 EBX: 00000000 ECX: 00000400 EDX: f55ad46c
ESI: 0f800000 EDI: c03ff000 EBP: f67fbec4 ESP: f67fbea8
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
...
...
CR2: 00000000c03ff000

Tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/power/hibernate_asm_32.S |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index b641388..9e4ef64 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -27,10 +27,21 @@ ENTRY(swsusp_arch_suspend)
 	ret
 
 ENTRY(restore_image)
+	movl	mmu_cr4_features, %ecx
 	movl	resume_pg_dir, %eax
 	subl	$__PAGE_OFFSET, %eax
 	movl	%eax, %cr3
 
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %edx
+	andl	$~(X86_CR4_PGE), %edx
+	movl	%edx, %cr4;  # turn off PGE
+1:
+	movl	%cr3, %eax;  # flush TLB
+	movl	%eax, %cr3
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %cr4;  # turn PGE back on
+1:
 	movl	restore_pblist, %edx
 	.p2align 4,,7
 
-- 
1.6.3.3

