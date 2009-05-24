Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZEXWgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZEXWgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbZEXWf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:35:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:58358 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZEXWf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=d6Wf9PwKL+C88j7wyKBjX7Aku1yHUEWehaVpB4fVcmTICDLxpFFjYOnMWCuELglb3y
         qAfIVQMQ/eGJSwYYGJeXVdcknIyOuc686PBvW8G9WeB+Y3mC1kTHKbuYQl8Hcl1PjSH7
         L3u9V3fTmtO05AS/g49zWBvoBLFh2PwjLNwhE=
Date: Sun, 24 May 2009 18:35:57 -0400 (EDT)
From: Bart Oldeman <bartoldeman@users.sourceforge.net>
X-X-Sender: bart@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org
Subject: [PATCH] x86, vm86: fix preemption bug for int3 breakpoint
 handlers.
Message-ID: <alpine.DEB.2.00.0905241834110.17184@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

