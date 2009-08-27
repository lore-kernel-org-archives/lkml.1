Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbZH0RWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbZH0RWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZH0RWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZH0RWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 1/6] kprobes/x86: Call BUG() when
	reentering probe into KPROBES_HIT_SS
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 13:22:58 -0400
Message-ID: <20090827172258.8246.61889.stgit@localhost.localdomain>
In-Reply-To: <20090827152539.GE6058@nowhere>
References: <20090827152539.GE6058@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call BUG() when a probe have been hit on the way of kprobe processing path,
because that kind of probes are currently unrecoverable (recovering it will
cause an infinit loop and stack overflow).

The original code seems to assume that it will be caused by an int3 which
another subsystem inserted on out-of-line singlestep buffer if the hitting
probe is same as current probe. However, in that case, int3-hitting-address
is on the out-of-line buffer and should be different from first (current)
int3 address.
Thus, I decided to remove the code.

I also removes arch_disarm_kprobe() because it will involve other stuffs
in text_poke().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
