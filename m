Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0CCDJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:09:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55424 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0CCDJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A/qnWP0PwxTEqWnmPjyeV+MbSEbVs0D+Eb/YhBPgu+nSyHksa77gORgpITormYCtR+
         lbtConc2G4zlShz0wtlKiVcT5abd90kq8pc1Im43CMZQCxSd8YphtuzkLHgNSYnW1trh
         QtBX2kXlvGmGZ+CK7EUfCzNtArSUnMkCATo0Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       "2 . 6 . 33 . x" <stable@kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] 
Date: Wed,  3 Mar 2010 04:09:02 +0100
Message-Id: <1267585742-3853-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      x86/stacktrace: Don't dereference bad frame pointers


 arch/x86/kernel/dumpstack_64.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

---
commit 29044ad1509ecc229f1d5a31aeed7a8dc61a71c4
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Mar 3 02:25:22 2010 +0100

    x86/stacktrace: Don't dereference bad frame pointers
    
    Callers of a stacktrace might pass bad frame pointers. Those
    are usually checked for safety in stack walking helpers before
    any dereferencing, but this is not the case when we need to go
    through one more frame pointer that backlinks the irq stack to
    the previous one, as we don't have any reliable address boudaries
    to compare this frame pointer against.
    
    This raises crashes when we record callchains for ftrace events
    with perf because we don't use the right helpers to capture
    registers there. We get wrong frame pointers as we call
    task_pt_regs() even on kernel threads, which is a wrong thing
    as it gives us the initial state of any kernel threads freshly
    created. This is even not what we want for user tasks. What we want
    is a hot snapshot of registers when the ftrace event triggers, not
    the state before a task entered the kernel.
    
    This requires more thoughts to do it correctly though.
    So first put a guardian to ensure the given frame pointer
    can be dereferenced to avoid crashes. We'll think about how to fix
    the callers in a subsequent patch.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: 2.6.33.x <stable@kernel.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 0ad9597..a6c906c 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -125,9 +125,15 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
 {
 #ifdef CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)bp;
+	unsigned long next;
 
-	if (!in_irq_stack(stack, irq_stack, irq_stack_end))
-		return (unsigned long)frame->next_frame;
+	if (!in_irq_stack(stack, irq_stack, irq_stack_end)) {
+		if (!probe_kernel_address(&frame->next_frame, next))
+			return next;
+		else
+			WARN_ONCE(1, "Perf: bad frame pointer = %p in "
+				  "callchain\n", &frame->next_frame);
+	}
 #endif
 	return bp;
 }
