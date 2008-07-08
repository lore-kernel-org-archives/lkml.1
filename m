Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbYGHXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbYGHXZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbYGHXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:04 -0400
Received: from gw.goop.org ([64.81.55.164]:51205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 47 of 55] xen64: implement failsafe callback
X-Mercurial-Node: 62b8ae85223841da7dbbd12da45056fde549be60
Message-Id: <62b8ae85223841da7dbb.1215554829@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the failsafe callback, so that iret and segment register
load exceptions are reported to the kernel.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1365,10 +1365,8 @@
 # with its current contents: any discrepancy means we in category 1.
 */
 ENTRY(xen_failsafe_callback)
-#if 1
-	ud2a
-#else
-	_frame (RIP-0x30)
+	framesz = (RIP-0x30)	/* workaround buggy gas */
+	_frame framesz
 	CFI_REL_OFFSET rcx, 0
 	CFI_REL_OFFSET r11, 8
 	movw %ds,%cx
@@ -1391,8 +1389,13 @@
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	movq $11,%rdi	/* SIGSEGV */
-	jmp do_exit
+	pushq $0
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq %r11
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq %rcx
+	CFI_ADJUST_CFA_OFFSET 8
+	jmp general_protection
 	CFI_RESTORE_STATE
 1:	/* Segment mismatch => Category 1 (Bad segment). Retry the IRET. */
 	movq (%rsp),%rcx
@@ -1406,7 +1409,6 @@
 	SAVE_ALL
 	jmp error_exit
 	CFI_ENDPROC
-#endif
 END(xen_failsafe_callback)
 
 #endif /* CONFIG_XEN */


