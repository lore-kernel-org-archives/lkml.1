Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYIIUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYIIUcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYIIUcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:32:22 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:16582 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYIIUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:32:22 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 17/24] i386: convert hardware exception 18 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:11 +0200
Message-Id: <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-10-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-11-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-14-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 09 Sep 2008 22:31:59 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle machine check exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |    2 +-
 arch/x86/kernel/traps_32.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5a88585..c5fe01b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1019,7 +1019,7 @@ ENTRY(machine_check)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl machine_check_vector
+	pushl $do_machine_check
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bc8b21d..f696914 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -62,6 +62,7 @@
 #include <asm/traps.h>
 
 #include "mach_traps.h"
+#include "cpu/mcheck/mce.h"
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
@@ -1250,6 +1251,14 @@ void __kprobes do_device_not_available(struct pt_regs *regs, long error)
 	}
 }
 
+#ifdef CONFIG_X86_MCE
+void __kprobes do_machine_check(struct pt_regs *regs, long error)
+{
+	conditional_sti(regs);
+	machine_check_vector(regs, error);
+}
+#endif
+
 void __init trap_init(void)
 {
 	int i;
@@ -1281,7 +1290,7 @@ void __init trap_init(void)
 	set_intr_gate(16, &coprocessor_error);
 	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_trap_gate(18, &machine_check);
+	set_intr_gate(18, &machine_check);
 #endif
 	set_trap_gate(19, &simd_coprocessor_error);
 
-- 
1.5.4.3

