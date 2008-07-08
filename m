Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYGHXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYGHXXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbYGHXO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:58 -0400
Received: from gw.goop.org ([64.81.55.164]:51207 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 38 of 55] xen64: deal with extra words Xen pushes onto
	exception frames
X-Mercurial-Node: 0d3b56f57af54bba9afe652ee0e84ba8d4f771de
Message-Id: <0d3b56f57af54bba9afe.1215554820@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen pushes two extra words containing the values of rcx and r11.  This
pvop hook copies the words back into their appropriate registers, and
cleans them off the stack.  This leaves the stack in native form, so
the normal handler can run unchanged.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c  |    2 +-
 arch/x86/xen/xen-asm_64.S |    5 +++++
 arch/x86/xen/xen-ops.h    |    2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1091,7 +1091,7 @@
 	.safe_halt = xen_safe_halt,
 	.halt = xen_halt,
 #ifdef CONFIG_X86_64
-	.adjust_exception_frame = paravirt_nop,
+	.adjust_exception_frame = xen_adjust_exception_frame,
 #endif
 };
 
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -133,6 +133,11 @@
 	ret
 #endif
 
+ENTRY(xen_adjust_exception_frame)
+	mov 8+0(%rsp),%rcx
+	mov 8+8(%rsp),%r11
+	ret $16
+
 ENTRY(xen_iret)
 	pushq $0
 	jmp hypercall_page + __HYPERVISOR_iret * 32
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -67,7 +67,9 @@
 DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
+/* These are not functions, and cannot be called normally */
 void xen_iret(void);
 void xen_sysexit(void);
+void xen_adjust_exception_frame(void);
 
 #endif /* XEN_OPS_H */


