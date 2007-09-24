Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXIXXxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXIXXxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXIXXxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:53:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXIXXxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:53:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@redhat.com>
Subject: [PATCH 2/2] powerpc: FULL_REGS on exec
X-Shopping-List: (1) Chronic hair
   (2) Recalcitrant samples
   (3) Sensuous chains
Message-Id: <20070924235244.2F3BB4D04B7@magilla.localdomain>
Date: Mon, 24 Sep 2007 16:52:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When PTRACE_O_TRACEEXEC is used, a ptrace call to fetch the registers at
the PTRACE_EVENT_EXEC stop (PTRACE_PEEKUSR) will oops in CHECK_FULL_REGS.
With recent versions, "gdb --args /bin/sh -c 'exec /bin/true'" and "run" at
the (gdb) prompt is sufficient to produce this.  I also have written an
isolated test case, see https://bugzilla.redhat.com/show_bug.cgi?id=301791#c15.

This change fixes the problem by clearing the low bit of pt_regs.trap in
start_thread so that FULL_REGS is true again.  This is correct since all of
the GPRs that "full" refers to are cleared in start_thread.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/process.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index e477c9d..fd799d2 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -605,6 +605,13 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 	regs->ccr = 0;
 	regs->gpr[1] = sp;
 
+	/*
+	 * We have just cleared all the nonvolatile GPRs, so make
+	 * FULL_REGS(regs) return true.  This is necessary to allow
+	 * ptrace to examine the thread immediately after exec.
+	 */
+	regs->trap &= ~1UL;
+
 #ifdef CONFIG_PPC32
 	regs->mq = 0;
 	regs->nip = start;
