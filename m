Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZIVTid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZIVTid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZIVTi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:27 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIVTi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mcWoD2aYghNXhN2F9fi98+uYREx0kvaCbzGTUiIGK8i2Gis/zKu+nSpaV+AWDSaniE
         FI0YxJ/BhYSSf5FpGA43Vm8uc2PfREHMyYb2WsN+iXau75FQEJ7gumxWdAi9uB80UsDC
         OLkSC/B4NM/BmI54XPvao3RjFDi9eSh6mdHe8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/24] kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS
Date: Tue, 22 Sep 2009 21:37:59 +0200
Message-Id: <1253648302-5771-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

