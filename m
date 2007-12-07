Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXLGBPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXLGBPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXLGBPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:15:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXLGBPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:15:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>,
       Miles Lane <miles.lane@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] x86 vDSO: canonicalize sysenter .eh_frame
In-Reply-To: Andrew Morton's message of  Thursday, 6 December 2007 14:37:54 -0800 <20071206143754.07a67819.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<47587796.8020705@free.fr>
	<20071206143754.07a67819.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071207011429.EE2BC26F8D9@magilla.localdomain>
Date: Thu,  6 Dec 2007 17:14:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some assembler versions automagically optimize .eh_frame contents,
changing their size.  The CFI in sysenter.S was not using optimal
formatting, so it would be changed by newer/smarter assemblers.
This ran afoul of the wired constant for padding out the other vDSO
images to match its size.  This changes the original hand-coded
source to use the optimal format encoding for its operations.  That
leaves nothing more for a fancy assembler to do, so the sizes will
match the wired-in expected size regardless of the assembler version.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/vdso32/int80.S    |    2 +-
 arch/x86/vdso/vdso32/syscall.S  |    2 +-
 arch/x86/vdso/vdso32/sysenter.S |   18 ++++++------------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/vdso/vdso32/int80.S b/arch/x86/vdso/vdso32/int80.S
index be4b7a9..b15b7c0 100644
--- a/arch/x86/vdso/vdso32/int80.S
+++ b/arch/x86/vdso/vdso32/int80.S
@@ -50,7 +50,7 @@ __kernel_vsyscall:
 	/*
 	 * Pad out the segment to match the size of the sysenter.S version.
 	 */
-VDSO32_vsyscall_eh_frame_size = 0x44
+VDSO32_vsyscall_eh_frame_size = 0x40
 	.section .data,"aw",@progbits
 	.space VDSO32_vsyscall_eh_frame_size-(.LENDFDEDLSI-.LSTARTFRAMEDLSI), 0
 	.previous
diff --git a/arch/x86/vdso/vdso32/syscall.S b/arch/x86/vdso/vdso32/syscall.S
index fe88d34..5415b56 100644
--- a/arch/x86/vdso/vdso32/syscall.S
+++ b/arch/x86/vdso/vdso32/syscall.S
@@ -71,7 +71,7 @@ __kernel_vsyscall:
 	/*
 	 * Pad out the segment to match the size of the sysenter.S version.
 	 */
-VDSO32_vsyscall_eh_frame_size = 0x44
+VDSO32_vsyscall_eh_frame_size = 0x40
 	.section .data,"aw",@progbits
 	.space VDSO32_vsyscall_eh_frame_size-(.LENDFDE1-.LSTARTFRAME), 0
 	.previous
diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysenter.S
index 902d5fc..e2800af 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -84,31 +84,25 @@ VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	.uleb128 0
 	/* What follows are the instructions for the table generation.
 	   We have to record all changes of the stack pointer.  */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpush_ecx-.LSTART_vsyscall
+	.byte 0x40 + (.Lpush_ecx-.LSTART_vsyscall) /* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x08		/* RA at offset 8 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpush_edx-.Lpush_ecx
+	.byte 0x40 + (.Lpush_edx-.Lpush_ecx) /* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x0c		/* RA at offset 12 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lenter_kernel-.Lpush_edx
+	.byte 0x40 + (.Lenter_kernel-.Lpush_edx) /* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x10		/* RA at offset 16 now */
 	.byte 0x85, 0x04	/* DW_CFA_offset %ebp -16 */
 	/* Finally the epilogue.  */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_ebp-.Lenter_kernel
+	.byte 0x40 + (.Lpop_ebp-.Lenter_kernel)	/* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x0c		/* RA at offset 12 now */
 	.byte 0xc5		/* DW_CFA_restore %ebp */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_edx-.Lpop_ebp
+	.byte 0x40 + (.Lpop_edx-.Lpop_ebp) /* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x08		/* RA at offset 8 now */
-	.byte 0x04		/* DW_CFA_advance_loc4 */
-	.long .Lpop_ecx-.Lpop_edx
+	.byte 0x40 + (.Lpop_ecx-.Lpop_edx) /* DW_CFA_advance_loc */
 	.byte 0x0e		/* DW_CFA_def_cfa_offset */
 	.byte 0x04		/* RA at offset 4 now */
 	.align 4
