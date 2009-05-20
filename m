Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZETXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZETXSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZETXSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57486 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbZETXSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:15 -0400
X-Sasl-enc: EhPBW8LoK6jQraDkdEK+dTuyrd1tyC82J5cHYOkNEejT 1242861495
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32/mce: add do_machine_check
Date: Thu, 21 May 2009 01:18:01 +0200
Message-Id: <1242861486-7255-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A distinct pattern exists in the handler stubs for traps. The mce
is slightly different and that is not necessary. This adds an extra
indirection via a trivial C function and makes the assembly code
equivalent to the other trap stubs.

No functional change intended.

impact: prepare for introduction of zeroentry/errorentry macros

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/cpu/mcheck/mce_32.c |    6 ++++++
 arch/x86/kernel/entry_32.S          |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_32.c b/arch/x86/kernel/cpu/mcheck/mce_32.c
index 3552119..b134ae6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -30,6 +30,12 @@ static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 /* Call the installed machine check handler for this CPU setup. */
 void (*machine_check_vector)(struct pt_regs *, long error_code) = unexpected_machine_check;
 
+/* Call the machine check vector */
+void do_machine_check(struct pt_regs *regs, long error_code)
+{
+	machine_check_vector(regs, error_code);
+}
+
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 3b63eba..0e8ac16 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -932,7 +932,7 @@ ENTRY(machine_check)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl machine_check_vector
+	pushl $do_machine_check
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
-- 
1.6.0.4

