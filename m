Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXLTMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXLTMAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXLTMAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbXLTMAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 13/43] powerpc ptrace special regs
Message-Id: <20071220115751.78CE726F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:57:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isolates the ptrace code for the special-case registers msr and trap
from the ptrace-layout dispatch code.  This should inline away completely.
It cleanly separates the low-level machine magic that has to be done for
deep reasons, from the superficial details of the ptrace interface.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   45 ++++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 8c25b00..4edc118 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -60,20 +60,38 @@
 #define PT_MAX_PUT_REG	PT_CCR
 #endif
 
+static unsigned long get_user_msr(struct task_struct *task)
+{
+	return task->thread.regs->msr | task->thread.fpexc_mode;
+}
+
+static int set_user_msr(struct task_struct *task, unsigned long msr)
+{
+	task->thread.regs->msr &= ~MSR_DEBUGCHANGE;
+	task->thread.regs->msr |= msr & MSR_DEBUGCHANGE;
+	return 0;
+}
+
+/*
+ * We prevent mucking around with the reserved area of trap
+ * which are used internally by the kernel.
+ */
+static int set_user_trap(struct task_struct *task, unsigned long trap)
+{
+	task->thread.regs->trap = trap & 0xfff0;
+	return 0;
+}
+
 /*
  * Get contents of register REGNO in task TASK.
  */
 unsigned long ptrace_get_reg(struct task_struct *task, int regno)
 {
-	unsigned long tmp = 0;
-
 	if (task->thread.regs == NULL)
 		return -EIO;
 
-	if (regno == PT_MSR) {
-		tmp = ((unsigned long *)task->thread.regs)[PT_MSR];
-		return tmp | task->thread.fpexc_mode;
-	}
+	if (regno == PT_MSR)
+		return get_user_msr(task);
 
 	if (regno < (sizeof(struct pt_regs) / sizeof(unsigned long)))
 		return ((unsigned long *)task->thread.regs)[regno];
@@ -89,15 +107,12 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
 	if (task->thread.regs == NULL)
 		return -EIO;
 
-	if (regno <= PT_MAX_PUT_REG || regno == PT_TRAP) {
-		if (regno == PT_MSR)
-			data = (data & MSR_DEBUGCHANGE)
-				| (task->thread.regs->msr & ~MSR_DEBUGCHANGE);
-		/* We prevent mucking around with the reserved area of trap
-		 * which are used internally by the kernel
-		 */
-		if (regno == PT_TRAP)
-			data &= 0xfff0;
+	if (regno == PT_MSR)
+		return set_user_msr(task, data);
+	if (regno == PT_TRAP)
+		return set_user_trap(task, data);
+
+	if (regno <= PT_MAX_PUT_REG) {
 		((unsigned long *)task->thread.regs)[regno] = data;
 		return 0;
 	}
-- 
1.5.3.6

