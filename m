Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYCRF1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYCRF1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYCRFYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:16 -0400
Received: from gw.goop.org ([64.81.55.164]:37848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYCRFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 25 of 31] x86: only enable interrupts when kernel state has
	been set up
X-Mercurial-Node: c8c4e4f4c61c1ccc8326bd8f60b54b60d98101c0
Message-Id: <c8c4e4f4c61c1ccc8326.1205797036@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysenter path tries to enable interrupts immediately.  Unfortunately
this doesn't work in a paravirt environment, because not enough kernel
state has been set up at that point (namely, pointing %fs to the kernel
percpu data segment).  To fix this, defer ENABLE_INTERRUPTS until after
the kernel state has been set up.

Unfortunately this means that we're running with interrupts disabled
for a while without calling the IRQ tracing code, but that can't be
called without setting up %fs either.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -290,10 +290,10 @@
 	movl TSS_sysenter_sp0(%esp),%esp
 ENTRY(sysenter_past_esp)
 	/*
-	 * No need to follow this irqs on/off section: the syscall
-	 * disabled irqs and here we enable it straight after entry:
+	 * Interrupts are disabled here, but we can't trace it until
+	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
+	 * we immediately enable interrupts at that point anyway.
 	 */
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $(__USER_DS)
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET ss, 0*/
@@ -329,6 +329,7 @@
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	GET_THREAD_INFO(%ebp)
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
@@ -545,6 +546,7 @@
 	pushl %eax			# save orig_eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace


