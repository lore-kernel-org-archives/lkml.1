Return-Path: <linux-kernel-owner+w=401wt.eu-S1764623AbXLQV1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764623AbXLQV1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760945AbXLQV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:26:55 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:59169 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXLQV0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AbQ/84F8M9/1Lvl+UaAqNfNfdiyc7P/dPi+lsjlIv1mTMRtlSdcPq7mGKJ+U/gDcGGW2rQ76fqT/T5PykcP6fBD1QYBFd2voNPHedIQq5oTXcBQa3ZHPut4w8TqQeqE2TBYUREwnUK+NnK4ATb8Ijfz7lrrkizLO4YZS/5RftE4=
Subject: [PATCH 1/4] x86: fix jprobe_saved_sp handling
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 13:26:55 -0800
Message-Id: <1197926820.23402.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of jprobe and cleans up. jprobe for x86-64
can cause kernel page fault when the jprobe_return() is called from
incorrect function. Anyway, that path finally invokes BUG() macro,
so this is not so serious.

Based on patch from Masami Hiramatsu <mhiramat@redhat.com>

- Use jprobe_saved_regs instead getting it from stack.
  (Especially on x86-64, it may get incorrect data, because
   pt_regs can not be get by using container_of(rsp))
- Change the type of stack pointer to unsigned long *.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |    8 ++------
 include/asm-x86/kprobes.h |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e5b7d07..9130c01 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1022,16 +1022,12 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
 #ifdef CONFIG_X86_32
 		if (&regs->sp != kcb->jprobe_saved_sp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_sp,
-					    struct pt_regs, sp);
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_sp;
 			printk("current sp %p does not match saved sp %p\n",
 			       &regs->sp, kcb->jprobe_saved_sp);
 #else
 		if ((long *)regs->sp != kcb->jprobe_saved_sp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_sp,
-					    struct pt_regs, sp);
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_sp;
 			printk("current sp %p does not match saved sp %p\n",
 			       (long *)regs->sp, kcb->jprobe_saved_sp);
 #endif
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index e348ed6..7319c62 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -79,7 +79,7 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	unsigned long kprobe_old_flags;
 	unsigned long kprobe_saved_flags;
-	long *jprobe_saved_sp;
+	unsigned long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
-- 
1.5.4.rc0.1083.gf568


