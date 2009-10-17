Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZJQJ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZJQJ5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZJQJ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:57:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:40289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZJQJ5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:57:43 -0400
Date: Sat, 17 Oct 2009 09:57:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172304.8246.4822.stgit@localhost.localdomain>
References: <20090827172304.8246.4822.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86-64: Allow to reenter probe on post_handler
Message-ID: <tip-f5ad31158d60946b9fd18c8a79c283a6bc432430@git.kernel.org>
Git-Commit-ID: f5ad31158d60946b9fd18c8a79c283a6bc432430
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:57:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5ad31158d60946b9fd18c8a79c283a6bc432430
Gitweb:     http://git.kernel.org/tip/f5ad31158d60946b9fd18c8a79c283a6bc432430
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:23:04 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:08:26 +0200

kprobes/x86-64: Allow to reenter probe on post_handler

Allow to reenter probe on the post_handler of another probe on x86-64,
because x86-64 already allows reentering int3.
In that case, reentered probe just increases kp.nmissed and returns.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172304.8246.4822.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
