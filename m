Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZKWXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZKWXU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZKWXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbZKWXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:20:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 10/10] [RFC] kprobes/x86: Use text_poke_fixup() for
	jump optimization
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 23 Nov 2009 18:22:34 -0500
Message-ID: <20091123232234.22071.68883.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use text_poke_fixup() for jump optimization instead of text_poke() with
stop_machine().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 arch/x86/kernel/kprobes.c |   54 +++------------------------------------------
 1 files changed, 3 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 6d81c11..3c5e30f 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -49,7 +49,6 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
-#include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
@@ -1355,54 +1354,6 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	return 0;
 }
 
-/*
- * Cross-modifying kernel text with stop_machine().
- * This code originally comes from immediate value.
- * This does _not_ protect against NMI and MCE. However,
- * since kprobes can't probe NMI/MCE handler, it is OK for kprobes.
- */
-static atomic_t stop_machine_first;
-static int wrote_text;
-
-struct text_poke_param {
-	void *addr;
-	const void *opcode;
-	size_t len;
-};
-
-static int __kprobes stop_machine_multibyte_poke(void *data)
-{
-	struct text_poke_param *tpp = data;
-
-	if (atomic_dec_and_test(&stop_machine_first)) {
-		text_poke(tpp->addr, tpp->opcode, tpp->len);
-		smp_wmb();	/* Make sure other cpus see that this has run */
-		wrote_text = 1;
-	} else {
-		while (!wrote_text)
-			smp_rmb();
-		sync_core();
-	}
-
-	flush_icache_range((unsigned long)tpp->addr,
-			   (unsigned long)tpp->addr + tpp->len);
-	return 0;
-}
-
-static void *__kprobes __multibyte_poke(void *addr, const void *opcode,
-					size_t len)
-{
-	struct text_poke_param tpp;
-
-	tpp.addr = addr;
-	tpp.opcode = opcode;
-	tpp.len = len;
-	atomic_set(&stop_machine_first, 1);
-	wrote_text = 0;
-	stop_machine(stop_machine_multibyte_poke, (void *)&tpp, NULL);
-	return addr;
-}
-
 /* Replace a breakpoint (int3) with a relative jump.  */
 int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
 {
@@ -1418,7 +1369,8 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
 	jmp_code[0] = RELATIVEJUMP_OPCODE;
 	*(s32 *)(&jmp_code[1]) = rel;
 
-	__multibyte_poke(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
+	text_poke_fixup(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE,
+			op->optinsn.insn);
 	return 0;
 }
 
@@ -1430,7 +1382,7 @@ void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	/* Set int3 to first byte for kprobes */
 	buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	__multibyte_poke(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+	text_poke_fixup(op->kp.addr, buf, RELATIVEJUMP_SIZE, op->optinsn.insn);
 }
 
 static int  __kprobes setup_detour_execution(struct kprobe *p,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
