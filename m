Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbXLRXTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbXLRXTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbXLRXTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:19:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbXLRXTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:19:30 -0500
Message-ID: <4768555A.3000604@redhat.com>
Date: Tue, 18 Dec 2007 18:18:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Roland McGrath <roland@redhat.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 1/2] x86: fix kprobe_handler reenable preemption
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a preemption bug in kprobe_handler(). It has to call preempt_enable()
before returning.
I think this is critical on preemptive kernel.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/kernel/kprobes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/kprobes.c
===================================================================
--- a/arch/x86/kernel/kprobes.c	2007-12-18 12:51:00.000000000 -0500
+++ b/arch/x86/kernel/kprobes.c	2007-12-18 12:53:38.000000000 -0500
@@ -467,7 +467,8 @@
 				arch_disarm_kprobe(p);
 				regs->ip = (unsigned long)p->addr;
 				reset_current_kprobe();
-				return 1;
+				ret = 1;
+				goto no_kprobe;
 #endif
 			}
 			/* We have reentered the kprobe_handler(), since
@@ -481,7 +482,7 @@
 			kprobes_inc_nmissed_count(p);
 			prepare_singlestep(p, regs);
 			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
+			ret = 1;
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


