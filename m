Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZIVTmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZIVTmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZIVTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:32 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZIVTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ka2F1nA5CUCx9vy2FK0yi+EHNeQlKESCRQyy96F5iuFggW+yRTzjyfn/2IPt+a8YN/
         x4x3DCxJt4984YxZ9bqxK12ZtyQCoBG1lxU58qmrZ4UzgNEjHOOpDvMwBfBvz4R3bW0r
         54VQZvnKITIGNOeMsijrmh5Cik6yGWL2MF9Is=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/24] kprobes/x86-64: Allow to reenter probe on post_handler
Date: Tue, 22 Sep 2009 21:38:00 +0200
Message-Id: <1253648302-5771-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

