Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZH0RWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZH0RWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZH0RWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZH0RWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 2/6] kprobes/x86-64: Allow to reenter
	probe on post_handler
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 13:23:04 -0400
Message-ID: <20090827172304.8246.4822.stgit@localhost.localdomain>
In-Reply-To: <20090827152539.GE6058@nowhere>
References: <20090827152539.GE6058@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to reenter probe on the post_handler of another probe on x86-64,
because x86-64 already allows reentering int3.
In that case, reentered probe just increases kp.nmissed and returns.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e0fb615..c5f1f11 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -463,17 +463,6 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 {
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
-#ifdef CONFIG_X86_64
-		/* TODO: Provide re-entrancy from post_kprobes_handler() and
-		 * avoid exception stack corruption while single-stepping on
-		 * the instruction of the new probe.
-		 */
-		arch_disarm_kprobe(p);
-		regs->ip = (unsigned long)p->addr;
-		reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-#endif
 	case KPROBE_HIT_ACTIVE:
 		save_previous_kprobe(kcb);
 		set_current_kprobe(p, regs, kcb);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
