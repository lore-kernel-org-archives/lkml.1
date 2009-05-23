Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZEWWp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZEWWp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZEWWpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:45:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:28003 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZEWWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:message-id:from:date;
        b=HMgbAbcJjYuDP0+oegtxFBPSHWsV0Gafvza4MKEid+pZGMhmVwOyPDgR8qTGGNI2M6
         6mHTcy5EfVLzK4GIDhW8RV3nLM8x7WMBkEq5aZLapmwYmYN4CuyjlYniXQhZjP5QCh/X
         5/52TrEneZH7CgSsSkO3M4ue7aAXbKqKarBtg=
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org
Message-Id: <E1M7zxs-0002tk-Ct@localhost.localdomain>
From: Bart Oldeman <bartoldeman@gmail.com>
Date: Sat, 23 May 2009 18:45:16 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 090d8c2d634b456999e0928d4982ce9ea7afddf2 Mon Sep 17 00:00:00 2001
From: Bart Oldeman <bart@enm-bo-lt.localnet>
Date: Sat, 23 May 2009 18:16:28 -0400
Subject: [PATCH] x86, vm86: fix preemption bug for int3 breakpoint handlers.

Impact: fix kernel bug such as:
May 22 16:47:47 localhost kernel: note: dosemu.bin[5281] exited with preempt_count 1

Commit be716615fe596ee117292dc615e95f707fb67fd1 ("x86, vm86:
fix preemption bug") fixes the problem for debug exceptions but not
for breakpoints. This change also fixes breakpoints. As the offending
codepath is jumping directly back to entry.S, move the logic to
vm86_32.c, and re-enable preemption in vm86_handle_trap() before
calling return_to_32bit().

Cc: stable@kernel.org
Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>
---
 arch/x86/kernel/traps.c   |    4 +---
 arch/x86/kernel/vm86_32.c |    6 +++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f07ada4..98ebe1c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -590,10 +590,8 @@ clear_dr7:
 
 #ifdef CONFIG_X86_32
 debug_vm86:
-	/* reenable preemption: handle_vm86_trap() might sleep */
-	dec_preempt_count();
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	conditional_cli(regs);
+	preempt_conditional_cli(regs);
 	return;
 #endif
 
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index b8035a0..17c7734 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -551,8 +551,12 @@ cannot_handle:
 int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
 {
 	if (VMPI.is_vm86pus) {
-		if ((trapno == 3) || (trapno == 1))
+		if ((trapno == 3) || (trapno == 1)) {
+			/* re-enable preemption: return_to_32bit()
+			   jumps straight to entry_32.S */
+			dec_preempt_count();
 			return_to_32bit(regs, VM86_TRAP + (trapno << 8));
+		}
 		do_int(regs, trapno, (unsigned char __user *) (regs->pt.ss << 4), SP(regs));
 		return 0;
 	}
-- 
1.6.2.4

