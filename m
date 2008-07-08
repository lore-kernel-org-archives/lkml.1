Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbYGHX1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbYGHX1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbYGHXPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:08 -0400
Received: from gw.goop.org ([64.81.55.164]:51209 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 50 of 55] xen64: save lots of registers
X-Mercurial-Node: af01787daf18a252cc0ab7fdb596f43114496278
Message-Id: <af01787daf18a252cc0a.1215554832@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen hypercall interface is allowed to trash any or all of the
argument registers, so we need to be careful that the kernel state
isn't damaged.  On 32-bit kernels, the hypercall parameter registers
same as a regparm function call, so we've got away without explicit
clobbering so far.  The 64-bit ABI defines lots of caller-save
registers, so save them all for safety.  We can trim this set later by
re-distributing the responsibility for saving all these registers.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/paravirt.h |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1396,8 +1396,8 @@
  * caller saved registers but the argument parameter */
 #define PV_SAVE_REGS "pushq %%rdi;"
 #define PV_RESTORE_REGS "popq %%rdi;"
-#define PV_EXTRA_CLOBBERS EXTRA_CLOBBERS, "rcx" , "rdx"
-#define PV_VEXTRA_CLOBBERS EXTRA_CLOBBERS, "rdi", "rcx" , "rdx"
+#define PV_EXTRA_CLOBBERS EXTRA_CLOBBERS, "rcx" , "rdx", "rsi"
+#define PV_VEXTRA_CLOBBERS EXTRA_CLOBBERS, "rdi", "rcx" , "rdx", "rsi"
 #define PV_FLAGS_ARG "D"
 #endif
 
@@ -1489,8 +1489,26 @@
 
 
 #ifdef CONFIG_X86_64
-#define PV_SAVE_REGS   pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx
-#define PV_RESTORE_REGS popq %rdx; popq %rcx; popq %rdi; popq %rax
+#define PV_SAVE_REGS				\
+	push %rax;				\
+	push %rcx;				\
+	push %rdx;				\
+	push %rsi;				\
+	push %rdi;				\
+	push %r8;				\
+	push %r9;				\
+	push %r10;				\
+	push %r11
+#define PV_RESTORE_REGS				\
+	pop %r11;				\
+	pop %r10;				\
+	pop %r9;				\
+	pop %r8;				\
+	pop %rdi;				\
+	pop %rsi;				\
+	pop %rdx;				\
+	pop %rcx;				\
+	pop %rax
 #define PARA_PATCH(struct, off)        ((PARAVIRT_PATCH_##struct + (off)) / 8)
 #define PARA_SITE(ptype, clobbers, ops) _PVSITE(ptype, clobbers, ops, .quad, 8)
 #define PARA_INDIRECT(addr)	*addr(%rip)


