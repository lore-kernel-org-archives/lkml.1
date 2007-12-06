Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXLFGl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXLFGl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 01:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXLFGlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 01:41:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:55812 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbXLFGlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 01:41:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,259,1194249600"; 
   d="scan'208";a="333931766"
Subject: [PATCH -mm] x86_64 EFI runtime service support : Calling
	convention fix (resend, cc LKML)
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Dec 2007 14:40:38 +0000
Message-Id: <1196952038.24045.37.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 06 Dec 2007 06:41:08.0534 (UTC) FILETIME=[FBB01560:01C837D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In EFI calling convention, %xmm0 - %xmm5 are specified as the scratch
registers (UEFI Specification 2.1, 2.3.4.2). To conforms to EFI
specification, this patch save/restore %xmm0 - %xmm5 registers
before/after invoking EFI runtime service. At the same time, the stack
is aligned in 16 bytes, and TS in CR0 in clear/restore to make it
possible to use SSE2 in EFI runtime service.

This patch is based on 2.6.24-rc4-mm1. And it has been tested on Intel
platforms with 64-bit UEFI 2.0 firmware.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi_stub_64.S |   71 +++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/efi_stub_64.S
+++ b/arch/x86/kernel/efi_stub_64.S
@@ -8,61 +8,102 @@
 
 #include <linux/linkage.h>
 
+#define SAVE_XMM			\
+	mov %rsp, %rax;			\
+	subq $0x70, %rsp;		\
+	and $~0xf, %rsp;		\
+	mov %rax, (%rsp);		\
+	mov %cr0, %rax;			\
+	clts;				\
+	mov %rax, 0x8(%rsp);		\
+	movaps %xmm0, 0x60(%rsp);	\
+	movaps %xmm1, 0x50(%rsp);	\
+	movaps %xmm2, 0x40(%rsp);	\
+	movaps %xmm3, 0x30(%rsp);	\
+	movaps %xmm4, 0x20(%rsp);	\
+	movaps %xmm5, 0x10(%rsp)
+
+#define RESTORE_XMM			\
+	movaps 0x60(%rsp), %xmm0;	\
+	movaps 0x50(%rsp), %xmm1;	\
+	movaps 0x40(%rsp), %xmm2;	\
+	movaps 0x30(%rsp), %xmm3;	\
+	movaps 0x20(%rsp), %xmm4;	\
+	movaps 0x10(%rsp), %xmm5;	\
+	mov 0x8(%rsp), %rsi;		\
+	mov %rsi, %cr0;			\
+	mov (%rsp), %rsp
+
 ENTRY(efi_call0)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call1)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call2)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call3)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call4)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $32, %rsp
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $32, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call5)
-	subq $40, %rsp
+	SAVE_XMM
+	subq $48, %rsp
 	mov %r9, 32(%rsp)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $40, %rsp
+	addq $48, %rsp
+	RESTORE_XMM
 	ret
 
 ENTRY(efi_call6)
-	subq $56, %rsp
-	mov 56+8(%rsp), %rax
+	SAVE_XMM
+	mov (%rsp), %rax
+	mov 8(%rax), %rax
+	subq $48, %rsp
 	mov %r9, 32(%rsp)
 	mov %rax, 40(%rsp)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
 	call *%rdi
-	addq $56, %rsp
+	addq $48, %rsp
+	RESTORE_XMM
 	ret
