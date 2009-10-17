Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZJQJ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZJQJ5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZJQJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:57:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:40229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZJQJ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:57:12 -0400
Date: Sat, 17 Oct 2009 09:56:49 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172258.8246.61889.stgit@localhost.localdomain>
References: <20090827172258.8246.61889.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS
Message-ID: <tip-e9afe9e1b3fdbd56cca53959a2519e70db9c8095@git.kernel.org>
Git-Commit-ID: e9afe9e1b3fdbd56cca53959a2519e70db9c8095
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:56:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9afe9e1b3fdbd56cca53959a2519e70db9c8095
Gitweb:     http://git.kernel.org/tip/e9afe9e1b3fdbd56cca53959a2519e70db9c8095
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:22:58 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:08:26 +0200

kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS

Call BUG() when a probe have been hit on the way of kprobe processing
path, because that kind of probes are currently unrecoverable
(recovering it will cause an infinite loop and stack overflow).

The original code seems to assume that it's caused by an int3
which another subsystem inserted on out-of-line singlestep buffer if
the hitting probe is same as current probe. However, in that case,
int3-hitting-address is on the out-of-line buffer and should be
different from first (current) int3 address.
Thus, I decided to remove the code.

I also removes arch_disarm_kprobe() because it will involve other stuffs
in text_poke().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172258.8246.61889.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kprobes.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index ecee3d2..e0fb615 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -482,22 +482,16 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_status = KPROBE_REENTER;
 		break;
 	case KPROBE_HIT_SS:
-		if (p == kprobe_running()) {
-			regs->flags &= ~X86_EFLAGS_TF;
-			regs->flags |= kcb->kprobe_saved_flags;
-			return 0;
-		} else {
-			/* A probe has been hit in the codepath leading up
-			 * to, or just after, single-stepping of a probed
-			 * instruction. This entire codepath should strictly
-			 * reside in .kprobes.text section.
-			 * Raise a BUG or we'll continue in an endless
-			 * reentering loop and eventually a stack overflow.
-			 */
-			arch_disarm_kprobe(p);
-			dump_kprobe(p);
-			BUG();
-		}
+		/* A probe has been hit in the codepath leading up to, or just
+		 * after, single-stepping of a probed instruction. This entire
+		 * codepath should strictly reside in .kprobes.text section.
+		 * Raise a BUG or we'll continue in an endless reentering loop
+		 * and eventually a stack overflow.
+		 */
+		printk(KERN_WARNING "Unrecoverable kprobe detected at %p.\n",
+		       p->addr);
+		dump_kprobe(p);
+		BUG();
 	default:
 		/* impossible cases */
 		WARN_ON(1);
