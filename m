Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYCMI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYCMI0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYCMI0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:26:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYCMI0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:26:09 -0400
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: user_regset PTRACE_SETREGS regression fix
X-Fcc: ~/Mail/linus
X-Zippy-Says: I'm wet!  I'm wild!
Message-Id: <20080313082535.99DF226F992@magilla.localdomain>
Date: Thu, 13 Mar 2008 01:25:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PTRACE_SETREGS request was only recently added on powerpc,
and gdb does not use it.  So it slipped through without getting
all the testing it should have had.

The user_regset changes had a simple bug in storing to all of
the 32-bit general registers block on 64-bit kernels.  This bug
only comes up with PTRACE_SETREGS, not PPC_PTRACE_SETREGS.
It causes a BUG_ON to hit, so this fix needs to go in ASAP.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 7673e98..2a9fe97 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -530,15 +530,21 @@ static int gpr32_set(struct task_struct *target,
 		--count;
 	}
 
-	if (kbuf)
+	if (kbuf) {
 		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count)
 			regs[pos++] = *k++;
-	else
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			++k;
+	} else {
 		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count) {
 			if (__get_user(reg, u++))
 				return -EFAULT;
 			regs[pos++] = reg;
 		}
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			if (__get_user(reg, u++))
+				return -EFAULT;
+	}
 
 	if (count > 0 && pos == PT_TRAP) {
 		if (kbuf)
