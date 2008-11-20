Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYKTV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYKTV6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYKTV55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:57:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbYKTV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:57:56 -0500
Message-Id: <20081120215748.507212188@goodmis.org>
References: <20081120215541.489725873@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 16:55:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/1] powerpc: ftrace, do nothing in mcount call for dyn ftrace
Content-Disposition: inline; filename=0001-powerpc-ftrace-do-nothing-in-mcount-call-for-dyn-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: quicken mcount calls that are not replaced by dyn ftrace

Dynamic ftrace no longer does on the fly recording of mcount locations.
The mcount locations are now found at compile time. The mcount
function no longer needs to store registers and call a stub function.
It can now just simply return.

Since there are some functions that do not get converted to a nop
(.init sections and other code that may disappear), this patch should
help speed up that code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/entry_32.S |   35 +----------------------------------
 arch/powerpc/kernel/entry_64.S |   12 ------------
 2 files changed, 1 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 7ecc0d1..d2c4035 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1162,40 +1162,7 @@ machine_check_in_rtas:
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
-	stwu	r1,-48(r1)
-	stw	r3, 12(r1)
-	stw	r4, 16(r1)
-	stw	r5, 20(r1)
-	stw	r6, 24(r1)
-	mflr	r3
-	stw	r7, 28(r1)
-	mfcr	r5
-	stw	r8, 32(r1)
-	stw	r9, 36(r1)
-	stw	r10,40(r1)
-	stw	r3, 44(r1)
-	stw	r5, 8(r1)
-	subi	r3, r3, MCOUNT_INSN_SIZE
-	.globl mcount_call
-mcount_call:
-	bl	ftrace_stub
-	nop
-	lwz	r6, 8(r1)
-	lwz	r0, 44(r1)
-	lwz	r3, 12(r1)
-	mtctr	r0
-	lwz	r4, 16(r1)
-	mtcr	r6
-	lwz	r5, 20(r1)
-	lwz	r6, 24(r1)
-	lwz	r0, 52(r1)
-	lwz	r7, 28(r1)
-	lwz	r8, 32(r1)
-	mtlr	r0
-	lwz	r9, 36(r1)
-	lwz	r10,40(r1)
-	addi	r1, r1, 48
-	bctr
+	blr
 
 _GLOBAL(ftrace_caller)
 	/* Based off of objdump optput from glibc */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index e6d5284..b00982e 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -888,18 +888,6 @@ _GLOBAL(enter_prom)
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
-	/* Taken from output of objdump from lib64/glibc */
-	mflr	r3
-	stdu	r1, -112(r1)
-	std	r3, 128(r1)
-	subi	r3, r3, MCOUNT_INSN_SIZE
-	.globl mcount_call
-mcount_call:
-	bl	ftrace_stub
-	nop
-	ld	r0, 128(r1)
-	mtlr	r0
-	addi	r1, r1, 112
 	blr
 
 _GLOBAL(ftrace_caller)
-- 
1.5.6.5

-- 
