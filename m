Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYKQTLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYKQTLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYKQTLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:11:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYKQTLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:11:16 -0500
Message-Id: <20081117191059.610706327@goodmis.org>
References: <20081117190948.619751203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 14:09:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] ftrace,ppc: fix module check in dynamic ftrace code
Content-Disposition: inline; filename=0003-ftrace-ppc-fix-module-check-in-dynamic-ftrace-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix to module check in making nops in dynamic ftrace for PPC

Paul Mackerras pointed out that the mod test in ftrace_make_nop looks
wrong. It is, but it did not trigger because the logic to ftrace just
happens to miss the bad case.

When ftrace first changes all the calls to mcount into nops, it passes
in the "mod" parameter, and the rec->arch.mod is NULL. This case assigns
the rec->arch.mod to mod and succeeds. From then on, ftrace will pass
in a NULL for mod and the check if mod and rec->arch.mod is the same
is skipped.

The failure of the current test may produce a false positive failuer,
which will cause ftrace to shutdown even if the code was correct. This
patch fixes the test.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 918a5d2..81e338c 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -354,10 +354,13 @@ int ftrace_make_nop(struct module *mod,
 		}
 		rec->arch.mod = mod;
 	} else if (mod) {
-		printk(KERN_ERR
-		       "Record mod %p not equal to passed in mod %p\n",
-		       rec->arch.mod, mod);
-		return -EINVAL;
+		if (mod != rec->arch.mod) {
+			printk(KERN_ERR
+			       "Record mod %p not equal to passed in mod %p\n",
+			       rec->arch.mod, mod);
+			return -EINVAL;
+		}
+		/* nothing to do if mod == rec->arch.mod */
 	} else
 		mod = rec->arch.mod;
 
-- 
1.5.6.5

-- 
